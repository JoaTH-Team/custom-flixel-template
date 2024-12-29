package;

import polymod.Polymod;
import polymod.backends.PolymodAssets.PolymodAssetType;
import polymod.format.ParseRules;

/**
 * To use PolyHandler, call `PolyHandler.reload();`
 */
class PolyHandler {
	static final MOD_DIR:String = 'mods';
	static final CORE_DIR:String = 'assets';
	static final API_VERSION:String = '1.0.0';
	static final API_VERSION_MATCH:String = '*.*.*';

	private static final extensions:Map<String, PolymodAssetType> = [
		'ogg' => AUDIO_GENERIC,
		'wav' => AUDIO_GENERIC,
		'png' => IMAGE,
		'xml' => TEXT,
		'json' => TEXT,
		'txt' => TEXT,
		'hx' => TEXT,
		'lua' => TEXT,
		'hxs' => TEXT,
		'ttf' => FONT,
		'otf' => FONT
	];

	public static var trackedMods:Array<ModMetadata> = [];

	public static function reload():Void {
		trace('Reloading Polymod...');
		loadMods(getMods());
	}

	public static function loadMods(folders:Array<String>):Void {
		var loadedModlist:Array<ModMetadata> = Polymod.init({
			modRoot: MOD_DIR,
			dirs: folders,
			framework: OPENFL,
			apiVersionRule: API_VERSION,
			errorCallback: onError,
			frameworkParams: {
				coreAssetRedirect: CORE_DIR
			},
			parseRules: getParseRules(),
			extensionMap: extensions,
			ignoredFiles: Polymod.getDefaultIgnoreList()
		});

		if (loadedModlist == null)
			return;

		trace('Loading Successful, ${loadedModlist.length} / ${folders.length} new mods.');

		for (mod in loadedModlist)
			trace('Name: ${mod.title}, [${mod.id}]');
	}

	public static function getMods():Array<String> {
		trackedMods = [];

		if (FlxG.save.data.disabledMods == null) {
			FlxG.save.data.disabledMods = [];
			FlxG.save.flush();
		}

		var daList:Array<String> = [];

		trace('Searching for Mods...');

		for (i in Polymod.scan({modRoot: MOD_DIR, apiVersionRule: API_VERSION_MATCH, errorCallback: onError})) {
			if (i != null) {
				trackedMods.push(i);
				if (!FlxG.save.data.disabledMods.contains(i.id))
					daList.push(i.id);
			}
		}

		if (daList != null && daList.length > 0)
			trace('Found ${daList.length} new mods.');

		return daList != null && daList.length > 0 ? daList : [];
	}

	public static function getModIDs():Array<String> {
		return (trackedMods.length > 0) ? [for (i in trackedMods) i.id] : [];
	}

	public static function getParseRules():ParseRules {
		final output:ParseRules = ParseRules.getDefault();
		output.addType("txt", TextFileFormat.LINES);
		output.addType("hx", TextFileFormat.PLAINTEXT);
		output.addType("hxs", TextFileFormat.PLAINTEXT);
		output.addType(";ua", TextFileFormat.PLAINTEXT);
		return output != null ? output : null;
	}

	static function onError(error:PolymodError):Void {
		switch (error.code) {
			case MOD_LOAD_PREPARE:
				trace(error.message);
			case MOD_LOAD_DONE:
				trace(error.message);
			case MISSING_ICON:
				trace(error.message);
			default:
				switch (error.severity) {
					case NOTICE:
						trace(error.message);
					case WARNING:
						trace(error.message);
					case ERROR:
						trace(error.message);
				}
		}
	}
}
