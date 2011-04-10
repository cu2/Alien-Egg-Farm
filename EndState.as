package {
	import org.flixel.*;
	public class EndState extends FlxState {
		[Embed(source="data/gameover.mp3")] public static var GameoverSound:Class;
		override public function create():void {
			FlxG.play(GameoverSound,0.5);
			bgColor = 0xff000000;
			var t:FlxText;
			t = new FlxText(0,25,FlxG.width,"Game Over");t.setFormat(null,24,0xffffffff,'center',0xff000000);add(t);
			if (FlxG.scores[1]>0) {
				t = new FlxText(1,100,FlxG.width,"You have lost because of remaining aliens.");
				if (FlxG.kong) FlxG.kong.API.stats.submitArray([{name:"Eggs Collected", value:0}]);
			} else {
				if (FlxG.scores[0]==0) t = new FlxText(1,100,FlxG.width,"You have collected no eggs.");
				else t = new FlxText(1,100,FlxG.width,"You have collected "+FlxG.scores[0]+" egg"+((FlxG.scores[0]>1)?"s":"")+".");
				if (FlxG.kong) FlxG.kong.API.stats.submitArray([{name:"Eggs Collected", value:FlxG.scores[0]}]);
			}
			t.setFormat(null,16,0xffffffff,'center',0xff000000);add(t);
			t = new FlxText(0,190,FlxG.width,"Press SPACE to play again.");t.setFormat(null,8,0xffffffff,'center',0xff000000);add(t);
			t = new FlxText(0,227,FlxG.width,"Created by Zanda Games");t.setFormat(null,8,0xffffffff,'right',0xff000000);add(t);
		}
		override public function update():void {
			super.update();
			if (FlxG.keys.SPACE) FlxG.state = new PlayState();
			if (FlxG.keys.M) {
				if (FlxG.music.playing) FlxG.music.pause();else FlxG.music.play();
			}
		}
	}
}