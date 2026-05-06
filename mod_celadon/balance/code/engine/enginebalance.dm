//MARK: Electricity

/obj/machinery/power/shuttle/engine/electric
	name = "ion thruster"
	desc = "A thruster that expels charged particles to generate thrust."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric
	icon_state = "burst"
	icon_state_off = "burst_off"
	icon_state_closed = "burst"
	icon_state_open = "burst_open"
	thrust = 4 // t2=5,t3=6,t4=7
	power_per_burn = 50000

/obj/machinery/power/shuttle/engine/electric/bad
	power_per_burn = 70000

/obj/machinery/power/shuttle/engine/electric/tech1
	name = "1st gen ion thruster"
	desc = "An overclocked thruster that generates 1.3 times more thrust than regular with increased energy consumption. Like other thrusters, it can be upgraded with stock parts to improve efficiency.\n\
		Don't forget to increase the power output of the precharger to get all its power. "
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/tech1
	icon_state = "tech1"
	icon_state_off = "tech1_off"
	icon_state_closed = "tech1"
	icon_state_open = "tech1_open"
	thrust = 5 //t2=6.5 ,t3=7.5 ,t4=9
	power_per_burn = 70000

/obj/machinery/power/shuttle/engine/electric/tech2
	name = "2nd gen ion thruster"
	desc = "An improved first-generation engine, with the same thrust, but reduced energy consumption, close to the standard engine. Like other engines, it can be upgraded with spare parts to improve efficiency.\n\
		Don't forget to increase the power output of the precharger to get all its power."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/tech2
	icon_state = "tech2"
	icon_state_off = "tech2_off"
	icon_state_closed = "tech2"
	icon_state_open = "tech2_open"
	thrust = 5 //t2=6.5 ,t3=7.5 ,t4=9
	// Мы же знаем, что никто из игроков не знает про фичу того, что можно увеличить вывод в СМЕСе и получать их истинный траст?
	power_per_burn = 65000

/obj/machinery/power/shuttle/engine/electric/tech3
	name = "3rd gen ion thruster"
	desc = "A highly efficient engine that emits charged particles, creating 1.5 times more thrust. Like other engines, it can be upgraded with spare parts to improve efficiency. \n\
		Don't forget to increase the power output of the precharger to get all its power."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/electric/tech3
	icon_state = "tech3"
	icon_state_off = "tech3_off"
	icon_state_closed = "tech3"
	icon_state_open = "tech3_open"
	thrust = 6 //t2=7.5 ,t3=9 ,t4=11.5
	power_per_burn = 60000

//MARK: Plasma, Explosion, Fire
/obj/machinery/power/shuttle/engine/fueled/plasma
	name = "plasma thruster"
	desc = "A thruster that burns plasma from an adjacent heater to create thrust."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/plasma
	fuel_type = GAS_PLASMA
	fuel_use = 20
	thrust = 10
	engine_type = "plasma"  // Явно указываем, что это плазменный двигатель

/obj/machinery/power/shuttle/engine/fueled/plasma/plasma_thrust(percentage = 100, deltatime)
	. = ..()
	var/obj/machinery/atmospherics/components/unary/shuttle/heater/resolved_heater = attached_heater?.resolve()
	var/true_percentage = min(resolved_heater.return_gas() / fuel_use , percentage / 100)  // Выбираем меньшее доступное значение , запрещаем летать на пустом баке
	return thrust * true_percentage

/obj/machinery/power/shuttle/engine/fueled/expulsion
	name = "expulsion thruster"
	desc = "A thruster that expels gas inefficiently to create thrust."
	circuit = /obj/item/circuitboard/machine/shuttle/engine/expulsion
	fuel_use = 80
	thrust = 5

/*
Старая формула
/obj/machinery/power/shuttle/engine/electric/RefreshParts()
	var/installed_capacitors = 0
	var/installed_lasers = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		installed_capacitors += C.rating
	for(var/obj/item/stock_parts/micro_laser/L in component_parts)
		installed_lasers += L.rating
	efficiency_multiplier = installed_capacitors
	thrust_multiplier = installed_lasers
	Эта формула определяет рейтинг деталей двигателя в кор коде

/obj/machinery/power/shuttle/engine/electric/update_engine()
	. = ..()
	if(!.)
		return
	if(!powernet)
		thruster_active = FALSE
		return FALSE

/obj/machinery/power/shuttle/engine/electric/on_construction()
	. = ..()
	connect_to_network()

/obj/machinery/power/shuttle/engine/electric/burn_engine(percentage = 100, seconds_per_tick)
	. = ..()

	Вот эти две формулы ниже рассчитывают энергоэффективность двигателя на основе установленных в конденсаторов и лазеров.
	var/updated_power_per_burn = (power_per_burn * (1 - (0.08 * (efficiency_multiplier - 3))))
	var/updated_thrust = (thrust * (thrust_multiplier / 3))

	power_per_burn = Количество требуемой энергии для того чтобы двигатель мог реализовать свою скорость на максимум.
	efficiency_multiplier = Определяет рейтинг деталей, в формуле (efficiency_multiplier - 3) сравнивает насколько детали лучше в сравнении с т1, базовый рейтинг т1 деталей = 1.
	Рейтинг деталей определяется с помощью вот этой хуйни /obj/machinery/power/shuttle/engine/electric/RefreshParts(), значения рейтинга лежат в stock_parts,
	изменение которых отразится на всей машинерии в игре. Поэтому мы "нимношко" потрогаем переменные в RefreshParts

	var/true_percentage = min(newavail() / updated_power_per_burn, percentage / 100)
	add_delayedload(updated_power_per_burn * true_percentage)
	return updated_thrust * true_percentage

/obj/machinery/power/shuttle/engine/electric/return_fuel()
	if(length(powernet?.nodes) == 2)
		for(var/obj/machinery/power/smes/S in powernet.nodes)
			return S.charge
	return newavail()

/obj/machinery/power/shuttle/engine/electric/return_fuel_cap()
	if(length(powernet?.nodes) == 2)
		for(var/obj/machinery/power/smes/S in powernet.nodes)
			return S.capacity
	return power_per_burn
	Старая формула
	*/

/obj/machinery/power/shuttle/engine/electric/burn_engine(percentage = 100, seconds_per_tick)
	. = ..()

	// Считает рейтинг конденсаторов и вычисляет эффективное энергопотребление
	var/power_mod = 1.0 - (efficiency_multiplier - 3) * (0.20 / 3)
	var/updated_power_per_burn = power_per_burn * power_mod

	// Считает рейтинг лазеров и вычисляет скорость двигателя
	var/thrust_mod = 1.0 + (thrust_multiplier - 3) * (0.25 / 3)
	var/updated_thrust = thrust * thrust_mod

	var/true_percentage = min(newavail() / updated_power_per_burn, percentage / 100)
	add_delayedload(updated_power_per_burn * true_percentage)
	return updated_thrust * true_percentage

