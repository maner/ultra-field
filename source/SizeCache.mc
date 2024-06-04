class SizeCache{
var width;
  var height;
  var height50;
  var width50;
  var h0,h1,h2,h4,h5,w0,wIc;
  
  function init(dc){
  	if (dc.getWidth()==width && dc.getHeight()==height){
  		return;
  	}
  	width=dc.getWidth();
  	height=dc.getHeight();
  	
    width50=dc.getWidth()/2;
    height50=dc.getHeight()/2;
    if (height>380){
      h0=0;
      h1=10;
      h2=height50-60;
      h4=height50+50;
      h5=height50+140;
      w0=90;
      wIc=70;
    } else if (height>255){
      h0=0;
      h1=5;
      h2=height50-50;
      h4=height50+40;
      h5=height50+90;
      w0=50;
      wIc=50;
    } else {
      h0=0;
      h1=5;
      h2=height50-50;
      h4=height50+40;
      h5=height50+85;
      w0=45;
      wIc=45;
    }
    // System.println("Heigth:"+height);
    // System.println("C:"+c);
    // System.println("h0:"+h0);
    // System.println("h1:"+h1);
    // System.println("h2:"+h2);
    // System.println("h4:"+h4);
    // System.println("h5:"+h5);
    // System.println("w0:"+w0);
    

  }


}