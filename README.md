# IcepickTF2Mods
Some miscellaneous mods for Icepick, the Titanfall 2 modding framework

All keybinds added by mods can be found in the controls menu.

Here's a brief summary of what each mod does.
- RLF (Remote Functions Lib): Allows other mods to add remote callbacks without modifying the \_remote\_callbacks\_sp.nut file. 
Must be used alongside a mod that uses it, otherwise levels will load forever. 
If you wish to leverage it, check the RLF\_callbacks.nut file for detailed instructions.
- EnableCheckpointMenu : Enables the developer menu that allows you to spawn at any checkpoint of your choosing in a level. The button is next to the datacenter indicator.
- HelmetRebootUI : Adds a keybind to toggle the helmet UI effect that occurs once you get the helmet in mission 1.
- MPExecutions : Allows you to use MP executions in singleplayer. They're randomized.
- NPCfreeze : Allows you to freeze NPCs and assign them to different groups. When an NPC spawns, it's assigned to the currently active group. Adds four keybinds:
  - Shift through the freeze groups (default max is 10, can be changed)
  - Toggle freeze for the current group 
  - Freeze all groups
  - Unfreeze all groups
- NoSmartPistolAndGrenadeDisplay : Disables the trajectory indicators for grenades and the smart pistol. Useful if you're using freecam, as they're buggy.
- infAmmo: Gives you infinite ammo in your clip.
- stockpileAmmo: Same as above, except it takes the ammo from the stockpile, like oldschool doom.
- wepnmodswitcher : Adds two keybinds to let you cycle through all attachments for the active weapon and tactical.
