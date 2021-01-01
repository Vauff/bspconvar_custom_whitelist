# bspconvar_custom_whitelist

This plugin changes the file that CS:GO reads the BSP convar whitelist from to bspconvar_custom_whitelist.txt. This stops CS:GO updates from overriding the changes you make to the original file. It also adds live reloading of the file automatically on map change, or manually if you reload the plugin during a map.

## Requirements

- [DHooks](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)

## Installation

- Install the plugin as you normally would, whether by compiling the .sp or using the pre-compiled .smx
- Add the gamedata file to your SourceMod gamedata folder
- Make a copy of bspconvar_whitelist.txt named as bspconvar_custom_whitelist.txt, and make your edits to this file