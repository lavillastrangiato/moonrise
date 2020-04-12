/obj/item/cash
	name = "cash"
	desc = "Some cold hard cash."
	icon = 'icons/obj/items/money.dmi'
	icon_state = "cash"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	force = 1
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_TINY
	var/currency
	var/absolute_worth = 0
	var/can_flip = FALSE // Cooldown tracker for single-coin flips.

/obj/item/cash/Initialize(ml, material_key)
	. = ..()
	appearance_flags |= PIXEL_SCALE
	if(!ispath(currency, /decl/currency))
		currency = GLOB.using_map.default_currency
	if(absolute_worth > 0)
		update_from_worth()

/obj/item/cash/proc/set_currency(var/new_currency)
	currency = new_currency
	update_from_worth()

/obj/item/cash/proc/adjust_worth(var/amt)
	absolute_worth += amt
	if(absolute_worth <= 0)
		qdel(src)
	else
		update_from_worth()

/obj/item/cash/proc/get_worth()
	var/decl/currency/local_currency = decls_repository.get_decl(currency)
	. = Floor(absolute_worth / local_currency.absolute_value)

/obj/item/cash/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cash))
		var/obj/item/cash/cash = W
		if(cash.currency != currency)
			to_chat(W, SPAN_WARNING("You can't mix currencies, it would be uncivilized."))
			return
		if(user.unEquip(W))
			adjust_worth(cash.absolute_worth)
			var/decl/currency/local_currency = decls_repository.get_decl(currency)
			to_chat(user, SPAN_NOTICE("You add [cash.get_worth()] [local_currency.name] to the pile."))
			to_chat(user, SPAN_NOTICE("It holds [get_worth()] [local_currency.name] now."))
			qdel(W)
		return TRUE
	else if(istype(W, /obj/item/gun/launcher/money))
		var/obj/item/gun/launcher/money/L = W
		L.absorb_cash(src, user)

/obj/item/cash/on_update_icon()
	icon_state = ""
	var/draw_worth = get_worth()
	var/list/adding_notes
	var/decl/currency/local_currency = decls_repository.get_decl(currency)
	for(var/denomination in local_currency.denominations)
		if(draw_worth < denomination)
			continue
		var/denomination_string = "[denomination]"
		while(draw_worth >= denomination)
			draw_worth -= denomination
			var/image/banknote = image(local_currency.icon, local_currency.denomination_has_state[denomination_string] || "cash")
			banknote.appearance_flags |= RESET_COLOR
			banknote.color = local_currency.denomination_has_colour[denomination_string] || COLOR_PALE_BTL_GREEN
			if(local_currency.denomination_has_mark[denomination_string])
				var/image/mark = image(local_currency.icon, local_currency.denomination_has_mark[denomination_string])
				mark.appearance_flags |= RESET_COLOR
				banknote.overlays |= mark
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			LAZYADD(adding_notes, banknote)
	overlays = adding_notes

/obj/item/cash/proc/update_from_worth()
	var/decl/currency/local_currency = decls_repository.get_decl(currency)
	matter = list()
	matter[local_currency.material] = absolute_worth * max(1, round(SHEET_MATERIAL_AMOUNT/10))
	var/current_worth = get_worth()
	if(current_worth in local_currency.denominations) // Single piece.
		SetName("[current_worth] [local_currency.name_singular] [local_currency.denomination_has_name[current_worth] || "piece"]")
		desc = "[initial(desc)] It's worth [current_worth] [current_worth == 1 ? local_currency.name_singular : local_currency.name]."
		w_class = ITEM_SIZE_TINY
	else
		SetName("pile of [local_currency.name]")
		desc = "[initial(desc)] It totals up to [current_worth] [current_worth == 1 ? local_currency.name_singular : local_currency.name]."
		w_class = ITEM_SIZE_SMALL
	update_icon()

/obj/item/cash/attack_self(var/mob/user)

	var/decl/currency/local_currency = decls_repository.get_decl(currency)
	var/current_worth = get_worth()

	// Handle coin flipping. Mostly copied from /obj/item/coin.
	if((current_worth in local_currency.denomination_is_coin) && alert("Do you wish to divide \the [src], or flip it?", "Flip or Split?", "Flip", "Split") == "Flip")
		if(!can_flip)
			to_chat(user, SPAN_WARNING("\The [src] is already being flipped!"))
			return
		can_flip = FALSE
		playsound(usr.loc, 'sound/effects/coin_flip.ogg', 75, 1)
		user.visible_message(SPAN_NOTICE("\The [user] flips \the [src] into the air."))
		sleep(1.5 SECOND)
		if(!QDELETED(user) && !QDELETED(src) && loc == user && get_worth() == current_worth)
			user.visible_message(SPAN_NOTICE("...and catches it, revealing that \the [src] landed on [(prob(50) && "tails") || "heads"]!"))
		can_flip = TRUE
		return TRUE
	// End coin flipping.

	if(QDELETED(src) || get_worth() <= 1 || user.incapacitated() || loc != user)
		return TRUE

	var/amount = input(usr, "How many [local_currency.name] do you want to take? (0 to [get_worth() - 1])", "Take Money", 20) as num
	amount = round(Clamp(amount, 0, Floor(get_worth() - 1)))

	if(!amount || QDELETED(src) || get_worth() <= 1 || user.incapacitated() || loc != user)
		return TRUE

	amount = Floor(amount * local_currency.absolute_value)
	adjust_worth(-(amount))
	var/obj/item/cash/cash = new(get_turf(src))
	cash.set_currency(currency)
	cash.adjust_worth(amount)
	user.put_in_hands(cash)

/obj/item/cash/c1
	absolute_worth = 1

/obj/item/cash/c10
	absolute_worth = 10

/obj/item/cash/c20
	absolute_worth = 20

/obj/item/cash/c50
	absolute_worth = 50

/obj/item/cash/c100
	absolute_worth = 100

/obj/item/cash/c200
	absolute_worth = 200

/obj/item/cash/c500
	absolute_worth = 500

/obj/item/cash/c1000
	absolute_worth = 1000

/obj/item/charge_card
	name = "charge card"
	icon = 'icons/obj/items/e_funds.dmi'
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."

	var/loaded_worth = 0
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.
	var/currency

/obj/item/charge_card/Initialize(ml, material_key)
	. = ..()
	appearance_flags |= PIXEL_SCALE
	if(!ispath(currency, /decl/currency))
		currency = GLOB.using_map.default_currency

/obj/item/charge_card/proc/adjust_worth(amt)
	loaded_worth += amt
	if(loaded_worth < 0)
		loaded_worth = 0

/obj/item/charge_card/examine(mob/user, distance)
	. = ..(user)
	if(distance <= 2 || user == loc)
		to_chat(user, SPAN_NOTICE("<b>Owner:</b> [owner_name]."))
		var/decl/currency/local_currency = decls_repository.get_decl(currency)
		to_chat(user, SPAN_NOTICE("<b>[capitalize(local_currency.name)]</b> remaining: [Floor(loaded_worth / local_currency.absolute_value)]."))

/obj/item/charge_card/get_single_monetary_worth()
	. = loaded_worth
