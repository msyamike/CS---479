import processing.serial.*;

/*
* Pac-man cordinate points for arc 
*/
int pacmanX;
int pacmanY;
int pacmanWidth;
int pacmanHeight;
float pacManAngleOne;
float pacManAngleTwo;
int flex;
int polyWidth;
int polyHeight;
/*
* Used to display score and tracker
*/
int lives;
int Calories;
int score;

// used to change the direction of the pacman based on the game
int levels; 
int i = 1;

int tracker;
String splitNumber;
int heightOne;
int heightTwo;
String[] data;
String[] foodItems = {"Salad", "quino", "Chia", "Chicken", "Carrot", "Pizza", "Pasta", "Fries", "Donuts", "coke"};
int [] circlesX;
int [] circlesY;
double [] deciders;
int [] calories = {100, 120, 120, 230, 60, 560, 667, 877, 450, 120};
int [] calX;
int [] calY;
boolean[] heightCheck;
double decider;

float randomX;
int ceilX;
float randomY;
int ceilY;
int random;
int randomBall;
int marker;
String[] list = new String[4];
int lf = 10;    // Linefeed in ASCII
Serial myPort;  // The serial port
String myString = null;
boolean mouthOpen;
int rectX;
int rectY;
int testo;
int pacmanSizeX = 50;
int pacmanSizeY = 50;
int sceneChange;
int milliSeconds;
int seconds;
int prevTime;
int max;
String text;
int one;
int two;
int three;
int low;
int high;
int val;

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
    float sx = x + tan(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void serialSetUp() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.clear();
  myString = myPort.readStringUntil(lf);
  myString = null;
}

void setup() {
  size(1500, 700);
  serialSetUp();
  pacmanX = 0;
  pacmanY = 50;
  pacmanWidth = 10;
  pacmanHeight = 10;
  pacManAngleOne = 0;
  pacManAngleTwo = 6.1;
  levels = 1;
  tracker = 0;
  marker = 1;
  lives = 3;
  rectX = 30;
  rectY = 30;
  data = new String [2];
  heightCheck = new boolean[5];
  polyWidth = 30;
  polyHeight = 10;
  sceneChange = 0;
  text = ".";
  one = 0;
  two = 0;
  three = 0;
  low = 0;
  high = 0;
   // foodItems = new String[10];
}


String randomHeight() {
  String retVal = "";
  int valOne = ceil(random(0, 5));
  int valTwo = ceil(random(1,5));
  while(valOne == valTwo) {
    valTwo = ceil(random(1,5));
  }
  retVal = str(valOne) + "," + str(valTwo);  
  return retVal;
}


