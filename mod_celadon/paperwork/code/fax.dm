/obj/machinery/fax
	name = "\improper fax machine"
	desc = "Bluespace technologies on the application of bureaucracy."
	icon = 'icons/obj/fax.dmi'
	icon_state = "fax"
	density = TRUE
	power_channel = AREA_USAGE_EQUIP
	max_integrity = 100
	pass_flags = PASSTABLE
	pixel_y = 6
	circuit = /obj/item/circuitboard/machine/fax
	/// The unique ID by which the fax will build a list of existing faxes.
	var/fax_id
	/// The name of the fax displayed in the list. Not necessarily unique to some EMAG jokes.
	var/fax_name
	/// A weak reference to an inserted object.
	var/datum/weakref/loaded_item_ref
	/// World ticks the machine is electrified for.
	var/seconds_electrified = MACHINE_NOT_ELECTRIFIED
	/// If true, the fax machine is jammed and needs cleaning
	var/jammed = FALSE
	/// Necessary to hide syndicate faxes from the general list. Doesn't mean he's EMAGGED!
	var/frontier_network = FALSE
	/// True if the fax machine should be visible to other fax machines in general.
	var/visible_to_network = TRUE
	/// If true we will eject faxes at speed rather than sedately place them into a tray.
	var/hurl_contents = FALSE
	/// This is where the dispatch and reception history for each fax is stored.
	var/list/fax_history = list()
	/// List of types which should always be allowed to be faxed
	var/static/list/allowed_types = list(
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/holochip,
		/obj/item/folder/biscuit,
		/obj/item/spacecash,
		/obj/item/documents,
	)
	/// Internal radio for announcing over comms
	var/obj/item/radio/radio
	/// Radio channel to speak into
	var/radio_channel
	/// Cooldown for aformentioned radio, prevents radio spam
	COOLDOWN_DECLARE(radio_cooldown)

	/// List with a fake-networks(not a fax actually), for request manager.
	var/list/special_networks = list(
		list(fax_name = "Nanotrasen Central Command", fax_id = "nanotrasen", color = "green", emag_needed = FALSE),
		list(fax_name = "Outpost Authority", fax_id = "outpost", color = "orange", emag_needed = FALSE),
		list(fax_name = "IRMG Mothership", fax_id = "inteq", color = "yellow", emag_needed = FALSE),
		list(fax_name = "Solarian Confederation Frontier Affairs", fax_id = "solgov", color = "teal", emag_needed = FALSE),
		list(fax_name = "Syndicate Coalition Coordination Center", fax_id = "syndicate", color = "red", emag_needed = FALSE),
		list(fax_name = "Ramzi Clique Overwatch", fax_id = "ramzi", color = "darkred", emag_needed = TRUE)
	)
	// should we make our message be important and be recieved in admin faxes
	var/admin_fax_id

	var/obj/docking_port/mobile/my_port

/obj/machinery/fax/Initialize(mapload)
	. = ..()
	GLOB.fax_machines += src
	if(!fax_id)
		fax_id = SSnetworks.make_address()
	if(fax_name == initial(fax_name) && !admin_fax_id)
		fax_name = get_clean_ship_name()
	wires = new /datum/wires/fax(src)

	radio = new(src)
	radio.subspace_transmission = TRUE
	radio.canhear_range = 0
	radio.on = TRUE

/obj/machinery/fax/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	my_port = port
	port.fax_list |= WEAKREF(src)

/obj/machinery/fax/ruin
	visible_to_network = FALSE
	special_networks = list()

/obj/machinery/fax/ruin/Initialize(mapload)
	. = ..()
	fax_name = "Unregistered Fax Machine " + fax_id

/obj/machinery/fax/Destroy()
	GLOB.fax_machines -= src
	QDEL_NULL(loaded_item_ref)
	QDEL_NULL(wires)
	QDEL_NULL(radio)
	return ..()

/obj/machinery/fax/update_overlays()
	. = ..()
	if(panel_open)
		. += "fax_panel"
	var/obj/item/loaded = loaded_item_ref?.resolve()
	if(loaded)
		. += mutable_appearance(icon, find_overlay_state(loaded, "contain"))

/obj/machinery/fax/examine()
	. = ..()
	if(jammed)
		. += span_notice("Its output port is jammed and needs cleaning.")

/obj/machinery/fax/process(seconds_per_tick)
	if(seconds_electrified > MACHINE_NOT_ELECTRIFIED)
		seconds_electrified -= seconds_per_tick

/obj/machinery/fax/attack_hand(mob/user)
	if(seconds_electrified && !(machine_stat & NOPOWER))
		if(shock(user, 100))
			return
	return ..()

/obj/machinery/fax/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TRUE

