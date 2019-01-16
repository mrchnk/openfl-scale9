

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.display.CanvasRenderer;
import openfl.display.DisplayObject;

class Main extends Sprite {


  public function new () {

    super ();

    var sprite = new Scale9Wrapper(Assets.getMovieClip ("scale9:Scale9Sprite"));
    sprite.scale9Grid = new Rectangle(10, 10, 20, 20);
    sprite.x = 10;
    sprite.y = 10;
    sprite.width = 180;
    sprite.height = 80;

    addChild(sprite);

  }

}

@:access(openfl.display.DisplayObject)
class Scale9Wrapper extends DisplayObject {

  private var _actualWidth: Float;
  private var _actualHeight: Float;

  private var child: DisplayObject;

  public function new(child:DisplayObject) {
    super();
    this.child = child;
    child.__renderParent = this;
    this._actualWidth = child.width;
    this._actualHeight = child.height;
  }

  @:noCompletion private override function __setStageReference (stage:Stage):Void {
		super.__setStageReference (stage);
    child.__setStageReference (stage);
  }

  override public function get_width(): Float { return _actualWidth; }
  override public function set_width(width: Float): Float { _actualWidth = width; return width; }
  override public function get_height(): Float { return _actualHeight; }
  override public function set_height(height: Float): Float { _actualHeight = height; return height; }

  private override function __renderCanvas(renderer:CanvasRenderer) {
    if (scale9Grid == null) {
      child.__update(true, true);
      child.__renderCanvas(renderer);
      return;
    }

    var bounds = child.getBounds(child);

    var paddingLeft = scale9Grid.left;
    var paddingTop = scale9Grid.top;
    var paddingRight = bounds.right - scale9Grid.right;
    var paddingBottom = bounds.bottom - scale9Grid.bottom;
    var paddingH = paddingLeft + paddingRight;
    var paddingV = paddingTop + paddingBottom;

    var scaleH = (_actualWidth - paddingH) / (bounds.width - paddingH);
    var scaleV = (_actualHeight - paddingV) / (bounds.height - paddingV);

    var xs = [0, paddingLeft, _actualWidth - paddingRight];
    var ys = [0, paddingTop, _actualHeight - paddingBottom];
    var scaleXs = [1, scaleH, 1];
    var scaleYs = [1, scaleV, 1];

    var scrollXs = [0, scale9Grid.x, scale9Grid.right];
    var scrollYs = [0, scale9Grid.y, scale9Grid.bottom];
    var scrollWidths = [scale9Grid.x, scale9Grid.width, bounds.width - scale9Grid.width];
    var scrollHeights = [scale9Grid.y, scale9Grid.height, bounds.height - scale9Grid.height];


    for (ix in 0...3) {
      for (iy in 0...3) {
        child.x = xs[ix];
        child.y = ys[iy];
        child.scaleX = scaleXs[ix];
        child.scaleY = scaleYs[iy];
        child.scrollRect = new Rectangle(scrollXs[ix], scrollYs[iy], scrollWidths[ix], scrollHeights[iy]);
        child.__update(true, true);
        child.__renderCanvas(renderer);
      }
    }
  }

}