void introScreen() {
  max += 5;
  milliSeconds = millis();
  int constant = 1000;
  if(milliSeconds - prevTime > constant) {
    seconds++;
    prevTime = milliSeconds;
    text += text;
  }
  background(#dd7d84);
  fill(0x00);
  textSize(85);
  text("Welcome to PacMan - Calorie Counter", 140, 200); 
  textSize(40);
  text("Loading" + text, 700, 400);
  for(int i = 0; i<seconds; i++) {
    fill(0x00);
    arc(500+max, 450, 20, 20, pacManAngleOne, pacManAngleTwo);

  }
  if(seconds == 3) {
    sceneChange = 1;
  }
}

void selectionMode() {
  background(#ca77bc);
  fill(0x00);
  textSize(100);
  text("Please Select a Mode", 350, 200); 
  fill(#51ae80);
  rect(350, 300, 100, 100, 28);
  fill(0x00);
  textSize(30);
  text("Healthy Mode", 330, 450); 
  fill(#c63b39);
  rect(750, 300, 100, 100, 28);
  fill(0x00);
  textSize(30);
  text("Junk Mode", 740, 450); 
  fill(#4b00e3);
  rect(1150, 300, 100, 100, 28);
  fill(0x00);
  textSize(30);
  text("Mix Mode", 1150, 450);   
}

double randomer() {
  return random(1, 3);
}

void randomX(int y, int size) {
  for(int i = 0; i<size; i++) {
     if(deciders[i] <= 2) {
      fill(#51ae70);
      ellipse(circlesX[i], y, 35, 35);
      fill(0);
      textSize(10);
      text(foodItems[random], circlesX[i]-5, y);
      calX[i] = calories[random];
    } else {
      fill(#b23f20);
      ellipse(circlesX[i], y, 35, 35);
      fill(0);
      textSize(10);
      text("Danger", circlesX[i]-5, y);
    }
  }
}

void randomY(int x, int size){
  // random = ceil(random(0,9));
  for(int i = 0; i<size; i++) {
     if(deciders[i] <= 2) {
      fill(#51ae70);
      // println(i);
      ellipse(x, circlesY[i], 35, 35);
      fill(0);
      textSize(10);
      text(foodItems[random], x-5, circlesY[i]);
      calY[i] = calories[random];
    } else {
      fill(#b23f20);
      ellipse(x, circlesY[i], 35, 35);
      fill(0);
      textSize(10);
      text("Danger", x, circlesY[i]);
    }
  }
}

void magicY() {
  decider = randomer();
  random = ceil(random(low, high));
  randomBall = ceil(random(0, 5));
  circlesY = new int [randomBall];
  deciders = new double [randomBall];
  calY = new int[randomBall];
}

void magicX() {
    decider = randomer();
    random = ceil(random(low, high));
    randomBall = ceil(random(0, 5));
    circlesX = new int [randomBall];
    deciders = new double [randomBall];
    calX = new int [randomBall];
}

void serialDraw() {
  String f = "Flex";
   myString = myPort.readStringUntil(lf);
   //println(myString);
  if(myString != null) {
      list = split(myString, ':');
      //println(list[0]);
      if(list[0].equals(f)) {
        flex = Integer.parseInt(list[1]);
        //println(flex);
      }
  }
}

void serialTouch() {
  String f = "Cap";
   myString = myPort.readStringUntil(lf);
  if(myString != null) {
      list = split(myString, ':');
      //println(list[0]);
      if(list[0].equals(f)) {
        one = Integer.parseInt(list[1]);
        two = Integer.parseInt(list[2]);
        three = Integer.parseInt(list[3]);
      }
  }
}

void endScreen() {
  background(#dd7d84);
  fill(0x00);
  textSize(100);
  text("The End", 600, 200); 
  textSize(60);
  if(lives > 0) {
    text("You Won", 700, 275);
  } else {
    text("You Lost", 700, 350);
  }
  textSize(40);
  text("Your Score: " + score, 700, 400);
}

void draw() {

  if(lives <= 0) {
    endScreen();
    sceneChange = 3;
  }
  if(sceneChange == 3) {
    endScreen();
    
  }
  if(sceneChange == 0) {
    introScreen();
  } else if(sceneChange == 1) {
    selectionMode();
    serialTouch();
    if(one == 1 && two == 0 && three == 0) {
      low = 0;
      high = 4;
      sceneChange = 2;
    }
    else if(one == 0 && two == 1 && three == 0) {
      low = 5;
      high = 9;
      sceneChange = 2;
    } else if(one == 0 && two == 0 && three == 1) {
      low = 0;
      high = 9;
      sceneChange = 2;
    }
  }
  else if(sceneChange == 2) {
    testo++;
  background(#c6ce85);
  serialDraw();
  //println(flex);
  if(flex < 200 && flex > 100) {
    mouthOpen = true;
  } else {
    mouthOpen = false;
  }
  if(tracker == 0) {
    splitNumber = randomHeight();
    data = split(splitNumber, ",");
    heightOne = Integer.parseInt(data[0]);
    heightTwo = Integer.parseInt(data[1]);

    heightCheck[heightOne-1] = true;
    heightCheck[heightTwo-1] = true;
    tracker = 1;
  }
  
  polygon(0, 50, 30, 20);
  fill(0xff);
  if(levels == 1) {
    if(mouthOpen) {
        pacManAngleOne = 0.8;
        pacManAngleTwo = 5.1;
    } else {
      pacManAngleOne = 0;
      pacManAngleTwo = 6.1;
    }
    if(tracker == 1) {
      magicX();
      for(int i = 0; i<randomBall; i++) {
        circlesX[i] = ceil(random(200, 1100));  // to determine where to place it
        deciders[i] = randomer();  // to determine red or green circle
      }
      tracker = 2;
    }
    for(int i = 0; i<randomBall; i++) {
      if(pacmanX == circlesX[i] && mouthOpen) {
        circlesX[i] = 20000;
        Calories += calX[i];
        if(deciders[i] > 2) {
          lives--;
          pacmanSizeY -= 10;
          pacmanSizeX -= 10;
        }
        else {
          pacmanSizeY+=3;
          pacmanSizeX+=3;
          score++;
        }
      }
    }
    randomX(50, randomBall);
    fill(0);
    ellipse(pacmanX, pacmanY, 5, 10);
    fill(0xff);
    if(heightCheck[levels-1] == true) {
      if(mouthOpen && pacmanX == 600) {
        rectX = 0;
        rectY = 0;
        polyWidth += 10;
        score++;
      }
      rect(600, 30, rectX, rectX);
    }
    pacmanX++;
    if(pacmanX > 1100) {
      levels = 2;
      rectX = 30;
      rectY = 30;
    }
   } else if(levels == 2) {
     if(mouthOpen) {
        pacManAngleOne = 2.4;
        pacManAngleTwo = 6.8;
    } else {
      pacManAngleOne = 1.6;
      pacManAngleTwo = 7.6;
    }
     if(tracker == 2) {
       magicY();
       for(int i = 0; i<randomBall; i++) {
        circlesY[i] = ceil(random(50, 350));  // to determine where to place it
        deciders[i] = randomer();  // to determine red or green circle
       }
      tracker = 3;
     }
     for(int i = 0; i<randomBall; i++) {
      if(pacmanY == circlesY[i] && mouthOpen) {
        circlesY[i] = 20000;
        Calories += calY[i];
        if(deciders[i] > 2) {
          lives--;
          pacmanSizeY -= 10;
          pacmanSizeX -= 10;
        }
        else {
          pacmanSizeY+=3;
          pacmanSizeX+=3;
          score++;
        }
      }
    }
     randomY(1110, randomBall);
    pacmanY++;
    if(heightCheck[levels-1] == true) {
      if(mouthOpen && pacmanY == 200) {
        rectX = 0;
        rectY = 0;
        polyWidth += 10;
        score++;
      }
      rect(1090, 200, rectX, rectY);
    }

    if(pacmanY > 350) {
      levels = 3;
      rectX = 30;
      rectY = 30;
    }
  }
  else if(levels == 3) {
    if(mouthOpen) {
        pacManAngleOne = 3.8;
        pacManAngleTwo = 8.4;
    } else {
      pacManAngleOne = 3.1;
      pacManAngleTwo = 9.1;
    }
    if(tracker == 3) {
      magicX();
      for(int i = 0; i<randomBall; i++) {
        circlesX[i] = ceil(random(200, 1100));  // to determine where to place it
        deciders[i] = randomer();  // to determine red or green circle
      }
      tracker = 4;
    }
    for(int i = 0; i<randomBall; i++) {
      if(pacmanX == circlesX[i] && mouthOpen) {
        Calories += calX[i];
        circlesX[i] = 20000;
        if(deciders[i] > 2) {
          lives--;
          pacmanSizeY -= 10;
          pacmanSizeX -= 10;
        }
        else {
          pacmanSizeY+=3;
          pacmanSizeX+=3;
          score++;
        }
      }
    }
    randomX(350, randomBall);
    if(heightCheck[levels-1] == true) {
      if(mouthOpen && pacmanX == 295) {
        rectX = 0;
        rectY = 0;
        polyWidth += 10;
        score++;
      }
      rect(295, 335, rectX, rectY);
    }
    pacmanX--;
    if(pacmanX <= 100) {
      rectX = 30;
      rectY = 30;
      levels = 4;
    }
    
  } 
  else if(levels == 4) {
    if(mouthOpen) {
        pacManAngleOne = 2.4;
        pacManAngleTwo = 7.1;
    } else {
      pacManAngleOne = 1.7;
      pacManAngleTwo = 7.6;
    }
    if(tracker == 4) {
      magicY();
      for(int i = 0; i<randomBall; i++) {
        circlesY[i] = ceil(random(350, 650));  // to determine where to place it
        deciders[i] = randomer();  // to determine red or green circle
      }
      tracker = 5;    
    }
    for(int i = 0; i<randomBall; i++) {
      if(pacmanY == circlesY[i] && mouthOpen) {
        Calories += calY[i];
        circlesY[i] = 20000;
        if(deciders[i] > 2) {
          lives--;
          pacmanSizeY -= 10;
          pacmanSizeX -= 10;
        }
        else {
          pacmanSizeY+=3;
          pacmanSizeX+=3;
          score++;
        }
      }
    }
    randomY(100, randomBall);
    if(heightCheck[levels-1] == true) {
      if(mouthOpen && pacmanY == 620) {
        rectX = 0;
        rectY = 0;
        polyWidth += 10;
        score++;
      }
      rect(90, 620, rectX, rectY);
    }
    pacmanY++;
    if(pacmanY > 650) {
      levels = 5;
      rectX = 30;
      rectY = 30;
    }
  } 
  else if(levels == 5) {
    if(mouthOpen) {
      pacManAngleOne = 0.9;
      pacManAngleTwo = 5.0;
    } else {
      pacManAngleOne = 0.3;
      pacManAngleTwo = 6.1;
    }
    if(tracker == 5) {
      magicX();
      for(int i = 0; i<randomBall; i++) {
        circlesX[i] = ceil(random(200, 1100));  // to determine where to place it
        deciders[i] = randomer();  // to determine red or green circle
      }
      tracker = -1;
    }
    for(int i = 0; i<randomBall; i++) {
      if(pacmanX == circlesX[i] && mouthOpen) {
        Calories += calX[i];
        circlesX[i] = 20000;
        if(deciders[i] > 2) {
          lives--;
          pacmanSizeY -= 10;
          pacmanSizeX -= 10;
        }
        else {
          pacmanSizeY+=3;
          pacmanSizeX+=3;
          score++;
        }
      }
    }
    randomX(650, randomBall);
    if(heightCheck[levels-1] == true) {
      if(mouthOpen && pacmanX == 300) {
        rectX = 0;
        rectY = 0;
        polyWidth += 10;
        score++;
      }
      rect(300, 640, rectX, rectY);
    }
    if(pacmanX >= 1380) {
      sceneChange = 3;
      
    }
    pacmanX++;
  } 
  fill(0xff);
  arc(pacmanX, pacmanY, pacmanSizeX, pacmanSizeY, pacManAngleOne, pacManAngleTwo);
  fill(0);
  ellipse(pacmanX-6, pacmanY-10, 5, 5);
  textSize(25);
  fill(0xff);
  rect(1280, 30, 200, 100);
  fill(0);
  text("Calories: " + Calories, 1290, 60); 
  text("Lives: " + lives, 1290, 90); 
  text("Score: " + score, 1290, 120); 
  fill(0);
  polygon(1505, 650, polyWidth, polyHeight);
  i++;    
  } else if(sceneChange == 3) {
    endScreen();
  }
}
