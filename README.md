# Download Manager ANE V3.0 (Android+iOS)
whether you're building an Air game or an app, there are many situations where you need to download big data files into your app. using the classic APIs in AS3 won't help you because they are not resumable supported and they use only one channel to download the files. The best efficient solution to this problem is to use a fully automatic download manager native extension which lets you download big files as fast as possible by downloading the files in chunks. on top of that, you need the downloads to be resumable so you can be sure that your download won't fail on any condition. Just download our cool download manager extension for Android and focus on your app/game logic without worrying about how you should handle your data files.

checkout here for the commercial version: http://myappsnippet.com/download-manager-air-native-extension/

![Download Manager ANE](http://myappsnippet.com/wp-content/uploads/2014/12/download-manager-adobe-air-extension_preview.jpg)

you may like to see the ANE in action? check this out: https://github.com/myflashlab/downloadManager-ANE/tree/master/FD/dist

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

# USAGE (Android + iOS)
```actionscript
import com.doitflash.air.extensions.dm.DM;
import com.doitflash.air.extensions.dm.DMEvent;

var _ex:DM = new DM();
_ex.addEventListener(DMEvent.ERROR, onError);
_ex.addEventListener(DMEvent.PROGRESS, onProgress);
_ex.addEventListener(DMEvent.COMPLETE, onComplete);

function onError(e:DMEvent):void
{
    trace(e.param.msg);
}

function onComplete(e:DMEvent):void
{
    trace("download completed");
}

function onProgress(e:DMEvent):void
{
    trace(e.param.perc);
}

_ex.startDownload("http://myflashlab.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", "dm", "Bully_Scholarship_Edition_Trailer.mp4");
//_ex.stopDownload();
//_ex.cancelDownload();
//_ex.deleteDownloaded();
```
you need the following permissions and activities:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<activity android:name="com.doitflash.downloadManager.MyActivity" />
```

# USAGE (Android only)
On Android, you can also use the built in Android Download manager if you wish (this is not supported on iOS though) The good thing about this approach on Android is that you can close your app as soon as the download begins.
```actionscript
import com.doitflash.air.extensions.dm.DM;
import com.doitflash.air.extensions.dm.DMEvent;

var _ex:DM = new DM();

// add a listener to know when the download is finished. if you are closing the app while the download is in progress, obvoiusly you won't receive this event but the download task will continue.
_ex.addEventListener(DMEvent.NATIVE_LIB_DOWNLOAD_JOB_FINISHED, onAndroidDownloadManagerJobFinished);

var id:int = _ex.nativeAndroidDM_start("http://myflashlab.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", "/dm", "", "DM ANE!", "Download Manager Air Native Extension", true);

// you can check if there are any download jobs are in progress or not.
var arr:Array = _ex.nativeAndroidDM_getOnGoingJobs(); // this array has download tasks as objects indexed which you can loop through and get more information about each ongoing download task

// you can cancel a download by its URL
//_ex.cancelByUrl("http://myflashlab.com/showcase/Bully_Scholarship_Edition_Trailer.mp4");

function onAndroidDownloadManagerJobFinished(e:DMEvent):void
{
	for (var name:String in e.param) 
	{
		trace(name + " = " + e.param[name])
	}
}
```
you need the following permissions and servicies:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<receiver android:name="com.doitflash.downloadManager.android.Receiver" android:enabled="true" >
	<intent-filter>
		<action android:name="android.intent.action.DOWNLOAD_NOTIFICATION_CLICKED" />
		<action android:name="android.intent.action.DOWNLOAD_COMPLETE" />
	</intent-filter>
</receiver>
```