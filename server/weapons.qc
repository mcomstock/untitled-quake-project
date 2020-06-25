/* W_Precache
 *
 * Precache calls relating to weapons.
 */
void() W_Precache = {
    precache_sound("weapons/bounce.wav");

    precache_model("progs/lavaball.mdl");
};

/* SUB_Remove
 *
 * Function to remove an entity.
 */
void() SUB_Remove = {
    remove(self);
};

/****************************************************************************************************
 * Throwing knife
 *
 * The following functions describe the behavior of the throwing knife.
 ***************************************************************************************************/

/*
 * T_ThrowingKnifeTouch
 *
 * The function that is called when a throwing knife hits something. It should bounce off solid
 * surfaces and keep going, or despawn and deal damage if it hits something that can take damage.
 */
void() T_ThrowingKnifeTouch = {
    local float damg;
    damg = 35;

    // Ignore the player that threw the knife.
    // TODO: Deal self damage after a bounce?
    if (other == self.owner) {
        return;
    }

    // Hit if the target takes damage.
    if (other.takedamage) {
        // TODO define damage function
        /* T_Damage(other, self, self.owner, damg); */
    }

    // Bounce if the target does not take damage.
    sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);

    // Stop angular velocity if the object is no longer moving.
    if (self.velocity == '0 0 0') {
        self.avelocity = '0 0 0';
    }
}

/*
 * W_FireThrowingKnife
 *
 * The function that is called when the player throws a throwing knife. It mostly handles the
 * initialization of the knife projectile, including the throwing sound, initial velocity, and so
 * on.
 */
void() W_FireThrowingKnife = {
    local entity knife;

    // Just use rocket ammo for now.
    self.currentammo = self.ammo_throwing_knife = self.ammo_throwing_knife - 1;

    // Set screen "recoil".
    self.punchangle_x = -2;

    // Define a knife.
    knife = spawn();
    knife.owner = self;
    knife.movetype = MOVETYPE_BOUNCE;
    knife.solid = SOLID_BBOX;
    knife.classname = "knife";

    // Set knife speed and direction.
    makevectors(self.v_angle);
    knife.velocity = aim(self, 600) * 1000;
    knife.angles = vectoangles(knife.velocity);

    // Delegate what happens when the knife hits something.
    knife.touch = T_ThrowingKnifeTouch;

    // Set the knife to despawn after a certain amount of time. Set the time relatively high since
    // it should mostly be hitting something that removes the knife.
    knife.nextthink = time + 10;
    knife.think = SUB_Remove;

    // Use the lavaball model for now.
    setmodel(knife, "progs/lavaball.mdl");
    setsize(knife, '0 0 0', '0 0 0');
    setorigin(knife, self.origin + v_forward*8 + '0 0 16');
};

/*
 * W_Attack
 *
 * Handle attacking with the currently selected weapon.
 */
void() W_Attack = {
    print("attacking, current ammo: ");
    print(ftos(self.currentammo));
    print("\n");

    if (self.currentammo <= 0) {
        return;
    }

    switch (self.weapon) {
    case (IT_THROWING_KNIFE):
        print("using knife\n");
        // TODO: Do the weapon animation
        W_FireThrowingKnife();
        self.attack_finished = time + 0.5;
        break;
    default:
        break;
    }
};

void() W_Impulse = {
    print("impulse: ");
    print(ftos(self.impulse));
    print("\n");

    // Handle weapon switching.
    switch (self.impulse) {
    case(1):
        self.weapon = IT_THROWING_KNIFE;
        self.currentammo = self.ammo_throwing_knife;
        self.weaponmodel = "progs/v_axe.mdl";
        self.weaponframe = 0;

        break;
    default:
        break;
    }

    self.impulse = 0;
};

/*
 * W_WeaponFrame
 *
 * Handle frame-by-frame weapon inputs, such as impulse and firing commands.
 */
void() W_WeaponFrame = {
    if (time < self.attack_finished) {
        return;
    }

    if (self.impulse) {
        W_Impulse();
    }

    if (self.button0) {
        W_Attack();
    }
};
