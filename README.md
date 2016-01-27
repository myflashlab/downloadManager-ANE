# Download Manager ANE V3.9.2 (Android+iOS)
whether you're building an Air game or an app, there are many situations where you need to download big data files into your app. using the classic APIs in AS3 won't help you because they are not resumable supported and they use only one channel to download the files. The best efficient solution to this problem is to use a fully automatic download manager native extension which lets you download big files as fast as possible by downloading the files in chunks. on top of that, you need the downloads to be resumable so you can be sure that your download won't fail on any condition. Just download our cool download manager extension for Android and focus on your app/game logic without worrying about how you should handle your data files.

# Demo .apk
you may like to see the ANE in action? [Download demo .apk](https://github.com/myflashlab/downloadManager-ANE/tree/master/FD/dist)

**NOTICE**: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.
[Download the ANE](https://github.com/myflashlab/downloadManager-ANE/tree/master/FD/lib)

# Air Usage
For both Android and iOS
```actionscript
import com.myflashlab.air.extensions.dm.DM;
import com.myflashlab.air.extensions.dm.DMEvent;

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

_ex.startDownload("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", "dm", "Bully_Scholarship_Edition_Trailer.mp4");
//_ex.stopDownload();
//_ex.cancelDownload();
//_ex.deleteDownloaded();
```

# Air .xml manifest
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

<activity android:name="com.doitflash.downloadManager.MyActivity" />
```

# Air Usage
For Android only, you can also use the built in Android Download manager if you wish (this is not supported on iOS though) The good thing about this approach on Android is that you can close your app as soon as the download begins.
```actionscript
import com.myflashlab.air.extensions.dm.DM;
import com.myflashlab.air.extensions.dm.DMEvent;

var _ex:DM = new DM();

// add a listener to know when the download is finished. if you are closing the app while the download is in progress, obvoiusly you won't receive this event but the download task will continue.
_ex.addEventListener(DMEvent.NATIVE_LIB_DOWNLOAD_JOB_FINISHED, onAndroidDownloadManagerJobFinished);

var id:int = _ex.nativeAndroidDM_start("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4", "/dm", "", "DM ANE!", "Download Manager Air Native Extension", true);

// you can check if there are any download jobs are in progress or not.
var arr:Array = _ex.nativeAndroidDM_getOnGoingJobs(); // this array has download tasks as objects indexed which you can loop through and get more information about each ongoing download task

// you can cancel a download by its URL
//_ex.cancelByUrl("http://myflashlabs.com/showcase/Bully_Scholarship_Edition_Trailer.mp4");

function onAndroidDownloadManagerJobFinished(e:DMEvent):void
{
	for (var name:String in e.param) 
	{
		trace(name + " = " + e.param[name])
	}
}
```

# Air .xml manifest
If you are using the Android built in download library only as described above, you will need to set the following manifest receiver.
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

# Requirements
* Android SDK 10 or higher
* iOS 6.1 or higher

# Commercial Version
http://www.myflashlabs.com/product/download-manager-ane-adobe-air-native-extension/

![Download Manager ANE](http://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-download-manager-595x738.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*Jan 20, 2016 - V3.9.2*
* bypassing xCode 7.2 bug causing iOS conflict when compiling with AirSDK 20 without waiting on Adobe or Apple to fix the problem. This is a must have upgrade for your app to make sure you can compile multiple ANEs in your project with AirSDK 20 or greater. https://forums.adobe.com/thread/2055508 https://forums.adobe.com/message/8294948


*Dec 20, 2015 - V3.9.1*
* minor bug fixes


*Nov 02, 2015 - V3.9*
* doitflash devs merged into MyFLashLab Team.


*May 17, 2015 - V3.0*
* added support for Android built-in download manager library.


*Jan 27, 2015 - V2.1*
* added support for iOS 64-bit


*Nov 05, 2014 - V2.0*
* total rebuild and the class names are changed with the new structure to add support for iOS
* queue options are deprecated as they seem not popular!
* added support for iPhone-ARM


*Sep 23, 2014 - V1.1*
* fixed connection timeout problem in watch dog class
* added support for Android-x86 devices


*May 06, 2014 - V1.0*
* beginning of the journey!