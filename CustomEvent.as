package 
{
	import flash.events.Event;
	public class CustomEvent extends Event
	{
		public static const QUERYREADY:String = "QueryReady";
		public static const DATEREADY:String = "DateReady";//———– Define your custom Event string constant
		public var data:*;//————- Define a data variable of * type to hold any kind of data object

		//———— Constructor
		public function CustomEvent(type:String, data:*)
		{
			this.data = data;
			super(type);
		}

	}

}