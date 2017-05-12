/datum/f13_objective/protect
	name = "Protect"
	desc = "Save dis mothefucker"
	kind = BOTH
	available_factions = list("city", "none", "brotherhood")

	check_mob(mob/living/carbon/human/H)
		if(!..())
			return 0
		if(ticker.minds.len < 2)
			return 0
		return 1

	assignto(subject, var/list/data = list())
		var/datum/f13_faction/F
		if(istype(subject, /datum/f13_faction))
			F = subject
		var/list/minds = shuffle(ticker.minds)
		var/datum/mind/target
		for(var/datum/mind/mind in minds)
			if(!mind || !mind.current)
				continue
			var/mob/living/M = mind.current
			if(mind != subject)
				if(F && M && M.social_faction == F.id)
					continue
				target = mind
				break
		data["target"] = target
		data["target_rank"] = target.assigned_role
		data["custom_desc"] = "Your target is <b>%target%</b> as <b>%target_rank%</b>"
		..()

	check_complete(var/datum/objective_holder/holder)
		if(!holder || !holder.data["target"])
			return 1
		var/datum/mind/target = holder.data["target"]
		if(target.current.stat != DEAD)
			return 1
		return 0