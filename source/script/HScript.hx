package script;

import flixel.FlxBasic;

/**
 * This is just a simple hscript code
 */
class HScript extends FlxBasic
{
    public var locals(get, set):Map<String, {r:Dynamic}>;

	function get_locals():Map<String, {r:Dynamic}>
	{
		@:privateAccess
		return interp.locals;
	}

	function set_locals(local:Map<String, {r:Dynamic}>)
	{
		@:privateAccess
		return interp.locals = local;
	}

	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;

	public var parser:Parser = new Parser();
	public var interp:Interp = new Interp();

	public function new(file:String, ?execute:Bool = true)
	{
		trace("Load File: " + file);
		super();
		parser.allowJSON = parser.allowTypes = parser.allowMetadata = true;

		if (execute)
			this.execute(file);
	}

	/**
	 * Execute a file, like how interp work
	 * @param file path to a file
	 * @param executeCreate default set is `true`, is will gonna call a function `onCreate`
	 */
	public function execute(file:String, ?executeCreate:Bool = true):Void
	{
		try
		{
			interp.execute(parser.parseString(File.getContent(file)));
		}
		catch (e:Dynamic)
			Lib.application.window.alert(Std.string(e), 'HScript Error!');

		trace('Script Loaded Succesfully: $file');

		if (executeCreate)
			call('onCreate', []);
	}

	/**
	 * Set a variable/function to script
	 * @param name a variable/function name
	 * @param val default value, or function how is gonna work
	 */
	public function set(name:String, val:Dynamic):Void
	{
		interp?.variables.set(name, val);
		locals.set(name, {r: val});
	}

	/**
	 * Get a variable/function on script if that exists
	 * @param name a variable/function you think that exists
	 * @return Dynamic
	 */
	public function get(name:String):Dynamic
	{
		if (locals.exists(name) && locals[name] != null)
			return locals.get(name).r;
		else if (interp.variables.exists(name))
			return interp?.variables.get(name);

		return null;
	}

	/**
	 * Check if that variable/function exists
	 * @param name a variable/function
	 * @return Bool
		return interp?.variables.exists(name)
	 */
	public function existsVar(name:String):Bool
		return interp?.variables.exists(name);

	/**
	 * Call a function with that, in script, it will able to do like:
     * ```haxe
     * // on source, onCreate is being called by `call("onCreate", []);`
     * function onCreate() {
     * // your haxe script here
     * }
     * ```
	 * @param name 
	 * @param args 
	 */
	public function call(name:String, args:Array<Dynamic>)
	{
		if (existsVar(name))
		{
			try
			{
				return Reflect.callMethod(this, get(name), args == null ? [] : args);
			}
			catch (e:Dynamic)
				Lib.application.window.alert(Std.string(e), 'HScript Error!');
		}

		return null;
	}

	public function getAll():Dynamic 
	{
		var balls:Dynamic = {};

		for (i in locals.keys())
			Reflect.setField(balls, i, get(i));
		for (i in interp.variables.keys())
			Reflect.setField(balls, i, get(i));

		return balls;
	}

	override function destroy() 
	{
		super.destroy();
		parser = null;
		interp = null;
	}    
}