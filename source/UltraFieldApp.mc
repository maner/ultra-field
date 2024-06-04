using Toybox.Application;
using Toybox.System;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class UltraFieldApp extends Application.AppBase {

	var view;

    function initialize() {
    	try{
        	AppBase.initialize();
        }catch( ex ) {
        	ex.printStackTrace();
        }
    }

    public function getInitialView() as [Views] or [Views, InputDelegates]  {
        var view = new UltraFieldView();
        return [view];
    }


    // function getInitialView() {
    // 	try{
    // 		view=new UltraFieldView();
    //     	return [ view ];
    //     }catch( ex ) {
    //     	ex.printStackTrace();
    //     	return null;
    //     }
    // }
    
    function onSettingsChanged(){
    	view.loadSettings(true);
    }

}
