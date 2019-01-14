

import openfl.display.Sprite;
import openfl.Assets;
import openfl.geom.Rectangle;

class Main extends Sprite {


	public function new () {

		super ();

		var scale9 = Assets.getMovieClip ("scale9:Scale9Sprite");
    scale9.scale9Bitmap = new Rectangle(10, 10, 20, 20);
    scale9.x = 10;
    scale9.y = 10;
    scale9.width = 180;
    scale9.height = 80;
		addChild (scale9);

	}

}
