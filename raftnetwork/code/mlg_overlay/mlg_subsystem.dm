#define DECREMENT_AMOUNT 5 // per wait

SUBSYSTEM_DEF(mlg)
    name = "mlg"
    wait = 5 SECONDS
    //association with user and list(hud objects)
    var/list/mlg_huds = list()
    //assocation with user and mlg_level
    var/list/mlg_level = list()
    //list of every mlg object type to load
    var/list/huds_to_load
    var/list/death_sounds = list('raftnetwork/sound/air_horn.ogg',
    'raftnetwork/sound/john_cena.ogg', 'raftnetwork/sound/ohhhhhh.ogg', 'raftnetwork/sound/smoke_weed.ogg', 'raftnetwork/sound/wow.ogg')
/datum/controller/subsystem/mlg/fire(resumed)
    for(var/user in mlg_level)
        if(mlg_level[user] <= 0)
            continue

        mlg_level[user] = max((mlg_level[user] - DECREMENT_AMOUNT), 0)
        tier(user)     

/datum/controller/subsystem/mlg/Initialize()
    huds_to_load = subtypesof(/atom/movable/screen/mlg)
    return SS_INIT_SUCCESS
    
/datum/controller/subsystem/mlg/proc/add_hud_to_player(mob/user)
    if(!ishuman(user) || !user?.client)
        return

    var/images_to_add = list()
    for(var/mlg_type in huds_to_load)
        var/initialized_image = new mlg_type ()
        images_to_add += initialized_image
        mlg_huds[user] = images_to_add
    user.client.screen += images_to_add
    mlg_level[user] = 0

    RegisterSignal(user, COMSIG_FIRER_BULLET_HIT_XENO, PROC_REF(on_bullet_landing))
    RegisterSignal(user, COMSIG_HUMAN_KILLED_MOB, PROC_REF(on_mob_kill))

/datum/controller/subsystem/mlg/proc/on_bullet_landing(atom/firer, mob/hit)
    SIGNAL_HANDLER
    if(hit.stat) //crit or dead
        return //it would be funny if this check was disabled once round ended so marines could spam hitmarkers round end.

    if(prob(mlg_level[firer] + 10))
        do_hit_effects(firer, hit)

    mlg_level[firer] += 2
    tier(firer)

/datum/controller/subsystem/mlg/proc/do_hit_effects(mob/firer, mob/hit)
    SEND_SOUND(firer, 'raftnetwork/sound/hitmarker.ogg')
    var/image/mlg_effects/crosshair/M = new()
    M.add_to_atom_overlay(hit)


/datum/controller/subsystem/mlg/proc/on_mob_kill(mob/killer, mob/killed)
    SIGNAL_HANDLER
    var/level_amount = 15
    if(isxeno(killed))
        var/mob/living/carbon/xenomorph/X = killed
        var/xeno_tier = X.tier
        if(xeno_tier) //not 0
            level_amount *= xeno_tier //15, 30, 45, 60

    if(prob(mlg_level[killer] / 3))
        playsound(killer, pick(death_sounds), 100)
        var/image/mlg_effects/explosion/M = new()
        M.add_to_atom_overlay(killed)
    mlg_level[killer] += level_amount
    tier(killer)


/datum/controller/subsystem/mlg/proc/remove_hud_from_player(mob/user) 
    if(user?.client)
        user.client.screen -= mlg_huds[user]
    mlg_huds[user] = null
    mlg_huds -= user
    mlg_level -= user

    UnregisterSignal(user, COMSIG_FIRER_BULLET_HIT_XENO) 
    UnregisterSignal(user, COMSIG_HUMAN_KILLED_MOB)

/datum/controller/subsystem/mlg/proc/tier(mob/user)
    if(!mlg_huds.Find(user) || !ishuman(user) || !user?.client)
        remove_hud_from_player(user)
        return
    mlg_level[user] = min(mlg_level[user], 120)
    
    for(var/mlg_image in mlg_huds[user])
        var/atom/movable/screen/mlg/instance = mlg_image
        instance.update_appearance(mlg_level[user])
