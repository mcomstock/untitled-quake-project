/*
 * Contains functions that the Quake endine expects to exist.
 */

float() AnimateSomeLameModel = {
    local float first_frame = 0;
    local float num_frames = 6;

    // Animate at 10 FPS.
    self.lerpfrac -= frametime * 10;

    // Protect against sudden low framerates.
    while (self.lerpfrac < 0) {
        self.frame2 = self.frame;
        self.frame += 1;

        // Restart the animation when it completes.
        if (self.frame >= first_frame + num_frames) {
            self.frame = first_frame;
        }

        // Go to the start of the frame.
        self.lerpfrac += 1;
    }

    // Set v_forward and others.
    makevectors(getviewprop(VF_ANGLES));
    // Read the current view origin.
    vector vieworg = getviewprop(VF_ORIGIN);
    // Reposition the entity to 128 units in front of the view.
    setorigin(self, vieworg + v_forward * 128);

    return FALSE;
};

void(float apiver, string enginename, float enginever) CSQC_Init = {
    // Note that the arguments are engine-defined and may not be the same for other engines.

    local entity foo = spawn();
    // Add an example animation.
    foo.predraw = AnimateSomeLameModel;
    precache_model("progs/player.mdl");
    setmodel(foo, "progs/player.mdl");
    // TODO: Make sure this location is actually in the world.
    setorigin(foo, '0 0 0');

    // Make sure the entity is drawn automatically by the builtins.
    foo.drawmask = MASK_ENGINE;
};

void(vector pos, float value, float threshold) Hud_DrawLargeValue = {
    float c, len;
    string s, fmt;

    if (value < 0) {
        value = 0;
    }

    if (value > 999) {
        value = 999;
    }

    s = ftos(floor(value));
    len = strlen(s);
    pos_x += 24 * (3 - len);

    // Show the numbers in red if the value is at or below the threshold.
    if (value <= threshold) {
        fmt = "anum_%g";
    } else {
        fmt = "num_%g";
    }

    while(len > 0) {
        len -= 1;
        c = str2chr(s, len);
        drawpic(pos + len * '24 0 0', sprintf(fmt, c-'0'), '24 24 0', '1 1 0', 1, 0);
    }
};

// TODO: Can these be local in the DrawHud function?
float stitems, stitems2, stweapon;

void(vector scrsz) DrawHud = {
    // Calculate the top-left of the sbar, assuming it is 320 units wide and in the bottom-middle of
    // the screen (allegedly - it shows up near the top for me).
    vector pos = [(scrsz_x - 320) / 2, pos_y = scrsz_y / 24, 0];

    // Get the player's self.items value. STAT_ITEMS is generated specially by the server.
    stitems = getstatbits(STAT_ITEMS, 0, 23);

    // Get the player's self.items2 value if it exists, otherwise get the serverflags global value.
    stitems2 = getstatbits(STAT_ITEMS, 23, 9);

    // Get the player's self.weapon value.
    stweapon = getstatf(STAT_ACTIVEWEAPON);

    // Draw the sbar background image with slight transparency.
    drawpic(pos, "sbar", '320 24 0', '1 1 1', 0.5, 0);

    Hud_DrawLargeValue(pos + '24 0 0', getstatf(STAT_ARMOR), 25);
    Hud_DrawLargeValue(pos + '136 0 0', getstatf(STAT_HEALTH), 25);
    Hud_DrawLargeValue(pos + '248 0 0', getstatf(STAT_AMMO), 10);
};

void(float width, float height, float menushown) CSQC_UpdateView = {
    /* drawfill('0 0 0', [width, height, 0], '1 1 0', 1, 0); */
    /* drawstring('0 0 0', "Hello, World", '8 8 0', '0 0 1', 1, 0); */

    // Reset the view properties to their default values. Note that the default values do not draw a
    // HUD.
    clearscene();

    // Since the default values do not inclued a HUD, add it.
    setviewprop(VF_DRAWENGINESBAR, 1);
    setviewprop(VF_DRAWCROSSHAIR, 1);

    // Add the entities to the view.
    addentities((intermission ? 0 : MASK_VIEWMODEL) | MASK_ENGINE);

    // Actually render the view.
    renderscene();

    // Draw the more complex parts of the HUD.
    DrawHud([width, height]);
};
