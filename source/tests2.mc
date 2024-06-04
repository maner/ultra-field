using Toybox.Test;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Activity;
using Toybox.StringUtil;
using Toybox.Application;


(:test)
function ultraTest(logger)  {
  var c=new Check(logger);

  var rb=new RaceBuilder();
  rb.init("V02","RACE NAME","20230307","4219");
  rb.add(344,"MARTIN",1001,900,50,"W");
  rb.add(501,"PENNELLO",1060,40,5,"W");
  rb.add(1344,"TURCHINO",532,150,550,"WF");

  var raceString=rb.toString();
  c.assert(raceString, true);
  Application.Properties.setValue("race",0);
  Application.Properties.setValue("splits", raceString);
  
  // var enc=StringUtil.encodeBase64(raceString);
  // c.assert("Enc: "+enc, true);
  // c.assert("Enc size: "+enc.length()+" + vs "+raceString.length(), true);


  var uf=new UltraField();
  var info=new Activity.Info();
  info.timerTime=0;

  uf.init(info);
  c.assert(uf.msg.name, "RACE NAME".equals(uf.msg.name));
  c.assert(uf.totalDist, uf.totalDist == 0);
  c.assert(uf.mode, uf.mode == UltraField.PREPARE);
  c.assert(uf.nextCP.label, "MARTIN".equals(uf.nextCP.label));
  c.assert("CP dist:" + uf.cpDistance, uf.cpDistance == 3440);
  c.assert("Approach dist:"+uf.approachDist,  uf.approachDist == 3440-500);

  uf.onTimerStart();
  c.assert(uf.mode, uf.mode == UltraField.DEFAULT_MODE);
  info=new Activity.Info();
  info.timerTime=30000; info.elapsedDistance=100.0;  //100m in 30sec
  uf.compute(info);
  c.assert(uf.totalDist, uf.totalDist == 100);
  info.elapsedDistance+=100.0; info.timerTime+=30000;
  uf.compute(info);
  c.assert(uf.totalDist, uf.totalDist == 200);
  System.println("// when approaching");
  info.elapsedDistance=3440-50.0; info.timerTime+=1000000;
  uf.compute(info);
  c.assert(uf.mode, uf.mode == UltraField.APPROACHING);

  System.println("// when lap in approaching, enter cp");
  uf.onTimerLap();
  c.assert(uf.mode, uf.mode == UltraField.IN_CP);
  c.assert("tot dist (3440):"+uf.totalDist,uf.totalDist ==3440);
  c.assert(uf.nextCP.label, "PENNELLO".equals(uf.nextCP.label));
  c.assert("msg:"+uf.msg, " 3.44\nMARTIN".equals(uf.msg));

  System.println("// leaving cp");

  info.elapsedDistance+=50; info.timerTime+=20000;
  uf.compute(info);
  c.assert("mode=def 1 ?:"+uf.mode, uf.mode == UltraField.DEFAULT_MODE);
  c.assert(uf.nextCP.label, "PENNELLO".equals(uf.nextCP.label));
  info.elapsedDistance+=100; info.timerTime+=100000;
  uf.compute(info);
  c.assert("mode:"+uf.mode, uf.mode == UltraField.DEFAULT_MODE);

  System.println("// check lap singolo, ritorna default dopo tot secondi");
  uf.onTimerLap();
  c.assert("mode:"+uf.mode, uf.mode == UltraField.AFTER_LAP);
  info.elapsedDistance+=1000; info.timerTime+=6*60*1000;
  uf.compute(info);
  c.assert(uf.mode, uf.mode == UltraField.DEFAULT_MODE);

 
  System.println("// check lap doppio, ");
  uf.onTimerLap();
  c.assert("mode==appr:"+uf.mode, uf.mode == UltraField.AFTER_LAP);
  info.elapsedDistance+=1; info.timerTime+=60*1000;
  uf.compute(info);
  uf.onTimerLap();
  c.assert("mode==message"+ uf.mode, uf.mode == UltraField.IN_CP);
  
  System.println("// check last CP, complete ");
  info.elapsedDistance+=100; info.timerTime+=20*1000;
  uf.compute(info);
  c.assert(uf.mode, uf.mode == UltraField.DEFAULT_MODE);
  info.elapsedDistance=13440+500.0; info.timerTime+=3600*1000;
  uf.compute(info);
  c.assert(uf.mode, uf.mode == UltraField.APPROACHING);
  System.println("//press lap");
  uf.onTimerLap();
  c.assert("mode==complete :"+ uf.mode, uf.mode == UltraField.COMPLETED);

  return c.res();
}


