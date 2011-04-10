package {
	import org.flixel.*;
	public class Alien extends FlxSprite {
		[Embed(source="data/alien.png")] protected var AlienSprite:Class;
		protected static const ALIEN_SPEED:int = 15;
		protected static const MAX_NUMBER_OF_ALIENS:int = 500;//so as not to crash the browser
		private var nextFacing:int = 0;
		private var timeToNextFacing:Number = 0;
		private var timeToMultiply:Number = 0;
		private var timeToHatch:Number = 0;
		private var timeToVanish:Number = 0;
		private var envir:PlayState;
		public function Alien(Envir:PlayState,X:uint,Y:uint) {
			super(X,Y);
			envir=Envir;
			loadGraphic(AlienSprite,true,false,10,10);
			addAnimation("egg",[0,1,2,3,4,5],10,false);
			addAnimation("hatch",[6,7,8,9],10,false);
			addAnimation("go_"+FlxSprite.UP,[10,11,12,13,14],20);
			addAnimation("go_"+FlxSprite.RIGHT,[15,16,17,18,19],20);
			addAnimation("go_"+FlxSprite.DOWN,[20,21,22,23,24],20);
			addAnimation("go_"+FlxSprite.LEFT,[25,26,27,28,29],20);
			addAnimation("dead_1",[30]);
			addAnimation("dead_2",[31]);
			addAnimation("dead_3",[32]);
			facing=10;timeToHatch=0.5+4*Math.random()+envir.aliens.countLiving()/MAX_NUMBER_OF_ALIENS*10;
			play("egg");
		}
		public override function update():void {
			velocity.x=0;velocity.y=0;
			if (facing==10) {//egg
				timeToHatch-=FlxG.elapsed;
				if (timeToHatch<0) {
					facing=11;play("hatch");
				}
			} else if (facing==11) {//hatching
				if (finished) {
					facing=Math.floor(4*Math.random());play("go_"+facing);
					changeFacing();
					timeToMultiply=2+4*Math.random();
				}
				play("hatch");
			} else if (facing>20) {//dead
				play("dead_"+(facing-20));
				timeToVanish-=FlxG.elapsed;
				if (timeToVanish<0) {
					envir.aliens.remove(this,true);
					envir.defaultGroup.remove(this,true);
				}
			} else {//walking
				timeToMultiply-=FlxG.elapsed;
				if (timeToMultiply<0) {
					timeToMultiply=2+4*Math.random();
					if (envir.aliens.countLiving()<MAX_NUMBER_OF_ALIENS) envir.aliens.add(new Alien(envir,x,y));
				}
				timeToNextFacing-=FlxG.elapsed;
				if (timeToNextFacing<0) {
					facing=nextFacing;
					changeFacing();
				}
				switch (facing) {
					case FlxSprite.UP:velocity.y=-ALIEN_SPEED;break;
					case FlxSprite.DOWN:velocity.y=ALIEN_SPEED;break;
					case FlxSprite.LEFT:velocity.x=-ALIEN_SPEED;break;
					case FlxSprite.RIGHT:velocity.x=ALIEN_SPEED;break;
				}
				play("go_"+facing);
				if (x<0) x+=(FlxG.width-10);
				if (x>FlxG.width-10) x-=(FlxG.width-10);
				if (y<0) y+=(FlxG.height-10);
				if (y>FlxG.height-10) y-=(FlxG.height-10);
			}
			super.update();
		}
		private function changeFacing():void {
			timeToNextFacing=1+2*Math.random();
			nextFacing=(facing+2*Math.floor(2*Math.random())+1)%4;
		}
		public function killMe():void {
			dead=true;
			facing=21+Math.floor(3*Math.random());
			timeToVanish=1+2*Math.random();
		}
	}
}