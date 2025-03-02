package;

import flixel.FlxG;
import openfl.display.Sprite;
import flixel.FlxGame;

class Main extends Sprite {
    /**
     * Edit all thing for your project right here
     * 
     * Also you may wanna to check the `Project.xml` too!
     */
    var gameConfig = {
        width: FlxG.width,
        height: FlxG.height,
        state: PlayState,
        fps: 60,
        skipSplash: false,
        enableFullScreen: false
    };
    public static var game:FlxGame;

    public function new() {
        super();

        game = new FlxGame(gameConfig.width, gameConfig.height, gameConfig.state, gameConfig.fps, gameConfig.fps, gameConfig.skipSplash, gameConfig.enableFullScreen);
        addChild(game);

        #if allowMods
        PolyHandler.reload(); // idk is work??
        #end
    }
}
