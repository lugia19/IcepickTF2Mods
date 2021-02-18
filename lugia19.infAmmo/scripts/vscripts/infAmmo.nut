global function infAmmoInit
global bool IsThreadRunning = false

void function infAmmoInit() {
	#if SERVER
	if (!IsThreadRunning)
		thread ReloadAll()
	//AddClientCommandCallback("refill_ammo",ReloadAll)
	#endif
}

bool function ReloadAll()
{
	IsThreadRunning = true
	while (GetPlayerArray().len() == 0)
		wait 3
	entity player = GetPlayerArray()[0]
	
	while (true) {
		wait 0.3
		if (IsValid(player) && IsAlive(player)) {
			ReloadPrimaryWeapons(player)
			ReloadTacticalAbility(player)
			ReloadOrdnance(player)
		}
	}
	return true
}

void function ReloadOrdnance(entity player)
{
	#if SERVER
	if (player.IsTitan())
		return	//Titans have infinite ammo as is, and this avoids breaking stuff like the lock on missiles.
	entity weapon = player.GetOffhandWeapon( OFFHAND_RIGHT )
	if ( IsValid( weapon ) )
	{
		int max = weapon.GetWeaponPrimaryClipCountMax()
		weapon.SetNextAttackAllowedTime( Time() )

		if ( weapon.IsChargeWeapon() )
			weapon.SetWeaponChargeFractionForced( 0 )
		else if ( max > 0 )
			weapon.SetWeaponPrimaryClipCount( max )
	}
	#endif
}