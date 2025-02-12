/mob/living/simple_animal/borer/can_do_special_ranged_attack(var/check_flag = TRUE)
	. = can_use_borer_ability(requires_host_value = check_flag)

/mob/living/simple_animal/borer/proc/can_use_borer_ability(var/silent = FALSE, var/requires_host_value = TRUE, var/usable_while_docile = FALSE, var/check_last_special = TRUE)

	if(controlling)
		return FALSE

	if(requires_host_value)
		if(!host)
			if(!silent)
				to_chat(src, SPAN_WARNING("You must be within a host body to use this action."))
			return FALSE
	else
		if(host)
			if(!silent)
				to_chat(src, SPAN_WARNING("You cannot be within a host body when using this action."))
			return FALSE

	if(stat)
		if(!silent)
			to_chat(src, SPAN_WARNING("You cannot perform this action in your current state."))
		return FALSE
	if(docile && !usable_while_docile)
		if(!silent)
			to_chat(src, SPAN_NOTICE("You are feeling far too docile to perform this action."))
		return FALSE
	if(check_last_special && is_on_special_ability_cooldown())
		if(!silent)
			to_chat(src, SPAN_NOTICE("You cannot perform this action so soon after the last."))
		return FALSE
	return TRUE

// BRAIN WORM ZOMBIES AAAAH.
/mob/living/simple_animal/borer/proc/replace_brain()

	var/mob/living/human/H = host

	if(!istype(host))
		to_chat(src, SPAN_WARNING("This host does not have a suitable brain."))
		return

	to_chat(src, SPAN_DANGER("You settle into the empty brainpan and begin to expand, fusing inextricably with the dead flesh of [H]."))

	H.add_language(/decl/language/corticalborer)

	if(host.stat == DEAD)
		H.verbs |= /mob/living/human/proc/jumpstart

	H.verbs |= /mob/living/human/proc/psychic_whisper
	if(!neutered)
		H.verbs |= /mob/living/proc/spawn_larvae

	if(H.client)
		H.ghostize(CORPSE_CANNOT_REENTER)

	if(src.mind)
		src.mind.assigned_special_role = "Borer Husk"
		src.mind.transfer_to(host)

	H.add_genetic_condition(GENE_COND_HUSK)

	var/obj/item/organ/internal/borer/B = new(H)
	if(islist(chemical_types))
		B.chemical_types = chemical_types.Copy()

	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, BP_HEAD)
	LAZYREMOVE(affecting.implants, src)

	var/s2h_id = src.computer_id
	var/s2h_ip= src.lastKnownIP
	src.computer_id = null
	src.lastKnownIP = null
	if(!H.computer_id)
		H.computer_id = s2h_id
	if(!H.lastKnownIP)
		H.lastKnownIP = s2h_ip

/mob/living/human/proc/jumpstart()
	set category = "Abilities"
	set name = "Revive Host"
	set desc = "Send a jolt of electricity through your host, reviving them."

	if(stat != DEAD)
		to_chat(usr, SPAN_WARNING("Your host is already alive."))
		return

	verbs -= /mob/living/human/proc/jumpstart
	visible_message(SPAN_DANGER("With a hideous, rattling moan, [src] shudders back to life!"))
	rejuvenate()
	update_posture()