/obj/machinery/fax/screwdriver_act(mob/living/user, obj/item/screwdriver)
	. = ..()
	default_deconstruction_screwdriver(user, icon_state, icon_state, screwdriver)
	update_icon()
	return TRUE

/obj/machinery/fax/multitool_act(mob/living/user, obj/item/I)
	if(panel_open)
		return
	var/new_fax_name = stripped_input(user, "Enter a new name for the fax machine.", "New Fax Name", max_length=128)
	if(!new_fax_name)
		return
	if(new_fax_name != fax_name)
		if(fax_name_exist(new_fax_name))
			if(frontier_network != TRUE && obj_flags != EMAGGED)
				to_chat(user, span_warning("There is already a fax machine with this name on the network."))
				return
		user.log_message("renamed [fax_name] (fax machine) to [new_fax_name]", LOG_GAME)
		fax_name = new_fax_name
	return TRUE

/obj/machinery/fax/attackby(obj/item/item, mob/user, params)
	if(jammed && clear_jam(item, user))
		return
	if(panel_open)
		if(is_wire_tool(item))
			wires.interact(user)
		return
	if(can_load_item(item))
		if(!loaded_item_ref?.resolve())
			loaded_item_ref = WEAKREF(item)
			item.forceMove(src)
			update_icon()
		return
	return ..()

/obj/machinery/fax/proc/clear_jam(obj/item/item, mob/user)
	if(istype(item, /obj/item/reagent_containers/spray))
		var/obj/item/reagent_containers/spray/clean_spray = item
		if(!clean_spray.reagents.has_reagent(/datum/reagent/space_cleaner, clean_spray.amount_per_transfer_from_this))
			return FALSE
		clean_spray.reagents.remove_reagent(/datum/reagent/space_cleaner, clean_spray.amount_per_transfer_from_this, 1)
		playsound(loc, 'sound/effects/spray3.ogg', 50, TRUE, -5)
		user.visible_message(span_notice("[user] cleans \the [src]."), span_notice("You clean \the [src]."))
		jammed = FALSE
		return TRUE
	if(istype(item, /obj/item/soap) || istype(item, /obj/item/reagent_containers/glass/rag))
		var/cleanspeed = 50
		if(istype(item, /obj/item/soap))
			var/obj/item/soap/used_soap = item
			cleanspeed = used_soap.cleanspeed
		user.visible_message(span_notice("[user] starts to clean \the [src]."), span_notice("You start to clean \the [src]..."))
		if(do_after(user, cleanspeed, target = src))
			user.visible_message(span_notice("[user] cleans \the [src]."), span_notice("You clean \the [src]."))
			jammed = FALSE
		return TRUE
	return FALSE

/obj/machinery/fax/proc/can_load_item(obj/item/item)
	return is_allowed_type(item) && (!istype(item, /obj/item/stack) || item:amount == 1)

/obj/machinery/fax/proc/is_allowed_type(obj/item/item)
	return is_type_in_list(item, allowed_types)

/obj/machinery/fax/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Fax")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/fax/ui_data(mob/user)
	var/list/data = list()
	for(var/obj/machinery/fax/fax as anything in GLOB.fax_machines)
		if(fax.fax_id == fax_id)
			continue
		if(!fax.visible_to_network)
			continue
		var/list/fax_data = list()
		if(admin_fax_id && !fax.admin_fax_id)
			fax_data["fax_name"] = fax.get_full_name()
		else
			fax_data["fax_name"] = fax.fax_name
		fax_data["fax_id"] = fax.fax_id
		fax_data["visible"] = fax.visible_to_network
		fax_data["has_paper"] = !!fax.loaded_item_ref?.resolve()
		fax_data["frontier_network"] = fax.frontier_network
		data["faxes"] += list(fax_data)

	data["fax_id"] = fax_id
	data["fax_name"] = fax_name
	data["visible"] = visible_to_network
	data["frontier_network"] = (frontier_network || (obj_flags & EMAGGED))
	data["has_paper"] = !!loaded_item_ref?.resolve()
	data["fax_history"] = fax_history
	data["special_faxes"] = special_networks
	return data

