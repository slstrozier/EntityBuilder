package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	import flash.geom.ColorTransform;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import fl.controls.Label;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.*;
	import flash.text.*;
	import fl.controls.Button;
	

	public class CustomCandle extends Sprite
	{

		private var body:Sprite;
		private var line:Sprite;
		private var open:Sprite;
		private var close:Sprite;
		// positions of open and close handles
		private var openPoint:Point;
		private var closePoint:Point;
		// drag rectangle
		private var dragRect:Rectangle;
		
		private var distanceFromOpenPtToClosedPt:Number;
		private var distanceOfOpenToLineBottom:Number;
		private var distanceOfClosedToLineTop:Number;
		private var OPEN_CLOSE:String;
		private var nuOPEN_CLOSE:String;
		private var ratioString:String;
		private var myLabel:TextField;
		private var error:String;
		private var slider:Slider;
		private var sliderLabel:TextField;
		private var infoQContain:Sprite;
		private var descriptionTextBox:TextField;
		private var _background:MovieClip;
		private var _candleBackground:MovieClip;
		public var go_Contain:Sprite;
		public var close_Contain:Sprite;
		public function CustomCandle()
		{

			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			
			_candleBackground = new MovieClip();
			_candleBackground.x = 50
			DrawBackground(_background = new MovieClip(), 250, 350);
			descriptionTextBox = new TextField();
			descriptionTextBox.alpha = 0;
			
			//infoQContain.description = "the information container";
			_background.addEventListener(MouseEvent.MOUSE_OVER, DisplayDescription);
			_background.removeEventListener(Event.ADDED_TO_STAGE, init);
			//sliderLabel = new Label();
			openPoint = new Point();
			closePoint = new Point();
			body = new Sprite();
			//myLabel = new Label();
			//myLabel.autoSize = "center";
			body.addEventListener(MouseEvent.MOUSE_DOWN, onBodyDown);
			addEventListener(Event.ENTER_FRAME, CheckForOpen);
			DrawTextBox(myLabel = new TextField(), 200, 20, "Ratio Label: The ratio of numbers for the Candle Stick");
			drawLine();
			makeHandles();
			drawBody(100);
			CreateSlider(slider = new Slider(), _candleBackground.x, 250);
			body.x = line.x;
			body.y = line.y + 20;
			onBodyDrag();
			_background.addChild(_candleBackground);
			_candleBackground.addChild(body)
			applyDropShadow();
			addChild(PlaceImage(close_Contain = new Sprite(), 1, 1, "closeB", "Candle Stick Close", closeMe, "Click Here to Close"))
			var butText:Button = new Button();
			butText = new Button();
			butText.label = "Commit Candle"
			butText.setSize(110, 25)
			butText.emphasized = true;
			//butText.setStyle("icon", BulletCheck);
			butText.move(_candleBackground.width - 40, _candleBackground.height + 110)
			butText.addEventListener(MouseEvent.CLICK, SubmitCandleStick);
			_candleBackground.addChild(butText);
			nuOPEN_CLOSE = "";
			//addChild(PlaceImage(go_Contain = new Sprite(), 0.3, 0.3, "candleStickGo.png", "Candle Stick Submit", SubmitCandleStick, "Click Here to Submit"));
			//go_Contain.x = _candleBackground.width + 50;
			//go_Contain.y = _candleBackground.height + 60;
		}
		function closeMe(event:Event):void{
			this.parent.removeChild(this)
		}
		function MyDescription(e:Event):void{
			
		}
		function SubmitCandleStick(event:MouseEvent):void{
			//trace(event.currentTarget.name);
			var custCandleData:Array = new Array(ratioString, error);
			//trace(custCandleData);
			dispatchEvent(new CustomEvent("CustomCandleCreated", custCandleData));
			parent.removeChild(this);
		}
		public function move(xLoca:Number, yLoca:Number){
			this.x = xLoca;
			this.y = xLoca;
		}
		function DisplayDescription(e:Event):void{
			
			//trace(e.currentTarget.name);
		}
		function Trace(e:Event):void{
			error = (e.target.value/100).toString();
			sliderLabel.text = error;
		}
		function UpdateRatioString():String{
			
			ratioString = distanceOfOpenToLineBottom.toString() + "," + distanceOfClosedToLineTop.toString() + "," + distanceFromOpenPtToClosedPt.toString() + "," + nuOPEN_CLOSE.toString();
			return ratioString;
		}
		function DrawBackground(_background:MovieClip, _width:Number, _height:Number):void{
			
			//First we declare an object, a dropshadow filter and name it my_shadow for further reference.  
			var my_shadow:DropShadowFilter = new DropShadowFilter();  
			//Now we apply some properties to our new filters object, this first property is the color, and we set that to black, as most shadows are.  
			my_shadow.color = 0x000000;  
			//These next two properties we set, are the position of our dropshadow relative to the object,  
			//This means 8 px from the object on both the x and y axis.  
			my_shadow.blurY = 8;  
			my_shadow.blurX = 8;  
			//And here we set an angle for the dropshadow, also relative to the object.  
			my_shadow.angle = 100;  
			//Setting an alpha for the shadow. This is to set the strength of the shadow, how "black" it should be.  
			my_shadow.alpha = .5;  
			//and here we set the distance for our shadow to the object.  
			my_shadow.distance = 6;   
			//Now we define an array for our filter with its properties to hold it. This will be the final object we refer to when we need to apply it to something.  
			var filtersArray:Array = new Array(my_shadow);  
			_background.graphics.lineStyle(2, 0xC0C0C0, 1); //Last arg is the alpha
			_background.graphics.beginFill(0xE8E8E8, 1); //Last arg is the alpha
			_background.graphics.drawRect(0, 0, _width, _height)
			_background.graphics.endFill();
			_background.filters = filtersArray;
			addChild(_background);
		}
		private function makeHandles():void
		{
			open = PlaceImage(open = new Sprite(), 0.1, 0.1, "newHandleOpen.png", "The Open Handle", onHandleDown, "Open");
            close = PlaceImage(close = new Sprite(), 0.1, 0.1, "newHandleClosed.png","The Close Handle", onHandleDown, "Closed");
			_candleBackground.addChild(open);
			_candleBackground.addChild(close);
			open.addEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);
			close.addEventListener(MouseEvent.MOUSE_DOWN, onHandleDown);
		}

		private function onHandleDown(e:MouseEvent):void
		{
			_candleBackground.addEventListener(MouseEvent.MOUSE_UP, onMouse_Up);
			_candleBackground.addEventListener(Event.ENTER_FRAME, onHandleMove);
			dragRect.height = line.height;
			Sprite(e.target).startDrag(false, dragRect);
		}

		private function onHandleMove(e:Event):void
		{
			openPoint.x = open.x;
			openPoint.y = open.y;
			closePoint.x = close.x;
			closePoint.y = close.y;
			//var openT:Sprite = PlaceImage
			drawBody(Point.distance(openPoint, closePoint));
			body.y = Math.min(open.y,close.y);
		}
		function PlaceImage(_container:Sprite, _scaleX:Number, _scaleY:Number, _className:String, _name:String, _function:Function, _extra:String):Sprite
		{
			
			var tempClass:Class = getDefinitionByName(_className) as Class;
			var tempBitmap:Bitmap = new Bitmap(new tempClass());
			if(_extra == "Open"){
				tempBitmap.x = -500;
				tempBitmap.y = -140;
			}
			else if(_extra == "Closed"){
				tempBitmap.x = 100;
				tempBitmap.y = -105;
			}
			
			
			_container.name = _name;
			_container.scaleY = _scaleY;
			_container.scaleX = _scaleX;
			_container.addChild(tempBitmap);
			_container.buttonMode = true;
			_container.addEventListener(MouseEvent.MOUSE_DOWN, _function);
			//_container.addEventListener(MouseEvent.CLICK, Trace);
			return _container;
			
		}
		
		private function onBodyDown(e:MouseEvent):void
		{
			_candleBackground.addEventListener(MouseEvent.MOUSE_UP, onMouse_Up);	
			_candleBackground.addEventListener(Event.ENTER_FRAME, onBodyDrag);
			dragRect.height = line.height - body.height;
			body.startDrag(false, dragRect);
		}

		private function onBodyDrag(e:Event = null):void
		{
			open.x = close.x = line.x;
			if (open.y >= close.y)
			{
				close.y = body.y;
				open.y = body.y + body.height;
			}
			else
			{
				open.y = body.y;
				close.y = body.y + body.height;
			}

		}
		function DrawTextBox(myTextField:TextField, _xLoca:Number, _yLoca:Number, _name:String):void{

			_background.addChild(myTextField); 
			myTextField.autoSize = "center"  
			myTextField.x = _xLoca;  
			myTextField.y = _yLoca;  
			myTextField.selectable = false;   
			
			var myFormat:TextFormat = new TextFormat();  
			myFormat.size = 24;   
			myFormat.italic = true;    
			myTextField.setTextFormat(myFormat);  
		
		}
		
		function onMouse_Up(e:MouseEvent):void
		{
			stopDrag();
			_candleBackground.removeEventListener(Event.ENTER_FRAME, onHandleMove);
			_candleBackground.removeEventListener(Event.ENTER_FRAME, onBodyDrag);
		}

		function drawPriceHandle():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0x000000);
			s.graphics.drawCircle(0, 0, 5);
			s.graphics.endFill();
			return s;
		}


		private function drawLine():void
		{
			line = new
			 Sprite();
			line.graphics.lineStyle(3, 0x000000, 1, false, LineScaleMode.VERTICAL,
                               CapsStyle.ROUND, JointStyle.MITER, 10);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(0, 200);
			line.x = 50;
			line.y = 20;
			_candleBackground.addChild(line);
			dragRect = new Rectangle(line.x,line.y,0,line.height);
		}


		private function drawBody(h:Number):void
		{
			body.name = "CandleStick Body";
			body.graphics.clear();
			body.graphics.lineStyle(1);
			body.graphics.beginFill(0x99FF33);
			body.graphics.drawRect(-10, 0, 20, h);
			body.graphics.endFill();
			//_candleBackground.addChild(PlaceImage(infoQContain = new Sprite, 0.1, 0.1, "infoQuestion.png", "Description", MyDescription, "Yep"));
			//infoQContain.x = 100
			//infoQContain.y = 200
		}

		private function applyDropShadow():void
		{
			var dropShadow:DropShadowFilter = new DropShadowFilter();
			dropShadow.distance = 0;
			dropShadow.angle = 45;
			dropShadow.color = 0x333333;
			dropShadow.alpha = 1;
			dropShadow.blurX = 2;
			dropShadow.blurY = 2;
			dropShadow.strength = 1;
			dropShadow.quality = 15;
			dropShadow.inner = false;
			dropShadow.knockout = false;
			dropShadow.hideObject = false;
			filters = new Array(dropShadow);
		}
		function CreateSlider(_slider:Slider, _xLoca:Number, _yLoca:Number):void{
			
			//DrawTextBox(sliderLabel, 100, 100 + 50, "Error: The  of error user is willing to accept"):void{
			_background.addChild(slider);
			
			DrawTextBox(sliderLabel = new TextField(), _xLoca + 50, _yLoca + 25, "The % error the user is willing to accept")
			sliderLabel.text = 0.0.toString();
			sliderLabel.autoSize = "center";
						//position slider
			slider.move(_xLoca,_yLoca);
			
			// control if slider updates instantly or after mouse is released
			slider.liveDragging = true;
			
			//set size of slider
			slider.setSize(100,0);
			
			//set maximum value
			slider.maximum = 100;
			
			//set mininum value
			slider.minimum = 0;
			
			slider.addEventListener(Event.CHANGE, Trace);
		}
			
		private function CheckForOpen(e:Event):void{
			var isNeg:Boolean = false;
			var isMaxed:Boolean = false;
			distanceFromOpenPtToClosedPt = Math.floor(body.height/2);
			if(distanceFromOpenPtToClosedPt > 100){
				distanceFromOpenPtToClosedPt = 100;
			}
			if(distanceFromOpenPtToClosedPt < 1){
				distanceFromOpenPtToClosedPt = 1;
			}
			//distanceOfOpenToLineBottom = open.y - 220;
			if(-(open.y - 220) < 0 || (close.y - 20) > 200){
				isNeg = true;
				isMaxed = true
			}
			else if(isNeg){

				distanceOfOpenToLineBottom = 0;
			}
			else if(isMaxed){
				distanceOfClosedToLineTop = 100;
			}
			
			
			else{
				
				distanceOfOpenToLineBottom = Math.floor(Math.abs(open.y - 220)/2);
				distanceOfClosedToLineTop = Math.floor(Math.abs(close.y - 20)/2);
				
				//trace(close.y - 20)
			}
			//trace(isNeg);
			
			//distanceOfClosedToLineTop = Math.abs(close.y - 20);
			if (open.y > close.y)
			{
				//change the color of the candle body to red
				body.transform.colorTransform = new ColorTransform(1,1,1,1,1,1,1,0);
				OPEN_CLOSE = "0";
				nuOPEN_CLOSE = "0";
				
			}
			if (open.y < close.y)
			{
				//change the color of the candle body to green
				body.transform.colorTransform = new ColorTransform(1,255,1,1,1,1,1,0);
				OPEN_CLOSE = "C";
				nuOPEN_CLOSE = "1";
			}
			myLabel.text = UpdateRatioString();
		
		}

	}

}