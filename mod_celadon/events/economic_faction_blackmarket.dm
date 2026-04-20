/*
Межфракционное влияние внутри раунда
Внутри находятся сценарии сообщений, проки изменения цен и блокировки кораблей.
Файл неразрывно связан с encryptor_terminal.dm
*/

// MARK: Сценарии сообщений

GLOBAL_LIST_EMPTY(faction_message_configs)

/proc/initialize_faction_message_configs()
	if(length(GLOB.faction_message_configs))
		return
	GLOB.faction_message_configs[/datum/faction/syndicate] = list(
		"announce_title" = "Donk.Co Supply Announce",
		"hostile_factions" = list(/datum/faction/nt, /datum/faction/solgov),
		"messages_up" = list(
			"Уважаемые клиенты, в связи с нестабильной обстановкой в вашем кластере систем, запланированные рейсы кораблей снабжения откладываются и компания вынуждена временно повысить цены определенных товаров на %PERCENT%. Мы искренне приносим свои извинения за неудобства.",
			"Уважаемые клиенты, уведомляем вас о том, что из-за активности ионных бурь, возникли перебои с поставками, поэтому мы вынуждены поднять цены на %PERCENT%. Мы искренне приносим свои извинения за неудобства.",
			"Уважаемые клиенты, наши базы данных подверглись кибер-атаке, что привело к изменению цен. Наши специалисты уже работают над восстановлением каналов."
		),
		"messages_down" = list(
			"Уважаемые клиенты, уведомляем вас о том что прибыла крупная поставка товаров для VIP клиентов со скидкой в %PERCENT%. Предложение ограничено по времени."
		)
	)
	GLOB.faction_message_configs[/datum/faction/inteq] = list(
		"announce_title" = "InteQ Risk Management Supply Department",
		"hostile_factions" = list(),
		"messages_up" = list(
			"InteQ Risk Management пересматривает тарифы. Цены InteQ увеличены на %PERCENT%.",
			"Аналитический отдел InteQ сообщает: в связи с повышенным спросом на услуги, стоимость контрактов выросла на %PERCENT%.",
			"InteQ информирует о корректировке прайс-листа. Цены временно повышены на %PERCENT%."
		),
		"messages_down" = list(
			"Конкуренция среди наёмников снижает спрос. Цены InteQ упали на %PERCENT%.",
			"InteQ запускает программу лояльности! Скидки до %PERCENT% на все услуги компании.",
			"В связи с переизбытком ресурсов на складах, цены InteQ снижены на %PERCENT%."
		)
	)
	GLOB.faction_message_configs[/datum/faction/solgov] = list(
		"announce_title" = "Solar Federation Frontier Affairs",
		"hostile_factions" = list(/datum/faction/syndicate),
		"messages_up" = list(
			"Один из наших логистических узлов подвергнулся террористической атаке, в связи с этим цены Координационного пункта ВС СФ повышены на %PERCENT%.",
			"Расписание поставок изменено, из-за повышенной активности ионных бурь, цены изменены на %PERCENT%.",
			"Вылеты кораблей снабжения отложенны из-за повышенной активности Bluespace аномалии на одном из маршрутов, временно цены повышены на %PERCENT%."
		),
		"messages_down" = list(
			"Успехи Экспедиционного Корпуса на приграничных системах кластера деблокировали маршруты для кораблей снабжения. Цены Координационного пункта для ВС СФ снижены на %PERCENT%.",
			"Благодаря оптимизации логистических цепочек, цены на товары СолФед уменьшены на %PERCENT%."
		)
	)
	GLOB.faction_message_configs[/datum/faction/nt] = list(
		"announce_title" = "North-Star Logistics Announce",
		"hostile_factions" = list(/datum/faction/syndicate),
		"messages_up" = list(
			"Наши корабли снабжения временно откладывают свои рейсы в связи с нестабильной обстановкой в кластере систем, и технических неполадок. Цены повышены %PERCENT%.",
			"Nanotrasen уведомляет: из-за внешних угроз введена надбавка за риск, цены увеличены на %PERCENT%.",
			"Технические неполадки на распределительных узлах привели к временному росту цен на %PERCENT%."
		),
		"messages_down" = list(
			"В связи с уменьшением активности Bluespace аномалии, стали доступны новые маршруты, благодаря чему цены на все товары Nanotrasen уменьшены на %PERCENT%.",
			"Мы рады сообщить что миротворческая группировка заполучила стратегическое преймущество над силами противника, маршруты снабжения стали безопасными, цены понижены на %PERCENT%."
		)
	)
	GLOB.faction_message_configs[/datum/faction/independent] = list(
		"announce_title" = "Outpost Cargo Announce",
		"hostile_factions" = list(),
		"messages_up" = list(
			"Мы вынуждены поднять цены из-за нестабильности в регионе. Рост на %PERCENT%.",
			"Независимые торговцы предупреждают: цены вырастут на %PERCENT% из-за дефицита товаров.",
			"Рыночная паника привела к скачку цен на %PERCENT%. Ожидайте стабилизации в ближайшее время."
		),
		"messages_down" = list(
			"Из-за внеплановой реструктуризация активов, цены снижены на %PERCENT%.",
			"Независимый рынок переполнен предложениями – скидки до %PERCENT% на большинство позиций!",
			"Снижение закупочных цен позволило уменьшить розничные цены на %PERCENT%."
		)
	)
	GLOB.faction_message_configs["blackmarket"] = list(
		"announce_title" = "Unknown Message",
		"hostile_factions" = list(),
		"messages_up" = list(
			"Системы черного рынка подверглись кибер-атаке, связи с этим цены выросли на %PERCENT%.",
			"Чёрный рынок лихорадит: спрос превышает предложение, цены взлетели на %PERCENT%.",
			"Теневые дилеры подняли цены на %PERCENT% из-за ужесточения контроля в секторе."
		),
		"messages_down" = list(
			"На чёрном рынке появилось много краденого товара. Цены рухнули на %PERCENT%."
		)
	)

