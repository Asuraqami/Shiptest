/*
===================================================
ПРЕФИКСЫ КОРАБЛЕЙ (IFF / IDENTIFICATION SYSTEM)
Модуль отвечает за то, как корабли видят имена друг друга,
включая скрытие префиксов, ручные метки и принудительную дешифровку.
===================================================
*/

// MARK: Defines (лучше вынести в __DEFINES/overmap.dm) ----
// Префикс, показываемый всем кораблям, чей истинный префикс неизвестен
#define DEFAULT_HIDDEN_PREFIX "ISV"

// Максимальная дистанция (в клетках овермапа) для идентификации "Identify"
#define IDENTIFY_MAX_RANGE 2
// Максимальная дистанция для дешифровки "Reveal Signature" (квадрат 1 клетка)
#define DECRYPT_PROXIMITY_RANGE 1
// Время кулдауна между отправками идентификационных данных
#define IDENTIFY_COOLDOWN_TIME 10 SECONDS
// Общее время дешифровки сигнатуры (60 секунд)
#define DECRYPT_TOTAL_TIME 60 SECONDS
// Интервалы оповещений во время дешифровки (в секундах)
#define DECRYPT_NOTIFY_INTERVALS list(45, 30, 15)

// Дополнительные кнопки в Interact
#define INTERACTION_OVERMAP_IDENTIFY "Identify"
#define INTERACTION_OVERMAP_SET_MARK "Set Mark"
#define INTERACTION_OVERMAP_REVEAL_SIGNATURE "Reveal Signature"

/*
============================================================
ПРОКИ ДЛЯ РАБОТЫ С ОТОБРАЖАЕМЫМИ ИМЕНАМИ
============================================================
*/

/*
Возвращает имя корабля `target` для отображения в консолях, радарах и т.п.
Учитывает фракцию, полученные данные (через identify/reveal) и ручные метки.

@param target - корабль-цель (может быть не /controlled)
@return строка, которая будет показана игроку
 */

/datum/overmap/ship/controlled/proc/get_display_name(datum/overmap/ship/controlled/target)
	if(!istype(target))
		return target.name

	var/datum/faction/my_faction = get_faction()
	var/datum/faction/target_faction = target.get_faction()
	// Своими считаются корабли, у которых типы датумов фракций совпадают (даже если name различается)
	if(my_faction && target_faction && my_faction.type == target_faction.type)
		return target.name

	var/list/known = known_ships?[REF(target)]
	if(!known)
		return "[DEFAULT_HIDDEN_PREFIX] [target.real_name]"

	if(known["revealed_prefix"])
		return "[known["revealed_prefix"]] [target.real_name]"

	if(known["custom_label"])
		return known["custom_label"]

	return "[DEFAULT_HIDDEN_PREFIX] [target.real_name]"

/*
==============================================
ПРОКИ ДЛЯ ОБНОВЛЕНИЯ БАЗЫ ДАННЫХ (known_ships)
==============================================
*/

/*
Сохраняет истинный префикс другого корабля в локальную базу знаний текущего корабля.
При этом удаляет ранее установленную ручную метку, так как теперь корабль опознан официально.

@param target - корабль, чей префикс мы узнали
*/

/datum/overmap/ship/controlled/proc/reveal_ship_prefix(datum/overmap/ship/controlled/target)
	LAZYINITLIST(known_ships)
	var/list/entry = known_ships[REF(target)]
	if(!entry)
		entry = list()
		known_ships[REF(target)] = entry
	// Берём префикс из шаблона цели (source_template.prefix)
	entry["revealed_prefix"] = target.source_template.prefix
	// Сбрасываем ручную метку, так как теперь опознание точнее
	entry -= "custom_label"

/*
Устанавливает или удаляет ручную метку для другого корабля.
Метка полностью заменяет отображаемое имя (включая префикс) в интерфейсе текущего корабля.
@param target - корабль, для которого ставим метку
@param label - новое имя метки. Если пустая строка или null – метка удаляется.
 */

