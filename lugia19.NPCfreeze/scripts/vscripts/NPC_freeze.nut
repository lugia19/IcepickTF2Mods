global function NPCFreezeInit
global function FreezeToggle
global function FZ_ShiftGroup
global array<bool> ShouldFreeze
global int FreezeGroup = 0
global int FreezeGroupNum = 10
global array<array<entity> > spawnedNPCs


void function NPCFreezeInit() {
#if SERVER
	for (int i=0;i<FreezeGroupNum;i++){
		ShouldFreeze.append(false)
		array<entity> temp = []
		spawnedNPCs.append(temp)
		printt("Array length of spawnedNPCs: " + spawnedNPCs.len().tostring())
		printt("Array length of ShouldFreeze: " + ShouldFreeze.len().tostring())
	}
	
	AddClientCommandCallback("fz_shiftgroup",FZ_ShiftGroup)
	AddClientCommandCallback("freezetoggle",FreezeToggle)
	AddClientCommandCallback("freezeall",FreezeAll)
	AddClientCommandCallback("unfreezeall",UnFreezeAll)
	
	AddSpawnCallback( "npc_turret_sentry", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_drone", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_soldier", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_titan", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_spectre", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_stalker", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_stalker_zombie", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_stalker_zombie_mossy", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_stalker_crawling_mossy", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_prowler", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_marvin", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_frag_drone", OnSpawnedNPC_FreezeMod )
	AddSpawnCallback( "npc_super_spectre", OnSpawnedNPC_FreezeMod )
#endif
}

bool function FZ_ShiftGroup(entity player, array<string> args)
{
	FreezeGroup += 1
	if (FreezeGroup == FreezeGroupNum) 
		FreezeGroup = 0
	
	#if SERVER
	SendHudMessage( player, "Current freeze group: " + FreezeGroup.tostring(), 0.4, 0.8, 50, 166, 255, 255, 0.15, 3.0, 0.5 )
	#endif
	
	return true
}

bool function FreezeToggle( entity player, array<string> args )
{
		#if SERVER
		ShouldFreeze[FreezeGroup] = !ShouldFreeze[FreezeGroup]
		if (ShouldFreeze[FreezeGroup])
			SendHudMessage( player, "Freezing group " + FreezeGroup.tostring(), 0.4, 0.8, 50, 166, 255, 255, 0.15, 3.0, 0.5 )
		else
			SendHudMessage( player, "Unfreezing group " + FreezeGroup.tostring(), 0.4, 0.8, 50, 166, 255, 255, 0.15, 3.0, 0.5 )
		
		ArrayRemoveDead(spawnedNPCs[FreezeGroup])
		
		foreach( npc in spawnedNPCs[FreezeGroup])
			ManageFreezeNPC( npc, ShouldFreeze[FreezeGroup])
		#endif
		
	return true
}

bool function FreezeAll( entity player, array<string> args )
{
		#if SERVER
		SendHudMessage( player, "Freezing all groups", 0.4, 0.8, 50, 166, 255, 255, 0.15, 3.0, 0.5 )
		for (int i=0;i<FreezeGroupNum;i++){
			if (ShouldFreeze[i] == false) {
				ShouldFreeze[i] = true
				ArrayRemoveDead(spawnedNPCs[i])
				foreach( npc in spawnedNPCs[i])
					ManageFreezeNPC( npc, ShouldFreeze[i])
			}	
		}
		#endif
		
	return true
}

bool function UnFreezeAll( entity player, array<string> args )
{
		#if SERVER
		SendHudMessage( player, "Unfreezing all groups", 0.4, 0.8, 50, 166, 255, 255, 0.15, 3.0, 0.5 )
		for (int i=0;i<FreezeGroupNum;i++){
			if (ShouldFreeze[i] == true) {
				ShouldFreeze[i] = false
				ArrayRemoveDead(spawnedNPCs[i])
				foreach( npc in spawnedNPCs[i])
					ManageFreezeNPC( npc, ShouldFreeze[i])
			}
		}
		#endif
		
	return true
}

void function ManageFreezeNPC(entity npc, bool freeze) {
#if SERVER
	if ( !IsValid( npc ) )
		return
	if (freeze) 
		npc.Freeze()
	else 
		npc.Unfreeze()
#endif
}

void function OnSpawnedNPC_FreezeMod( entity npc ) {

	spawnedNPCs[FreezeGroup].append(npc)
	
	if (ShouldFreeze[FreezeGroup])
		ManageFreezeNPC(npc, ShouldFreeze[FreezeGroup])
	
	string classname = npc.GetClassName()
	#if SERVER
	if (GetPlayerArray().len() > 0)
		SendHudMessage( GetPlayerArray()[0], "Added NPC " + classname + " to group " + FreezeGroup.tostring(), 0.4, 0.8, 50, 166, 255, 255, 0.15, 3.0, 0.5 )
	#endif
}


