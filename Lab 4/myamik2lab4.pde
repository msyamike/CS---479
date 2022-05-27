/*
* Title: Color Match Game
* Team Members: Krish Bavana, Dwaragesh Sivakumar, Madhava Sai Yamike, Richa Bhujbal
* Group 6
* Color Match Game
* Theme: Helps improving the concetration levels
*/

// Libraries
import grafica.*;
import processing.serial.*;


int sceneChanger; // used for changing the scenes
int lives; // used to keep track of the lives of the player
int score; // uses to keep track of the score of the player
int i = 0;

// Used to set position for the circle
int circleOneYPos;
int circleTwoYPos;
int circleThreeYPos;
int circleFourYPos;

// Used to set the colors for the circle

int circleColorOne;
int circleColorTwo;
int circleColorThree;
int circleColorFour;
float randomer; // used for setting the random color

// used to set the colors for the poly catchers
int polyOneColor;
int polyTwoColor;
int polyThreeColor;
int polyFourColor;

// to keep the status of the each sensor
int oneStatus;
int twoStatus;
int threeStatus;
int fourStatus;
String path;

// Extra variable use for text and tracking system
String text;
int tracker;
int prevTracker;
int matcher;
int itr;

// To store the data for the serial data
Serial myPort;  // The serial port
String myString;
int lf = 10;
String[] list = new String[4];

/*
* This function is used for basic port set up for 
* the serial and later called in the setup function
*/
void serialSetUp() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  myString = myPort.readStringUntil(lf);
  myString = null;
}

