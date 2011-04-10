package {
	import org.flixel.*;
	public class PlayState extends FlxState {
		public var level:FlxTilemap;
		public var aliens:FlxGroup;
		public var player:FlxSprite;
		public var hudScore:FlxText;
		public var hudTime:FlxText;
		public var hudAttribute:FlxText;
		[Embed(source="data/map.txt",mimeType="application/octet-stream")] public static var MapTxt:Class;
    	[Embed(source="data/tileset.png")] public static var TileSet:Class;
		[Embed(source="data/player.png")] public static var PlayerSprite:Class;
		[Embed(source="data/stomp.mp3")] public static var StompSound:Class;
		[Embed(source="data/collect.mp3")] public static var CollectSound:Class;
		[Embed(source="data/seconds.mp3")] public static var SecondsSound:Class;
		protected static const PLAYER_SPEED:int = 75;
		public var soundEffectPlaying:Number = 0;
		public var soundEffectPlaying2:Number = 0;
		public var timeUntilEnd:Number = 180;
		public var nextSecondToPlayGong:Number = 5;//last 5 seconds ticking
		public var eggsCollected:uint = 0;
		override public function create():void {
			//level
			level = new FlxTilemap();
			level.drawIndex=0;
			level.loadMap(new MapTxt,TileSet);
			level.collideIndex=10;
			for (var y:Number=0; y<level.heightInTiles ; y++) for (var x:Number=0; x<level.widthInTiles ; x++) if (level.getTile(x,y)<10) {
				if (Math.random()<0.1) {
					level.setTile(x,y,4+Math.floor(4*Math.random()));
				} else {
					level.setTile(x,y,Math.floor(4*Math.random()));
				}
			}
			add(level);
			//aliens
			aliens = new FlxGroup();
			aliens.add(new Alien(this,240,180));
			add(aliens);
			//player
			player = new FlxSprite(80,60);
			player.loadGraphic(PlayerSprite);
			player.loadGraphic(PlayerSprite,true,false,20,20);
			player.facing=0;
			player.addAnimation("go_0",[0]);
			player.addAnimation("go_1",[1]);
			player.addAnimation("go_2",[2]);
			player.addAnimation("go_3",[3]);
			player.addAnimation("go_4",[4]);
			player.addAnimation("go_5",[5]);
			player.addAnimation("go_6",[6]);
			player.addAnimation("go_7",[7]);
			player.play("go_"+player.facing);
			add(player);
			//hud
			hudScore = new FlxText(2,2,120,"No eggs collected yet");
			hudScore.setFormat(null,8,0xffffffff,'left',0xff000000);
			add(hudScore);
			hudTime = new FlxText(160,2,158,Math.ceil(timeUntilEnd)+" seconds left");
			hudTime.setFormat(null,8,0xffffffff,'right',0xff000000);
			add(hudTime);
			hudAttribute = new FlxText(0,227,FlxG.width,"Created by Zanda Games");
			hudAttribute.setFormat(null,8,0xffffffff,'right',0xff000000);
			add(hudAttribute);
		}
		override public function update():void {
			if (FlxG.keys.M) {
				if (FlxG.music.playing) FlxG.music.pause();else FlxG.music.play();
			}
			//
			var dir_x:Number=0;
			var dir_y:Number=0;
			if (FlxG.keys.LEFT || FlxG.keys.A) dir_x=-1;
			if (FlxG.keys.RIGHT || FlxG.keys.D) dir_x=1;
			if (FlxG.keys.UP || FlxG.keys.W) dir_y=-1;
			if (FlxG.keys.DOWN || FlxG.keys.S) dir_y=1;
			//
			var next_facing:Number=-1;
			if (dir_x>0) {
				next_facing=2+dir_y;
			} else if (dir_x<0) {
				next_facing=6-dir_y;
			} else {
				if (dir_y!=0) next_facing=2+2*dir_y;
			}
			//
			var dir_d:Number=Math.sqrt(dir_x*dir_x+dir_y*dir_y);
			if (dir_d>0) {
				dir_x/=dir_d;
				dir_y/=dir_d;
			}
			player.velocity.x=dir_x*100;
			player.velocity.y=dir_y*100;
			if (player.x<0) player.x+=(FlxG.width-20);
			if (player.x>FlxG.width-20) player.x-=(FlxG.width-20);
			if (player.y<0) player.y+=(FlxG.height-20);
			if (player.y>FlxG.height-20) player.y-=(FlxG.height-20);
			//
			if (next_facing!=-1) {
				player.facing=next_facing;
				player.play("go_"+player.facing);
			}
			//
			timeUntilEnd-=FlxG.elapsed;
			if (timeUntilEnd<=nextSecondToPlayGong) {
				FlxG.play(SecondsSound,0.5);
				nextSecondToPlayGong-=1;
			}
			if (timeUntilEnd<=0 || aliens.countLiving()<=0) {
				FlxG.scores[0]=eggsCollected;
				FlxG.scores[1]=aliens.countLiving();
				FlxG.state = new EndState();
			}
			if (soundEffectPlaying>=0) soundEffectPlaying-=FlxG.elapsed;
			if (soundEffectPlaying2>=0) soundEffectPlaying2-=FlxG.elapsed;
			if (eggsCollected==0) hudScore.text="No eggs collected yet"
			else hudScore.text=eggsCollected.toString()+" egg"+((eggsCollected>1)?"s":"")+" collected";
			hudTime.text=Math.ceil(timeUntilEnd)+" second"+((Math.ceil(timeUntilEnd)>1)?"s":"")+" left";
			//
			super.update();
			//
			FlxU.overlap(aliens,player,collectEggOrStompAlien);
		}
		public function collectEggOrStompAlien(alien:Alien,player:FlxSprite):void {
			if (alien.facing<21) if (Math.abs(alien.x+5-player.x-10)<=10) if (Math.abs(alien.y+5-player.y-10)<=10) {
				if (alien.facing==10) {//collect egg
					if (Math.abs(alien.x+5-player.x-10)<=8) {
						alien.facing=21;//vs mysterious doublefiring
						if (soundEffectPlaying<=0) {
							soundEffectPlaying=0.25;
							FlxG.play(CollectSound,0.5);
						}
						eggsCollected++;
						aliens.remove(alien,true);
						defaultGroup.remove(alien,true);
					}
				} else {//stomp alien
					if (soundEffectPlaying2<=0) {
						soundEffectPlaying2=0.25;
						FlxG.play(StompSound);
					}
					alien.killMe();
				}
			}
		}
	}
}