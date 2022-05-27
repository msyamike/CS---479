import processing.serial.*;
import grafica.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
String[] data;
String[] data2;
int count;
int i;
int value;
PGraphics pg;
float[] beats = new float[500];  // Used to calculate average BPM
int beatIndex;
int beat_old = 0;
int lastBPM = 0;
int BPM = 0;
GPlot plot;
GPointsArray points;

void setup() {
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[1], 115200);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
  data = new String[1000];
  data2 = new String[1000];
  count = 0;
  i = 0;
  value = 0;
  size(1000, 400); 
  background(0xff);
  PFont font = createFont("Arial", 24, true);
  textFont(font);
  textSize(25);
  plot = new GPlot(this, 250, 50);
  points = new GPointsArray(1000);
}



void draw() { // Continous calling
    serialEvent();
}


void serialEvent() {
  plot.setPos(250, 50);
  plot.setTitleText("Heart Rate: " + BPM);
  plot.getXAxis().setAxisLabelText("Time");
  plot.getYAxis().setAxisLabelText("Beats per minute");
  String checker;
  char val;
  int size;
  myString = myPort.readStringUntil(lf);
  if(myString != null) {
    data = split(myString, '!');
    data2 = split(data[0], ' ');
    if(data2.length > 0) {
      checker = data2[1];
      size = checker.length()-1;
      val = checker.charAt(size);
      if(val == '0' || val == '1' || val == '2' || val=='3' || val == '4' || val == '5' || val == '6' || val == '7' || val == '8' || val == '9') {
        // println(data2[1]);
        value = Integer.parseInt(data2[1]);
        points.add(i, value);
        
        BPM = value;
        plot.setTitleText("BPM: " + BPM);
        println(value);
      }
      
    }
    i++;
  }
    plot.setPoints(points);
    String inString;
    if(count == 60) {
      int curTime = millis();
      inString = str(curTime);
      count = 0;
    } else {
      inString = "0";
      count++;
    }
    plot.defaultDraw();
}
