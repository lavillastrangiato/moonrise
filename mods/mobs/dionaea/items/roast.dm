/obj/item/food/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon = 'mods/mobs/dionaea/icons/roast.dmi'
	plate = /obj/item/plate
	filling_color = "#75754b"
	center_of_mass = @'{"x":16,"y":7}'
	nutriment_desc = list("a chorus of flavor" = 6)
	nutriment_amt = 6
	bitesize = 2

/obj/item/food/dionaroast/populate_reagents()
	add_to_reagents(/decl/material/solid/metal/radium, 2)
	. = ..()
