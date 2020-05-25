/*
 * Contains functions that the Quake engine expects to exist.
 */

/*
 * Called for the player every frame before physics are run.
 */
void() PlayerPreThink = {
};

/*
 * Called for the player every frame after physics are run.
 */
void() PlayerPostThink = {
};

/*
 * Called for every player when a new player connects or a new level starts. Typically used to
 * announce the new player to every other player.
 */
void(optional float csqcactive) ClientConnect = {
    bprint("Please welcome ");
    bprint(self.netname);
    bprint(" to the game!\n");
};

/*
 * Called for every player when a player disconnects from a server. Typically used to announce that
 * the player has left the game.
 */
void() ClientDisconnect = {
    bprint("Please bid ");
    bprint(self.netname);
    bprint(" farewell!\n");
};

/*
 * Called when a player suicides.
 */
void() ClientKill = {
};

/*
 * According to the QuakeC reference, this is called after setting parm1 - parm16.
 */
void() PutClientInServer = {
};

/*
 * Called to set parms for self so they can be restored.
 */
void() SetChangeParms = {
};

/*
 * Called when a client initially connects to a server. Sets parm1 - parm16 so that they can be
 * saved for restarts.
 */
void() SetNewParms = {
};

/*
 * Handle the server starting or loading a map.
 */
void() main = {
};

/*
 * Called before each frame is run.
 */
void() StartFrame = {
};

/*
 * Called when a map is loaded. The purpose of this function seems to be to precache any files that
 * will be needed that aren't already defined as a base Quake asset.
 */
void() worldspawn = {
};
