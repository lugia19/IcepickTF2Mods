global function ModSwitchInit

void function ModSwitchInit()
{
	AddClientCommandCallback("tacticalmodswitch",Trigger_tacticalmodswitch)
	AddClientCommandCallback("activewepmodswitch",Trigger_activewepmodswitch)
}

bool function Trigger_tacticalmodswitch( entity player, array<string> args )
{
	common_modswitch(player,player.GetOffhandWeapon( OFFHAND_SPECIAL))
	return true
}

bool function Trigger_activewepmodswitch( entity player, array<string> args )
{
	common_modswitch(player,player.GetActiveWeapon())
	#if SERVER
	entity tempwepn = player.GetActiveWeapon()
	player.TakeWeaponNow(player.GetActiveWeapon().GetWeaponClassName())
	player.GiveWeapon(tempwepn.GetWeaponClassName(),tempwepn.GetMods())
	//This is to avoid graphical glitches
	#endif
	return true
}


void function common_modswitch(entity player, entity weapon)
{
	#if SERVER
		array<string> availablemods = GetWeaponMods_Global( weapon.GetWeaponClassName() )
		
		array<string> mods = weapon.GetMods()
		
		int nextMod = -1
		
		if (mods.len() != 0)
			nextMod = availablemods.find(mods[0])
		
		if (!IsValid(nextMod))		//NULL = -1 = no mod. This should never be reachable.
			nextMod=-1
		
		nextMod = nextMod+1
			
		if (nextMod >= availablemods.len())
			nextMod = -1
			
		foreach (mod in mods)
			weapon.RemoveMod(mod)	//Clear out all the mods currently equipped (if there's more than one, somehow)
		
		if (nextMod != -1)
		{
			weapon.AddMod(availablemods[nextMod])
			SendHudMessage( player, "Current mod: " + availablemods[nextMod], 0.4, 0.8, 255, 50, 50, 255, 0.15, 3.0, 0.5 )
		}
		else
			SendHudMessage( player, "Current mod: none", 0.4, 0.8, 255, 50, 50, 255, 0.15, 3.0, 0.5 )
			
	#endif
}