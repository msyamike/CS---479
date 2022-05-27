/* How to use a flex sensor/resistro - Arduino Tutorial
   Fade an LED with a flex sensor
   More info: http://www.ardumotive.com/how-to-use-a-flex-sensor-en.html
   Dev: Michalis Vasilakis // Date: 9/7/2015 // www.ardumotive.com  */

#include <Wire.h>
#include <Adafruit_MPR121.h>

// You can have up to 4 on one i2c bus but one is enough for testing!
Adafruit_MPR121 cap = Adafruit_MPR121();

// Keeps track of the last pins touched
// so we know when buttons are 'released'
uint16_t lasttouched = 0;
uint16_t currtouched = 0;
int one;
int two;
int three;
bool boolTouch;
const int MPU=0x68;
//Constants:
const int ledPin = 3;   //pin 3 has PWM funtion
const int flexPin = A0; //pin A0 to read analog input

//Variables:
int value; //save analog value


void setup(){
  one = 0;
  two = 0;
  three = 0;
   //Serial.println("MPR121 found!");
   if (!cap.begin(0x5A)) {
    while (1);
  }
  Wire.beginTransmission(MPU);
  Wire.write(0x6B); 
  Wire.write(0);    
  Wire.endTransmission(true);
  pinMode(flexPin, INPUT);
  pinMode(ledPin, OUTPUT);  //Set pin 3 as 'output'
  Serial.begin(115200);       //Begin serial communication

}
void flex() {
  value = analogRead(flexPin);         //Read and save analog value from potentiometer
  Serial.print("Flex:");
  Serial.print(value);               //Print value
  Serial.println(":");
}

void loop(){
  
  flex();
  capacitative();
  delay(100);                          //Small delay
  
}

void capacitative(){
  // Get the currently touched pads
  currtouched = cap.touched();
  // Serial.println("Reached Here");
  for (uint8_t i=0; i<12; i++) {
//    one = 0;
//    two = 0;
//    three = 0;
    if ((currtouched & _BV(i)) && !(lasttouched & _BV(i)) ) {
      boolTouch = true;
    }
    // if it was touched and now isnt, alert!
    if (!(currtouched & _BV(i)) && (lasttouched & _BV(i)) ) {
      if(i == 0) {
        if(one >= 1) {
          one = 0;
        } else {
          one++;
        }
        
      }
      if(i == 3) {
        if(two >= 1) {
          two = 0;
        } else {
          two++;
        }
      }
      if(i == 6) {
        if(three >= 1) {
          three = 0;
        } else {
          three++;
        }
        
      }
      Serial.print("Cap:");
      Serial.print(one);
      Serial.print(":");
      Serial.print(two);
      Serial.print(":");
      Serial.print(three);
      Serial.println(":");
      boolTouch = false;
    }
  }

  // reset our state
  lasttouched = currtouched;
}
