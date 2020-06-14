/*
 * Contains functions that the Quake endine expects to exist.
 */

/*
 * Called at startup. enginename and engineversion are arbitary hints and can take any
 * form. enginename should be consistant between revisions, but this cannot truely be relied upon.
 */
void(float apiver, string enginename, float enginever) CSQC_Init = {
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

/*
 * Called every single video frame. The CSQC is responsible for rendering the entire screen.
 */
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
};

/*
 * Called as an eventual result of the uri_get builtin.
 */
/* void(float reqid, float responsecode, string resourcebody, int resourcebytes) URI_Get_Callback = { */
/* }; */

/*
 * Called after the server's model+sound precaches have been executed. Gives a chance for the qc to
 * read the entity lump from the bsp (via getentitytoken).
 */
void() CSQC_WorldLoaded = {
    print("CSQC_WorldLoaded started\n");
};

/*
 * Specifies that the csqc is going down. Save your persistant settings here.
 */
void() CSQC_Shutdown = {
    print("CSQC_Shutdown started\n");
};

/*
 * Alternative to CSQC_UpdateView, called when the engine thinks there should be a loading
 * screen. If present, will inhibit the engine's normal loading screen, deferring to qc to draw it.
 */
/* void(float vwidth, float vheight, float notmenu) CSQC_UpdateViewLoading = { */
/* }; */

/*
 * Part of simple csqc, called after drawing the 3d view whenever CSQC_UpdateView is not defined.
 */
/* void(vector viewsize, float scoresshown) CSQC_DrawHud = { */
/* }; */

/*
 * Part of simple csqc, called after CSQC_DrawHud whenever CSQC_UpdateView is not defined, and when
 * there are no menus/console active.
 */
void(vector viewsize, float scoresshown) CSQC_DrawScores = {
    print("CSQC_DrawScores started\n");
};

/*
 * Gives the CSQC a chance to intercept stuffcmds. Use the tokenize builtin to parse the
 * message. Unrecognised commands would normally be localcmded, but its probably better to drop
 * unrecognised stuffcmds completely.
 *
 * NOTE: UNCOMMENTING THIS SEEMS TO PREVENT THE WORLD FROM LOADING!
 */
/* void(string msg) CSQC_Parse_StuffCmd = { */
/*     print("CSQC_Parse_StuffCmd: "); */
/*     print(msg); */
/*     print("\n"); */
/* }; */

/*
 * Gives the CSQC a chance to intercept centerprints. Return true if you wish the engine to
 * otherwise ignore the centerprint.
 */
float(string msg) CSQC_Parse_CenterPrint = {
    print("CSQC_Parse_CenterPrint started\n");

    return FALSE;
};

/*
 * Called as a result of player.dmg_save or player.dmg_take being set on the server. Return true to
 * completely inhibit the engine's colour shift and damage rolls, allowing you to do your own
 * thing. You can use punch_roll +=
 * (normalize(inflictororg-player.origin)*v_right)*(take+save)*autocvar_v_kickroll; as a modifier
 * for the roll angle should the player be hit from the side, and slowly fade it away over time.
 */
float(float save, float take, vector inflictororg) CSQC_Parse_Damage = {
    print("CSQC_Parse_Damage started\n");

    return FALSE;
};

/*
 * Gives the CSQC a chance to intercept sprint/bprint builtin calls. CSQC should filter by the
 * client's current msg setting and then pass the message on to the print command, or handle them
 * itself.
 */
void(string printmsg, float printlvl) CSQC_Parse_Print = {
    print("CSQC_Parse_Print started\n");
};

/*
 * Called when the client receives an SVC_CGAMEPACKET. The csqc should read the data or call the
 * error builtin if it does not recognise the message.
 */
void() CSQC_Parse_Event = {
    print("CSQC_Parse_Event started\n");
};

/*
 * Called whenever a key is pressed, the mouse is moved, etc. evtype will be one of the IE_*
 * constants. The other arguments vary depending on the evtype. Key presses are not guarenteed to
 * have both scan and unichar values set at the same time.
 */
