global function RegisterModRemoteCallbacks
global function RemoteFuncLib_Init
global bool IsModLoaded = false

//TL;DR on how to use this "library": Just copy this file into your mod's vscripts folder, and add your own custom callbacks using Remote_RegisterFunction to RegisterModRemoteCallbacks.
//YOU MUST change IsModLoaded to true in your mod's copy of this file. Also this library must not be ran by itself.

//Then pray the merge algorithm adds all of them properly.
//IMPORTANT: the library mod needs to go before any mod leveraging it. You must also not define this file as a custom script in any other mod's mod.json.

void function RegisterModRemoteCallbacks() {

return
}

void function emptyinit () {

}

void function RemoteFuncLib_Init ()
{	
	
	print("RemoteFuncLib Init: " + IsModLoaded.tostring())
	
	if (!IsModLoaded) {
		
		
		#if CLIENT
		while (!IsValid(GetLocalViewPlayer()))
			wait 0.5
		
		GetLocalViewPlayer().ClientCommand("reload_mods; restart_checkpoint")
		#endif
		
		#if SERVER
		while (GetPlayerArray().len() == 0)
			wait 0.5
		
		ClientCommand(GetPlayerArray()[0],"reload_mods; restart_checkpoint")
		#endif
	}
	
		//The restart_checkpoint prevents a "server is out of sync" error. 
		//This is hacky, but needed to fix a bug with icepick.
}

