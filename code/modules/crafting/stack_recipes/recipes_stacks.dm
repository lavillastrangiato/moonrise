// Tiles
/decl/stack_recipe/tile
	abstract_type = /decl/stack_recipe/tile
	res_amount = 4
	max_res_amount = 20
	time = 5
	difficulty = 1
	apply_material_name = FALSE
	category = "tiling"

/decl/stack_recipe/tile/spawn_result(user, location, amount)
	var/obj/item/stack/S = ..()
	if(istype(S))
		S.amount = amount
		if(user)
			S.add_to_stacks(user, 1)
	return S

/decl/stack_recipe/tile/wood
	name = "wood floor tile"
	result_type = /obj/item/stack/tile/wood
	required_material = /decl/material/solid/organic/wood

/decl/stack_recipe/tile/mahogany
	name = "mahogany floor tile"
	result_type = /obj/item/stack/tile/mahogany
	required_material = /decl/material/solid/organic/wood/mahogany

/decl/stack_recipe/tile/maple
	name = "maple floor tile"
	result_type = /obj/item/stack/tile/maple
	required_material = /decl/material/solid/organic/wood/maple

/decl/stack_recipe/tile/ebony
	name = "ebony floor tile"
	difficulty = 3
	result_type = /obj/item/stack/tile/ebony
	required_material = /decl/material/solid/organic/wood/ebony

/decl/stack_recipe/tile/walnut
	name = "walnut floor tile"
	result_type = /obj/item/stack/tile/walnut
	required_material = /decl/material/solid/organic/wood/walnut
