/* MARK: = Ammo List =
[*] - отсутствуют.
[-] - отключены.

> .308
> 8x58
> 410x76mm
Resprite
> .308
> 5.56x42
> 7.62x40
*/

/*
MARK: BULLET STACK IN BOX
Чтобы не срать в кор код где я меняю циферку 4 на циферку 7, заливаю сюда переопределение количества горстей патронов в коробке, чтобы избавить игроков от раздражающей дрочни с менеджементом инвентаря.
Единая таблица: тип_коробки -> список(тип_стопки, количество_горстей)
*/

/obj/item/storage/box/ammo/var/static/list/ammo_box_spawn_config = list(
	// Gauss
	/obj/item/storage/box/ammo/ferropellet        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/ferropellet, 7),
	/obj/item/storage/box/ammo/ferropellet/hc     = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/ferropellet/hc, 7),
	/obj/item/storage/box/ammo/ferroslug          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/ferroslug, 7),
	/obj/item/storage/box/ammo/ferroslug/hc       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/ferroslug/hc, 7),
	/obj/item/storage/box/ammo/ferrolance         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/ferrolance, 7),
	/obj/item/storage/box/ammo/ferrolance/hc      = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/ferrolance/hc, 7),

	// 8x50mmR
	/obj/item/storage/box/ammo/a8_50r             = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a8_50r, 7),
	/obj/item/storage/box/ammo/a8_50r/hp          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a8_50r/hp, 7),
	/obj/item/storage/box/ammo/a8_50r/match       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a8_50r/match, 7),
	/obj/item/storage/box/ammo/a8_50r/trac        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a8_50r/trac, 7),

	// 5.56x42mm CLIP
	/obj/item/storage/box/ammo/a556_42            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a556_42, 7),
	/obj/item/storage/box/ammo/a556_42/hp         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a556_42/hp, 7),
	/obj/item/storage/box/ammo/a556_42/ap         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a556_42/ap, 7),

	// 7.62x40mm CLIP
	/obj/item/storage/box/ammo/a762_40            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40, 7),
	/obj/item/storage/box/ammo/a762_40/hp         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40/hp, 7),
	/obj/item/storage/box/ammo/a762_40/ap         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40/ap, 7),
	/obj/item/storage/box/ammo/a762_40/rubber     = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40/rubber, 7),
	/obj/item/storage/box/ammo/a762_40/inteq      = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40, 7),
	/obj/item/storage/box/ammo/a762_40/ap/inteq   = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40/ap, 7),
	/obj/item/storage/box/ammo/a762_40/hp/inteq   = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40/hp, 7),
	/obj/item/storage/box/ammo/a762_40/rubber/inteq = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a762_40/rubber, 7),

	// .308
	/obj/item/storage/box/ammo/a308               = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308, 7),
	/obj/item/storage/box/ammo/a308/hp            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/hp, 7),
	/obj/item/storage/box/ammo/a308/ap            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/ap, 7),
	/obj/item/storage/box/ammo/a308/inteq         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308, 7),

	// .299 Eoehoma Caseless
	/obj/item/storage/box/ammo/c299               = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c299, 7),

	// 12 gauge
	/obj/item/storage/box/ammo/a12g_buckshot      = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/shotgun/buckshot, 7),
	/obj/item/storage/box/ammo/a12g_slug          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/shotgun/slug, 7),
	/obj/item/storage/box/ammo/a12g_beanbag       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/shotgun/beanbag, 7),
	/obj/item/storage/box/ammo/a12g_rubbershot    = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/shotgun/rubber, 7),
	/obj/item/storage/box/ammo/a12g_blank         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/shotgun/blank, 7),
	/obj/item/storage/box/ammo/pulseslug          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/shotgun/pulseslug, 7),
	/obj/item/storage/box/ammo/a12g_dart          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/shotgun/dart, 7),

	// 4.6x30mm
	/obj/item/storage/box/ammo/c46x30mm           = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c46x30mm, 7),
	/obj/item/storage/box/ammo/c46x30mm/ap        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c46x30mm/ap, 7),
	/obj/item/storage/box/ammo/c46x30mm/hp        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c46x30mm/hp, 7),
	/obj/item/storage/box/ammo/c46x30mm/rubber    = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c46x30mm/rubber, 7),
	/obj/item/storage/box/ammo/c46x30mm/tesla     = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c46x30mm/tesla, 7),

	// 5.56mm HITP
	/obj/item/storage/box/ammo/c556mm             = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c556mm, 7),
	/obj/item/storage/box/ammo/c556mm_surplus     = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c556mm/surplus, 7),
	/obj/item/storage/box/ammo/c556mm_ap          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c556mm/ap, 7),
	/obj/item/storage/box/ammo/c556mm_hp          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c556mm/hp, 7),
	/obj/item/storage/box/ammo/c556mm_rubber      = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c556mm/rubbershot, 7),

	// 5.7x39mm
	/obj/item/storage/box/ammo/c57x39             = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c57x39, 7),
	/obj/item/storage/box/ammo/c57x39/hp          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c57x39/hp, 7),
	/obj/item/storage/box/ammo/c57x39/ap          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c57x39/ap, 7),
	/obj/item/storage/box/ammo/c57x39/rubber      = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c57x39/rubber, 7),

	// Sniper
	/obj/item/storage/box/ammo/a50box             = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/p50, 7),
	/obj/item/storage/box/ammo/a858               = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a858, 7),
	/obj/item/storage/box/ammo/a300               = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a300, 7),
	/obj/item/storage/box/ammo/a300/trac          = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a300/trac, 2),
	/obj/item/storage/box/ammo/a65clip            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a65clip, 7),
	/obj/item/storage/box/ammo/a65clip/trac       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a65clip/trac, 2),

	// Foam darts
	/obj/item/storage/box/ammo/foam_darts         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/foam_darts, 7),
	/obj/item/storage/box/ammo/foam_darts/riot    = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/foam_darts/riot, 7),

	// Pistol calibers
	/obj/item/storage/box/ammo/c10mm              = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c10mm, 7),
	/obj/item/storage/box/ammo/c10mm_surplus      = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c10mm/surplus, 7),
	/obj/item/storage/box/ammo/c10mm_ap           = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c10mm/ap, 7),
	/obj/item/storage/box/ammo/c10mm_hp           = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c10mm/hp, 7),
	/obj/item/storage/box/ammo/c10mm_rubber       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c10mm/rubber, 7),

	/obj/item/storage/box/ammo/c9mm               = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c9mm, 7),
	/obj/item/storage/box/ammo/c9mm_surplus       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c9mm/surplus, 7),
	/obj/item/storage/box/ammo/c9mm_ap            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c9mm/ap, 7),
	/obj/item/storage/box/ammo/c9mm_hp            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c9mm/hp, 7),
	/obj/item/storage/box/ammo/c9mm_rubber        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c9mm/rubber, 7),

	/obj/item/storage/box/ammo/c45                = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c45, 7),
	/obj/item/storage/box/ammo/c45_surplus        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c45/surplus, 7),
	/obj/item/storage/box/ammo/c45_ap             = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c45/ap, 7),
	/obj/item/storage/box/ammo/c45_hp             = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c45/hp, 7),
	/obj/item/storage/box/ammo/c45_rubber         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c45/rubber, 7),

	/obj/item/storage/box/ammo/c22lr              = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c22lr, 7),
	/obj/item/storage/box/ammo/c22lr/ap           = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c22lr/ap, 7),
	/obj/item/storage/box/ammo/c22lr/hp           = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c22lr/hp, 7),
	/obj/item/storage/box/ammo/c22lr/rubber       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c22lr/rubber, 7),

	/obj/item/storage/box/ammo/a357               = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a357, 7),
	/obj/item/storage/box/ammo/a357_match         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a357/match, 7),
	/obj/item/storage/box/ammo/a357_hp            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a357/hp, 7),

	/obj/item/storage/box/ammo/a4570              = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a4570, 7),
	/obj/item/storage/box/ammo/a4570_match        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a4570/match, 7),
	/obj/item/storage/box/ammo/a4570_hp           = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a4570/hp, 7),
	/obj/item/storage/box/ammo/a4570_explosive    = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a4570/explosive, 7),

	/obj/item/storage/box/ammo/c38                = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c38, 7),
	/obj/item/storage/box/ammo/c38_surplus        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c38/surplus, 7),
	/obj/item/storage/box/ammo/c38_hotshot        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c38/hotshot, 7),
	/obj/item/storage/box/ammo/c38_iceblox        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/c38/iceblox, 7),

	/obj/item/storage/box/ammo/a44roum            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a44roum, 7),
	/obj/item/storage/box/ammo/a44roum_rubber     = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a44roum/rubber, 7),
	/obj/item/storage/box/ammo/a44roum_hp         = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a44roum/hp, 7),

	// CELADON-ADD коробки
	/obj/item/storage/box/ammo/a556_box/surplus   = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a556_45/surplus, 7),
	/obj/item/storage/box/ammo/a308/rubber        = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/rubber, 7),
	/obj/item/storage/box/ammo/a308/surplus       = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/surplus, 7),
	/obj/item/storage/box/ammo/a410_ammo_box      = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410, 7),
	/obj/item/storage/box/ammo/a410_ammo_box/slug     = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410/slug, 7),
	/obj/item/storage/box/ammo/a410_ammo_box/flechette = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410/flechette, 7),
	/obj/item/storage/box/ammo/x762_54            = list(/obj/item/ammo_box/magazine/ammo_stack/prefilled/x762_54, 7),
)

