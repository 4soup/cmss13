//I put what I felt were significant variables for combat/equipment in this list, 
//if you think something needs to be added/removed or have better implementation, by all means do so.
#define RETARD_LIST list("job", "l_hand", "r_hand", "wear_l_ear", "wear_r_ear", "w_uniform", "shoes", "gloves", "belt", "wear_suit", "glasses", "wear_mask", "head", "back", "l_store", "r_store", "health", "disabilities", "sdisabilities", "mobility_flags", "melee_damage_lower", "melee_damage_upper", "unacidable", "explo_proof", "emp_proof", "maxHealth", "bruteloss", "fireloss", "oxyloss", "toxloss", "cloneloss", "brainloss", "max_blood", "mob_size", "slowed", "chem_effect_reset_time", "command_aura_available", "mobility_aura_count", "protection_aura_count", "marksman_aura_count", "mobility_aura", "protection_aura", "marksman_aura", "blood_volume", "limit_blood", "paralyzed", "confused", "losebreath", "bodytemperature", "recovery_constant")

/obj/tr_walkway
    icon = 'raftnetwork/icons/obj/tr_walkway.dmi'
    unacidable = TRUE
    var/on = TRUE

/obj/tr_walkway/MouseEntered(location, control, params)
    . = ..()
    alpha = initial(alpha) - 90

/obj/tr_walkway/MouseExited(location, control, params)
    . = ..()
    alpha = initial(alpha)



/obj/tr_walkway/killer
    name = "killer"
    desc = "kills shit click to toggle killing"
    icon_state = "killer"

/obj/tr_walkway/killer/Initialize(mapload, ...)
    . = ..()
    icon_state = "killer[on]"

/obj/tr_walkway/killer/clicked(mob/user, list/mods)
    . = ..()
    on = !on
    icon_state = "killer[on]"

/obj/tr_walkway/killer/Crossed(M as mob)
    if (!on || !isliving(M))
        return

    var/mob/living/ML = M
    if(ML.client)
        return

    ML.Destroy()
    qdel(ML)



/obj/tr_walkway/spawner
    name = "spawner"
    desc = "spawns shit, click to toggle spawning."
    icon_state = "spawner0"
    var/mob/spawned_mob
    var/mob_type = /mob/living/carbon/xenomorph/runner
    var/list/mob_vars
    var/list/mob_atoms

/obj/tr_walkway/spawner/Initialize(mapload, ...)
    . = ..()
    icon_state = "spawner[on]"
    if (on)
        START_PROCESSING(SSobj, src)

/obj/tr_walkway/spawner/clicked(mob/user, list/mods)
    . = ..()
    on = !on
    icon_state = "spawner[on]"
    to_chat(user, "spawning [on ? "enabled" : "disabled"]" )
    if(on)
        START_PROCESSING(SSobj, src)
    else
        STOP_PROCESSING(SSobj, src)
    return TRUE

/obj/tr_walkway/spawner/process()
    if (!on)
        STOP_PROCESSING(SSobj, src)
        return

    if(QDELETED(spawned_mob))
        spawn_mob()
        return

    if(spawned_mob.stat)
        // // option one: clear corpses
        // spawned_mob.Destroy()
        // qdel(spawned_mob)

        // option two: Let the bodies hit the floor.
        spawned_mob = null
        return

    spawned_mob.Move(get_step(spawned_mob, EAST), EAST)

/obj/tr_walkway/spawner/proc/spawn_mob()
    spawned_mob = new mob_type (get_turf(src))
    if(!length(mob_vars) || !length(mob_atoms))
        return

    for(var/var_name in mob_vars)
        spawned_mob.vars[var_name] = mob_vars[var_name]
    
    for(var/var_name in mob_atoms)
        var/atom/new_atom = mob_atoms[var_name]
        new_atom = new new_atom (spawned_mob)
        spawned_mob.vars[var_name] = new_atom
    spawned_mob.regenerate_icons() 



/obj/tr_walkway/clear_button
    name = "clean button"
    desc = "click to clear gibs and items."
    icon_state = "magicsoap"

/obj/tr_walkway/clear_button/clicked(mob/user, list/mods)
    . = ..()
    for (var/turf/T in block(x-7, y-7, z, x+7, y+7, z))
        for (var/atom/A in T)
            if(!isliving(A))
                if(istype(A, /obj/tr_walkway))
                    continue
                qdel(A)
                continue

            var/mob/M = A
            if(M.client)
                continue
            qdel(M)
    to_chat(user, "cleared!")



// only applies to column below.
/obj/tr_walkway/cloner
    name = "cloner"
    desc = "click to copy the mob ontop into spawners. turn the spawner off to not copy the new mob"
    icon_state = "camera"
    var/mob/living/clone_type
    var/list/clone_vars 
    //we need to create new copies of each atom or else we would just switch a pointer
    var/list/clone_atoms 

/obj/tr_walkway/cloner/clicked(mob/user, list/mods)
    var/mob/M = locate(/mob/living) in range(1, src)
    if(!M)
        return

    clone_type = M.type
    clone_atoms = list()
    clone_vars = list()
    for(var/var_name in RETARD_LIST)
        if(!M.vars.Find(var_name)) //hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
            continue
        var/var_value = M.vars[var_name] 

        if(isatom(var_value))
            var/atom/var_atom = var_value
            clone_atoms[var_name] = var_atom.type

        else
            clone_vars[var_name] = var_value

    // send_clone_to_spawners() returns the numbers of spawners the clone was sent to.
    var/n = send_clone_to_spawners()
    to_chat(user, "copied clone_type: [clone_type] to [n ? n : 0] spawners")

/obj/tr_walkway/cloner/proc/send_clone_to_spawners()
    var/n
    for(var/obj/tr_walkway/spawner/S in range(10, src)) //21x21
        if(!S.on)
            continue // only on spawners get sent copies
        S.mob_type = clone_type
        if(length(clone_vars))
            S.mob_vars = clone_vars
        if(length(clone_atoms))
            S.mob_atoms = clone_atoms
        n ++
    return n

/obj/tr_walkway/skill_granter
    icon_state = "spurdo"
    name = "skill granter"
    desc = "click to grant every skill and give access"

/obj/tr_walkway/skill_granter/clicked(mob/user, list/mods)
    to_chat(user, "granting")
    if(user?.skills)
        user.skills = null //no restrictions
    give_access(user)

/obj/tr_walkway/skill_granter/proc/give_access(mob/user)
    if(!istype(user, /mob/living/carbon/human))
        alert("Invalid mob for giving access")
        return

    var/mob/living/carbon/human/H = user
    var/obj/item/card/id/id = H.get_idcard()
    if(id)
        id.icon_state = "gold"
        id.access = get_access(ACCESS_LIST_GLOBAL)
    else
        id = new(H)
        id.icon_state = "gold"
        id.access = get_access(ACCESS_LIST_GLOBAL)
        id.registered_name = H.real_name
        id.registered_ref = WEAKREF(H)
        id.assignment = "Captain"
        id.name = "[id.registered_name]'s [id.id_type] ([id.assignment])"
        H.equip_to_slot_or_del(id, WEAR_ID)
        H.update_inv_wear_id()

#undef RETARD_LIST