/obj/machinery/fax/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("remove")
			var/obj/item/loaded = loaded_item_ref?.resolve()
			if(!loaded)
				return
			loaded.forceMove(drop_location())
			loaded_item_ref = null
			update_icon()
			return TRUE
		if("send")
			var/obj/item/loaded = loaded_item_ref?.resolve()
			if(!loaded)
				return
			var/destination = params["id"]
			if(send(loaded, destination))
				log_fax(loaded, destination, params["name"])
				loaded_item_ref = null
				update_icon()
				return TRUE
		if("send_special")
			var/obj/item/loaded = loaded_item_ref?.resolve()
			var/obj/thing_to_send
			if(!loaded)
				return
			if(istype(loaded, /obj/item/paper))
				var/obj/item/paper/fax_paper = loaded
				fax_paper.request_state = TRUE
				thing_to_send = fax_paper
			else
				thing_to_send = loaded

			if(!thing_to_send)
				return
			thing_to_send.loc = null
			INVOKE_ASYNC(src, PROC_REF(animate_object_travel), thing_to_send, "fax_receive", find_overlay_state(thing_to_send, "send"))
			history_add("Send", params["name"])

			GLOB.requests.fax_request(usr.client, "sent a fax message from [fax_name]/[fax_id] to [params["name"]]", thing_to_send)
			var/to_show = ""
			if(istype(thing_to_send, /obj/item/paper) || istype(thing_to_send, /obj/item/photo))
				to_show = "[istype(thing_to_send, /obj/item/paper) ? ADMIN_SHOW_PAPER(thing_to_send) : ADMIN_SHOW_PHOTO(thing_to_send)]"
			else
				to_show = ". They sent [thing_to_send.name]"

			to_chat(GLOB.admins, span_adminnotice("[icon2html(src.icon, GLOB.admins)]<b><font color=green>FAX REQUEST: </font>[ADMIN_FULLMONTY(usr)]:</b> <span class='linkify'>sent a fax message from [fax_name]/[fax_id][ADMIN_FLW(src)] to [html_encode(params["name"])][to_show]"))
			log_fax(thing_to_send, params["id"], params["name"])
			loaded_item_ref = null

			for(var/obj/machinery/fax/fax as anything in GLOB.fax_machines)
				if(fax.admin_fax_id == params["id"])
					fax.receive(thing_to_send, fax_name)
					break
			update_appearance()

		if("history_clear")
			history_clear()
			return TRUE

/obj/machinery/fax/proc/log_fax(obj/item/sent, destination_id, name)
	if (istype(sent, /obj/item/paper))
		var/obj/item/paper/sent_paper = sent
		log_paper("[usr] has sent a fax with the message \"[sent_paper.get_raw_text()]\" to [name]/[destination_id].")
		return
	log_game("[usr] has faxed [sent] to [name]/[destination_id].]")

/obj/machinery/fax/proc/send(atom/movable/loaded, id)
	for(var/obj/machinery/fax/fax as anything in GLOB.fax_machines)
		if(fax.fax_id != id)
			continue
		if(!fax.visible_to_network)
			continue
		if(fax.jammed)
			do_sparks(5, TRUE, src)
			balloon_alert(usr, "destination port jammed")
			playsound(src, 'sound/machines/scanbuzz.ogg', 25, TRUE, -9)
			return FALSE
		fax.receive(loaded, fax_name, important = admin_fax_id)
		history_add("Send", fax.fax_name)
		INVOKE_ASYNC(src, PROC_REF(animate_object_travel), loaded, "fax_receive", find_overlay_state(loaded, "send"))
		return TRUE
	return FALSE

/obj/machinery/fax/proc/receive(atom/movable/loaded, sender_name, important = FALSE)
	playsound(src, 'sound/items/poster_being_created.ogg', 20, FALSE)
	INVOKE_ASYNC(src, PROC_REF(animate_object_travel), loaded, "fax_receive", find_overlay_state(loaded, "receive"))
	say("Incoming fax message.")
	history_add("Receive", sender_name)
	addtimer(CALLBACK(src, PROC_REF(vend_item), loaded), 1.9 SECONDS)

/obj/machinery/fax/proc/animate_object_travel(obj/item/item, animation_state, overlay_state)
	icon_state = animation_state
	var/mutable_appearance/overlay = mutable_appearance(icon, overlay_state)
	overlays += overlay
	addtimer(CALLBACK(src, PROC_REF(travel_animation_complete), overlay), 2 SECONDS)

/obj/machinery/fax/proc/travel_animation_complete(mutable_appearance/remove_overlay)
	icon_state = "fax"
	overlays -= remove_overlay

/obj/machinery/fax/proc/find_overlay_state(obj/item/item, state_prefix)
	if(istype(item, /obj/item/paper))
		return "[state_prefix]_paper"
	if(istype(item, /obj/item/photo))
		return "[state_prefix]_photo"
	if(iscash(item))
		return "[state_prefix]_cash"
	if(istype(item, /obj/item/card))
		return "[state_prefix]_id"
	if(istype(item, /obj/item/reagent_containers/food))
		return "[state_prefix]_food"
	if(istype(item, /obj/item/throwing_star))
		return "[state_prefix]_star"
	return "[state_prefix]_paper"

