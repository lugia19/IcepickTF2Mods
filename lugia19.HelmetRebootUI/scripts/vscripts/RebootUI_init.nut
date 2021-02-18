global function RebootUIInit
global function rebUI_toggle
global function ServerCallback_rebUI
global bool rebootenabled = false
global array<var> rebootRuis

void function RebootUIInit() {
#if SERVER
	AddClientCommandCallback("rebui_toggle",rebUI_toggle)
#endif
}

bool function ServerCallback_rebUI()
{
	#if CLIENT
	if (!rebootenabled) {
		var rebootRui = RuiCreate( $"ui/helmet_reboot.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
		rebootRuis.append( rebootRui )

		var borderRui = CreateCockpitRui( $"ui/helmet_border.rpak", 100 )
		rebootRuis.append( borderRui )
	}
	else {
		try {
			clGlobal.levelEnt.Signal( "end_flicker" ) // make sure no flickering is going on
		} catch(exception) {
			printt("This signal isn't guaranteed to exist, so let's just be safe.")
		}
		
		foreach( rui in rebootRuis )
		{
			RuiDestroyIfAlive( rui )
		}
		rebootRuis.clear() //Clear out the array once the graphic's disabled
	}
	rebootenabled = !rebootenabled
	#endif
	return true
}

bool function rebUI_toggle(entity player, array<string> args)
{
	#if SERVER
	Remote_CallFunction_NonReplay(player, "ServerCallback_rebUI")
	#endif
	return true
}