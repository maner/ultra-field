
using Toybox.System;
using Toybox.Graphics;

class UltraField{
    enum {
        STOPPED=0,
        PAUSED,
        RUNNING
    }
    
    enum {
    	PREPARE,//0
        DEFAULT_MODE, //1
        APPROACHING,  //2
        AFTER_LAP, //3
        COMPLETED, //4
        IN_CP, //5
        NO_LAP_SUPPORT
    }
    var mLapNumber = 0;
    var mTimerState = STOPPED;
   
   	var totalDist=0;
	var lastD=0;
	var lastT=0;
	var lastTLap=-10000;
	var dist=null;
	var msg=null;
	var maxSpeed=0;
	var triggerSecs=20000;
	var lastTimer;
	var debug=false;
	var deltaTrg=500;
	var counter=0;
	
	var dYNumber=67;
	var dYText=20;
	
	
	var mode=DEFAULT_MODE;
	var approachDist=0;
	var cpDistance=0;
	var nextCP;

	var splitter;
	
    
    function init(info){
        var loadPrev=info.elapsedDistance!=null;
        if(loadPrev){
        	lastD=info.elapsedDistance;
			lastT=info.timerTime;
		}
		loadSettings(loadPrev);
		// switch(info.sport){
		// 	case Activity.SPORT_RUNNING:
		// 	case Activity.SPORT_HIKING:
		// 	case Activity.SPORT_WALKING:
		// 		break;
		// 	default:
		// 		maxSpeed=99;
		// }
        prepareCP();
        mode=PREPARE;
     }

    function onTimerStart(){
        mTimerState = RUNNING;
        if(mode==PREPARE){
        	mode=DEFAULT_MODE;
            msg=null;
        }
    }
    
    function onTimerStop(){
        mTimerState = STOPPED;
    }

    function onTimerPause(){
        mTimerState = PAUSED;
    }

    function onTimerResume(){
        onTimerStart();
    }
    
    function getFloatPropValue(key){
      var value=Application.Properties.getValue(key);
      if(value==null){ return 0.0;}
      if ( value instanceof Toybox.Lang.String ){
        	return value.toFloat();
      }
      return value;
    }


	function prepareCP(){
	    nextCP=splitter.getCP();

        if(nextCP!=null){
        	cpDistance=nextCP.dist;
        	approachDist=cpDistance-deltaTrg;
        } else {
        	mode=COMPLETED;
        }
	}

    function onTimerLap(){
		var delta=lastTimer-lastTLap;
        log("LAP "+mLapNumber + " After " + delta);
        lastTLap=lastTimer;
        mLapNumber++;
        switch(mode){
        	case DEFAULT_MODE:
        		mode=AFTER_LAP;
        		break;
        	case AFTER_LAP:
        	case APPROACHING:
			    mode=IN_CP;
        		doTrigger();
        		break;
        }
    }
    
    function doTrigger(){
		if(nextCP==null){
			return;
		}
         totalDist=nextCP.dist;
		 Application.Properties.setValue("lastDist",totalDist);
         msg=(totalDist/1000.0).format("%2.2f")+"\n"+nextCP.label;
         
		 log("Trigger: "+msg);
    	 lastTLap=lastTLap;
    	 dist=null;
		 prepareCP();
		 Application.Properties.setValue("lastIndex",splitter.index);
    }

    function compute(info) {
		lastTimer=info.timerTime;
		if(info.elapsedDistance==null){
			return;
		}
		var dd=info.elapsedDistance - lastD;
		var dt=info.timerTime - lastT;
		if(dd<25 || dt==0){
            //log("SKIP delta:"+ dd);
			return;
		}
		var speed=dd/dt*3600.0 ;
		if(speed<=maxSpeed){
			totalDist+=dd;
			dist=null;
			Application.Properties.setValue("lastDist",totalDist);
		} else {
            //log("SKIP speed:"+ speed);
        }
		lastD=info.elapsedDistance;
		lastT=info.timerTime;
		var deltaToLap=lastTimer-lastTLap;
		
        switch(mode){
        	case DEFAULT_MODE:
        		if(totalDist>approachDist){
        			mode=APPROACHING;
        		}
        		break;
        	case AFTER_LAP:
        		if(deltaToLap>triggerSecs){
        			mode=DEFAULT_MODE;
        		}
        		break;
        	case IN_CP:
        		if(deltaToLap>5000){
        			mode=DEFAULT_MODE;
        		}
        		break;
        }
    }

	function loadSettings(loadPrev){
		log("Free mem : " +System.getSystemStats().freeMemory);
    	maxSpeed = Application.Storage.getValue("maxSpeed");
		if(maxSpeed==null) {
        	maxSpeed=20;
        	Application.Properties.setValue("maxSpeed",maxSpeed);
        }
        deltaTrg=getFloatPropValue("deltaTrigger");
        deltaTrg=deltaTrg*1000;
        totalDist=0;
        var lastIndex=0;
     	var jsonRace=null;
     	var race = Application.Properties.getValue("race");
    	log("RACE: , " + race);
		switch(race){
    		case 0: 
    			jsonRace= Application.Properties.getValue("splits");
    			break;
    		case 1:
    			jsonRace =WatchUi.loadResource(Rez.JsonData.race1); 
    			break;
    		case 2:
    			jsonRace =WatchUi.loadResource(Rez.JsonData.race2); 
    			break;
			case 3:
    			jsonRace =WatchUi.loadResource(Rez.JsonData.race3); 
    			break;
    		case 4:
    			jsonRace =WatchUi.loadResource(Rez.JsonData.race4); 
    			break;
    		case 5:
    			jsonRace =WatchUi.loadResource(Rez.JsonData.race5); 
    			break;
			case 6:
    			jsonRace =WatchUi.loadResource(Rez.JsonData.race6); 
    			break;
	   	}
		splitter=new Splitter(jsonRace);
		msg=splitter.getInfo();
		if(loadPrev){
        	var totalDistP=Application.Properties.getValue("lastDist");
        	if(totalDistP!=null){
     			totalDist=totalDistP.toFloat();
     		}
     		log("totalDist:" +totalDist+ " lastIndex:"+ lastIndex);
			var lastIndexP=Application.Properties.getValue("lastIndex");
			if(lastIndexP!=null){
				lastIndex=lastIndexP.toFloat();
			}
			for( var i=1;i<lastIndex;i++){
				prepareCP();
			}
     	}
     	dist = (totalDist/1000.0).format("%2.1f");
	}
    
    function log(s){
      System.println(s);
    }
    
}