/obj/item/storage/box/ammo/Initialize(mapload)
	. = ..()
	var/list/config = ammo_box_spawn_config[type]
	if(!config)
		return
	var/stack_type = config[1]
	var/amount = config[2]
	// Удаляем всё что определялось в кор-коде
	for(var/obj/item/I in contents)
		qdel(I)
	// Наполняем правильными горстями
	for(var/i in 1 to amount)
		new stack_type(src)
	update_icon()

/*
=========================================
CELADON LEGACY
=========================================
*/

// MARK: .308

//коробки патроны 308 калибра - на данный момент эндгейм патроны , огромный урон , огромное пробитие , высокая цена

//Резина , минимум урона здоровью , средне стамине
/obj/item/storage/box/ammo/a308/rubber
	name = "box of rubber .308 ammo"
	icon_state = "a308box-rubbershot"

/obj/item/storage/box/ammo/a308/rubber/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/rubber = 4)
	generate_items_inside(items_inside,src)

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/rubber
	ammo_type = /obj/item/ammo_casing/a308/rubber
	max_ammo = 10

//Тупое название сурплус , будет брак или некачественное исполнение. Снижен урон , минимум пробития - не для продажи
/obj/item/storage/box/ammo/a308/surplus
	name = "Коробка бракованных патронов .308"
	desc = "Не очень качественные патроны калибра .308, хуже заводских но все еще годны."
	icon_state = "a308_brak"

