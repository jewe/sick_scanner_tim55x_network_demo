
/*

  Simple Test for SICK scanner TIM55x
  tested with TIM551 with network connection
  Processing 3.1.1
  2016 Jens Weber

*/


import processing.net.*;

Client myClient; 
byte[] b, buf;
String sBuf, sBufDec;
int rawdata2;
int dummy;
int counter, line;
int[] data;
int dataCounter = -1;

void setup()
{
  // open TCP connection to scanner
  myClient = new Client(this, "192.168.1.19", 2112);   
  myClient.clear();
  delay(30);
  
  // send command
  
  //myClient.write("\02sRN DeviceIdent\03"); // device name
  //myClient.write("\02sRN LMDscandata\03"); // one time scan
  
  // request continiuos scans
  myClient.write("\02sEN LMDscandata 1\03");
  
  counter = 0;
  line = 0;
  sBuf = "";
  sBufDec = "";
}

void draw(){} 


void clientEvent(Client myClient) {
  
  b = myClient.readBytes(1);
  counter++;
  if (b[0] == 32){ // parts of the telegram are separated by space
    
    if (sBuf.equals("LMDscandata")){
      print(line);
      print("\t ");
      print(sBuf);
      print("\t ");
      println(sBufDec);
      line = 1;
    }
    
    // output lines before data section
    if ((line == 0 || line > 23) && dataCounter <= 0){
      print(line);
      print("\t ");
      print(sBuf);
      if (line > 22 && line < 30){
        print("\t ");
        print(unhex(sBuf));
      }
      print("\t ");
      println(sBufDec);
    }
      
    // print scan data
    if (dataCounter > 0) {
      print("-\t ");
      print(dataCounter);
      print("\t ");
      print(unhex(sBuf));
      println("\t ");
      dataCounter--;
    }
    
    // set number of scans
    if (line == 25) {
      dataCounter = int( unhex(sBuf) );
      print(line);
      print(" - \t ");
      println(dataCounter);
    }
    
    sBuf = "";
    sBufDec = "";
    line++;
    
  } else {
    
    sBuf += char(b[0]); // ascii
    sBufDec += str(b[0]) + " "; // decimal
    
  }

}