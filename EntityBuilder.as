package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import fl.events.ComponentEvent;
	import fl.controls.TextInput;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.filters.*;
	import flash.utils.getDefinitionByName;
	import fl.controls.Label;
	import flash.text.AntiAliasType;
	import fl.events.SliderEvent;
	import com.yahoo.astra.fl.controls.AutoComplete;
	import flash.text.TextFormat;
	import fl.controls.Button;

	
	public class EntityBuilder extends MovieClip{
		
		private var STRATEGY:Strategy = Strategy.getInstance();
		private var submitButton:Button;
		private var initialEntity:Entity;
		private var comparedEntity:Entity;
		
	
		
		public function EntityBuilder() {
			
			var temp:Entity = createEntity();
			initialEntity = temp;
			initialEntity.addEventListener("CompareEntity", newEntity)
			initialEntity.addEventListener("RemoveCompareEntityButton", removeCompareEntityButton)
			initialEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleRemove)
			initialEntity.addEventListener("RemoveEntity", removeCompareEntityButton);
			initialEntity.addEventListener("CandleCreationComplete", handleCandle);
			initialEntity.addEventListener("mathOpsSelected", handleMathOp);
			addChild(initialEntity);
		}
		function handleMathOp(event:CustomEvent):void{
			trace("Math Op Selected" + event.data[0])
			createSubmitButton(300, 200);
		}
		function handleCandle(event:Event):void{
			
			initialEntity.updateFieldOptions();
			createSubmitButton(300, 200);
		}
		function handleRemove(event:Event):void{
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
			if(comparedEntity){
				if(comparedEntity.stage){
					removeChild(comparedEntity);
					//initialEntity.removeEventListener("mathOpsSelected", newMathOp)
				}
				
			}
		}
		function secondEntityRemove():void{
			if(comparedEntity){
				if(comparedEntity.stage){
					removeChild(comparedEntity);
				}
			}
		}
		function createEntity():Entity{
			var tempEnt = new Entity();
			return tempEnt;
		}
		function removeCompareEntityButton(event:Event):void{
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
			secondEntityRemove();
		}
		function createSubmitButton(xLoca:Number = 300, yLoca:Number = 450):void{
			
			if(submitButton){
				if(submitButton.stage){
					removeChild(submitButton);
				}
			}
			submitButton = new Button();
			//submitButton.label = "Compare Entity"
			submitButton.setSize(125, 25);
			submitButton.emphasized = true;
			//submitButton.setStyle("icon", BulletCheck);
			//submitButton.textField.wordWrap = true;
			
			//submitButton.removeEventListener(MouseEvent.CLICK, newEntity);
			submitButton.addEventListener(MouseEvent.CLICK, compareEntities);
			submitButton.label = "Done"
			submitButton.move(xLoca, yLoca);
			submitButton.enabled = true;
			//submitButton.addEventListener(MouseEvent.CLICK, newEntity);
			//submitButton.x = _background.width - 140;
			//submitButton.y = _background.height - 65;
			initialEntity.addEventListener("mathOpsSelected", newMathOp)
			addChild(submitButton)
		}
		function newMathOp(event:Event):void{
			if(comparedEntity){
				if(comparedEntity.stage){
					//removeChild(comparedEntity);
					//initialEntity.removeEventListener("mathOpsSelected", newMathOp)
				}
				
			}
		}
		function newEntity(event:Event):void{
			trace("New entity here");
			if(comparedEntity){
				
			}
			comparedEntity = createEntity();
			comparedEntity.y += 250;
			addChild(comparedEntity);
			
		}
		function createNewEntity():void{
			var me:MovieClip = createEntity();
			addChild(me);
			
			comparedEntity = me as Entity;
			comparedEntity.y += 250;
			comparedEntity.setIsCompared(false);
			comparedEntity.addEventListener("Enable Compare", enableCompareButton);
			comparedEntity.addEventListener(Event.REMOVED_FROM_STAGE, handleComparedRemove)
			comparedEntity.addEventListener("RemovedButtonClicked", resetInitialMathOps)
			
			addChild(comparedEntity);
			STRATEGY.dispatch();
		}
		function resetInitialMathOps(event:Event):void{
			initialEntity.resetMathOps();
		}
		function noEntity(event:Event):void{
			
		}
		function handleComparedRemove(event:Event):void{
			/*submitButton.move(300, 200)
			submitButton.removeEventListener(MouseEvent.CLICK, newEntity);
			submitButton.removeEventListener(MouseEvent.CLICK, compareEntities);
			submitButton.addEventListener(MouseEvent.CLICK, newEntity);
			submitButton.enabled = true;*/
			if(submitButton){
			if(submitButton.stage){
				removeChild(submitButton);
			}
			}
			//initialEntity.addEventListener("CompareEntity", newEntity)
			//initialEntity.resetMathOps();
		}
		function enableCompareButton(event:Event):void{
			createSubmitButton();
		}
		function compareEntities(event:Event):void{
			trace("++++++++++++++++INITIAL++++++++++++++++++++++++")
			
			var ent:XML = initialEntity.setXML()
			trace(ent);
			trace("++++++++++++++++INITIAL++++++++++++++++++++++++")
			comparedEntity.setXML()
			
			trace("++++++++++++++++COMPARED++++++++++++++++++++++++")
			trace(comparedEntity.getConditionalEntityArray());
			trace("++++++++++++++++COMPARED++++++++++++++++++++++++")
			var secondEntity:XML = new XML(<SecondEntity/>);
			var comparedEntityArray:Array = comparedEntity.getConditionalEntityArray();
			var comparedEntityType:String = comparedEntityArray[0];
			var comparedEntityCondEntity:String = comparedEntityArray[1];
			secondEntity["SecondEntity"]. @ ["type"] = comparedEntityType;
			secondEntity["SecondEntity"] = comparedEntityCondEntity;
			ent.appendChild(secondEntity.SecondEntity);
			trace("++++++++++++++++SECOND ENTITY XML++++++++++++++++++++++++")
			trace(ent.toXMLString());
			trace("++++++++++++++++SECOND ENTITY XML++++++++++++++++++++++++")
			
		}
		

	}
}
