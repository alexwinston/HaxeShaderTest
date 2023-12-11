package;

import VectorMath.cos;
import VectorMath.vec4;
import VectorMath.sin;
import VectorMath.vec2;
import VectorMath.max;
import glsl.GLSL.texture2D;
import glsl.GLSL.float;
import glsl.GLSL.int;
import glsl.OpenFLShader;

class OutlineShader extends OpenFLShader {
	/**
	 * 边缘颜色
	 */
	@:uniform
	public var outlineColor:Vec4;

	/**
	 * 边缘大小
	 */
	@:uniform
	public var outlineSize:Float;

	/**
	 * 质量，有效值在1-90
	 */
	@:uniform
	public var quality:Float;

	/**
	 * 是否只显示外框，0为显示全部，1为挖空显示
	 */
	@:uniform
	public var showout:Bool;

	/**
	 * HDR光效，有效值0-1
	 */
	@:uniform
	public var hdrStrength:Float;

	@:glsl
	public function texColor(color1:Vec4, color2:Vec4):Vec4 {
		return outlineColor * max(0, (color1.a - color2.a));
	}

	override function fragment() {
		super.fragment();
		var uv:Vec2 = 1 / gl_openfl_TextureSize;
		var times:Int = int(quality * 4.);
		var setp:Float = 6.28 / float(times);
		var outcolor:Vec4 = color;
		var light:Float = 0.;
		for (i in 0...360) {
			if (i > times) {
				break;
			}
			var r:Float = setp * float(i);
			var offestCenter:Vec2 = vec2(uv.x * outlineSize * sin(r), uv.y * outlineSize * cos(r));
			var copy:Vec4 = texture2D(gl_openfl_Texture, gl_openfl_TextureCoordv + offestCenter);
			// 这里可能还可以细节一些？
			outcolor += texColor(copy, color) * (1 - color.a) * (1 - color.a) * (1 - color.a);
			// 光亮效果
			light += (copy.r + copy.g + copy.b) / 3.;
		}
		outcolor += outlineColor * vec4(light / float(times)) * hdrStrength;
		// 这是挖空实现
		if (showout) {
			this.gl_FragColor = outcolor * (1 - color.a);
		} else {
			outcolor += color * (light / (float(times) / 8)) * hdrStrength;
			this.gl_FragColor = outcolor;
		}
		// this.gl_FragColor = color + color * light * 0.3;
	}
}