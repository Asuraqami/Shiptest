/*!
Зашифрованный терминал, принимающий фракционные документы.
Влияет на экономику или вызывает дипломатические инциденты.
Файл неразрывно связан с economic_faction_blackmarket.dm
 */

#define ENCRYPTOR_COOLDOWN (5 SECONDS) // Время через которое терминал вновь сможет кушать документы
#define ENCRYPTOR_ACTIVATION_DELAY (5 SECONDS) // Время через которое произойдет анонс после вставления документов

// MARK: - Вспомогательный прок определения фракции документа

/proc/get_faction_from_document(obj/item/I)
	if(istype(I, /obj/item/documents/syndicate))
		return /datum/faction/syndicate
	if(istype(I, /obj/item/documents/nanotrasen))
		return /datum/faction/nt
	if(istype(I, /obj/item/documents/solfed))
		return /datum/faction/solgov
	if(istype(I, /obj/item/documents))
		return /datum/faction/independent
	return null

// MARK: - Терминал

/obj/machinery/encrypted_terminal
	name = "encrypted terminal"
	desc = "A terminal that houses documents with confidential information and completely copies and encrypts their contents, followed by storing or destroying the original."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "nanite_cloud_controller"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODECONSTRUCT_1
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 100

	var/active = FALSE
	var/last_use = 0
	var/timer_id
	var/target_faction
	var/modifier_delta
	var/list/accepted_documents = list()

/obj/machinery/encrypted_terminal/Initialize(mapload)
	. = ..()
	if(!length(accepted_documents))
		accepted_documents = list(/obj/item/documents) // fallback

/obj/machinery/encrypted_terminal/Destroy()
	if(timer_id)
		deltimer(timer_id)
	return ..()

/obj/machinery/encrypted_terminal/examine(mob/user)
	. = ..()
	. += span_notice("Insert faction documents to influence the market.")

/obj/machinery/encrypted_terminal/attackby(obj/item/I, mob/user, params)
	if(active)
		to_chat(user, span_warning("[src] is already processing a document! Wait until it finishes."))
		return
	if(world.time < last_use + ENCRYPTOR_COOLDOWN)
		to_chat(user, span_warning("[src] is recharging. Try again later."))
		return

	var/accepted = FALSE
	for(var/type in accepted_documents)
		if(istype(I, type))
			accepted = TRUE
			break
	if(!accepted)
		to_chat(user, span_warning("[src] doesn't accept [I]."))
		return

	if(!user.temporarilyRemoveItemFromInventory(I))
		to_chat(user, span_warning("You can't let go of [I]!"))
		return
	qdel(I)

	// Награда всегда выдаётся
	new /obj/item/spacecash/bundle(loc, rand(4000, 9000))
	to_chat(user, span_green("The terminal spits out some credits."))

	var/effect_result = choose_effect(I)
	if(isnull(effect_result))
		return

	active = TRUE
	last_use = world.time
	icon_state = "nanite_cloud_controller"
	update_appearance()
	playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	visible_message(span_notice("[src] hums to life, encrypting and processing the documents..."))

	if(effect_result) // TRUE — отложенный экономический сдвиг
		timer_id = addtimer(CALLBACK(src, PROC_REF(activate_event)), ENCRYPTOR_ACTIVATION_DELAY, TIMER_STOPPABLE)
	// FALSE — мгновенный дипломатический инцидент уже произошёл, терминал завершит работу по окончании активации (но мы не запускали таймер, нужно завершить)
	else
		finish()

/obj/machinery/encrypted_terminal/proc/choose_effect(obj/item/I)
	// Должен быть переопределён в подтипах
	return null

/obj/machinery/encrypted_terminal/proc/activate_event()
	if(target_faction)
		trigger_economic_shift(target_faction, modifier_delta, do_announce = TRUE)
	finish()

/obj/machinery/encrypted_terminal/proc/finish()
	active = FALSE
	icon_state = initial(icon_state)
	update_appearance()
	timer_id = null

// MARK: Фракционные терминалы со списками того, какие документы они жрут

/obj/machinery/encrypted_terminal/syndicate
	accepted_documents = list(/obj/item/documents/nanotrasen, /obj/item/documents/solfed)

/obj/machinery/encrypted_terminal/syndicate/choose_effect(obj/item/I)
	if(prob(20))
		if(trigger_cyber_sabotage(/datum/faction/syndicate))
			return FALSE
	if(prob(30))
		target_faction = /datum/faction/syndicate
		modifier_delta = -0.1
	else
		if(prob(50))
			target_faction = /datum/faction/nt
		else
			target_faction = /datum/faction/solgov
		modifier_delta = 0.15
	return TRUE

/obj/machinery/encrypted_terminal/nanotrasen
	accepted_documents = list(/obj/item/documents/syndicate)

/obj/machinery/encrypted_terminal/nanotrasen/choose_effect(obj/item/I)
	if(prob(20))
		if(trigger_cyber_sabotage(/datum/faction/nt))
			return FALSE
	if(prob(30))
		target_faction = /datum/faction/nt
		modifier_delta = -0.1
	else
		if(prob(50))
			target_faction = /datum/faction/syndicate
		else
			target_faction = "blackmarket"
		modifier_delta = 0.15
	return TRUE

/obj/machinery/encrypted_terminal/solfed
	accepted_documents = list(/obj/item/documents/syndicate)

/obj/machinery/encrypted_terminal/solfed/choose_effect(obj/item/I)
	if(prob(20))
		if(trigger_cyber_sabotage(/datum/faction/solgov))
			return FALSE
	if(prob(30))
		target_faction = /datum/faction/solgov
		modifier_delta = -0.1
	else
		if(prob(50))
			target_faction = /datum/faction/syndicate
		else
			target_faction = "blackmarket"
		modifier_delta = 0.15
	return TRUE

/obj/machinery/encrypted_terminal/inteq
	accepted_documents = list(/obj/item/documents/syndicate, /obj/item/documents/nanotrasen, /obj/item/documents/solfed)

/obj/machinery/encrypted_terminal/inteq/choose_effect(obj/item/I)
	var/doc_faction = get_faction_from_document(I)
	if(prob(30))
		// Кибератака от имени заказчика (фракция документа)
		if(trigger_cyber_sabotage(doc_faction))
			return FALSE
	// Экономический сдвиг в зависимости от документа
	switch(doc_faction)
		if(/datum/faction/syndicate)
			target_faction = pick(/datum/faction/nt, /datum/faction/solgov)
			modifier_delta = 0.15
		if(/datum/faction/nt)
			target_faction = /datum/faction/syndicate
			modifier_delta = 0.15
		if(/datum/faction/solgov)
			target_faction = /datum/faction/syndicate
			modifier_delta = 0.15
		else
			return null
	return TRUE

/obj/machinery/encrypted_terminal/independent
	accepted_documents = list(/obj/item/documents/frontier,/obj/item/documents/syndicate, /obj/item/documents/nanotrasen, /obj/item/documents/solfed)

/obj/machinery/encrypted_terminal/independent/choose_effect(obj/item/I)
	return null  // только деньги
