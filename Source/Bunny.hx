package;

import ColorShader;
import openfl.utils.Assets;
import openfl.display.Tile;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.Event;

// class Bunny extends Bitmap
class Bunny extends Tile {
	public var speedX:Float;
	public var speedY:Float;
	public var r:Float;
	public var b:Float;
	public var g:Float;
	// public var testShader:ColorShader;
	public var testShader:OutlineShader;

	// public function new(testShader:ColorShader) {
	public function new(testShader:OutlineShader) {
		// super(Assets.getBitmapData("assets/wabbit_alpha.png"));
		super();

		// this.testShader = new ColorShader();
		// this.testShader = new OutlineShader();
		// this.testShader.u_quality.value = [2];
		// this.testShader.u_outlineColor.value = [1, 1, 0, 1];
		// this.testShader.u_outlineSize.value = [3];
		this.testShader = testShader;
		this.shader = this.testShader;
		
		this.r = Math.random();
		this.b = Math.random();
		this.g = Math.random();
		// this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		// this.addEventListener(Event.RENDER, enterFrameHandler);
	}

	public function update():Void {
		this.enterFrameHandler();
	}

	private function enterFrameHandler(event:Event = null):Void {
        // trace(toString() + " - Enter Frame");
		this.r = Math.random();
		this.b = Math.random();
		this.g = Math.random();
		// this.colorShader.u_r.value[0] = this.r;
		// this.colorShader.u_b.value[0] = this.b;
		// this.colorShader.u_g.value[0] = this.g;
		this.testShader.u_outlineColor.value[0] = this.r;
		this.testShader.u_outlineColor.value[1] = this.g;
		this.testShader.u_outlineColor.value[2] = this.b;
    }
}