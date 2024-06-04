
using Toybox.WatchUi;
using Toybox.Activity;
using Toybox.Graphics;
using Toybox.System;
import Toybox.WatchUi;

class UltraFieldView extends WatchUi.DataField{

	var uf=new UltraField();
	var sizeCache=new SizeCache();
	var fontText=Graphics.FONT_LARGE;
	var fontMsg=Graphics.FONT_LARGE;
	var counter=0;
	var lastBk=-1;
	
	var colors=[Graphics.COLOR_RED, Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK];
  
	function initialize(){
    	DataField.initialize();
  		var info = Activity.getActivityInfo();
  		info.timerTime=0;
  		uf.init(info);
		// lastBk=getBackgroundColor();
		// if (lastBk==Graphics.COLOR_BLACK) {
		// 	 colors[2]=Graphics.COLOR_WHITE;
		// }
	}

	function compute(info) {
		uf.compute(info);
	}

	function onTimerStart(){
        uf.onTimerStart();
    }
    
    function onTimerStop(){
        uf.onTimerStop();
    }

    function onTimerPause(){
        uf.onTimerPause();
    }

    function onTimerResume(){
        uf.onTimerResume();
    }

	function onTimerLap(){
		uf.onTimerLap();
    }

   function onUpdate(dc){
	    var bkColor=Graphics.COLOR_TRANSPARENT;
		if (lastBk!=getBackgroundColor()) {
			lastBk=getBackgroundColor();
			bkColor=lastBk==Graphics.COLOR_BLACK ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
			colors[2]=bkColor;
			System.println("Change background! bkColor:"+bkColor);
			
		}
	 	sizeCache.init(dc);
        var dataColor=colors[uf.mTimerState];
        dc.setColor(dataColor, bkColor);
        if(uf.dist==null){
        	uf.dist=(uf.totalDist/1000.0).format("%2.2f");
        }
		var distToNext=((uf.totalDist-uf.cpDistance)/1000.0).format("%5.2f");
    	switch(uf.mode){
    		case uf.NO_LAP_SUPPORT:
            	drawText(dc,sizeCache.width50, sizeCache.height50, Graphics.FONT_MEDIUM, uf.msg, false);
      			return;
      		case uf.IN_CP:
				//counter+=1;
    			//if(counter>2){
    			//	counter=0;
    				drawInfo(dc,uf.dist, uf.nextCP, distToNext, uf.msg);
    			//} else {
      			//	drawText(dc,sizeCache.width50, sizeCache.height50, Graphics.FONT_LARGE  , uf.msg, false);
				//}
      			return;
      		case uf.DEFAULT_MODE:
				drawInfo(dc,uf.dist, uf.nextCP, distToNext, null);
      			return;
      		case uf.COMPLETED:
				drawText(dc,sizeCache.width50, sizeCache.height50, Graphics.FONT_NUMBER_THAI_HOT  , uf.dist, false);
				return;
        	case uf.APPROACHING:
        	case uf.AFTER_LAP:
	        	drawInfo(dc,uf.dist, uf.nextCP, distToNext, " LAP IF \n"+(uf.nextCP.dist/1000.0).format("%5.2f"));
	        	var delta=uf.lastTimer-uf.lastTLap;
	        	var lineL=(sizeCache.width*(uf.triggerSecs-delta))/uf.triggerSecs;
	        	dc.drawLine(0, sizeCache.height*0.4, lineL, sizeCache.height*0.4);
	        	dc.drawLine(0, sizeCache.height*0.6, lineL, sizeCache.height*0.6);
	        	return;
	        case uf.PREPARE:
			    if(uf.msg.nameML==null){
					uf.msg.nameML=Graphics.fitTextToArea(uf.msg.name, Graphics.FONT_SYSTEM_SMALL, sizeCache.width, 70, true);
					uf.msg.locationML=Graphics.fitTextToArea(uf.msg.location, Graphics.FONT_SYSTEM_SMALL, sizeCache.width-20, 50, true);
				}
			    dc.drawText(sizeCache.width50, sizeCache.height50-90, Graphics.FONT_SYSTEM_TINY, "UltraField", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	        	dc.drawText(sizeCache.width50, sizeCache.height50-50, Graphics.FONT_LARGE, uf.msg.date, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	        	dc.drawText(sizeCache.width50, sizeCache.height50, Graphics.FONT_SYSTEM_SMALL, uf.msg.nameML, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	        	dc.drawText(sizeCache.width50, sizeCache.height50+50, Graphics.FONT_SYSTEM_SMALL, uf.msg.locationML, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
				return;
	        }
    }


    
    function drawInfo(dc, number1, cp, number2, msg){

// dc.drawLine(0, sizeCache.h0,200, sizeCache.h0);
// dc.drawLine(0, sizeCache.h1,200, sizeCache.h1);
// dc.drawLine(0, sizeCache.h2,200, sizeCache.h2);
// dc.drawLine(0, sizeCache.h4,200, sizeCache.h4);
// dc.drawLine(0, sizeCache.h5,200, sizeCache.h5);

		/** DIST TO NEXT, in fondo */
	    var p=number2.find(".");
  		var p1=number2.substring(0,p);
  		var p2=number2.substring(p,number2.length());
		dc.drawText(sizeCache.width50+20, sizeCache.h5, Graphics.FONT_NUMBER_THAI_HOT , p1, Graphics.TEXT_JUSTIFY_RIGHT |  Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(sizeCache.width50+12, sizeCache.h5+5, Graphics.FONT_NUMBER_MEDIUM , p2, Graphics.TEXT_JUSTIFY_LEFT |  Graphics.TEXT_JUSTIFY_VCENTER);

		//** TOTAL, in alto */
		p=number1.find(".");
  		p1=number1.substring(0,p);
  		p2=number1.substring(p,number2.length());
		System.println("number:"+number1+"___P!:"+p1+"__");
		dc.drawText(sizeCache.width50+20, sizeCache.h1, Graphics.FONT_NUMBER_HOT , p1, Graphics.TEXT_JUSTIFY_RIGHT );
		dc.drawText(sizeCache.width50+20, sizeCache.h1+15, Graphics.FONT_NUMBER_MEDIUM , p2, Graphics.TEXT_JUSTIFY_LEFT );
		dc.drawText(sizeCache.width50, sizeCache.h0, Graphics.FONT_SYSTEM_XTINY, "dist", Graphics.TEXT_JUSTIFY_CENTER);

		/**checkPoint Name */
		dc.drawText(5, sizeCache.height50, fontText, cp.label, Graphics.TEXT_JUSTIFY_LEFT |  Graphics.TEXT_JUSTIFY_VCENTER);
		//*D+, ele, D-*/
		if (cp.dPlus.length()>0){
		  dc.drawText(sizeCache.width50-sizeCache.w0, sizeCache.h4, Graphics.FONT_SYSTEM_TINY , '+'+cp.dPlus, Graphics.TEXT_JUSTIFY_RIGHT |  Graphics.TEXT_JUSTIFY_VCENTER );
		}
		dc.drawText(sizeCache.width50, sizeCache.h4, Graphics.FONT_LARGE , cp.ele+"m", Graphics.TEXT_JUSTIFY_CENTER |  Graphics.TEXT_JUSTIFY_VCENTER );
		if (cp.dMinus.length()>0){
			dc.drawText(sizeCache.width50+sizeCache.w0, sizeCache.h4, Graphics.FONT_SYSTEM_TINY , '-'+cp.dMinus, Graphics.TEXT_JUSTIFY_LEFT |  Graphics.TEXT_JUSTIFY_VCENTER );
		}

    	//drawText(dc,sizeCache.width50, sizeCache.height50+30, fontText, cp.info, true); //ex info
    	if (msg != null){
    		counter+=1;
    		if(counter>2){
    			counter=0;
    			dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
    			drawText(dc,sizeCache.width50, sizeCache.height50, fontMsg, msg, true);
				dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    		}
    	}

		var px=sizeCache.wIc;
		// //* barrier */
		if(cp.barrierHH){
		  dc.drawText(px, sizeCache.h2+10, Graphics.FONT_NUMBER_MILD, cp.barrierHH, Graphics.TEXT_JUSTIFY_RIGHT |  Graphics.TEXT_JUSTIFY_VCENTER);
		  dc.drawText(px, sizeCache.h2+10, Graphics.FONT_SYSTEM_TINY, cp.barrierMM, Graphics.TEXT_JUSTIFY_LEFT |  Graphics.TEXT_JUSTIFY_VCENTER);
		  px=px+40;
		}


		var icons=cp.getIcons();
		for (var i=0;i<icons.size();i++){
			var obj=icons[i];
			if (obj instanceof String){
				dc.drawText(px, sizeCache.h2, Graphics.FONT_LARGE, obj, Graphics.TEXT_JUSTIFY_CENTER);
			} else if (obj has :getHeight) {
				dc.drawBitmap(px, sizeCache.h2, obj);
			} else {
				System.println("? :"+obj.toString());
			}
			px=px+27;
		}


    }

    function drawText(dc, x, y, font, text, border){
		var just=(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
     	dc.drawText(x, y, font, text, just);
     	if(border){
     		var dim=dc.getTextDimensions(text, font);
     		//log("size "+font+"| "+text+ "-->"+dim);
     		dc.drawRectangle(x-dim[0]/2,y-dim[1]/2, dim[0],dim[1]);
     	}
    }

	function loadSettings(loadPrev){
		uf.loadSettings(loadPrev);
	}
   
}

