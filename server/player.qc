/*
 * Contains functions that handle the state of the player.
 */

/*
 * Called for the player every frame before physics are run.
 */
void() PlayerPreThink = {
    /* self.velocity = '0 100 0'; */
};

/*
 * Called for the player every frame after physics are run.
 */
void() PlayerPostThink = {
};

/*
 * Provides QC with a way to intercept 'cmd foo' commands from the client. Very handy. Self will be
 * set to the sending client, while the 'cmd' argument can be tokenize()d and each element retrieved
 * via argv(argno). Unrecognised cmds MUST be passed on to the clientcommand builtin.
 */
void(string cmd) SV_ParseClientCommand = {
    print("SV_ParseClientCommand: ");
    print(cmd);
    print("\n");
};

/*
 * Part of cluster mode. Handles cross-node events that were sent via clusterevent, on behalf of the
 * named client.
 */
/* void(string dest, string from, string cmd, string info) SV_ParseClusterEvent = { */
/* }; */

/*
 * Provides QC with a way to communicate between servers, or with client server browsers. Sender is
 * the sender's ip. Body is the body of the message. You'll need to add your own password/etc
 * support as required. Self is not valid.
 */
/* float(string sender, string body) SV_ParseConnectionlessPacket = { */
/*     return FALSE; */
/* }; */

/*
 * For each frame that the server is paused, this function will be called to give the gamecode a
 * chance to unpause the server again. the pauseduration argument says how long the server has been
 * paused for (the time global is frozen and will not increment while paused). Self is not valid.
 */
/* void(float pauseduration) SV_PausedTic = { */
/* }; */

/*
 * Called to give the qc a change to block pause/unpause requests. Return false for the pause
 * request to be ignored. newstatus is 1 if the user is trying to pause the game. For the duration
 * of the call, self will be set to the player who tried to pause, or to world if it was triggered
 * by a server-side event.
 */
/* float(float newstatus) SV_ShouldPause = { */
/*     return TRUE; */
/* }; */

/*
 * Called each time a player movement packet was received from a client. Self is set to the player
 * entity which should be updated, while the input_* globals specify the various properties stored
 * within the input packet. The contents of this function should be somewaht identical to the
 * equivelent function in CSQC, or prediction misses will occur. If you're feeling lazy, you can
 * simply call 'runstandardplayerphysics' after modifying the inputs.
 *
 * This only works when using the QuakeWorld defs.
 */
void() SV_RunClientCommand = {
    print("SV_RunClientCommand called\n");

    print("input_timelength: ");
    print(ftos(input_timelength));
    print("\n");

    print("input_angles: ");
    print(vtos(input_angles));
    print("\n");

    print("input_movevalues: ");
    print(vtos(input_movevalues));
    print("\n");

    print("input_buttons: ");
    print(ftos(input_buttons));
    print("\n");

    print("input_impulse: ");
    print(ftos(input_impulse));
    print("\n");

    /* runstandardplayerphysics(self); */
};

/*
 *Called each video frame. This is the only place where ssqc is allowed to call the
 *R_BeginPolygon/R_PolygonVertex/R_EndPolygon builtins. This is exclusively for debugging, and will
 *break in anything but single player as it will not be called if the engine is not running both a
 *client and a server.
 */
/* void() SV_AddDebugPolygons = { */
/* }; */

/*
 * Compatibility method to tweak player input that does not reliably work with prediction
 * (prediction WILL break). Mods that care about prediction should use SV_RunClientCommand
 * instead. If pr_no_playerphysics is set to 1, this function will never be called, which will
 * either fix prediction or completely break player movement depending on whether the feature was
 * even useful.
 */
/* void() SV_PlayerPhysics = { */
/*     print("SV_PlayerPhysics called\n"); */
/* }; */

/*
 * Called after non-player entities have been run at the end of the physics frame. Player physics is
 * performed out of order and can/will still occur between EndFrame and BeginFrame.
 */
/* void() EndFrame = { */
/* }; */

void() PlayerSpawn = {
    print("PlayerSpawn called\n");
};

void() info_player_start = {
    print("info_player_start called\n");
};
