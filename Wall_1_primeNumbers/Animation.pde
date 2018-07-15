public static class Animation extends WallAnimation {

  
  // First, we add metadata to be used in the MoMath system. Change these
  // strings for your behavior.
  String behaviorName = "Example Dynamic Wall Behavior";
  String author = "MoMath";
  String description = "Simple forward-backward behavior.";


  // Now we initialize a few helpful global variables.
  boolean forward = true;
  //float step = 0.0003;
  float loc = 0;
  int baseNumber = 1;
  float timeFromLastUpdate = 0;
  String state = "base";
  ArrayList<Integer> list = null;
  int wiggleCount = 0;

  // Number of wall slats
  int wallLength = 128;
  boolean[] removed = new boolean[128];
  
  //String algorithm = "primeNumbers"; // 1
  //String algorithm = "bubbleSort"; // 2
  //String algorithm = "binaryCount"; // 3
  int algorithmNumber = 1;
  
  int bubbleIndex = 0;
  boolean bubbleChange = false;
  float[] bubbleValue = new float[128];
  
  int slatsPerDigit = 20;
  int binaryCounter = 0;
  boolean[][] bits = new boolean[32][5];
  
  // The setup block runs at the beginning of the animation. You could
  // also use this function to initialize variables, load data, etc.
  void setup() {
    reset();
  }		 
  
  void reset() {
    if( algorithmNumber == 1 ) {
      for (int i=0; i<128; i++) {
        DWSlat slat = wall.slats[i];
        slat.setBottom(1);
        slat.setTop(1);
        
        removed[i] = false;
      }
      baseNumber = 1;
      return;
    }
    
    if( algorithmNumber == 3 ) {
      Random rand = new Random();
      
      for (int i=0; i<128; i++) {
        DWSlat slat = wall.slats[i];
        float n = rand.nextFloat();
        bubbleValue[i] = n;       
        slat.setBottom( n );
        slat.setTop(1);
      }
      return;
    }
 
   if( algorithmNumber == 2 ) {
     int n=-1;
     for(int i4=0; i4<2; i4++) {
       for(int i3=0; i3<2; i3++) {
         for(int i2=0; i2<2; i2++) {
           for(int i1=0; i1<2; i1++) {
             for(int i0=0; i0<2; i0++) {
               n++;
               bits[n][0] = i0==1;
               bits[n][1] = i1==1;
               bits[n][2] = i2==1;
               bits[n][3] = i3==1;
               bits[n][4] = i4==1;
               println(n + "\t" + i4 + " "  + i3 + " " + i2 + " " + i1 + " " + i0 );
             }
           }
         }
       }
     }
     binaryCounter = 0;
      for (int i=0; i<128; i++) {
        DWSlat slat = wall.slats[i];
        slat.setBottom( 0 );
        slat.setTop(0);
      }
     return;
   }
  }

  // The update block will be repeated for each frame. This is where the action should be programmed.
  void update() {
    timeFromLastUpdate += deltaTime;
    
    //println( System.currentTimeMillis() );
    int n = getAlgorithm();
    if(n == 1 || n == 2 || n == 3) { if(algorithmNumber != n) { algorithmNumber = n; reset(); }}
    //println( System.currentTimeMillis() + " - n: " + n);
      
    if( algorithmNumber == 1 ) {
      primeNumbers();
      return;
    } 
    
    if( algorithmNumber == 3 ) {
      bubbleSort();
      return;
    } 
    
   if( algorithmNumber == 2 ) {
      binaryCount();
     return;
   }
  }
  
  void binaryCount() {
    if(state.equals("base") ) {
      // TIME FOR THE NEXT UPDATE?
      if(timeFromLastUpdate > 1) {
        timeFromLastUpdate = 0;
        binaryCount_prepareUpdate();
        // WHAT SHOULD I DO NEXT?
        if(binaryCounter == -1) {
          println("Resetting");
          state = "reset";
        } else {
          println("binaryCounter:"+binaryCounter);
          state = "update";
        }
      }
      return;
    } 
    
    if( state.equals("update") ) {
       for(int i=0; i<bits[binaryCounter].length; i++) {
          int start = i * slatsPerDigit;
          int pos = bits[binaryCounter][i] ? 1 : 0;
          for(int n=0; n<slatsPerDigit; n++) {
            DWSlat slat = wall.slats[ (int) map(start + n, 0, 127, 127, 0) ]; 
            slat.setBottom( pos );
            slat.setTop( pos );
          }
        }
        state = "base";
      return;
    } 
    
    if(state.equals("reset") ) {
       reset(); 
       binaryCounter = 0;
       state = "base";
       return;
    }
  }
  
  
  
  void binaryCount_prepareUpdate() {
    binaryCounter++;
    if(binaryCounter >= Math.pow(2, 5) ) { binaryCounter = -1; }
  }
  
  void bubbleSort() {
    //println("bubbleIndex: "+bubbleIndex);
    if(bubbleIndex == 127) {
      /*if(bubbleChange) {
        for(int i=0; i<128; i++) { print("" + bubbleValue[i] + " - "); }
        println("");
      }*/
      bubbleIndex = 0;
      bubbleChange = false;
      return;
    }
    
    // sort bubbleIndex and bubbleIndex+1
    if( bubbleSwap(bubbleIndex) ) {     
        //println("swapped " + bubbleValue[bubbleIndex] + "  -  " + bubbleValue[bubbleIndex+1]);
        wall.slats[bubbleIndex].setBottom(bubbleValue[bubbleIndex]);
        wall.slats[bubbleIndex+1].setBottom(bubbleValue[bubbleIndex+1]);
    }
    bubbleIndex++;
    return;
  }
  
  boolean bubbleSwap(int i) {
    if( bubbleValue[i] > bubbleValue[i+1] ) {
      // swap
      float temp = bubbleValue[i];
      bubbleValue[i] = bubbleValue[i+1];
      bubbleValue[i+1] = temp;
      bubbleChange = true;
      return true;
    }
    return false;
  }
  
  void primeNumbers() {
    if(state.equals("base") ) {
      // TIME FOR THE NEXT UPDATE?
      if(timeFromLastUpdate > .3) {
        timeFromLastUpdate = 0;
        primeNumber_prepareUpdate();
        // WHAT SHOULD I DO NEXT?
        if(baseNumber == -1) {
          println("Resetting");
          state = "reset";
        } else {
          println("baseNumber:"+baseNumber);
          list =  primeNumber_findCurrentNumbers();
          state = "update";
          wiggleCount = 0;
          String ret = setPrimeNumber( baseNumber );
          println("setPrimeNumber returned >"+ret+"<");
        }
      }
      return;
    } 
    
    if( state.equals("update") ) {
      wiggleCount++;
      if(wiggleCount < 60) {
        // WIGGLE
        int pos1 = wiggleCount%2;
        int pos2 = pos1==0 ? 0 : 1;
        for(int i : list) {
          DWSlat slat = wall.slats[i];  
          slat.setBottom(pos1);
          slat.setTop(pos2);
        }
      } else {
        // CLEAN UP AND TRANSITION
        for(int i : list) {
          DWSlat slat = wall.slats[i]; 
          removed[i] = true;
          slat.setBottom(0);
          slat.setTop(0);
        }
        state = "base";
      }    
      return;
    } 
    
    if(state.equals("reset") ) {
       reset(); 
       baseNumber = 1;
       state = "base";
       return;
    }
  }
  
  ArrayList<Integer> primeNumber_findCurrentNumbers() {
    ArrayList<Integer> list = new ArrayList<Integer>();
    for (int i=baseNumber+1; i<128; i++) {
      if( i%baseNumber == 0 ) { list.add( i ); }
    }
    return list;
  }
  
  void primeNumber_prepareUpdate() {
    while(baseNumber<(128/2)) {
      baseNumber++;
      if( ! removed[baseNumber]) { return; }
    }
    baseNumber = -1;
  }
  
  
  
  // COMMUNICATION 
  public int getAlgorithm() {
    URL url = null;
    HttpURLConnection con = null;
    try {
      url = new URL("http://localhost:8080/get");
      con = (HttpURLConnection) url.openConnection();
      con.setRequestMethod("GET");
      
      int status = con.getResponseCode();
      BufferedReader in = new BufferedReader( new InputStreamReader(con.getInputStream()));
      String inputLine;
      StringBuffer content = new StringBuffer();
      while ((inputLine = in.readLine()) != null) {
          content.append(inputLine);
      }
      in.close();
      con.disconnect();    
      String s = content.toString();
      int i = s.indexOf(':');
      i = s.indexOf('"', i);
      //println("getAlgorithm :: i:"+i);
      String sa =  s.substring(i+1, i+2);
      //println("getAlgorithm :: sa:"+sa);
      int a =  Integer.parseInt( sa );
      //println("getAlgorithm :: i:"+i);
      return a;
      // { id:"2" }
      
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      return -1;
    }
    
  }
  
  public String setPrimeNumber(int n) {
    URL url = null;
    HttpURLConnection con = null;
    try {
      url = new URL("http://localhost:8080/putNumber/"+n);
      con = (HttpURLConnection) url.openConnection();
      con.setRequestMethod("GET");
      
      int status = con.getResponseCode();
      BufferedReader in = new BufferedReader( new InputStreamReader(con.getInputStream()));
      String inputLine;
      StringBuffer content = new StringBuffer();
      while ((inputLine = in.readLine()) != null) {
          content.append(inputLine);
      }
      in.close();
      con.disconnect();    
      String s = content.toString();
      println("setPrimeNumber :: s: " + s);
      return s;
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      return null;
    }
    
  }
  
  

  // Leave this function blank
  void exit() {
  }
  
  // You can ignore everything from here.
  String getBehaviorName() {
    return behaviorName;
  }
  
  String getAuthorName() {
    return author;
  }
  
  String getDescription() {
    return description;
  }
  
}