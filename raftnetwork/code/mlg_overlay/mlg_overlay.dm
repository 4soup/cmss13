/atom/movable/screen/mlg
    icon_state = null
    // control logic
    var/last_state
    // sits ontop of hud and objects.
    plane = CINEMATIC_PLANE
    // transparent to mouse
    alpha = 230

/atom/movable/screen/mlg/MouseEntered(location, control, params)
    . = ..()
    mouse_opacity = FALSE
    alpha = 30
    spawn(6 SECONDS)
        mouse_opacity = TRUE
        alpha = initial(alpha)

//overwrite in subtypes to modify leveling
/atom/movable/screen/mlg/proc/update_appearance(scale = 0)
    switch(scale)
        if(-1.#INF to 20)
            if(last_state == 0)
                return

            last_state = 0
            icon_state = null
            overlays.Cut()
        if(21 to 40)
            if(last_state == 1)
                return

            last_state = 1
            icon_state = "0"
            overlays.Cut()
        if(41 to 70)
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