/obj/item/storage/box/ammo/a308/surplus/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/surplus = 4)
	generate_items_inside(items_inside,src)

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a308/surplus
	ammo_type = /obj/item/ammo_casing/a308/surplus
	max_ammo = 10


// MARK: 410x76

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/saiga_bullet.dmi'
	ammo_type = /obj/item/ammo_casing/a410
	max_ammo = 15

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410/slug
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/saiga_bullet.dmi'
	ammo_type = /obj/item/ammo_casing/a410/a410_slug
	max_ammo = 15

/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410/flechette
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/saiga_bullet.dmi'
	ammo_type = /obj/item/ammo_casing/a410/a410_flechette
	max_ammo = 15

/obj/item/storage/box/ammo/a410_ammo_box
	name = "Ammo box (410x76mm buckshot)"
	desc = "A box of buckshot 410x76mm ammo."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/saiga_ammo.dmi'
	icon_state = "410box_buckshot"
/obj/item/storage/box/ammo/a410_ammo_box/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410 = 4)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/ammo/a410_ammo_box/slug
	name = "Ammo box (410x76mm slug)"
	desc = "A box of slug 410x76mm ammo."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/saiga_ammo.dmi'
	icon_state = "410box_slug"
/obj/item/storage/box/ammo/a410_ammo_box/slug/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410/slug = 4)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/ammo/a410_ammo_box/flechette
	name = "Ammo box (410x76mm flechette)"
	desc = "A box of flechette 410x76mm ammo."
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/saiga_ammo.dmi'
	icon_state = "410box_flechette"
