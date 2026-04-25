// Префикс, показываемый всем кораблям, чей истинный префикс неизвестен
#define DEFAULT_HIDDEN_PREFIX "ISV"

// Новые типы взаимодействия между кораблями
#define INTERACTION_OVERMAP_IDENTIFY "Identify"
#define INTERACTION_OVERMAP_SET_MARK "Set Mark"
#define INTERACTION_OVERMAP_REVEAL_SIGNATURE "Reveal Signature"

/*
Возвращает имя корабля target для отображения в консолях, радарах и т.п.
Учитывает фракцию, полученные данные и ручные метки.
*/
/datum/overmap/ship/controlled/proc/get_display_name(datum/overmap/ship/controlled/target)
	// Если это не контролируемый корабль – просто его имя
	if(!istype(target))
		return target.name

	// Одна и та же фракция видит полное имя
	var/datum/faction/my_faction = get_faction()
	var/datum/faction/target_faction = target.get_faction()
	if(my_faction && my_faction == target_faction)
		return target.name

	// Проверяем, есть ли у нас информация о целевом корабле
	var/list/known = known_ships?[REF(target)]
	if(!known)
		return "[DEFAULT_HIDDEN_PREFIX] [target.real_name]"

	// Если известен истинный префикс – используем его
	if(known["revealed_prefix"])
		return "[known["revealed_prefix"]] [target.real_name]"

	// Если есть ручная метка (кастомная подпись) – показываем её
	if(known["custom_label"])
		return known["custom_label"]

	// Ничего не знаем – скрываем префикс
	return "[DEFAULT_HIDDEN_PREFIX] [target.real_name]"

/*
Сохраняет истинный префикс другого корабля в локальную базу знаний.
При этом удаляет ранее установленную метку, т.к. теперь известно настоящее имя.
*/
/datum/overmap/ship/controlled/proc/reveal_ship_prefix(datum/overmap/ship/controlled/target)
	LAZYINITLIST(known_ships)
	var/list/entry = known_ships[REF(target)]
	if(!entry)
		entry = list()
		known_ships[REF(target)] = entry
	entry["revealed_prefix"] = target.source_template.prefix
	entry -= "custom_label"  // сбрасываем метку при опознании

/*
Устанавливает или удаляет ручную метку для другого корабля.

@param target Корабль, для которого ставим метку.
@param label Новое имя метки. Если пустая строка или null – метка удаляется.
*/
/datum/overmap/ship/controlled/proc/set_custom_label(datum/overmap/ship/controlled/target, label)
	LAZYINITLIST(known_ships)
	var/list/entry = known_ships[REF(target)]
	if(!entry)
		entry = list()
		known_ships[REF(target)] = entry

	if(!label || label == "")
		entry -= "custom_label"
	else
		entry["custom_label"] = sanitize(label)

/*
Обрабатывает взаимодействие "Identify" (передача идентификационных данных).

@param initiator Корабль, запросивший идентификацию.
@return Сообщение о результате для пилота.
*/
/datum/overmap/ship/controlled/proc/handle_identification_interaction(datum/overmap/ship/controlled/initiator)
	if(!COOLDOWN_FINISHED(src, broadcast_ident_cooldown))
		return "Идентификационная система перезаряжается."

	// Проверка дистанции: не более 2 клеток по x и y
	var/dx = abs(initiator.x - x)
	var/dy = abs(initiator.y - y)
	if(dx > 2 || dy > 2)
		return "Цель вне радиуса идентификации (максимум 2 клетки)."

	// Передаём свой префикс запрашивающему
	initiator.reveal_ship_prefix(src)
	COOLDOWN_START(src, broadcast_ident_cooldown, 10 SECONDS)
	return "Идентификационные данные отправлены кораблю [initiator.get_display_name(initiator)]."

/*
Обрабатывает взаимодействие "Set Mark" – установку ручной метки.
Нельзя ставить метку на самого себя или на корабли той же фракции.

@param user Пилот, выполняющий действие.
@param target Корабль, на который ставится метка.
@param initiator Корабль инициатора (кто ставит метку).
@return Сообщение о результате.
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

	var/new_mark = tgui_input_text(user, "Enter mark for [target.real_name]:", "Set Mark", 15)
	if(isnull(new_mark))
		return "Marking cancelled."
	if(new_mark == "")
		initiator.set_custom_label(target, null)
		return "Mark removed."

	initiator.set_custom_label(target, new_mark)
	return "Mark '[new_mark]' set on [target.real_name]."

/*
Обрабатывает взаимодействие "Reveal Signature" – принудительное раскрытие префикса цели.
Требует отсутствия помех на клетке инициатора: небула, аванпост, ионный/электрический шторм.
Занимает 1 минуту.
*/
/datum/overmap/ship/controlled/proc/handle_reveal_signature(mob/living/user, datum/overmap/ship/controlled/target, datum/overmap/ship/controlled/initiator)
	if(!istype(target))
		return "Разблокировка сигнатуры возможна только для корабля."
	if(target == initiator)
		return "Вы уже знаете свою сигнатуру."

	// Проверка помех на клетке инициатора (включая пристыкованные объекты)
	var/list/nearby_objects = initiator.get_nearby_overmap_objects(include_docked = TRUE, empty_if_src_docked = FALSE)
	for(var/datum/overmap/obj in nearby_objects)
		if(istype(obj, /datum/overmap/outpost) || \
			istype(obj, /datum/overmap/event/nebula) || \
			istype(obj, /datum/overmap/event/emp) || \
			istype(obj, /datum/overmap/event/electric))
			return "Радиопомехи не позволяют запустить дешифровку."

	// Уведомления через консоли
	initiator.say("Запущена дешифровка сигнатуры [target.real_name]. Подождите 60 секунд...")
	target.say("Внимание, зафиксировано сканирование сигнатуры кораблём [initiator.real_name].")

	if(!check_decrypt_proximity(target, initiator))
		return "Цель вышла из радиуса дешифровки."
	sleep(15 SECONDS)
	if(!check_decrypt_proximity(target, initiator))
		return "Цель вышла из радиуса дешифровки."
	initiator.say("Дешифровка сигнатуры [target.real_name] закончится через 45 секунд...")
	sleep(15 SECONDS)
	if(!check_decrypt_proximity(target, initiator))
		return "Цель вышла из радиуса дешифровки."
	initiator.say("Дешифровка сигнатуры [target.real_name] закончится через 30 секунд...")
	sleep(15 SECONDS)
	if(!check_decrypt_proximity(target, initiator))
		return "Цель вышла из радиуса дешифровки."
	initiator.say("Дешифровка сигнатуры [target.real_name] закончится через 15 секунд...")
	sleep(15 SECONDS)
	if(!check_decrypt_proximity(target, initiator))
		return "Цель вышла из радиуса дешифровки."

	initiator.reveal_ship_prefix(target)
	initiator.say("Сигнатура корабля [target.real_name] успешно дешифрована.")
	target.say("Сигнатура нашего корабля была дешифрована кораблём [initiator.real_name].")
	return "Сигнатура корабля [target.real_name] успешно дешифрована."
// Вспомогательная функция проверки дистанции (можно добавить в ship_prefix_system.dm)
/datum/overmap/ship/controlled/proc/check_decrypt_proximity(datum/overmap/ship/controlled/target, datum/overmap/ship/controlled/initiator)
	if(QDELETED(target) || QDELETED(initiator))
		return FALSE
	if(abs(target.x - initiator.x) <= 1 && abs(target.y - initiator.y) <= 1)
		return TRUE
	return FALSE
