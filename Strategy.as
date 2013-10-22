package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Strategy extends MovieClip
	{
		private static var instance:Strategy;
		private static var isOkayToCreate:Boolean = false;
		//*********Array Variables***********
		private var DATABASE:Array;
		private var IND_DATABASE:Array;
		private var STOCKS:Array;
		private var INDEXES:Array;
		private var CURRENCIES:Array;
		private var BONDS:Array;
		private var COMMODITIES:Array;
		private var INDICATORS:Array;
		private var TIMEOPTIONS:Array;
		private var TREATMENTS:Array;
		private var ETFS:Array;
		private var MATHOPS:Array;
		private var PORTOPERATORS:Array;
		private var INTRADE_MATHOPS:Array;
		private var INTRADE_TIMEOPTIONS:Array;
		private var DATABASE_INITIAL:Array;
		private var ITERATION_DATABASE:Array;
		private var CALCULATED_DATABASE:Array;
		//*********End Array Variables*******
		private var urlDriver:URLFactory;

		public function Strategy()
		{
			if(!isOkayToCreate) throw new Error(this + " is a Singleton. Access using getInstance()");
			createIterationDatabase();
			SetDatabase();
			SetDatabaseInitial();
			this.addEventListener("DataBaseReady", SetINDDatabase);
			this.addEventListener("INDDataBaseReady", CreateIndexesDictionary);
			this.addEventListener("IndexesReady", CreateStocksDictionary);
			this.addEventListener("StocksReady", CreateIndicatorsDictionary);
			this.addEventListener("IndicatorsReady", CreateTimeOptionsDictionary);
			this.addEventListener("TimeOptionsReady", CreateCurrenciesDictionary);
			this.addEventListener("CurrenciesReady", CreateBondsDictionary);
			this.addEventListener("BondsReady", CreateTreatmentsDictionary);
			this.addEventListener("TreatementsReady", CreateETFSDictionary);
			this.addEventListener("InTradeMathOpsReady", CreateInTradeTimeOptionsDictionary);
			this.addEventListener("InTradeTimeOptionsReady", CreatePortOperators);
			this.addEventListener("MathOpsReady", CreateInTradeMathOperators);
			this.addEventListener("PortOpsReady", createCalculatedDB);
			this.addEventListener("DataBaseReady", CreateCommoditiesDictionary);
			this.addEventListener("ETFSReady", CreateMathOperators);
			this.addEventListener("CalculatedDBsReady", StrategyReady);
			this.addEventListener("StrategyReady", moveForward)

		}
		public static function getInstance():Strategy
        {
            //If there's no instance, create it
            if (!instance)
            {
				
                //Allow the creation of the instance, and after it is created, stop any more from being created
                isOkayToCreate = true;
                instance = new Strategy();
				              
            }
			//dispatchEvent(new Event("StrategyReady"));
            return instance;
        }
		function moveForward(event:Event):void{
			 isOkayToCreate = false;
             trace("Singleton instance created!");
		}
		function waitForCompleteion():void{
			
		}
		public function dispatch():void{
			dispatchEvent(new Event("StrategyReady"));
		}
		
		public function createCalculatedDB(e:Event):void{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=DBS_LIST&ISTBL=false");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, calculatedDBSetter);
		}
		public function createStandardDictionary(data:String):Array{
			var temp:Array = new Array();
			temp = createMathOpsDictionary(data);
			
			return temp;
		}
		function calculatedDBSetter(e:CustomEvent)
		{
			//trace(e.data);
			CALCULATED_DATABASE = CreateDictionary(e.data, false);
			
			dispatchEvent(new Event("CalculatedDBsReady"));
		}
		public function createIterationDatabase():void{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=content&DBS=index");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, iterateDBSetter);
		}
		function iterateDBSetter(e:CustomEvent)
		{
			
			ITERATION_DATABASE = CreateDictionary(e.data,false);
			
			//dispatchEvent(new Event("MathOpsReady"));
			
		}
		public function CreateMathOperators(event:Event):void
		{
			//C:/Users/Programmer2/Desktop/mathOps.txt
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=Oper_me&INTRADE=false");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, MathOpsSetter);
		}
		function MathOpsSetter(e:CustomEvent)
		{
			
			MATHOPS = createMathOpsDictionary(e.data);
			dispatchEvent(new Event("MathOpsReady"));
			
		}
		public function CreateInTradeMathOperators(event:Event):void
		{
			//C:\Users\Programmer2\Desktop\Adobe Photoshop CS5.1\FINALSTRATEGY\mathOps.txt
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=Oper_me&INTRADE=true");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, InTradeMathOpsSetter);
			
		}
		function InTradeMathOpsSetter(e:CustomEvent):void
		{

			INTRADE_MATHOPS = createMathOpsDictionary(e.data);
			dispatchEvent(new Event("InTradeMathOpsReady"));
			
		}
		public function CreatePortOperators(event:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=Oper_pf");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, PortOpsSetter);
		}
		function PortOpsSetter(e:CustomEvent):void
		{
			
			PORTOPERATORS = createMathOpsDictionary(e.data);
			dispatchEvent(new Event("PortOpsReady"));
			
		}
		public function CreateIndexesDictionary(e:Event):void
		{

			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=CONTENT&DBS=INDEX");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, IndexesSetter);
		}
		//Event handler for CreateIndexesDictionary(), sets the _INDEXES Dictonary
		function IndexesSetter(e:CustomEvent)
		{
			INDEXES = CreateDictionary(e.data,false);
			dispatchEvent(new Event("IndexesReady"));

		}
		//Queries the stock database for the data of available stocks
		public function CreateStocksDictionary(e:Event):void
		{

			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=CONTENT&DBS=STOCK");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, StockSetter);

		}
		//Event handler for CreateStocksDictionary(), sets the _STOCKLIST array
		function StockSetter(e:CustomEvent)
		{
			STOCKS = CreateDictionary(e.data,false);
			dispatchEvent(new Event("StocksReady"));
		}

		///Queries for the list of Tradeables available. Uses the TreatmentSetter handler for this task
		public function CreateCommoditiesDictionary(e:Event):void
		{

			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=CONTENT&DBS=COMMODITY");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, CommoditySetter);
		}
		///Event handler for CreateTradeablesDictionary(), sets the _TRADABLES_DATABASE Dictionary
		function CommoditySetter(e:CustomEvent)
		{
			COMMODITIES = CreateDictionary(e.data,false);
			dispatchEvent(new Event("CommoditiesReady"));
		}

		///Queries for the list of Tradeables available. Uses the TreatmentSetter handler for this task
		public function CreateCurrenciesDictionary(e:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=CONTENT&DBS=CURRENCY");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, CurrencySetter);

		}
		///Event handler for CreateTradeablesDictionary(), sets the _TRADABLES_DATABASE Dictionary
		function CurrencySetter(e:CustomEvent)
		{

			CURRENCIES = CreateDictionary(e.data,false);
			dispatchEvent(new Event("CurrenciesReady"));
		}

		///Queries for the list of Tradeables available. Uses the TreatmentSetter handler for this task
		public function CreateBondsDictionary(e:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=CONTENT&DBS=BOND");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, BondsSetter);
		}
		///Event handler for CreateTradeablesDictionary(), sets the _TRADABLES_DATABASE Dictionary
		function BondsSetter(e:CustomEvent)
		{

			BONDS = CreateDictionary(e.data,false);
			dispatchEvent(new Event("BondsReady"));
		}

		public function CreateTimeOptionsDictionary(e:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=Oper_tm&INTRADE=false");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, TimeOptionsSetter);
		}
		//Event handler for CreateIndexesDictionary(), sets the _INDEXES Dictonary
		function TimeOptionsSetter(e:CustomEvent)
		{
			//trace(e.data)
			TIMEOPTIONS = CreateDictionary(e.data,false);
			dispatchEvent(new Event("TimeOptionsReady"));
		}
		public function CreateInTradeTimeOptionsDictionary(e:Event):void
		{
			
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=Oper_tm");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, InTradeTimeOptionsSetter);
		}
		//Event handler for CreateIndexesDictionary(), sets the _INDEXES Dictonary
		function InTradeTimeOptionsSetter(e:CustomEvent)
		{
			//trace(e.data)
			INTRADE_TIMEOPTIONS = CreateDictionary(e.data,false);
			dispatchEvent(new Event("InTradeTimeOptionsReady"));
		}
		private function SetDatabase():void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=DBS_List&ISTBL=true");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, DatabaseSetter);
		}

		function DatabaseSetter(e:CustomEvent):void
		{
			DATABASE = CreateDictionary(e.data,false);

			dispatchEvent(new Event("DataBaseReady"));
		}
		private function SetDatabaseInitial():void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=DBS_List&ISTBL=false");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, DatabaseSetterInitial);
		}

		function DatabaseSetterInitial(e:CustomEvent):void
		{
			DATABASE_INITIAL = CreateDictionary(e.data,false);
			
			dispatchEvent(new Event("InitialDataBaseReady"));
		}
		
		private function SetINDDatabase(e:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=DBS_List&ISTBL=false");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, indDatabaseSetter);
		}

		function indDatabaseSetter(e:CustomEvent):void
		{
			IND_DATABASE = CreateDictionary(e.data,false);

			dispatchEvent(new Event("INDDataBaseReady"));
		}
		public function CreateIndicatorsDictionary(e:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=ind_list");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, IndicatorSetter);

		}
		//Event handler for CreateIndexesDictionary(), sets the _INDEXES Dictonary
		function IndicatorSetter(e:CustomEvent)
		{
			
			INDICATORS = this.createINDDictionary(e.data);
			

			dispatchEvent(new Event("IndicatorsReady"));
		}
		///Queries for the list of Treatments available. Uses the TreatmentSetter handler for this task
		public function CreateTreatmentsDictionary(e:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=treat_list");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, TreatmentsSetter);
		}
		///Event handler for CreateTreatmentsDictionary(), sets the _TREATMENT array
		public function TreatmentsSetter(e:CustomEvent)
		{
			//trace(e.data);
			TREATMENTS = createTreatmentsDictionary(e.data);
			dispatchEvent(new Event("TreatementsReady"));
		}
		public function CreateETFSDictionary(e:Event):void
		{
			urlDriver = new URLFactory("http://192.168.1.103:8080/sample/ServiceFlash?TASK=CONTENT&DBS=ETF");
			urlDriver.addEventListener(CustomEvent.QUERYREADY, ETFsSetter);
		}
		///Event handler for CreateETFSDictionary(), sets the _ETFS array
		public function ETFsSetter(e:CustomEvent)
		{
			//trace(e.data)
			ETFS = CreateDictionary(e.data,false);
			dispatchEvent(new Event("ETFSReady"));
		}
		function StrategyReady(e:Event):void
		{
			dispatch();
			//name: splitArray[0].toString(), description: splitArray[1], parameters: splitArray[2], paramDescriptions: parameters, database: hasDatabase.filter(noEmpty)
			//trace(this.GetINDDatabase()[0].name + ":" + this.GetINDDatabase()[0].description +":" + this.GetINDDatabase()[0].parameters +":" + this.GetINDDatabase()[0].paramDescriptions +":" + this.GetINDDatabase()[0].database)
			
		}
		//++++++++++++SETTERS++++++++++++++++++++

		//++++++++++END SETTERS+++++++++++++++++

		//++++++++++GETTERS+++++++++++++++++

		public function GetDatabase():Array
		{
			return DATABASE;
		}
		public function GetINDDatabase():Array
		{
			
			return IND_DATABASE;
		}
		public function GetStocks():Array
		{
			
			return STOCKS;
		}
		public function GetTimeOptions():Array
		{
			return TIMEOPTIONS;
		}
		public function GetIndicators():Array
		{
			return INDICATORS;
		}
		public function GetCurrencies():Array
		{
			return CURRENCIES;
		}
		public function GetIndex():Array
		{
			return INDEXES;
		}
		public function GetTreatments():Array
		{
			return TREATMENTS;
		}
		public function GetCommodities():Array
		{
			return COMMODITIES;
		}
		public function GetEtfs():Array
		{
			return ETFS;
		}
		public function GetBonds():Array
		{
			return BONDS;
		}
		public function getCalculatedDB():Array
		{
			return CALCULATED_DATABASE;
		}
		public function GetMathOps():Array
		{

			return MATHOPS;
		}
		public function GetPortOps():Array{
			
			
			return PORTOPERATORS;
		}
		public function GetInTradeMathOps():Array{
			return INTRADE_MATHOPS;
		}
		public function GetInTradeTimeOps():Array{
			return INTRADE_TIMEOPTIONS;
		}
		public function GetInitialDatabase():Array{
			return DATABASE_INITIAL;
		}
		public function getIterationDatabase():Array{
			return ITERATION_DATABASE;
		}
		
		//++++++++++END GETTERS++++++++++++++
		/**
		* Creates a dictionary of the string data given
		*
		* @param stringData The data passed to parse
		* @param dictionary The Dictionary object to hold the data
		*
		* @return The Dictionary created.
		*/
		/*function CreateDictionary(stringData:String, dictionary:Dictionary):Dictionary
		{
		var dataArray:Array = stringData.split("\n").filter(noEmpty);
		function noEmpty(item:*, index:int, array:Array):Boolean
		{
		return item != "";
		}
		dictionary = new Dictionary();
		for (var i:int = 0; i < dataArray.length; i++)
		{
		var j:int = dataArray[i].toString().indexOf('","');
		dictionary[dataArray[i].toString().substr(0,j)] = dataArray[i].toString().substr(j+3, dataArray[i].toString().length);
		}
		
		return dictionary;
		}*/

		function CreateDictionary(stringData:String, isIndicator:Boolean, isMathOp:Boolean = false):Array
		{

			var finalArray:Array = new Array();
			var dataArray:Array = stringData.split("\n").filter(noEmpty);
			dataArray.sort(Array.CASEINSENSITIVE);
			for (var i:int = 0; i < dataArray.length; i++)
			{
				var splitArray:Array = dataArray[i].split('","');
				var parameters:Array = new Array();
				var hasDatabase:Array = new Array("Not Null");
				
				
				if (Number(splitArray[3]) > 0)
				{
					

					if (isIndicator)
					{
						hasDatabase[0] = splitArray[5];
						parameters.push(checkNull(splitArray[4]));
						
					}

				}
				if (!isIndicator)
				{
					parameters.push(checkNull(splitArray[4]), checkNull(splitArray[5]), checkNull(splitArray[6]),checkNull(splitArray[7]));
					var tar2:Array = removeEmpties(parameters);

					parameters = tar2;
				}
				
				if (Number(splitArray[3]) == 0)
				{
					
					parameters = new Array();
					parameters.push("No Parameters");
					if (isIndicator)
					{
						hasDatabase[0] = splitArray[4];
					}
				}
				finalArray.push({HumanName: splitArray[0].toString(), DataName: splitArray[1].toString(), description: splitArray[2], parameters: splitArray[3], paramDescriptions: parameters, database: hasDatabase.filter(noEmpty)});
				//trace(finalArray[i].HumanName + "<HUMAN NAME>|" + finalArray[i].DataName + "<DATA NAME>|" + finalArray[i].description + "<DESCRIPTION>|" + finalArray[i].parameters + "<PARAMETERS>|" + finalArray[i].paramDescriptions + "<PARAMDESCR>|" + finalArray[i].defaults + "<DEFAULT VALUE>|" + finalArray[i].MainParameter + "<LEAD PARAMETER>@#");
			}

			//trace(finalArray[0])
			finalArray.sort();
			return finalArray;
		}
		public function createTreatmentsDictionary(stringData:String):Array
		{
			/*trace("***************************************** DATA BEFORE ************************************");
			trace(stringData);*/
			stringData = this.trimWhitespace(stringData);
			var finalArray:Array = new Array();
			var dataArray:Array = stringData.split("\n");
			dataArray.sort(Array.CASEINSENSITIVE);
			//trace("**" + dataArray + "**")
			for (var i:int = 0; i < dataArray.length; i++)
			{
				var splitArray:Array = dataArray[i].split('","');			
				var _humanName:String = checkStringNewLine(splitArray[0]);
				var _dataName:String  = checkStringNewLine(splitArray[1]);
				var _descriptions:String = checkStringNewLine(splitArray[2]);
				var _parameters:String = checkStringNewLine(splitArray[3]);
				var _mainParameter:String = "-1";
				var _paramDescriptions:String = checkStringNewLine(splitArray[4]);
				var _defaults:String = checkNumberNewLine(splitArray[5]);
				//trace(_defaults.split(':') + "<--Defaults")
				//var humanName = splitArray[0].split(" ").join("");
				finalArray.push({HumanName: _humanName, DataName: _dataName, description: _descriptions, parameters: _parameters, paramDescriptions: _paramDescriptions.split(':'), defaults: _defaults.split(':'), MainParameter: _mainParameter, database: "false1"});
				//trace(finalArray[i].HumanName + "<HUMAN NAME>|" + finalArray[i].DataName + "<DATA NAME>|" + finalArray[i].description + "<DESCRIPTION>|" + finalArray[i].parameters + "<PARAMETERS>|" + finalArray[i].paramDescriptions + "<PARAMDESCR>|" + finalArray[i].defaults + "<DEFAULT VALUE>|" + finalArray[i].MainParameter + "<LEAD PARAMETER>@#");				
				
			}
			finalArray.push({HumanName: "*No Treatment*", DataName: "", description: "No Treatment has been selected", parameters: 0, paramDescriptions: new Array(), defaults: new Array(), MainParameter: "N/A", database: "false1"});
			//trace("***************************************** DATA AFTER ************************************");
			return finalArray;
		}
		function createINDDictionary(stringData:String):Array
		{
			//trace("***************************************** DATA BEFORE ************************************");
			///trace(stringData);
			//trace("*****************************************  END DATA BEFORE ************************************");
			stringData = this.trimWhitespace(stringData);
			var finalArray:Array = new Array();
			var dataArray:Array = stringData.split("\n");
			dataArray.sort(Array.CASEINSENSITIVE);
			//trace("******************* Start Parsing of Data Array ***********************************")
			for (var i:int = 0; i < dataArray.length; i++)
			{
				var splitArray:Array = dataArray[i].split('","');
				var parameters:Array = new Array();
				var hasDatabase:Array = new Array("Not Null");
				
				var _humanName:String = checkStringNewLine(splitArray[0]);
				var _dataName:String  = checkStringNewLine(splitArray[1]);
				var _descriptions:String = checkStringNewLine(splitArray[2]);
				var _parameters:String = checkStringNewLine(splitArray[3]);
				var _paramDescriptions:String;
				var _mainParameter:String = "-1";
				var _hasDatabase:String = "false";
				var _defaults:String = "None"
				//trace(_parameters);
				if(_parameters == "0"){
					_paramDescriptions = "0";
					_hasDatabase = splitArray[4];
				   }
				if(_parameters != "0"){
					_defaults = checkNumberNewLine(splitArray[3]);
					_paramDescriptions = splitArray[4];
					_hasDatabase = splitArray[6]
				}
				
				//trace(_humanName+":"+_parameters+":"+_mainParameter);
				//var _paramDescriptions:String = checkStringNewLine(splitArray[4]);
				//var _defaults:String = checkNumberNewLine(splitArray[5]);
				//trace(_defaults.split(':') + "<--Defaults")
				//var humanName = splitArray[0].split(" ").join("");
				finalArray.push({HumanName: _humanName, DataName: _dataName, description: _descriptions, parameters: _parameters, paramDescriptions: _paramDescriptions.split(':'), defaults: _defaults.split(':'), MainParameter: _mainParameter, database: _hasDatabase});
				//trace(finalArray[i].HumanName + "<HUMAN NAME>|" + finalArray[i].DataName + "<DATA NAME>|" + finalArray[i].description + "<DESCRIPTION>|" + finalArray[i].parameters + "<PARAMETERS>|" + finalArray[i].paramDescriptions + "<PARAMDESCR>|" + finalArray[i].defaults + "<DEFAULT VALUE>|" + finalArray[i].database + "<DATABASE>@#");				
			}

			//trace("***************************************** DATA AFTER PARSING ************************************");
			return finalArray;
		}
		function createMathOpsDictionary(stringData:String):Array
		{
			/*trace("***************************************** DATA BEFORE ************************************");
			trace(stringData);*/
			stringData = this.trimWhitespace(stringData);
			var finalArray:Array = new Array();
			var dataArray:Array = stringData.split("\n");
			dataArray.sort(Array.CASEINSENSITIVE);
			
			for (var i:int = 0; i < dataArray.length; i++)
			{
				var splitArray:Array = dataArray[i].split('","');			
				var _humanName:String = checkStringNewLine(splitArray[0]);
				var _dataName:String  = checkStringNewLine(splitArray[1]);
				var _descriptions:String = checkStringNewLine(splitArray[2]);
				var _parameters:String = checkStringNewLine(splitArray[3]);
				var _paramDescriptions:String = checkStringNewLine(splitArray[4]);
				var _defaults:String = checkNumberNewLine(splitArray[5]);
				var _mainParameter:String = "-1";
				
				if(_parameters.indexOf(':') > -1){
					_mainParameter = _parameters.substr(_parameters.indexOf(":") + 1 , _parameters.length)
				   	_parameters = _parameters.substring(0, _parameters.indexOf(":"));
					
				   }
								
				finalArray.push({HumanName: _humanName, DataName: _dataName, description: _descriptions, parameters: _parameters, paramDescriptions: _paramDescriptions.split(':'), defaults: _defaults.split(':'), MainParameter: _mainParameter, database: "false1"});
				//trace(finalArray[i].HumanName + "<HUMAN NAME>|" + finalArray[i].DataName + "<DATA NAME>|" + finalArray[i].description + "<DESCRIPTION>|" + finalArray[i].parameters + "<PARAMETERS>|" + finalArray[i].paramDescriptions + "<PARAMDESCR>|" + finalArray[i].defaults + "<DEFAULT VALUE>|" + finalArray[i].MainParameter + "<LEAD PARAMETER>@#");				
				//trace(_paramDescriptions);
			}

			//trace("***************************************** DATA AFTER ************************************");
			return finalArray;
		}
		
		function checkNumberNewLine(value:String):String{
			var defaultString = value;
			if(value)
			{
				
				var rex:RegExp = /[\s\r\n]*/gim;
				defaultString = defaultString.replace(rex,'');
				
			}
			if(defaultString == null){
				defaultString = "0";
			}
			
				return defaultString;
		}

		function checkStringNewLine(value:String):String{
			var returnString = "";
			if(value){
			returnString = value.split("  ").join("");
			returnString = returnString.split("\n").join("");
			returnString = trimWhitespace(returnString);
			}
			return returnString
		}
		function removeEmpties(arr:Array):Array
		{
			var temp:Array = new Array();
			for (var idx:Number = 0; idx < arr.length; idx++)
			{
				if (arr[idx] != "No Value")
				{
					temp.push(arr[idx]);
				}
			}
			return temp;
		}
		function noEmpty(item:*, index:int, array:Array):Boolean
		{
			return item != "";
		}

		function checkNull(originalstring:String):String
		{
			if (originalstring)
			{
				return (trimWhitespace(originalstring));
			}
			else
			{
				return "No Value";
			}
		}
		function trimWhitespace($string:String):String
		{
			if ($string == null)
			{
				return "";
			}
			return $string.replace(/^\s+|\s+$/g, "");
		}
	}
}