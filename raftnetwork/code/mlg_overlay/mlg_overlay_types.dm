/atom/movable/screen/mlg/x_button
    icon = 'icons/mob/hud/human_bronze.dmi'
    icon_state = "x"
    screen_loc = "LEFT,TOP"

/atom/movable/screen/mlg/x_button/MouseEntered()
    alpha = 200

/atom/movable/screen/mlg/x_button/MouseExited()
    alpha = initial(alpha)

/atom/movable/screen/mlg/x_button/update_appearance()
    return

/atom/movable/screen/mlg/x_button/clicked(mob/user, list/mods)
    . = ..()
    if(!ishuman(user))
        return
    var/mob/living/carbon/human/H = user
    H.toggle_mlg_mode()

/atom/movable/screen/mlg/wow_guy
    icon = 'raftnetwork/icons/mob/hud/wow.dmi'
    screen_loc = "RIGHT,BOTTOM"

/atom/movable/screen/mlg/wow_guy/update_appearance(scale)
    switch(scale)
        if(-1.#INF to 20)
            if(last_state == 0)
                return
            
            last_state = 0
            icon_state = null
        if(21 to 50)
            if(last_state == 1)
                return

            last_state = 1
            icon_state = "0"
        else
            if(last_state == 2)
                return

            last_state = 2
            icon_state = "1"


/atom/movable/screen/mlg/bone
    icon = 'raftnetwork/icons/mob/hud/bone.dmi'
    screen_loc = "LEFT:-23,TOP"

/atom/movable/screen/mlg/bone/update_appearance(scale = 0)
    if(scale < 20 && last_state != 0)
        last_state = 0
        icon_state = null
    else if(scale > 19 && last_state != 1)
        last_state = 1
        icon_state = "0"

/atom/movable/screen/mlg/brazzers
    icon = 'raftnetwork/icons/mob/hud/brazzers.dmi'
    screen_loc = "RIGHT-50%,TOP-0.25"

/atom/movable/screen/mlg/brazzers/update_appearance(scale = 0)
    if(scale < 68 && last_state != 0)
        last_state = 0
        icon_state = null
    else if(scale > 69 && last_state != 1)
        last_state = 1
        icon_state = "0"


/atom/movable/screen/mlg/blunt
    icon = 'raftnetwork/icons/mob/hud/blunt.dmi'
    screen_loc = "LEFT+3,BOTTOM"

/atom/movable/screen/mlg/blunt/update_appearance(scale = 0)
    switch(scale)
        if(-1.#INF to 25)
            if(last_state == 0)
                return

            last_state = 0
            icon_state = null
            overlays.Cut()
        if(26 to 40)
            if(last_state == 1)
                return

            last_state = 1
            icon_state = "0"
            overlays.Cut()
        if(41 to 60)
            if(last_state == 2)
                return

            last_state = 2
            icon_state = "1"
            overlays.Cut()
        else
            if(last_state == 3)
                return

            last_state = 3
            icon_state = "0"
            var/width = icon(src.icon,  null).Width() //as god intended. 
            var/image/double = image(icon, icon_state = "1")
            double.pixel_x = round(width * 0.2)
            src.overlays = list(double)	


/atom/movable/screen/mlg/smug
    icon = 'raftnetwork/icons/mob/hud/smug_dancing.dmi'
    screen_loc = "CENTER,BOTTOM"

/atom/movable/screen/mlg/snoop
    icon = 'raftnetwork/icons/mob/hud/snoop.dmi'
    screen_loc = "BOTTOMLEFT"

/atom/movable/screen/mlg/snoop/update_appearance(scale = 0)
    switch(scale)
        if(-1.#INF to 30)
            if(last_state == 0)
                return

            last_state = 0
            icon_state = null
            overlays.Cut()
        if(31 to 65)
            if(last_state == 1)
                return

            last_state = 1
            icon_state = "0"
            overlays.Cut()
        if(66 to 88)
            if(last_state == 2)
                return

            last_state = 2
            icon_state = "1"
            overlays.Cut()
        else
            if(last_state == 3)
                return

            last_state = 3
            icon_state = "0"
            var/width = icon(src.icon,  null).Width() //as god intended. 
            var/image/double = image(icon, icon_state = "1")
            double.pixel_x = round(width * 0.2)
            src.overlays = list(double)	

/atom/movable/screen/mlg/orange_chip
    icon = 'raftnetwork/icons/mob/hud/chip.dmi'
    screen_loc = "CENTER-4,BOTTOM+4"

/atom/movable/screen/mlg/triangle
    icon = 'raftnetwork/icons/mob/hud/yid.dmi'
    screen_loc = "RIGHT-1,TOP-5%"

/atom/movable/screen/mlg/dorrito_logo
    icon = 'raftnetwork/icons/mob/hud/dorrito.dmi'
    screen_loc = "RIGHT-1,CENTER-1.5"

/image/mlg_effects/
    //how long the effect should last, if zero, flick()
    var/effect_alive_time = 0
    var/atom/atom_ref 
    // // proportion used to calculate how far from the center of the icon the overlay should be placed
    // var/bounds = 0.6

/image/mlg_effects/proc/add_to_atom_overlay(atom/A)
    if(!A?.overlays)
        return

    atom_ref = A
    atom_ref.overlays += src
    addtimer(CALLBACK(src, PROC_REF(remove_from_overlays)), effect_alive_time)

/image/mlg_effects/proc/remove_from_overlays()
    if(!atom_ref?.overlays)
        return
    atom_ref.overlays -= src
    qdel(src)

/image/mlg_effects/explosion 
    icon = 'raftnetwork/icons/mob/hud/explode.dmi'
    effect_alive_time = 17
    layer = ABOVE_MOB_LAYER

/image/mlg_effects/crosshair/add_to_atom_overlay(atom/A)
    // var/width = icon(A.icon, null).Width()
    // var/height = icon(A.icon, null).Height()
    // pixel_x = rand(width * (1 - bounds), width * bounds)
    // pixel_y = rand(height * (1 - bounds), height * bounds)

    pixel_x = rand(0, 32)
    pixel_y = rand(0, 32)
    if(!A?.overlays)
        return

    atom_ref = A
    atom_ref.overlays += src
    addtimer(CALLBACK(src, PROC_REF(remove_from_overlays)), effect_alive_time)


/image/mlg_effects/crosshair
    icon = 'raftnetwork/icons/mob/hud/crosshair_mlg.dmi'
    effect_alive_time = 10 SECONDS