(:test)
function ultraTest_restart(logger)  {
  var c=new Check(logger);

  var rb=new RaceBuilder();
  rb.init("V02","RACE NAME","20230307","4219");
  rb.add(344,"MARTIN",1001,900,50,"W");
  rb.add(501,"PENNELLO",1060,40,5,"W");
  rb.add(1344,"TURCHINO",532,150,550,"WF");

  var raceString=rb.toString();
  c.assert(raceString, true);
  Application.Properties.setValue("race",0);
  Application.Properties.setValue("splits", raceString);

  var uf=new UltraField();
  var info=new Activity.Info();
  info.timerTime=0;

  uf.init(info);
  //////c.assert(uf.msg.name, "RACE NAME".equals(uf.msg.name));
  //Test.assertEqual(uf.msg.name, "RACE NAME1");
  //c.assert(uf.totalDist, uf.totalDist == 0);
  Test.assertEqual(uf.totalDist, 0);
  //c.assert(uf.totalDist, uf.totalDist == 0);
  //c.assert(uf.mode, uf.mode == UltraField.PREPARE);
  Test.assertEqualMessage(uf.mode, UltraField.PREPARE, "Non MODE PREPARE");
  c.assert(uf.nextCP.label, "MARTIN".equals(uf.nextCP.label));
  c.assert("CP dist:" + uf.cpDistance, uf.cpDistance == 3440);
  c.assert("Approach dist:"+uf.approachDist,  uf.approachDist == 3440-500);

  uf.onTimerStart();
  c.assert(uf.mode, uf.mode == UltraField.DEFAULT_MODE);
  info=new Activity.Info();
  info.timerTime=30000; info.elapsedDistance=100.0;  //100m in 30sec
  uf.compute(info);
  c.assert(uf.totalDist, uf.totalDist == 100);
  info.elapsedDistance+=100.0; info.timerTime+=30000;
  uf.compute(info);
  c.assert(uf.totalDist, uf.totalDist == 200);
  System.println("// when approaching");
  info.elapsedDistance=3440-50.0; info.timerTime+=1000000;
  uf.compute(info);
  c.assert(uf.mode, uf.mode == UltraField.APPROACHING);

  System.println("// when lap in approaching, enter cp");
  uf.onTimerLap();
  c.assert(uf.mode, uf.mode == UltraField.IN_CP);
  c.assert("tot dist (3440):"+uf.totalDist,uf.totalDist ==3440);
  c.assert(uf.nextCP.label, "PENNELLO".equals(uf.nextCP.label));
  c.assert("msg:"+uf.msg, " 3.44\nMARTIN".equals(uf.msg));


  //--- restart
  c.assert("Splitter index==2 ,"+uf.splitter.index, uf.splitter.index==2);
  c.assert("App prop index==2 ,"+Application.Properties.getValue("lastIndex"), Application.Properties.getValue("lastIndex")==2);
  var prevDist=uf.totalDist;
  uf.onTimerStop();
  uf=new UltraField();
  uf.init(info);
  c.assert("dist after restart: "+uf.totalDist+ " exp:"+prevDist, uf.totalDist == prevDist);
  c.assert(uf.nextCP.label, "PENNELLO".equals(uf.nextCP.label));

  return c.res();
}



(:test)
function CANC(logger)  {
  var c=new Check(logger);
  var d=(532/1000.0).format("%2.2f");
  Test.assertEqualMessage("0.53", d, "format as :"+d);

  d=(12532/1000.0).format("%2.2f");
  Test.assertEqualMessage("12.53", d, "format as :"+d);
  d=(312532/1000.0).format("%2.2f");
  Test.assertEqualMessage("312.53", d, "format as :"+d);
  return true;

}
