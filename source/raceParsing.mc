using Toybox.System;
using Toybox.Graphics;

class RaceBuilder{
	hidden var s;
	const cpSep=";";
	const fldSep="|";

	function init(ver,name,date,dist){
    	s=ver+cpSep+name+cpSep+date+cpSep+dist;
    }

	function add (dist, label, ele, dplus, dminus,flags){
		s=s+fldSep+ dist+cpSep+ label +cpSep+ ele +cpSep+ dplus +cpSep+ dminus +cpSep+flags;
	}

	function toString(){
		return s;
	}
}


class Splitter {
	var s ;
	var index=0;
	var totDp=0, totDm=0;
	public function initialize(initS){
      s=initS;
    }

	public function getInfo(){
		var info=new Info();
		var vrs=s.substring(0,3);
		//System.println("Version:"+vrs+".");

		if (!vrs.equals("V02")){
			info.date="";
			info.name="Please upgrade";
			info.location="Invalid version: "+vrs;
			s="";
			return info;
		}
		var idx=s.find("|");
  		var s1=s.substring(4,idx);
  		s=s.substring(idx+1, s.length());


		idx=s1.find(";");
		
  		info.name=s1.substring(0,idx);
		s1=s1.substring(idx+1, s1.length());
		idx=s1.find(";");
  		info.date=s1.substring(0, idx);
		info.location=s1.substring(idx+1, s1.length());

		return info;
	}

	public function getCP(){
		var cp=_getCP();
		if (cp==null) {return null;} 
		if (cp.flags.length()>0 || Application.Properties.getValue("includeWP")) {
			cp.dPlus+=totDp;
			cp.dMinus+=totDm;
			totDp=0;
			totDm=0;
			return cp;
		}
		totDp+=cp.dPlus;
		totDm+=cp.dMinus;
		return getCP();
	}


	public function _getCP(){
		if(s.length()==0){
			return null;
		}
		var idx=s.find("|");
		if(idx==null) {idx=s.length();}
  		var s1=s.substring(0,idx);
  		s=s.substring(idx+1, s.length());
		idx=s1.find(";");
		var cp=new CheckPoint();
		var distCM=s1.substring(0,idx).toNumber();
  		cp.dist=distCM*10;
		cp._dist1=(distCM / 100).toString();
		cp._dist2=(distCM % 100).format("%02d");
		s1=s1.substring(idx+1, s1.length());
		idx=s1.find(";");
  		cp.label=s1.substring(0, idx);
		s1=s1.substring(idx+1, s1.length());
		idx=s1.find(";");
		cp.ele=s1.substring(0, idx);
		s1=s1.substring(idx+1, s1.length());
		idx=s1.find(";");
		cp.dPlus=s1.substring(0, idx).toNumber();
		s1=s1.substring(idx+1, s1.length());
		idx=s1.find(";");
		cp.flags="";
		if(idx==null) {return cp;}
		cp.dMinus=s1.substring(0, idx).toNumber();
		if(idx!=null){
			cp.flags=s1.substring(idx+1, s1.length());
			var pBar=cp.flags.find("!");
			if (pBar){
				cp.barrierHH=cp.flags.substring(pBar+1, pBar+3);
				cp.barrierMM=cp.flags.substring(pBar+3, pBar+6);
				cp.flags=cp.flags.substring(0, pBar);
			}
		}
		index=index+1;
		return cp;
	}
}

class StringSplitter{

	public function splitString(text, width, font){
		return Graphics.fitTextToArea(text, font, width, width, true);
	}

}

class Info {
	var name;
	var date;
	var location;
	var nameML;
	var locationML;
}

//icons 
enum {
	DRINK,
	HOTDRINK,
	HOTFOOD,
	BAG,
	AID,
	BUS
}