/obj/item/storage/box/ammo/a410_ammo_box/flechette/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/a410/flechette = 4)
	generate_items_inside(items_inside,src)

// MARK: 7.62X54mm R

/obj/item/ammo_box/magazine/ammo_stack/prefilled/x762_54
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/svd_bullet.dmi'
	ammo_type = /obj/item/ammo_casing/x762_54
	max_ammo = 10

/obj/item/storage/box/ammo/x762_54
	name = "box of 7.62x54mmR ammo"
	desc = "A box of standard 7.62x54mmR ammo."
	icon_state = "x762_54box"
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'

/obj/item/storage/box/ammo/x762_54/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/x762_54 = 4)
	generate_items_inside(items_inside,src)

// MARK: RESPRITE






// MARK: .308

/obj/item/storage/box/ammo/a308
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'
	icon_state = "a308box-HP"

/obj/item/storage/box/ammo/a308/hunterspride
	icon_state = "a308box"

/obj/item/storage/box/ammo/a308/hp
	icon_state = "a308box-hp"

/obj/item/storage/box/ammo/a308/ap
	icon_state = "a308box-ap"

// MARK: 5.56x42

/obj/item/storage/box/ammo/a556_42
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'
	icon_state = "a556_42box_big"

// MARK: 7.62x40

/obj/item/storage/box/ammo/a762_40
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'

/obj/item/storage/box/ammo/a762_40/inteq
	icon_state = "a762_40box_big_inteq"

/obj/item/storage/box/ammo/a762_40/ap/inteq
	icon_state = "a762_40box_big-ap_inteq"

/obj/item/storage/box/ammo/a762_40/hp/inteq
	icon_state = "a762_40box_big-hp_inteq"

/obj/item/storage/box/ammo/a762_40/rubber/inteq
	icon_state = "a762_40box_big-rubbershot_inteq"

/obj/item/ammo_box/magazine/m57_39_sidewinder
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo.dmi'

// MARK: 4.6x30

/obj/item/storage/box/ammo/c46x30mm
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'

/obj/item/storage/box/ammo/c46x30mm/tesla
	name = "box of 4.6x30mm tesla ammo"
	desc = "A box of standard 4.6x30mm tesla ammo."
	icon_state = "46x30mmbox-tesla"

/obj/item/storage/box/ammo/c46x30mm/tesla/PopulateContents()
	var/static/items_inside = list(
		/obj/item/ammo_box/magazine/ammo_stack/prefilled/c46x30mm/tesla = 4)
	generate_items_inside(items_inside,src)

// MARK: 9x18mm

//why are they not subpaths to c9mm
/obj/item/storage/box/ammo/c9mm
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'

/obj/item/storage/box/ammo/c9mm_ap
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'

/obj/item/storage/box/ammo/c9mm_hp
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'

/obj/item/storage/box/ammo/c9mm_rubber
	icon = 'mod_celadon/_storage_icons/icons/items/weapons/ammo/ammo_boxes.dmi'