/*
* This function helps in all the setup for the 
* variables declared in the global
*
*/
void setup() {
  serialSetUp(); // calls the function for serial setup
  tracker = 0;
  prevTracker = 0;
  matcher = 0;
  size(1500, 800); // sets up the size of the window
  text = ".";
  itr = 0;
  sceneChanger = 0;
  lives = 5;
  score = 0;
  // setting all the postions to 0 in the beginning
  circleOneYPos = 0;
  circleTwoYPos = 0;
  circleThreeYPos = 0;
  circleFourYPos = 0;
  // each circle in the begin starts with different color to give time to intro time 
  circleColorOne = colorChange(1);
  circleColorTwo = colorChange(2);
  circleColorThree = colorChange(3);
  circleColorFour = colorChange(4);
  background(#eea69d);
  randomer = 0;
  // all the polyholders start with the white color and later changes based on the sensor
  polyOneColor = 0xFF;
  polyTwoColor = 0xFF;
  polyThreeColor = 0xFF;
  polyFourColor = 0xFF;
}

/*
* This function is used to create the setup for the box catcher
* Polygon function is inspired by the processing website sources
* Reference: https://processing.org/examples/regularpolygon.html
* Changed it the shape game required based on that code
*/
void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + sin(a) * radius;
    float sy = y + tan(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

/*
* This function is used for changing the
* color of the Circles. Based on the randomness
* the colors will change. 
*/
int colorChange(float randomType) {
 int colors = 0;
 if(randomType <= 1) {
   colors = #50b297;
 } else if(randomType > 1 && randomType <= 2) {
   colors = #3b50c4;
 } else if(randomType > 2 && randomType <= 3) {
   colors = #8e5177;
 } else {
   colors = #516f6c;
 }
  return colors;
}

/*
* This function is primary used for extracting the data
* from the serial and slicing based on the coma (",")
* and converts from the string to integer
*/
void serialDraw() {
   myString = myPort.readStringUntil(lf);
  if(myString != null) { // only for the non null data
      list = split(myString, ',');
      oneStatus = Integer.parseInt(list[0]);
      twoStatus = Integer.parseInt(list[1]);
      threeStatus = Integer.parseInt(list[2]);
      fourStatus = Integer.parseInt(list[3]);
  }
}

/*
* This function is used for changing the
* colors of the polygon. Based on the taps
* the colors will change on polygon
* One Tap for #50b297 (Light Green)
* Two Taps for #3b50c4 (Blue)
* Three Taps for #8e5177 (Purple)
* Four Taps for #516f6c (Dark Green)
*/
void colorChange() {
  // For the first polygon
  if(oneStatus == 1) {
      polyOneColor = #50b297;
    } else if(oneStatus == 2) {
      polyOneColor = #3b50c4;
    } else if(oneStatus == 3) {
      polyOneColor = #8e5177;
    } else if(oneStatus == 4) {
      polyOneColor = #516f6c;
    }
    // for the second polygon
    if(twoStatus == 1) {
      polyTwoColor = #50b297;
    } else if(twoStatus == 2) {
      polyTwoColor = #3b50c4;
    } else if(twoStatus == 3) {
      polyTwoColor = #8e5177;
    } else if(twoStatus == 4) {
      polyTwoColor = #516f6c;
    }
    // for the third polygon
    if(threeStatus == 1) {
      polyThreeColor = #50b297;
    } else if(threeStatus == 2) {
      polyThreeColor = #3b50c4;
    } else if(threeStatus == 3) {
      polyThreeColor = #8e5177;
    } else if(threeStatus == 4) {
      polyThreeColor = #516f6c;
    }
    // for the fourth polygon
    if(fourStatus == 1) {
      polyFourColor = #50b297;
    } else if(fourStatus == 2) {
      polyFourColor = #3b50c4;
    } else if(fourStatus == 3) {
      polyFourColor = #8e5177;
    } else if(fourStatus == 4) {
      polyFourColor = #516f6c;
    }
}

void draw() {
  serialDraw();  // calls the data extraction
  tracker = millis();  // to change the screen from loading to game page
  matcher = tracker-prevTracker;
  if(sceneChanger == 0) {
    fill(0x00);
    textSize(100);
    text("Welcome to Color Match Game", 150, 200);
    fill(0x00);
    // every 1.5 seconds the color of the background and loading status will change
    if(matcher > 1500) {
      text("Welcome to Color Match Game", 150, 200);
      if(itr == 0) {
        background(#828fcd);
      }
      else if (itr == 1){
        background(#aed0da);
      }
      else if(itr == 2) {
        background(#d39458);
      } else if(itr == 3) {
        sceneChanger = 1; // after fully loading the screen will change
      }
      text = text + text;
      prevTracker = tracker;
      matcher = 0;
      itr++;
    }
    //#eea69d
    textSize(40);
    text("Loading"+ text, 700, 400);
  }
  
  if(sceneChanger == 1) {
    background(#eea69d);
    fill(0x00);
    rect(1340, 30, 135, 80);
    fill(0xFF);
    textSize(30);
    text("Lives: " + lives, 1340, 60);
    text("Score: " + score, 1340, 100);
    // Placement of all the objects
    fill(circleColorOne);
    ellipse(150, circleOneYPos, 70, 70);
    fill(polyOneColor);
    polygon(150, 800, 50, 10);  // polygon Box
    fill(circleColorTwo);
    ellipse(500, circleTwoYPos, 70, 70);
    fill(polyTwoColor);
    polygon(500, 800, 50, 10);
    fill(circleColorThree);
    ellipse(800, circleThreeYPos, 70, 70);
    fill(polyThreeColor);
    polygon(800, 800, 50, 10);
    fill(circleColorFour);
    ellipse(1200, circleFourYPos, 70, 70);
    fill(polyFourColor);
    polygon(1200, 800, 50, 10);
    // changing the circle position based on the random
    circleOneYPos += random(1,3);
    circleTwoYPos += random(1,4);
    circleThreeYPos += random(2,4);
    circleFourYPos += random(1,4);
    colorChange(); // calls the color change function
    if(circleOneYPos > 790) {
      // checks for the win and loose
      if(circleColorOne == polyOneColor) {
        score++;
      } else {
        lives--;
      }
      circleOneYPos = ceil(random(0, 400)); // set the circle back in random position
      randomer = random(1,4);
      circleColorOne = colorChange(randomer); // set back the color back to random
    }
    if(circleTwoYPos > 790) {
      if(circleColorTwo == polyTwoColor) {
        score++;
      } else {
        lives--;
      }
      circleTwoYPos = ceil(random(0, 400));
      randomer = random(1,4); // the random color is based on the random function
      circleColorTwo = colorChange(randomer);
    }
    if(circleThreeYPos > 790) {
      if(circleColorThree == polyThreeColor) {
        score++;
      } else {
        lives--;
      }
      circleThreeYPos = ceil(random(0, 400));
      randomer = random(1,4);
      circleColorThree = colorChange(randomer);
    }
    if(circleFourYPos > 790) {
      if(circleColorFour == polyFourColor) {
        score++;
      } else {
        lives--;
      }
      circleFourYPos = ceil(random(0, 400));
      randomer = random(1,4);
      circleColorFour = colorChange(randomer);
    }
    if(lives <= 0) {
      sceneChanger = 2;
    }
  }
  // Final scene change to the end
  if(sceneChanger == 2) {
    background(#8e5177);
    textSize(100);
    fill(#fef4f4);
    text("The End", 650, 400);
    textSize(40);
    text("Your score: " + score, 700, 460); // displays the score
  }
}
