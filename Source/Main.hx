package;

import Bunny;
import openfl.display.Tileset;
import openfl.display.Tilemap;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.utils.Assets;

class Main extends Sprite
{
	// private var testShader:ColorShader;
	private var testShader:OutlineShader;

	private var addingBunnies:Bool;
	private var bunnies:Array<Bunny>;

	private var fps:FPS;
	private var gravity:Float;
	private var minX:Int;
	private var minY:Int;
	private var maxX:Int;
	private var maxY:Int;

	private var tilemap:Tilemap;
	
	public function new() {
		super();

		bunnies = new Array();

		this.stage.scaleMode = NO_SCALE;
        this.stage.align = TOP_LEFT;

		gravity = 0.5;

		// this.testShader = new ColorShader();
		this.testShader = new OutlineShader();
		this.testShader.u_quality.value = [2];
		this.testShader.u_outlineColor.value = [1, 1, 0, 1];
		this.testShader.u_outlineSize.value = [3];

		var bitmapData = Assets.getBitmapData("assets/wabbit_alpha.png");
		var tileset = new Tileset(bitmapData);
		tileset.addRect(bitmapData.rect);

		this.tilemap = new Tilemap(stage.stageWidth, stage.stageHeight, tileset);
		this.addChild(tilemap);

		fps = new FPS();
		addChild(fps);

		for (i in 0...100) {
			addBunny();
		}

		stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
		stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		stage.addEventListener(Event.RESIZE, stage_onResize);
	}

	private function addBunny():Void {
		var bunny = new Bunny(this.testShader);
		bunny.x = 0;
		bunny.y = 0;
		bunny.speedX = Math.random() * 5;
		bunny.speedY = (Math.random() * 5) - 2.5;
		bunnies.push(bunny);

		// this.addChild(bunny);
		this.tilemap.addTile(bunny);
	}

	// Event Handlers
	private function stage_onEnterFrame(event:Event):Void {
		var bunny;

		for (i in 0...bunnies.length) {
			bunny = bunnies[i];
			bunny.x += bunny.speedX;
			bunny.y += bunny.speedY;
			bunny.speedY += gravity;

			if (bunny.x > maxX) {
				bunny.speedX *= -1;
				bunny.x = maxX;
			} else if (bunny.x < minX) {
				bunny.speedX *= -1;
				bunny.x = minX;
			}

			if (bunny.y > maxY) {
				bunny.speedY *= -0.8;
				bunny.y = maxY;

				if (Math.random() > 0.5) {
					bunny.speedY -= 3 + Math.random() * 4;
				}
			} else if (bunny.y < minY) {
				bunny.speedY = 0;
				bunny.y = minY;
			}
			bunny.update();
		}

		if (addingBunnies) {
			trace(fps.currentFPS);

			for (i in 0...100) {
				addBunny();
			} 
		}
	}

	private function stage_onMouseDown(event:MouseEvent):Void {
		addingBunnies = true;
	}

	private function stage_onMouseUp(event:MouseEvent):Void {
		addingBunnies = false;
		trace(bunnies.length + " bunnies");
	}

	private function stage_onResize(event:Event):Void {
		trace("onResize");
		maxX = Std.int(stage.stageWidth / this.scaleX);
		maxY = Std.int(stage.stageHeight / this.scaleY);
	}
}
