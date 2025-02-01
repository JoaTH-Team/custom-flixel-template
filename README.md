# Custom Flixel Template
a custom template version of haxeflixel template

## What contains?
Unlike other Flixel-Template, this one is gonna contains all of the thing that help working with modded system
* Polymod Support
* Lua Script, HSCript already coded
* Paths with modded support
* More Simple on `Project.xml`

## How to make script loaded?
Open any state and using `LoadedSystem.loadLuaScript();` if you wanna load lua script or `LoadedSystem.loadHScript();` if you wanna load hscript script

## Define
There are the list of some define:
- allowLua: Allow to used Lua stuff and able to loaded entire lua with LoadedSystem class (ONLY WORK ON `cpp`, `hl` is not working!)
- allowScript: Allow to used HScript stuff and able to loaded entire hscript with LoadedSystem class
- allowMods: Allow to used mods on this custom flixel template

All of them are enable by default, if you wish to disable some you can do like this on project.xml `<!-- <define name="allowMods" /> -->` or some other define you want!