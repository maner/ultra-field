import Toybox.WatchUi;

class CheckPoint{

  var dist;
  var label;
  var info;
  var ele;
  var dPlus;
  var dMinus;
  var flags;
  var barrierHH;
  var barrierMM;

  var _dist1;
  var _dist2;

  var _icons;

  function getIcons(){
    if (_icons==null){
      _icons= [];
      if (flags!=null){
        var chars=flags.toCharArray();
        for (var i=0;i<chars.size();i++){
          var c=chars[i];
          var value=map.get(c);
          if(System.getSystemStats().freeMemory<1000){value=null;}
          if (value!=null) { 
            System.println("Load "+c+" ->"+value+" free: "+System.getSystemStats().freeMemory);
            value=WatchUi.loadResource($.Rez.Drawables[value]) as BitmapResource;
          } else {value=c;}
          _icons.add(value);
        }
      }
    }
    return _icons;
  }
  
  var map={
    'w' => :water,
    'd' => :drink,
    'D' => :hotDrink,
    'f' => :foods,
    'F' => :hotFood,
    's' => :bag,
    'a' => :aid,
    'b' => :bus,
    't' => :timer,
    'z' => :bed
  };

}