float(float evtype, float scanx, float chary, float devid) CSQC_InputEvent = {
    return FALSE;
};

/*
 * Called just before each time clientcommandframe is updated. You can edit the input_* globals in
 * order to apply your own player inputs within csqc, which may allow you a convienient way to pass
 * certain info to ssqc.
 */
void() CSQC_Input_Frame = {
    /* print("CSQC_Intput_Frame started\n"); */
    /* runstandardplayerphysics(self); */
};

/*
 * Called by the engine after the video was restarted. This serves to notify the CSQC that any
 * render targets that it may have cached were purged, and will need to be regenerated.
 */
/* void(string rendererdescription) CSQC_RendererRestarted = { */
/* }; */

/*
 * Called if the user uses any console command registed via registercommand.
 */
float(string cmd) CSQC_ConsoleCommand = {
    print("CSQC_ConsoleCommand: ");
    print(cmd);
    print("\n");

    return FALSE;
};

/*
 * Called if the user clicks a ^[text\infokey\infovalue^] link. Use infoget to read/check each
 * supported key. Return true if you wish the engine to not attempt to handle the link
 * itself. WARNING: link text can potentially come from other players, so be careful about what you
 * allow to be changed.
 */
/* float(string text, string info) CSQC_ConsoleLink = { */
/* }; */

/*
 * Clumsily defined function for compat with DP. Should call spawn, set that ent's entnum field, and
 * return the entity inside the 'self' global which will then be used for fllowing Ent_Updates. MUST
 * NOT PARSE ANY NETWORK DATA (which makes it kinda useless).
 */
/* void(float entnum) CSQC_Ent_Spawn = { */
/* }; */

/*
 * Parses the data sent by ssqc's various SendEntity functions (must use the exact same reads as the
 * ssqc used writes - to debug this rule more easily, you may wish to use sv_csqcdebug). 'self'
 * provides context between frames, and self.entnum should normally report which ssqc entity . Be
 * aware that interpolation will need to happen separately.
 */
void(float isnew) CSQC_Ent_Update = {
    print("CSQC_Ent_Update started\n");
};

void() CSQC_Ent_Remove = {
    print("CSQC_Ent_Remove started\n");
};

/* float(float entnum, float channel, string soundname, float vol, float attenuation, vector pos, float pitchmod, float flags) CSQC_Event_Sound = { */
/* }; */

/*
 * Please don't use this. Use CSQC_Parse_Event and multicasts instead. The use of serverside
 * protocol translation to handle QW vs NQ protocols mean that you're likely to end up reading
 * slightly different data. Which is bad. Return true to say that you fully handled the
 * tempentity. Return false to have the client attempt to rewind the network stream and parse the
 * message itself.
 */
/* float() CSQC_Parse_TempEntity = { */
/* }; */

/* void(string cmdtext) GameCommand = { */
/* }; */

/*
 * Provides an entrypoint to generate pages for the CEF plugin from within QC. Headers are
 * -separated key/value pairs (use tokenizebyseparator).
 */
/* string(string uri, string method, string postdata, __in string requestheaders, __inout string responseheaders) Cef_GeneratePage = { */
/* }; */

/*
 * Part of FTE_MULTIPROGS. Called as soon as a progs is loaded, called at a time when entities are
 * not valid. This is the only time when it is safe to call addprogs without field assignment. As it
 * is also called as part of addprogs, this also gives you a chance to hook functions in modules
 * that are already loaded (via externget+externget).
 */
void(float prevprogs) init = {
    print("init started\n");
};

/*
 * Part of FTE_MULTIPROGS. Called after fields have been finalized. This is the first point at which
 * it is safe to call spawn(), and is called before any entity fields have been parsed. You can use
 * this entrypoint to send notifications to other modules.
 */
/* void() initents = { */
/* }; */

void(float isnew) Player_Refresh = {
    print("Player_Refresh called\n");
};
