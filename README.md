# bspconvar_custom_whitelist

This plugin changes the file that CS:GO reads the BSP convar whitelist from to bspconvar_custom_whitelist.txt. This stops CS:GO updates from overriding the changes you make to the original file. It also adds live reloading of the file automatically on map change, or manually with `sm_reloadwhitelist`.

Advanced users can also configure map specific overrides by adding new sections like so.
```
"convars"
{
    ...
    sv_airaccelerate            1
    sv_autobunnyhopping         1

    "de_dust2"
    {
        sv_airaccelerate        0
        sv_jump_impulse         1
    }
    "dz_blacksite"
    {
        sv_autobunnyhopping     0
    }
}
```

## Requirements

- [DHooks](https://forums.alliedmods.net/showpost.php?p=2588686&postcount=589)

## Installation

- Install the plugin as you normally would, whether by compiling the .sp or using the pre-compiled .smx
- Add the gamedata file to your SourceMod gamedata folder
- Make a copy of bspconvar_whitelist.txt named as bspconvar_custom_whitelist.txt, and make your edits to this file