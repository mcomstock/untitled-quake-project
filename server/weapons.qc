/* W_Precache
 *
 * Precache calls relating to weapons.
 */
void() W_Precache = {
    precache_sound("weapons/bounce.wav");

    precache_model("progs/lavaball.mdl");
};

/*
 * T_SpearTouch
 *
 * The function that is called when a spear hits something.
 */
void() T_SpearTouch = {
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

    // Get stuck in objects that don't take damage.
    self.movetype = MOVETYPE_NONE;
    sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);

    // Stop angular velocity if the object is no longer moving.
    if (self.velocity == '0 0 0') {
        self.avelocity = '0 0 0';
    }
};

/*
 * T_SpearThink
 *
 * The think function for the spear, which handles gravity and despawning.
 */
void() W_SpearThink = {
    if (self.velocity_z > -1000) {
        self.velocity_z -= 10;
    }

    if (time - self.spawn_time > 10) {
        remove(self);
    }

    self.nextthink = time + 0.1;
};

/*
 * W_FireSpear
 *
 * The function that is called when the player throws a spear. It mostly handles the initialization
 * of the model, including the firing sound, initial velocity, and so on.
 */
void() W_FireSpear = {
    local entity spear;

    // Just use rocket ammo for now.
    self.currentammo = self.ammo_spear = self.ammo_spear - 1;

    // Set screen "recoil".
    self.punchangle_x = -2;

    // Define a spear.
    spear = spawn();
    spear.spawn_time = time;
    spear.owner = self;
    spear.movetype = MOVETYPE_FLY;
    spear.solid = SOLID_BBOX;
    spear.classname = "spear";

    // Set spear speed and direction.
    makevectors(self.v_angle);
    spear.velocity = aim(self, 600) * 1000;
    spear.angles = vectoangles(spear.velocity);

    // Delegate what happens when the spear hits something.
    spear.touch = T_SpearTouch;

    // Set up calling the think function for the spear, which handles gravity and despawning.
    spear.nextthink = time + 0.1;
    spear.think = W_SpearThink;

    // Use the lavaball model for now.
    setmodel(spear, "progs/lavaball.mdl");
    setsize(spear, '0 0 0', '0 0 0');
    setorigin(spear, self.origin + v_forward*8 + '0 0 16');
};

/*
 * T_ArrowTouch
 *
 * The function that is called when an arrow hits something.
 */
void() T_ArrowTouch = {
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

    // Get stuck in objects that don't take damage.
    self.movetype = MOVETYPE_NONE;
    sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);

    // Stop angular velocity if the object is no longer moving.
    if (self.velocity == '0 0 0') {
        self.avelocity = '0 0 0';
    }
};

/*
 * T_ArrowThink
 *
 * The think function for the arrow, which handles gravity and despawning.
 */
void() W_ArrowThink = {
    if (self.velocity_z > -1000) {
        self.velocity_z -= 100;
    }

    if (time - self.spawn_time > 10) {
        remove(self);
    }

    self.nextthink = time + 0.1;
};

/*
 * W_FireArrow
 *
 * The function that is called when the player throws an arrow. It mostly handles the initialization
 * of the model, including the firing sound, initial velocity, and so on.
 */
void() W_FireArrow = {
    local entity arrow;

    // Just use rocket ammo for now.
    self.currentammo = self.ammo_arrow = self.ammo_arrow - 1;

    // Set screen "recoil".
    self.punchangle_x = -2;

    // Define an arrow.
    arrow = spawn();
    arrow.spawn_time = time;
    arrow.owner = self;
    arrow.movetype = MOVETYPE_FLY;
    arrow.solid = SOLID_BBOX;
    arrow.classname = "arrow";

    // Set arrow speed and direction.
    makevectors(self.v_angle);
    arrow.velocity = aim(self, 600) * 3000;
    arrow.angles = vectoangles(arrow.velocity);

    // Delegate what happens when the arrow hits something.
    arrow.touch = T_ArrowTouch;

    // Set up calling the think function for the arrow, which handles gravity and despawning.
    arrow.nextthink = time + 0.1;
    arrow.think = W_ArrowThink;

    // Use the lavaball model for now.
    setmodel(arrow, "progs/lavaball.mdl");
    setsize(arrow, '0 0 0', '0 0 0');
    setorigin(arrow, self.origin + v_forward*8 + '0 0 16');
};

/*
 * T_ThrowingKnifeTouch
 *
 * The function that is called when a throwing knife hits something.
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

    // Get stuck in objects that don't take damage.
    self.movetype = MOVETYPE_NONE;
    sound(self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);

    // Stop angular velocity if the object is no longer moving.
    if (self.velocity == '0 0 0') {
        self.avelocity = '0 0 0';
    }
};

/*
 * T_ThrowingKnifeThink
 *
 * The think function for the throwing knife, which handles gravity and despawning.
 */
void() W_ThrowingKnifeThink = {
    if (self.velocity_z > -1000) {
        self.velocity_z -= 100;
    }

    if (time - self.spawn_time > 10) {
        remove(self);
    }

    self.nextthink = time + 0.1;
};

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
    knife.spawn_time = time;
    knife.owner = self;
    knife.movetype = MOVETYPE_FLY;
    knife.solid = SOLID_BBOX;
    knife.classname = "knife";

    // Set knife speed and direction.
    makevectors(self.v_angle);
    knife.velocity = aim(self, 600) * 1000;
    knife.angles = vectoangles(knife.velocity);

    // Delegate what happens when the knife hits something.
    knife.touch = T_ThrowingKnifeTouch;

    // Set up calling the think function for the knife, which handles gravity and despawning.
    knife.nextthink = time + 0.1;
    knife.think = W_ThrowingKnifeThink;

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
        self.attack_finished = time + 0.5;
        return;
    }

    switch (self.weapon) {
    case (IT_THROWING_KNIFE):
        print("using knife\n");
        // TODO: Do the weapon animation
        W_FireThrowingKnife();
        self.attack_finished = time + 0.5;
        break;

    case (IT_SPEAR):
        W_FireSpear();
        self.attack_finished = time + 0.5;
        break;

    case (IT_BOW):
        W_FireArrow();
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
    case (1):
        self.weapon = IT_THROWING_KNIFE;
        self.currentammo = self.ammo_throwing_knife;
        self.weaponmodel = "progs/v_axe.mdl";
        self.weaponframe = 0;

        break;

    case (2):
        self.weapon = IT_SPEAR;
        self.currentammo = self.ammo_spear;
        self.weaponmodel = "progs/v_nail.mdl";
        self.weaponframe = 0;

        break;

    case (3):
        self.weapon = IT_BOW;
        self.currentammo = self.ammo_arrow;
        self.weaponmodel = "progs/v_shot.mdl";
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
