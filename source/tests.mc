using Toybox.Test;
using Toybox.WatchUi;
using Toybox.System;

// //(:test)
// function splitNumber(logger)  {
//   var distToNext=12999.887.toNumber();
//   var p1=distToNext /1000;
//   var p2=distToNext % 1000;
//   logger.debug(p1);
//   logger.debug(p2);
//   return (p1 == 12 ) && p2==999;
// }

// //(:test)
// function split(logger)  {

//   var s="1234567|12345|123456789";
//   var idx=s.find("|");
//   var s1=s.substring(0,idx);
//   s=s.substring(idx+1, s.length());
//   logger.debug(s1);
//   logger.debug(s);
  
//   idx=s.find("|");
//   var s2=s.substring(0,idx);
//   s=s.substring(idx+1, s.length());
//   logger.debug(s2);

//   idx=s.find("|");
//   logger.debug(idx== null);
//   var s3=s;
//   return s1.equals("1234567") && s2.equals("12345") && s3.equals("123456789") ;
// }

//(:test)
function parseTDS(logger)  {
  logger.debug("mem:"+ System.getSystemStats().freeMemory);
  var c=new Check(logger);
  logger.debug("Starting");
  var s="V01;UTMB TDS;2022-08-24;123|0;Courmayeur;1220;00;|680;Checrouit;1956;76749;L|1530;Combal;1970;588560;F|3560;P.S.Bernard;2188;1149937;F|4740;Seez;891;191299;L|5030;B.S.Maurice;813;991;F|5600;F.Platte;1992;11553;|6659;Roselend;1967;779783;F|7459;Gittaz;1665;382691;L|9170;Beaufort;741;9951918;B|9840;Hauteluce;1190;538132;F|11380;Col Joly;1989;1353512;F|12280;Contamines;1170;34856;F|13390;Bellevue;1801;1270643;|13860;Houches;1010;0772;F|14630;Chamonix;1035;138127;B";
  var sm=new Splitter(s);
  var info=sm.getInfo();
  c.assert(info.name, info.name.equals("UTMB TDS"));
  var cp=sm.getCP();
  while(cp!=null){
    logger.debug("CP: "+cp.label);
    cp=sm.getCP();
  }
  logger.debug("mem:"+ System.getSystemStats().freeMemory);
  return c.res();
}



(:test)
function buildSplit(logger)  {
  var c=new Check(logger);

  var rb=new RaceBuilder();
  rb.init("V01","RACE NAME","20230307","ua");
  rb.add(344,"MARTIN",1001,900,50,"w");
  rb.add(401,"PENNELLO",1060,40,5,"wf");
  rb.add(1344,"TURCHINO",532,150,550,"wf!1200");

  var s=rb.toString();
  c.assert(s, true);

  var sm=new Splitter(s);
  var info=sm.getInfo();
  c.assert(info.name, info.name.equals("RACE NAME"));
  c.assert(info.date, info.date.equals("20230307"));
  c.assert(info.location, info.location.equals("ua"));

  var cp=sm.getCP();
  c.assert(cp.dist, cp.dist.equals(3440));
  c.assert(cp._dist1, cp._dist1.equals("3"));
  c.assert(cp._dist2, cp._dist2.equals("44"));
  c.assert(cp.label, cp.label.equals("MARTIN"));
  c.assert(cp.ele, cp.ele.equals("1001"));
  c.assert(cp.dPlus, cp.dPlus.equals("900"));
  c.assert(cp.dMinus, cp.dMinus.equals("50"));
  c.assert(cp.flags, cp.flags.equals("w"));
  var icons=cp.getIcons();
  c.assert("icons size:"+icons.size(), icons.size()==1);
  //c.assert(icons[0].toString(), icons[0].toString().equals("Bitmap 24 x 24"));

  cp=sm.getCP();
  c.assert(cp.dist, cp.dist.equals(4010));
  c.assert("dist2:"+cp._dist2, cp._dist2.equals("01"));
  c.assert(cp.label, cp.label.equals("PENNELLO"));
  c.assert(cp.ele, cp.ele.equals("1060"));
  c.assert(cp.dPlus, cp.dPlus.equals("40"));
  c.assert(cp.dMinus, cp.dMinus.equals("5"));

  cp=sm.getCP();
  c.assert(cp.label, cp.label.equals("TURCHINO"));
  c.assert(cp.dMinus, cp.dMinus.equals("550"));
  c.assert(cp.flags, cp.flags.equals("wf"));
  c.assert(cp.barrierHH, cp.barrierHH.equals("12"));
  c.assert(cp.barrierMM, cp.barrierMM.equals("00"));

  cp=sm.getCP();
  c.assert("fine", cp == null);
  return c.res();
}


//(:test)
function splitString(logger)  {
  var c=new Check(logger);
  var strSpl=new StringSplitter();
  var res=strSpl.splitString("hello world from a long long location",180, Toybox.Graphics.FONT_SYSTEM_TINY);
  c.assert(res, res);
  return c.res();
}

//(:test)
function upgrade(logger)  {
  var c=new Check(logger);
  logger.debug("Starting");
  var s="V03;UTMB TDS;2022-08-24;123|0;Courmayeur;1220;00;|680;Checrouit;1956;76749;L|1530;Combal;1970;588560;F|3560;P.S.Bernard;2188;1149937;F|4740;Seez;891;191299;L|5030;B.S.Maurice;813;991;F|5600;F.Platte;1992;11553;|6659;Roselend;1967;779783;F|7459;Gittaz;1665;382691;L|9170;Beaufort;741;9951918;B|9840;Hauteluce;1190;538132;F|11380;Col Joly;1989;1353512;F|12280;Contamines;1170;34856;F|13390;Bellevue;1801;1270643;|13860;Houches;1010;0772;F|14630;Chamonix;1035;138127;B";
  var sm=new Splitter(s);
  var info=sm.getInfo();
  c.assert(info.name, info.name.equals("Please upgrade"));
  c.assert(info.location, info.location.equals("Invalid version: V03"));
  return c.res();
}






// //----
// class MyData {
//       optional string text = 1;
//       repeated uint32 nums = 2 [packed=true];
//  }


// (:test)
// function testChatGpt(){

//   var myDataSequence=new [10];
//   for (var i=0;i<10;i++){
//     var m=new MyData();
//     m.text="hello";
//     m.nums=123;
//     myDataSequence[i]=m;
//   }

//     // Serialize a sequence of MyData objects to a byte array
//     ByteArrayOutputStream output = new ByteArrayOutputStream();
//     for each (MyData data in myDataSequence) {
//       data.writeTo(output);
//     }
//     byte[] serializedData = output.toByteArray();

//     // Deserialize MyData objects from a byte array
//     StringIterator input = new StringIterator(serializedData);
//     while (input.hasMoreData()) {
//       MyData data = new MyData();
//       data.mergeFrom(input);
//       // do something with the deserialized object
//     }
// }

// //----

class Check {
  var _l;
  var b =true;
  public function initialize(logger){
    _l=logger;
  }
  public function assert(val, cond){
    if(cond == false) {
      _l.debug(" >>> Failure! : "+val+ " <<<<<<");
      b=false;
      System.exit();
      
    } else {
      _l.debug(" OK : "+val);

    }
  }

  public function res(){
    return b;
  }
}


