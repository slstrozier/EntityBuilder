package 
{
	import flash.utils.getDefinitionByName;
	import flash.filters.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import CustomCandle;
	
	
	
	


	public class Candlestick extends MovieClip
	{
		//private var c:CustomCandle;
		private var _background:MovieClip;
		private var IS_DOJI:MovieClip;
		private var IS_SHOOTING_STAR:MovieClip;
		private var IS_ABANDONED_BABY:MovieClip;
		private var _CLOSE_CONTAINER:MovieClip;
		private var _DARK_CANDLE_CONTAINER:MovieClip;
		private var _QUESTIONMARK_CONTAINER:MovieClip;
		private var line:MovieClip;
		private var DragNDropClip:MovieClip;
		private var objectScaleX:Number;
		private var objectScaleY:Number;
		private var preSetSelection:String;
		private var myStage:MovieClip;
		
		public function Candlestick(stage:MovieClip)
		{
			myStage = stage;
			objectScaleX = new Number();
			objectScaleY = new Number();
			//this.addEventListener(MouseEvent.ROLL_OVER, ScaleMeUp);
			//this.addEventListener(MouseEvent.ROLL_OUT, ScaleMeDown);
			_background = new MovieClip();
			//Mouse.cursor = "auto";
			DragNDropClip = new MovieClip  ;
			IS_DOJI = new MovieClip();
			IS_SHOOTING_STAR = new MovieClip();
			IS_ABANDONED_BABY = new MovieClip();
			_CLOSE_CONTAINER = new MovieClip();
			_QUESTIONMARK_CONTAINER = new MovieClip();
			
		

			line = new MovieClip  ;
			DrawBackground(0,0,350,400, 0xC0C0C0);


			PlaceImage(IS_DOJI, "candlestickDoji.gif", handleClick, true);
			PlaceImage(IS_SHOOTING_STAR, "candleShootingStar.gif", handleClick, true);
			PlaceImage(IS_ABANDONED_BABY, "candleAbandonedBaby.gif", handleClick, true);
			
			PlaceImage(_CLOSE_CONTAINER, "closeB", Close, false);
			PlaceImage(_QUESTIONMARK_CONTAINER, "questionMark", customCandlestick, false);
			_CLOSE_CONTAINER.x = _background.width - 40;
			//_CLOSE_CONTAINER.scaleX = .2
			//_CLOSE_CONTAINER.scaleY = .2

			//this.addChild(line);
			IS_DOJI.scaleX = 1.5;
			IS_DOJI.scaleY = 1.5;
			IS_DOJI.y = 15;
			IS_DOJI.x = 15;
			IS_DOJI.name = "IS_DOJI";

			IS_SHOOTING_STAR.scaleX = 1.5;
			IS_SHOOTING_STAR.scaleY = 1.5;
			IS_SHOOTING_STAR.x = _background.width - IS_SHOOTING_STAR.width - 30;
			IS_SHOOTING_STAR.y = 10;
			IS_SHOOTING_STAR.name = "IS_SHOOTING_STAR"

			IS_ABANDONED_BABY.scaleX = 1.5;
			IS_ABANDONED_BABY.scaleY = 1.5;
			IS_ABANDONED_BABY.y = 250;
			IS_ABANDONED_BABY.x = 20;
			IS_ABANDONED_BABY.name = "IS_ABANDONED_BABY"
			
			
			_QUESTIONMARK_CONTAINER.scaleX = 0.4;
			_QUESTIONMARK_CONTAINER.scaleY = 0.4;
			_QUESTIONMARK_CONTAINER.x = _background.width - _QUESTIONMARK_CONTAINER.width - 30;;
			_QUESTIONMARK_CONTAINER.y = 250;
			
			

			this.addChild(DragNDropClip);
			
			//DragNDropClip.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownHandler);
			//DragNDropClip.addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);
			//line.graphics.moveTo(200,200);
			DrawGrid(2);
			DragNDropClip.addEventListener("CustomCandleCreated", CustomCandleCreated);
			//line.graphics.endFill();
			//line.graphics.endFill();
			//myStage.addChild(this);
			

		}
		function CustomCandleCreated(e:Event):void{
			//trace("SSCANDLECREATED");
		}
		function RollOver(e:Event):void{
			//trace(e.currentTarget.name)
			objectScaleX = e.currentTarget.scaleX;
			objectScaleY = e.currentTarget.scaleY;
			e.currentTarget.scaleX = 2;
			e.currentTarget.scaleY = 2;
		}
		function RollOut(e:Event):void{
			e.currentTarget.scaleX = objectScaleX;
			e.currentTarget.scaleY = objectScaleY;
		}
		function customCandlestick(e:Event):void
		{
			var customC:CustomCandle = new CustomCandle();
			
			customC.addEventListener("CustomCandleCreated", customCandleHandler)
			customC.move(100, 0)
			//dispatchEvent(new Event("Custom Candle"));
			this.myStage.removeChild(this);
			this.myStage.addChild(customC);
		}
		public function move(xLoca:Number, yLoca:Number){
			this.x = xLoca;
			this.y = xLoca;
		}
		function customCandleHandler(event:CustomEvent):void{
			var customCandleResults:String = event.data;
			sendCustomCandleResults(customCandleResults);
		}
		function sendCustomCandleResults(results:String):void{
			
			dispatchEvent(new CustomEvent("customCandleResults", results));
		}
		function ScaleMeUp(e:Event):void
		{
			this.scaleX = 0.9;
			this.scaleY = 0.9;
		}
		function ScaleMeDown(e:Event):void
		{
			this.scaleX = 0.3;
			this.scaleY = 0.3;
			this.x = 450;
		}
		// Define a mouse down handler (user is dragging)
		function MouseDownHandler(evt:MouseEvent):void
		{
			DragNDropClip.startDrag();
		}

		function MouseUpHandler(evt:MouseEvent):void
		{
			DragNDropClip.stopDrag();
		}
		function Close(e:Event):void
		{
			this.parent.removeChild(this);
		}
		function PlaceImage(_container:Sprite, _className:String, _function:Function, _isCandle:Boolean):void
		{
			var tempClass:Class = getDefinitionByName(_className) as Class;
			var tempBitmap:Bitmap = new Bitmap(new tempClass());
			_container.name = _className;
			_container.addChild(tempBitmap);
			_container.buttonMode = true;
			_container.addEventListener(MouseEvent.CLICK, _function);
			if(_isCandle){
				_container.addEventListener(MouseEvent.MOUSE_OVER, RollOver);
				_container.addEventListener(MouseEvent.MOUSE_OVER, RollOut);
			}
			DragNDropClip.addChild(_container);
			
		}

		function handleClick(event:Event):void
		{	
			preSetSelection = event.currentTarget.name;
			dispatchEvent(new CustomEvent("PreSelectedCandle", preSetSelection));
			this.parent.removeChild(this);
		}
		function handleCustomCandle(event:CustomEvent):void{
			
		}
		public function DrawBackground(_xCoor:int, _yCoor:int, _legnth:int, _width:Number, _color:uint):void
		{

			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = 0;
			dropShadow.angle = 45;
			dropShadow.color = 0x333333;
			dropShadow.alpha = 1;
			dropShadow.blurX = 10;
			dropShadow.blurY = 10;
			dropShadow.strength = 1;
			dropShadow.quality = 15;
			dropShadow.inner = false;
			dropShadow.knockout = false;
			dropShadow.hideObject = false;
			
			DragNDropClip.filters = [dropShadow];
			//var _background = new MovieClip();
			
			
			
			
			_background.graphics.lineStyle(1, 0x6D7B8D);
			//Last arg is the alpha;
			_background.graphics.beginFill(0xFFFFFF, 1);
			//Last arg is the alpha;
			_background.graphics.drawRect(_xCoor, _yCoor, _legnth, _width);
			_background.graphics.endFill();
			_background.buttonMode = true;
			DragNDropClip.addChild(_background);
			//CreateDataGrid();

			DragNDropClip.y = 0;
			DragNDropClip.x = 0;
			//trace(DragNDropClip.width);
			
		}
		function DrawGrid(gridSize:Number):void
		{
			//trace(DragNDropClip.width);
			var temp:Number = _background.width / gridSize;
			var temp1:Number = _background.height / gridSize;
			var temp2:Number = temp;
			var temp3:Number = temp1;
			for (var i:Number = 0; i < gridSize; i++)
			{
				var lineDrawing:MovieClip = new MovieClip();
				DragNDropClip.addChild(lineDrawing);
				lineDrawing.graphics.lineStyle(2);
				lineDrawing.graphics.moveTo(temp,0);
				lineDrawing.graphics.lineTo(temp, _background.height - 10);
				var lineDrawingH:MovieClip = new MovieClip();
				DragNDropClip.addChild(lineDrawingH);
				lineDrawingH.graphics.lineStyle(1);
				lineDrawingH.graphics.moveTo(0 , temp1);
				lineDrawingH.graphics.lineTo(_background.width, temp1);
				temp = temp + temp2;
				temp1 = temp1 + temp3;
			}
		}
	}

}