/obj/machinery/fax/proc/vend_item(atom/movable/vend)
	vend.forceMove(drop_location())
	if(hurl_contents)
		vend.throw_at(get_edge_target_turf(drop_location(), pick(GLOB.alldirs)), rand(1, 4), EMBED_THROWSPEED_THRESHOLD)

/obj/machinery/fax/proc/history_add(history_type = "Send", history_fax_name)
	var/list/history_data = list()
	history_data["history_type"] = history_type
	history_data["history_fax_name"] = history_fax_name
	history_data["history_time"] = station_time_timestamp()
	fax_history += list(history_data)

/obj/machinery/fax/proc/history_clear()
	fax_history = null

/obj/machinery/fax/proc/fax_name_exist(new_fax_name)
	for(var/obj/machinery/fax/fax as anything in GLOB.fax_machines)
		if (fax.fax_name == new_fax_name)
			return TRUE
	return FALSE

/obj/machinery/fax/proc/shock(mob/living/user, chance)
	if(!istype(user) || machine_stat & (BROKEN|NOPOWER))
		return FALSE
	if(!prob(chance))
		return FALSE
	do_sparks(5, TRUE, src)
	var/check_range = TRUE
	return electrocute_mob(user, get_area(src), src, 0.7, check_range)

/*
Возвращает имя корабля без префикса, используя real_name из порта
или обрезая префикс из имени области
*/
/obj/machinery/fax/proc/get_clean_ship_name()
	if(my_port?.current_ship)
		var/datum/overmap/ship/controlled/ship = my_port.current_ship
		if(ship.real_name)
			return ship.real_name
	var/area_name = get_area_name(src)
	var/first_space = findtext(area_name, " ")
	if(first_space)
		return copytext(area_name, first_space + 1)
	return area_name

/*
Возвращает полное имя корабля с префиксом для админского отображения
*/
/obj/machinery/fax/proc/get_full_name()
	if(my_port?.current_ship)
		var/datum/overmap/ship/controlled/ship = my_port.current_ship
		if(ship.real_name && ship.source_template?.prefix)
			return "[ship.source_template.prefix] [ship.real_name]"
	return get_area_name(src)


/obj/machinery/fax/ramzi
	frontier_network = TRUE
	visible_to_network = FALSE

/obj/machinery/fax/inteq
	special_networks = list(
		list(fax_name = "Outpost Authority", fax_id = "outpost", color = "orange", emag_needed = FALSE),
		list(fax_name = "IRMG Mothership", fax_id = "inteq", color = "yellow", emag_needed = FALSE)
	)

/obj/machinery/fax/indie
	special_networks = list(
		list(fax_name = "Outpost Authority", fax_id = "outpost", color = "orange", emag_needed = FALSE)
	)

/obj/machinery/fax/nanotrasen
	special_networks = list(
		list(fax_name = "Outpost Authority", fax_id = "outpost", color = "orange", emag_needed = FALSE),
		list(fax_name = "Nanotrasen Central Command", fax_id = "nanotrasen", color = "green", emag_needed = FALSE)
	)

/obj/machinery/fax/syndicate
	special_networks = list(
		list(fax_name = "Outpost Authority", fax_id = "outpost", color = "orange", emag_needed = FALSE),
		list(fax_name = "Syndicate Coalition Coordination Center", fax_id = "syndicate", color = "red", emag_needed = FALSE)
	)

/obj/machinery/fax/solgov
	special_networks = list(
		list(fax_name = "Outpost Authority", fax_id = "outpost", color = "orange", emag_needed = FALSE),
		list(fax_name = "Solarian Confederation Frontier Affairs", fax_id = "solgov", color = "teal", emag_needed = FALSE)
	)

/obj/machinery/fax/admin
	name = "Central Command Fax Machine"
	fax_name = "Nanotrasen Central Command"
	radio_channel = RADIO_CHANNEL_CENTCOM
	visible_to_network = FALSE
	admin_fax_id = "nanotrasen"

/obj/machinery/fax/admin/outpost
	name = "Outpost Fax Machine"
	fax_name = "Outpost Authority"
	admin_fax_id = "outpost"

/obj/machinery/fax/admin/solgov
	name = "SolGov Frontier Affairs Fax Machine"
	fax_name = "Solarian Confederation Frontier Affairs"
	admin_fax_id = "solgov"

/obj/machinery/fax/admin/syndicate
	name = "Syndicate Coordination Fax Machine"
	fax_name = "Syndicate Coordination Center"
	admin_fax_id = "syndicate"

/obj/machinery/fax/admin/inteq
	name = "IRMG Fax Machine"
	fax_name = "IRMG Mothership"
	admin_fax_id = "inteq"

/obj/machinery/fax/admin/ramzi
	name = "rusty fax machine"
	fax_name = "Ramzi Communications Quartermaster"
	admin_fax_id = "ramzi"
	frontier_network = TRUE
