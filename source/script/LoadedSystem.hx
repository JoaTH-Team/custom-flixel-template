package script;

import sys.FileSystem;
using StringTools;

class LoadedSystem {
	#if allowLua
    public static var luaArray:Array<LuaScript> = [];
    public static function loadLuaScript(?endWith:String = ".lua"):Void {
		var foldersToCheck:Array<String> = [Paths.file('scripts/')];
		for (mod in PolyHandler.getModIDs())
			foldersToCheck.push('mods/$mod/scripts/');
		for (folder in foldersToCheck) {
			if (FileSystem.exists(folder) && FileSystem.isDirectory(folder)) {
				for (file in FileSystem.readDirectory(folder)) {
					if (file.endsWith(endWith)) {
						luaArray.push(new LuaScript(folder + file));
					}
				}
			}
		}
    }
	#end

	#if allowScript
    public static var hscriptArray:Array<HScript> = [];
    public static function loadHScript(?endWith:String = ".hx"):Void {
        var foldersToCheck:Array<String> = [Paths.file('scripts/')];
		for (mod in PolyHandler.getModIDs())
			foldersToCheck.push('mods/$mod/scripts/');
		for (folder in foldersToCheck) {
			if (FileSystem.exists(folder) && FileSystem.isDirectory(folder)) {
				for (file in FileSystem.readDirectory(folder)) {
					if (file.endsWith(endWith)) {
						hscriptArray.push(new HScript(folder + file));
					}
				}
			}
		}
    }
	#end
}