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
			TakeFromStockpile(player)
			//ReloadTacticalAbility(player)
			//ReloadOrdnance(player)
		}
	}
	return true
}

void function ReloadOrdnance(entity player)
{
	#if SERVER
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

void function TakeFromStockpile( entity player )
{
	#if SERVER
		array<entity> weapons = player.GetMainWeapons()
		foreach ( weapon in weapons )
		{
			printt("Clip: "+weapon.GetWeaponPrimaryClipCountMax().tostring() + "/" + weapon.GetWeaponPrimaryClipCountMax().tostring())
			printt("Stockpile:" + weapon.GetWeaponPrimaryAmmoCount().tostring())
			int max = weapon.GetWeaponPrimaryClipCountMax()
			int diff = weapon.GetWeaponPrimaryClipCountMax() - weapon.GetWeaponPrimaryClipCount()
			int currentAmmo = weapon.GetWeaponPrimaryAmmoCount()
			if (currentAmmo == 0)
				continue
			
			if (currentAmmo >= diff) {
				printt(player.IsTitan)
				printt(weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile))
				if (!player.IsTitan() && !weapon.GetWeaponSettingBool(eWeaponVar.ammo_no_remove_from_stockpile))
					weapon.SetWeaponPrimaryAmmoCount(currentAmmo - diff)	//Infinite stockpile.
				weapon.SetWeaponPrimaryClipCount( max )
			}
			else {
				weapon.SetWeaponPrimaryClipCount(max - diff + currentAmmo)
				weapon.SetWeaponPrimaryAmmoCount(0)
			}
		}
	#endif
}