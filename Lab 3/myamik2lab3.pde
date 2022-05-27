import processing.serial.*;
import grafica.*;

int lf = 10;    // Linefeed in ASCII
Serial myPort;  // The serial port
int i = 0;
String myString = null;
GPlot plot1;
String[] list = new String[5];
String[] prevList = new String[5];
int prev = 0;
int numOfSteps = 0;
int cadance = 0;
int milliSeconds = 0;
int minute = 0;
int itr = 1;
int prevMillis = 0;
int z = 0;
int prevZ = 0;
String Motion = "Standing Still";
int prevStand = 0;
String profile = "Normal";
GPointsArray points;
int testTime = 0;
PImage img;

void serialSetUp() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  myString = myPort.readStringUntil(lf);
  myString = null;
}


void setup() {
  serialSetUp();
  size(1500, 800);
  img = loadImage("1.png");
  
  plot1 = new GPlot(this);
  plot1.setPos(600,250);
  plot1.setDim(600, 400);
  plot1.setPointColor(color(0,0,0,255));
  plot1.setPointSize(2);
  String nums = "0 0 0 0";
  prevList = split(nums, ' ');
  milliSeconds = millis();
}

void serialDraw() {
   myString = myPort.readStringUntil(lf);
  if(myString != null) {
      list = split(myString, ' ');
      // println(myString);
  }
  
}


void draw() {
  serialDraw();
  milliSeconds = millis();
  plot1.setTitleText("Number of Steps ");
  plot1.getXAxis().setAxisLabelText("Time");
  plot1.getYAxis().setAxisLabelText("Steps");
  background(#a2bf8d);
  //ellipse(50, 50, 10, 10);
  textSize(60);
  fill(#2c4a3f);
  text("Gait Analysis", 100, 80); 
  fill(0xFF);
  rect(60, 100, 400, 650);
  if(list[0] != null) {
    // println("Medial: " + list[0]);
    int data =Integer.parseInt(list[0]);  
    if(data >= 1022) {
      fill(#d96126);
    } else if(data > 700 && data < 1023) {
      fill(#2ad541);
    } else if(data > 550 && data < 700) {
      fill(#c8dd22);
    } else {
      fill(#bc4381);
    }
  }
  ellipse(244, 190, 90, 90); // medial fore foot
  if(list[1] != null) {
    // println(list[1]);
    // println("Lateral: " + list[1]);   
    int data =Integer.parseInt(list[0]);  
    if(data >= 1022) {
      profile = "Tip Toeing";
      fill(#d96126);
    } else if(data > 700 && data < 1023) {
      fill(#2ad541);
      
    } else if(data > 550 && data < 700) {
      fill(#c8dd22);
    } else {
      fill(#bc4381);
    }
  }
  ellipse(310, 344, 90, 90); // lateral fore foot
  if(list[2] != null) {
    // println("Mid: " + list[2]);
    int data =Integer.parseInt(list[2]);  
    if(data >= 1022) {
      profile = "Out Toeing";
      fill(#d96126);  // high preassure  -- orangeish red
    } else if(data > 700 && data < 1023) {
      
      fill(#2ad541);   // medium preassure -- green data
    } else if(data > 550 && data < 700) {
      fill(#c8dd22);  // low pressure  -- yellowish green
    } else {
      fill(#bc4381);
    }
  }
  ellipse(200, 414, 90, 90); // lateral fore foot
  if(list[2] != null && list[3] != null) {
    int data =Integer.parseInt(list[2]);  
    int data2 =Integer.parseInt(list[3]);
    if(data > 1000 && data2 > 1000) {
      profile = "In Toeing";
    }
  }
  if(list[3] != null) {
    // println("Heal: " + list[3]);
    int data =Integer.parseInt(list[3]);  
    if(data >= 1022) {
      profile = "Heel";
      fill(#d96126);
    } else if(data > 700 && data < 1023) {
      
      fill(#2ad541);
    } else if(data > 550 && data < 700) {
      fill(#c8dd22);
    } else {
      fill(#bc4381);
    }
  }
  ellipse(244, 640, 90, 90); // heal 
  if(list[0] != null && prevList[0] != null) {
    int converterOne = Integer.parseInt(list[0]);
    int prevConvert = Integer.parseInt(prevList[0]);
    int converterTwo = Integer.parseInt(list[1]);
    int prevConvertTwo = Integer.parseInt(prevList[1]);
    if(prevConvert <  700 && converterOne > 700) {
      numOfSteps += 1;
    } else if(prevConvertTwo < 700 && converterTwo > 700) {
      numOfSteps += 1;
    }
      
  }
  prevList = list;
  
  if(list[4] != null) {
    z =Integer.parseInt(list[4]);  
    println("Data: "+ z);
  }
  
  /*
  if(prevZ + 300 < z) {
    Motion = "Standing Still";
  }
  */
  prevZ = z;
  
  fill(0xFF);
  rect(1000, 35, 350, 60);
  fill(0x00);
  textSize(30);
  text("Number of Steps: " + numOfSteps, 1030, 80);
  int check = (milliSeconds - prevMillis);
  println((milliSeconds - prevMillis));
  if(check >= 60000) {
    prevMillis = milliSeconds;
    cadance = (cadance + numOfSteps)/itr;
    itr = itr + 1;
    
  }
  fill(0xFF);
  rect(590, 35, 380, 60);
  fill(0x00);
  textSize(30);
  text("Cadance: " + cadance + " steps/minute", 600, 80);
  
  prevStand = numOfSteps;
  fill(0xFF);
  rect(590, 150, 410, 60);
  fill(0x00);
  textSize(30);
  text("Motion Status: " + Motion , 600, 200);
  
  int testZ = z-prevZ*2;
  fill(0xFF);
  rect(1050, 150, 410, 60);
  fill(0x00);
  textSize(30);
  text("Stride Length: " + testZ, 1060, 200);
  
  image(img, 100, 100, 300, 600);
  fill(0xFF);
  rect(60, 720, 400, 60);
  fill(0x00);
  textSize(30);
  text("Profiles: " + profile, 185, 750);
  plot1.addPoint(testTime , numOfSteps);
  plot1.beginDraw();
  plot1.drawBackground();
  plot1.drawBox();
  plot1.drawXAxis();
  plot1.drawYAxis();
  plot1.drawTitle();
  plot1.drawGridLines(GPlot.BOTH);
  plot1.drawPoints();
  plot1.endDraw();
  testTime += 1;
}
