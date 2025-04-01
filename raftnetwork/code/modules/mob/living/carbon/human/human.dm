/mob/living/carbon/human/verb/toggle_mlg_mode()
    set name = "toggle MLG mode"
    set desc = "Adds a bunch of flashy and noisy mechanics that activate as you kill stuff."
    set category = "IC"
    var/is_on 

    if(SSmlg.mlg_huds.Find(src))
        SSmlg.remove_hud_from_player(src)
        is_on = FALSE
    else
        SSmlg.add_hud_to_player(src)
        is_on = TRUE
        
    to_chat(src, "toggled mlg hud [is_on ? "on" : "off"].")
