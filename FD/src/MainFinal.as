package 
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.StatusEvent;
	import flash.text.AntiAliasType;
	import flash.text.AutoCapitalize;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	
	import com.myflashlab.air.extensions.dm.DM;
	import com.myflashlab.air.extensions.dm.DMEvent;
	
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	
	import com.luaye.console.C;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 2/9/2013 12:06 PM
	 */
	public class MainFinal extends Sprite 
	{
		private var _ex:DM;
		
		private const BTN_WIDTH:Number = 150;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		private var _currDownloadId:int;
		
		public function MainFinal():void 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 100;
			C.width = 500;
			C.height = 250;
			C.strongRef = true;
			C.visible = true;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>DownloadManager for adobe air (Android + iOS)</b> V"+DM.VERSION+"</font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			init();
			onResize();
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
            {
				e.preventDefault();
				NativeApplication.nativeApplication.exit();
            }
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 270 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
		}
		
		private function init():void
		{
			// initialize the extension
			_ex = new DM();
			
			// use these listeners if you are downloading on Android and iOS
			_ex.addEventListener(DMEvent.ERROR, onError);
			_ex.addEventListener(DMEvent.PROGRESS, onProgress);
			_ex.addEventListener(DMEvent.COMPLETE, onComplete);
			
			// use this listeners if you are downloading using Android Download Manager
			_ex.addEventListener(DMEvent.NATIVE_LIB_DOWNLOAD_JOB_FINISHED, onAndroidDownloadManagerJobFinished);
			
			// -------------------------------------------------------------------------------------------------------------------------------------
			// ---------------------------------------- these methods below can be used on iOS and Android -----------------------------------------
			// -------------------------------------------------------------------------------------------------------------------------------------
			
			var btn0:MySprite = createBtn("Start (iOS+Android)");
			btn0.addEventListener(MouseEvent.CLICK, startDownload);
			_list.add(btn0);
			
			function startDownload(e:MouseEvent):void
			{
				C.log("startDownload >> Please wait for the download to start...", _ex.startDownload("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", "dm", "Bully_Scholarship_Edition_Trailer.mp4"));
			}
			
			// ----------------------
			
			var btn3:MySprite = createBtn("stop (iOS+Android)");
			btn3.addEventListener(MouseEvent.CLICK, stopDownload);
			_list.add(btn3);
			
			function stopDownload(e:MouseEvent):void
			{
				C.log("stopDownload >> ", _ex.stopDownload());
			}
			
			// ----------------------
			
			var btn4:MySprite = createBtn("cancel (iOS+Android)");
			btn4.addEventListener(MouseEvent.CLICK, cancelDownload);
			_list.add(btn4);
			
			function cancelDownload(e:MouseEvent):void
			{
				C.log("cancelDownload >> ", _ex.cancelDownload());
			}
			
			// ----------------------
			
			var btn5:MySprite = createBtn("delete (iOS+Android)");
			btn5.addEventListener(MouseEvent.CLICK, deleteDownload);
			_list.add(btn5);
			
			function deleteDownload(e:MouseEvent):void
			{
				C.log("deleteDownloaded >> ", _ex.deleteDownloaded());
			}
			
			// -------------------------------------------------------------------------------------------------------------------------------------
			// ---------------------------------------- these methods below can be used on Android only. -------------------------------------------
			// -------------------------------------------------------------------------------------------------------------------------------------
			
			var btn01:MySprite = createBtn("start (Android)", 0x990000);
			btn01.addEventListener(MouseEvent.CLICK, startAndroid);
			_list.add(btn01);
			
			function startAndroid(e:MouseEvent):void
			{
				var id:int = _ex.nativeAndroidDM_start("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", "/dm", "", "DM ANE!", "Download Manager Air Native Extension", true);
				C.log("download id = " + id + " - check out the download progress in your notification!");
			}
			
			// ----------------------
			
			var btn02:MySprite = createBtn("get onGoing (Android)", 0x990000);
			btn02.addEventListener(MouseEvent.CLICK, getOngoingDownloads);
			_list.add(btn02);
			
			function getOngoingDownloads(e:MouseEvent):void
			{
				var arr:Array = _ex.nativeAndroidDM_getOnGoingJobs();
				C.log("number of ongoing jobs = " + arr.length);
				trace("arr includes objects with more information about each ongoing download job");
			}
			
			var btn03:MySprite = createBtn("cancel by URL (Android)", 0x990000);
			btn03.addEventListener(MouseEvent.CLICK, cancelByUrl);
			_list.add(btn03);
			
			function cancelByUrl(e:MouseEvent):void
			{
				_ex.cancelByUrl("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4");
			}
			
		}
		
		// on Android and iOS
		private function onError(e:DMEvent):void
		{
			C.log(e.param.msg);
		}
		
		// on Android and iOS
		private function onComplete(e:DMEvent):void
		{
			C.log("download completed");
		}
		
		// on Android and iOS
		private function onProgress(e:DMEvent):void
		{
			C.log(e.param.perc);
		}
		
		// on Android ONLY
		private function onAndroidDownloadManagerJobFinished(e:DMEvent):void
		{
			for (var name:String in e.param) 
			{
				C.log(name + " = " + e.param[name])
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String, $color:uint = 0x666666):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = 0xDFE4FF;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xFFDB48;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				sp.bgAlpha = 1;
				sp.bgColor = 0xDFE4FF;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, $color, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}
	
}