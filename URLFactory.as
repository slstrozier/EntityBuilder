package 
{
	//import ST_Files.CustomEvent
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import flash.events.*;
	//import flash.sampler.Sample;

	public class URLFactory extends MovieClip
	{

		public var loader:URLLoader;
		public var textData:Object;
		public var dataArray:Array;
		public var url:String;
		private var DISPATCHSTRING:String;

		/**
		  Constructor. At creation, sets loader and gives it an eventListener
		@param url The address for the url request
		  */
		public function URLFactory(url:String)
		{
			this.url = url;
			var rand:String = "&"+(Math.random()*100000000).toString();
					loader = new URLLoader();
					loader.addEventListener(Event.COMPLETE, HandleComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, loaderMissing);
					loader.load(new URLRequest(url + rand));
		}
		function loaderMissing(event:IOErrorEvent):void
		{
			trace("ERROR");
			trace(event.toString())
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, HandleComplete);
			loader.load(new URLRequest("C:/Users/Programmer2/Desktop/Adobe Photoshop CS5.1/FINALSTRATEGY/TestFiles/dbs_list.txt"));
		}
		/**
		  EventListner. Sets the textData to the data of the URLLoader and calls SetData() to store
		the date into the variable
		  */
		function HandleComplete(e:Event):void
		{
			textData = loader.data;
			trace(textData);
			dispatchEvent(new CustomEvent(CustomEvent.QUERYREADY, textData));
			//dispatchEvent(new Event("dataReadyE"));
		}

		

	}
}