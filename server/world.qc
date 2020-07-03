/*
 * Contains functions that handle the state of the world.
 */

void() W_Precache;

/*
 * Called for every player when a new player connects or a new level starts. Typically used to
 * announce the new player to every other player.
 */
void(optional float csqcactive) ClientConnect = {
    bprint(PRINT_HIGH, "Please welcome ");
    bprint(PRINT_HIGH, self.netname);
    bprint(PRINT_HIGH, " to the game!\n");
};

/*
 * Called for every player when a player disconnects from a server. Typically used to announce that
 * the player has left the game.
 */
void() ClientDisconnect = {
    bprint(PRINT_HIGH, "Please bid ");
    bprint(PRINT_HIGH, self.netname);
    bprint(PRINT_HIGH, " farewell!\n");
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
    print("PutClientInServer called\n");

    local entity spawnpoint;
    spawnpoint = find(world, classname, "info_player_start");

    self.classname = "player";
    self.solid = SOLID_SLIDEBOX;
    setmodel(self, "progs/player.mdl");
    self.movetype = MOVETYPE_WALK;
    self.health = self.max_health = 100;
    self.takedamage = DAMAGE_AIM;
    self.flags = FL_CLIENT;
    self.maxspeed = 320;

    self.origin = spawnpoint.origin + [0, 0, 1];
    self.angles = spawnpoint.angles;
    self.fixangle = TRUE;
    setsize(self, [-16, -16, -24], [16, 16, 32]);
    self.view_ofs = '0 0 22';
    self.velocity = '0 0 0';

    self.ammo_throwing_knife = 10;
    self.ammo_arrow = 10;
    self.ammo_spear = 10;
    self.attack_finished = time;
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
    print("main called\n");
};

/*
 * Called before each frame is run.
 */
void() StartFrame = {
    /* deathmatch = cvar("deathmatch"); */
};

/*
 * Called when a map is loaded. The purpose of this function seems to be to precache any files that
 * will be needed that aren't already defined as a base Quake asset.
 */
void() worldspawn = {
    print("worldspawn called\n");

    precache_model("progs/player.mdl");

    W_Precache();
};