/proc/generate_economic_shift_message(faction_type, modifier_delta)
	var/percent = abs(modifier_delta) * 100
	var/up = (modifier_delta > 0)
	var/list/cfg = GLOB.faction_message_configs[faction_type]
	if(!cfg)
		var/faction_name = get_faction_display_name(faction_type)
		var/direction = up ? "увеличены" : "снижены"
		return "Экономические флуктуации затронули [faction_name]: цены [direction] на [percent]%."
	var/list/messages = up ? cfg["messages_up"] : cfg["messages_down"]
	return replacetext(pick(messages), "%PERCENT%", "[percent]")

/proc/generate_announce_title(faction_type)
	var/list/cfg = GLOB.faction_message_configs[faction_type]
	return cfg ? cfg["announce_title"] : "Market Alert"

/proc/get_faction_display_name(faction_type)
	if(faction_type == "blackmarket")
		return "Black Market"
	var/datum/faction/F = new faction_type()
	if(F?.name)
		var/f_name = F.name
		qdel(F)
		return f_name
	qdel(F)
	var/list/path_parts = splittext("[faction_type]", "/")
	return capitalize(path_parts[path_parts.len])

// MARK: Экономические баффы и дебаффы

/proc/trigger_economic_shift(faction_type, modifier_delta, do_announce = FALSE)
	if(!faction_type)
		return

	if(faction_type == "blackmarket")
		if(istype(SSeconomy) && hascall(SSeconomy, "adjust_blackmarket_price_multiplier"))
			call(SSeconomy, "adjust_blackmarket_price_multiplier")(modifier_delta)
		else
			log_game("ERROR: SSeconomy.adjust_blackmarket_price_multiplier not found!")
	else
		if(istype(SSeconomy) && hascall(SSeconomy, "adjust_faction_price_multiplier"))
			call(SSeconomy, "adjust_faction_price_multiplier")(faction_type, modifier_delta)
		else
			log_game("ERROR: SSeconomy.adjust_faction_price_multiplier not found!")

	if(do_announce)
		var/final_announce = generate_economic_shift_message(faction_type, modifier_delta)
		var/title = generate_announce_title(faction_type)
		priority_announce(final_announce, sender_override = title)

	log_game("Economic shift: Faction=[faction_type] Delta=[modifier_delta] Announce=[do_announce]")

// MARK: Кибер-саботаж который блокирует один из кораблей протвника внутри раунда на 20 минут.

/proc/clear_diplomatic_blacklist(datum/overmap/ship/controlled/ship, datum/overmap/outpost/target_outpost)
	if(QDELETED(ship) || QDELETED(target_outpost))
		return
	ship.blacklisted -= target_outpost
	priority_announce("Технические работы завершены. Ограничения на стыковку для [ship.name] сняты.", sender_override = "Outpost Administration Announce")
	log_game("Diplomatic blacklist cleared: [ship.name] at [target_outpost.name]")

/proc/trigger_cyber_sabotage(initiator_faction)
	if(!initiator_faction)
		return FALSE
	var/list/cfg = GLOB.faction_message_configs[initiator_faction]
	if(!cfg || !length(cfg["hostile_factions"]))
		return FALSE
	var/target_faction_type = pick(cfg["hostile_factions"])
	var/datum/faction/target_faction = new target_faction_type()
	if(!target_faction)
		return FALSE
	var/target_faction_name = target_faction.name
	var/list/valid_ships = list()
	for(var/datum/overmap/ship/controlled/ship as anything in SSovermap.controlled_ships)
		if(!ship.source_template?.faction)
			continue
		if(!istype(ship.source_template.faction, target_faction_type))
			continue
		valid_ships += ship
	if(!length(valid_ships))
		log_game("Cyber sabotage failed: no valid ships of faction [target_faction_name] found.")
		qdel(target_faction)
		return FALSE
	var/datum/overmap/ship/controlled/victim_ship = pick(valid_ships)
	var/datum/overmap/outpost/target_outpost = SSovermap.outposts[1]
	if(!target_outpost)
		log_game("Cyber sabotage failed: no outpost found.")
		qdel(target_faction)
		return FALSE
	var/reason = "Стыковка была временно приостановлена из-за кибер-атаки. Расчетное время до устранения неполадок: 20 минут."
	victim_ship.blacklisted[target_outpost] = reason
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_diplomatic_blacklist), victim_ship, target_outpost), 2 MINUTES, TIMER_STOPPABLE|TIMER_DELETE_ME)
	var/initiator_name = get_faction_display_name(initiator_faction)
	var/announce_text = "Наши системы безопасности подверглись кибератаке. Временно некоторые суда [target_faction_name] не могут стыковаться в порту [target_outpost.name]. Наши специалисты уже работают над этим; технические работы будут завершены через 20 минут."
	priority_announce(announce_text, sender_override = "Outpost Administration Announce")
	log_game("Cyber sabotage: [initiator_name] blacklisted [victim_ship.name] from [target_outpost.name] for 20 minutes")
	qdel(target_faction)
	return TRUE

/world/New()
	. = ..()
	initialize_faction_message_configs()
