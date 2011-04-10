package {
	import org.flixel.*;
	import org.flixel.data.*;
	public class MenuState extends FlxState {
    	[Embed(source="data/backgroundmusic.mp3")] public static var BackgroundMusic:Class;
		override public function create():void {
			FlxG.playMusic(BackgroundMusic,1);
			bgColor = 0xff000000;
			var t:FlxText;
			t = new FlxText(0,25,FlxG.width,"Alien Egg Farm");t.setFormat(null,24,0xffffffff,'center',0xff000000);add(t);
			t = new FlxText(1,80,FlxG.width,"Eggs are a great source of energy. Just think about Rocky.");t.setFormat(null,8,0xffffffff,'center',0xff000000);add(t);
			t = new FlxText(1,90,FlxG.width,"And what is the ultimate source of energy? Alien eggs!\n\nIn this game you are set on a planet trying to collect as many alien eggs as possible in 3 minutes. The trick is to let the aliens lay eggs, hatch and lay more eggs for a while, to maximize the number of eggs collected. But be careful to kill all the aliens");t.setFormat(null,8,0xffffffff,'center',0xff000000);add(t);
			t = new FlxText(1,150,FlxG.width,"before time is up, otherwise you will lose.");t.setFormat(null,8,0xffffffff,'center',0xff000000);add(t);
			t = new FlxText(0,190,FlxG.width,"Press SPACE to continue.");t.setFormat(null,8,0xffffffff,'center',0xff000000);add(t);
			t = new FlxText(0,227,FlxG.width,"Created by Zanda Games");t.setFormat(null,8,0xffffffff,'right',0xff000000);add(t);
		}
		override public function update():void {
			if (!FlxG.kong) (FlxG.kong = parent.addChild(new FlxKong()) as FlxKong).init();
			super.update();
			if (FlxG.keys.SPACE) FlxG.state = new PlayState();
			if (FlxG.keys.M) {
				if (FlxG.music.playing) FlxG.music.pause();else FlxG.music.play();
			}
		}
	}
}