/datum/overmap/ship/controlled/proc/set_custom_label(datum/overmap/ship/controlled/target, label)
	LAZYINITLIST(known_ships)
	var/list/entry = known_ships[REF(target)]
	if(!entry)
		entry = list()
		known_ships[REF(target)] = entry

	if(!label) // пустая строка или null
		entry -= "custom_label"
	else
		entry["custom_label"] = sanitize(label)   // санитайзим, чтобы избежать XSS/вредоносных символов

/*
================================================================
ОБРАБОТЧИКИ ВЗАИМОДЕЙСТВИЙ (вызываются из show_interaction_menu)
================================================================
*/

/*
"Identify" – передача своего префикса другому кораблю.
Запрашивающий корабль (initiator) получает истинный префикс текущего корабля (src).
@param initiator - корабль, который запросил идентификацию
@return сообщение для пилота (успех/ошибка)
*/

/datum/overmap/ship/controlled/proc/handle_identification_interaction(datum/overmap/ship/controlled/initiator)
	if(!COOLDOWN_FINISHED(src, broadcast_ident_cooldown))
		return "Идентификационная система перезаряжается."

	// Проверка растояния на овермапе (не более IDENTIFY_MAX_RANGE клеток по любой оси)
	if(!in_overmap_range(initiator, IDENTIFY_MAX_RANGE))
		return "Цель вне радиуса идентификации (максимум [IDENTIFY_MAX_RANGE] клетки)."

	// Передаём свой префикс запрашивающему
	initiator.reveal_ship_prefix(src)
	COOLDOWN_START(src, broadcast_ident_cooldown, IDENTIFY_COOLDOWN_TIME)
	return "Идентификационные данные отправлены кораблю [initiator.get_display_name(initiator)]."

/*
"Set Mark" – установку ручной метки на другой корабль.
Нельзя ставить метку на самого себя или на корабли той же фракции.
@param user - пилот (моб), выполняющий действие
@param target - корабль, на который ставится метка
@param initiator - корабль инициатора (чей known_ships обновляется)
@return сообщение для пилота
*/
/datum/overmap/ship/controlled/proc/handle_set_mark_interaction(mob/living/user, datum/overmap/ship/controlled/target, datum/overmap/ship/controlled/initiator)
	if(!istype(target))
		return "Метку можно поставить только на корабль."

	if(target == initiator)
		return "Нельзя поставить метку на собственный корабль."

	var/datum/faction/my_faction = initiator.get_faction()
	var/datum/faction/target_faction = target.get_faction()
	if(my_faction && my_faction == target_faction)
		return "Нельзя поставить метку на корабль вашей фракции."

	var/new_mark = tgui_input_text(user, "Введите метку для [target.real_name]:", "Установка метки", 15)
	if(isnull(new_mark))
		return "Установка метки отменена."
	if(new_mark == "")
		initiator.set_custom_label(target, null)
		return "Метка удалена."

	initiator.set_custom_label(target, new_mark)
	return "Метка '[new_mark]' установлена на [target.real_name]."

