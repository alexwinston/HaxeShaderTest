package;

import glsl.OpenFLShader;
import VectorMath.vec4;

class ColorShader extends OpenFLShader {
	@:uniform public var r:Float;
	@:uniform public var b:Float;
	@:uniform public var g:Float;

    public function new(r:Float = 0.0, g:Float = 0.0, b:Float = 0.0) {
        super();
        this.u_r.value = [r];
		this.u_b.value = [b];
		this.u_g.value = [b];
    }

	override function fragment() {
		super.fragment();
		// var uv:Vec2 = gl_FragCoord / gl_openfl_TextureSize.xy;
		var uv:Vec2 = gl_openfl_TextureCoordv; //gl_openfl_TextureSize;
		// https://godotforums.org/d/31870-texture-upside-down-and-mirrored/4
		uv.y = 1.0 - uv.y;
		gl_FragColor = vec4(r, b, g, 1.0);
		// gl_FragColor = vec4(uv.x, 0.0, 0.0, 1.0);
		// gl_FragColor = vec4(0.0, uv.y, 0.0, 1.0);
	}
}