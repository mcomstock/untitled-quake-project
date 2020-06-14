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
    // input_buttons: seems to be that 1 is attack and 2 is jump.

    makevectors(input_angles);

    local vector h_forward = v_forward;
    h_forward_z = 0;
    h_forward = normalize(h_forward);

    local vector h_right = v_right;
    h_right_z = 0;
    h_right = normalize(h_right);

    local vector intended_direction = h_forward * input_movevalues_x + h_right * input_movevalues_y;

    local vector new_velocity;
    local vector old_velocity = self.velocity;

    local float old_speed = vlen(old_velocity);
    local float p_maxspeed = self.maxspeed;

    // How quickly to slow down when movement is stopped.
    local float braking = 5;
    // How quickly to speed up when movement is applied.
    local float acceleration = 10;
    // The height a player can step up without jumping.
    local float step_height = 22;

    // Apply the brakes. Always do this so that direction changes take over more quickly.
    local float new_speed = max(old_speed - braking, 0);
    new_velocity = normalize(old_velocity) * new_speed;

    // Apply acceleration due to any movement.
    new_velocity += acceleration * input_timelength * intended_direction;

    // Do not exceed the maximum speed.
    if (vlen(new_velocity) > p_maxspeed) {
        new_velocity = p_maxspeed * normalize(new_velocity);
    }

    // Just stop if the speed is too low.
    if (vlen(new_velocity) < 1) {
        new_velocity = '0 0 0';
    }

    self.velocity = new_velocity;

    // Update the player's position, handling collision up to three times.
    local float remaining_attempts;
    local float remaining_time = input_timelength;
    local float remaining_step = TRUE;
    for (remaining_attempts = 3; remaining_time > 0 && remaining_attempts > 0; remaining_attempts--) {
        // Update the self position based on the current velocity.
        local vector destination = self.origin + self.velocity * remaining_time;
        tracebox(self.origin, self.mins, self.maxs, destination, FALSE, self);
        self.origin = trace_endpos;

        // Update the amount of time left.
        remaining_time -= remaining_time * trace_fraction;

        // Handle collision. Only handle it once, to avoid getting stuck in some crazy situation.
        if (remaining_time > 0) {
            // Try to step up, if possible.
            if (remaining_step) {
                // Attempt to go up in preparation for the step.
                local vector step_up_destination = self.origin;
                step_up_destination_z += step_height;
                tracebox(self.origin, self.mins, self.maxs, step_up_destination, FALSE, self);

                // Attempt to go forward at the new height.
                local vector step_forward_destination = trace_endpos + self.velocity * remaining_time;
                // Make sure the destination has the correct height in case of vertical velocity.
                step_forward_destination_z = trace_endpos_z;
                tracebox(trace_endpos, self.mins, self.maxs, step_forward_destination, FALSE, self);

                local float step_forward_fraction = trace_fraction;

                // If the step was successful, update the position.
                if (trace_fraction > 0) {
                    // TODO maybe handle collisions that happen here.

                    // Move back down until the ground or starting height was reached.
                    local vector step_down_destination = trace_endpos;
                    step_down_destination_z -= step_height;
                    tracebox(trace_endpos, self.mins, self.maxs, step_down_destination, FALSE, self);
                    self.origin = trace_endpos;

                    // Only count the forward movement time.
                    remaining_time -= remaining_time * step_forward_fraction;

                    // Don't allow multiple steps in a single movement update.
                    remaining_step = FALSE;

                    continue;
                }
            }

            // Use the formula for vector reflection.
            self.velocity = self.velocity - 2 * (self.velocity * trace_plane_normal) * trace_plane_normal;

            // Apply collision effects.
            touchtriggers();
        }
    }


    // TODO
    // * Falling
    // * Jumping
    // * Air control
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