/*
"Reveal Signature" – принудительная дешифровка префикса цели.
Требует:
- отсутствия помех на клетке инициатора (небула, аванпост, ионки/электро шторм)
- дистанции не более DECRYPT_PROXIMITY_RANGE
- времени 60 секунд, с периодической проверкой дистанции
- свободной консоли дешифровки (active_decrypt_target)
@param user - пилот
@param target - цель дешифровки
@param initiator - корабль, который проводит дешифровку
@return сообщение для пилота
*/
/datum/overmap/ship/controlled/proc/handle_reveal_signature(mob/living/user, datum/overmap/ship/controlled/target, datum/overmap/ship/controlled/initiator)
	if(!istype(target))
		return "Разблокировка сигнатуры возможна только для корабля."
	if(target == initiator)
		return "Вы уже знаете свою сигнатуру."

	// Проверка, не занята ли уже консоль дешифровкой
	if(initiator.active_decrypt_target)
		return "Консоль уже выполняет дешифровку сигнатуры [initiator.active_decrypt_target.real_name]."

	// Проверка помех на клетке инициатора (включая пристыкованные объекты)
	var/list/nearby_objects = initiator.get_nearby_overmap_objects(include_docked = TRUE, empty_if_src_docked = FALSE)
	for(var/datum/overmap/obj in nearby_objects)
		if(istype(obj, /datum/overmap/outpost) || \
			istype(obj, /datum/overmap/event/nebula) || \
			istype(obj, /datum/overmap/event/emp) || \
			istype(obj, /datum/overmap/event/electric))
			return "Радиопомехи не позволяют запустить дешифровку."

	// Устанавливаем флаг активности
	initiator.active_decrypt_target = target

	// Находим консоли для вывода сообщений
	var/obj/machinery/computer/helm/init_helm = length(initiator.helms) > 0 ? initiator.helms[1] : null
	var/obj/machinery/computer/helm/target_helm = length(target.helms) > 0 ? target.helms[1] : null

	if(init_helm)
		init_helm.say("Запущена дешифровка сигнатуры [target.real_name]. Подождите [DECRYPT_TOTAL_TIME / 10] секунд...")
	if(target_helm)
		target_helm.say("Внимание, зафиксировано сканирование сигнатуры кораблём [initiator.real_name].")

	// Основной цикл дешифровки с проверками дистанции и оповещениями
	// Вместо четырёх блоков sleep используем параметризированный подход (сохраняя поведение)
	var/time_elapsed = 0
	var/notify_index = 1
	var/notify_times = DECRYPT_NOTIFY_INTERVALS  // list(45, 30, 15)

	while(time_elapsed < DECRYPT_TOTAL_TIME)
		// Ждём 15 секунд между проверками
		sleep(15 SECONDS)
		time_elapsed += 15 SECONDS

		// Проверка дистанции
		if(!in_overmap_range(target, DECRYPT_PROXIMITY_RANGE, initiator))
			initiator.active_decrypt_target = null
			return "Цель вышла из радиуса дешифровки."

		// Оповещение, если подошло время
		if(notify_index <= length(notify_times) && (DECRYPT_TOTAL_TIME - time_elapsed) == notify_times[notify_index])
			if(init_helm)
				init_helm.say("Дешифровка сигнатуры [target.real_name] закончится через [notify_times[notify_index]] секунд...")
			notify_index++

	// Завершение
	initiator.active_decrypt_target = null
	initiator.reveal_ship_prefix(target)

	if(init_helm)
		init_helm.say("Сигнатура корабля [target.real_name] успешно дешифрована.")
	if(target_helm)
		target_helm.say("Сигнатура нашего корабля была дешифрована кораблём [initiator.real_name].")
	return "Сигнатура корабля [target.real_name] успешно дешифрована."

/*
===========================
MARK: ВСПОМОГАТЕЛЬНЫЕ ПРОКИ
===========================
*/

/*
Проверяет, находится ли целевой корабль в указанном радиусе (по оси X и Y)
относительно корабля-инициатора (по умолчанию src – текущий корабль)
@param target - целевой корабль
@param range - максимальное допустимое расстояние по X и Y
@param origin - от какого корабля считаем (если не указан, берётся src)
@return TRUE если |x1-x2| <= range и |y1-y2| <= range, иначе FALSE
*/
/datum/overmap/ship/controlled/proc/in_overmap_range(datum/overmap/ship/controlled/target, range, datum/overmap/ship/controlled/origin)
	if(!istype(target) || QDELETED(target))
		return FALSE
	if(!origin)
		origin = src
	if(QDELETED(origin))
		return FALSE
	if(abs(target.x - origin.x) <= range && abs(target.y - origin.y) <= range)
		return TRUE
	return FALSE

/datum/overmap/ship/controlled/proc/check_decrypt_proximity(datum/overmap/ship/controlled/target, datum/overmap/ship/controlled/initiator)
	return in_overmap_range(target, DECRYPT_PROXIMITY_RANGE, initiator)
