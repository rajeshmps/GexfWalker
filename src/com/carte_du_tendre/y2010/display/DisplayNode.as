/*
# Copyright (c) 2010 Alexis Jacomy <alexis.jacomy@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

package com.carte_du_tendre.y2010.display{
	
	import com.carte_du_tendre.y2010.data.Node;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DisplayNode extends Sprite{
		
		public static const NODES_SCALE:Number = 0.7;
		
		private var _labelField:TextField;
		private var _upperCircle:Sprite;
		private var _node:Node;
		private var _goal:Array; // goal := (x_goal,y_goal)
		
		public function DisplayNode(node:Node,new_x:Number,new_y:Number){
			_labelField = new TextField();
			_upperCircle = new Sprite();
			_goal = new Array();
			_node = node;
			
			x = new_x;
			y = new_y;
			
			this.hitArea = _upperCircle;
			
			draw();
		}

		private function draw():void{
			var format:TextFormat = new TextFormat("Verdana",12*NODES_SCALE*_node.size/10);
			var circleHitArea:Sprite = new Sprite;
			
			with(_labelField){
				text = _node.label;
				autoSize = TextFieldAutoSize.CENTER;
				selectable = false;
				setTextFormat(format);
			}
			_labelField.x = this.x - _labelField.width/2;
			_labelField.y = this.y - _labelField.height/2;
			
			with(this.graphics){
				beginFill(_node.color,1);
				drawCircle(0,0,NODES_SCALE*_node.size);
				endFill();
			}
			
			with(_upperCircle.graphics){
				beginFill(_node.color,0);
				drawCircle(0,0,NODES_SCALE*_node.size);
				endFill();
			}
			_upperCircle.x = this.x;
			_upperCircle.y = this.y;
		}
		
		public function moveToSlowly(new_x:Number,new_y:Number):void{
			_goal[0] = new_x;
			_goal[1] = new_y;
			
			addEventListener(Event.ENTER_FRAME,slowDisplacementHandler);
		}
		
		private function slowDisplacementHandler(e:Event):void{
			var d:Number = Math.pow(this.x-_goal[0],2)+Math.pow(this.y-_goal[1],2);
			
			if(d<0.5){
				removeEventListener(Event.ENTER_FRAME,slowDisplacementHandler);
			}else{
				moveTo(this.x/2 + _goal[0]/2, this.y/2 + _goal[1]/2);
			}
		}
		
		public function moveTo(new_x:Number,new_y:Number):void{
			x = new_x;
			y = new_y;
			
			_upperCircle.x = new_x;
			_upperCircle.y = new_y;
			
			_labelField.x = new_x - _labelField.width/2;
			_labelField.y = new_y - _labelField.height/2;
		}
		
		public function whenMouseOver():void{
			with(this.graphics){
				clear();
				lineStyle(NODES_SCALE*_node.size/4,brightenColor(_node.color,40));
				beginFill(_node.color,1);
				drawCircle(0,0,NODES_SCALE*_node.size);
				endFill();
			}
		}
			
		public function whenMouseOut():void{
			with(this.graphics){
				clear();
				beginFill(_node.color,1);
				drawCircle(0,0,NODES_SCALE*_node.size);
				endFill();
			}
		}
		
		/**
		 * Makes a uint color become brigther or darker, depending of the parameter.
		 * If the <code>perc</code> parameter is above 50, it will brighten the color.
		 * If the parameter is below 50, it will darken it.
		 * 
		 * @param color Original color value, such as 0x88AACC.
		 * @param perc Value between 0 and 100 to modify original color.
		 * @return New color value (still such as 0x113355)
		 * 
		 * @author Martin Legris
		 * @see http://blog.martinlegris.com
		 */
		protected function brightenColor(color:Number, perc:Number):Number{
			var factor:Number;
			var blueOffset:Number = color % 256;
			var greenOffset:Number = ( color >> 8 ) % 256;
			var redOffset:Number = ( color >> 16 ) % 256;
			
			if(perc > 50 && perc <= 100) {
				factor = ( ( perc-50 ) / 50 );
				
				redOffset += ( 255 - redOffset ) * factor;
				blueOffset += ( 255 - blueOffset ) * factor;
				greenOffset += ( 255 - greenOffset ) * factor;
			}
			else if( perc < 50 && perc >= 0 ){
				factor = ( ( 50 - perc ) / 50 );
				
				redOffset -= redOffset * factor;
				blueOffset -= blueOffset * factor;
				greenOffset -= greenOffset * factor;
			}
			
			return (redOffset<<16|greenOffset<<8|blueOffset);
		}
		
		public function get upperCircle():Sprite{
			return _upperCircle;
		}
		
		public function set upperCircle(value:Sprite):void{
			_upperCircle = value;
		}
		
		public function get labelField():TextField{
			return _labelField;
		}
		
		public function set labelField(value:TextField):void{
			_labelField = value;
		}
		
		public function get node():Node{
			return _node;
		}
		
		public function set node(value:Node):void{
			_node = value;
		}
		
		public function get goal():Array{
			return _goal;
		}
		
		public function set goal(value:Array):void{
			_goal = value;
		}
	}
}