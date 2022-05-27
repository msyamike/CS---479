/*
 * Created by ArduinoGetStarted.com
 *
 * This example code is in the public domain
 *
 * Tutorial page: https://arduinogetstarted.com/tutorials/arduino-force-sensor
 */

#include <Wire.h>
const int MPU=0x68; 
int16_t AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;
#define FORCE_SENSOR_PIN1 A0 // the FSR and 10K pulldown are connected to A0
#define FORCE_SENSOR_PIN2 A1 // the FSR and 10K pulldown are connected to A0
#define FORCE_SENSOR_PIN3 A2 // the FSR and 10K pulldown are connected to A0
#define FORCE_SENSOR_PIN4 A3 // the FSR and 10K pulldown are connected to A0
#define led1 3
#define led2 6
#define led3 9
#define led4 11

int healUp;
int MedialUp;
int laterUp;
int midUp;
int medialForefoot;
int laterMidfoot;
int medialMidfoot;
int heal;

void setup() {
  Wire.begin();
  Wire.beginTransmission(MPU);
  Wire.write(0x6B); 
  Wire.write(0);    
  Wire.endTransmission(true);
  Serial.begin(115200);
  healUp = 0;
  MedialUp = 0;
  laterUp = 0;
  midUp = 0;
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  delay(100);
}

void gait() {
  medialForefoot = analogRead(FORCE_SENSOR_PIN1);
  laterMidfoot = analogRead(FORCE_SENSOR_PIN2);
  medialMidfoot = analogRead(FORCE_SENSOR_PIN3);
  heal = analogRead(FORCE_SENSOR_PIN4);
  // updateVals();

  Serial.print(medialForefoot); // print the raw analog reading
  Serial.print(" ");
  Serial.print(laterMidfoot); // print the raw analog reading
  Serial.print(" ");
  Serial.print(medialMidfoot); // print the raw analog reading
  Serial.print(" ");
  Serial.print(heal); // print the raw analog reading
  Serial.print(" ");
  // Serial.print("Heal = ");
  
  //Serial.print("Medial = ");
  
  //Serial.print("Lateral = ");
  
  //Serial.print("Mid = ");
  

  if(medialForefoot > 600) {
    digitalWrite(led1, HIGH);
  } else {
    digitalWrite(led1, LOW);
  }
  if(laterMidfoot > 600) {
    digitalWrite(led2, HIGH);
  } else {
    digitalWrite(led2, LOW);
  }
  if(medialMidfoot > 600) {
    digitalWrite(led3, HIGH);
  } else {
    digitalWrite(led3, LOW);
  }
  if(heal > 600) {
    digitalWrite(led4, HIGH);
  } else {
    digitalWrite(led4, LOW);
  }
  delay(1000);
}

void cadance() {
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,12,true);  
  AcX=Wire.read()<<8|Wire.read();    
  AcY=Wire.read()<<8|Wire.read();  
  AcZ=Wire.read()<<8|Wire.read();  
  GyX=Wire.read()<<8|Wire.read();  
  GyY=Wire.read()<<8|Wire.read();  
  GyZ=Wire.read()<<8|Wire.read();  
  
  // Serial.print("Accelerometer: ");
  //Serial.print("X = "); Serial.print(AcX);
  //Serial.print(" | Y = "); Serial.print(AcY);
  //Serial.print(" | Z = "); Serial.println(AcZ); 
  Serial.print(AcZ);
  Serial.println(" ");
  /*
  Serial.print("Gyroscope: ");
  Serial.print("X = "); Serial.print(GyX);
  Serial.print(" | Y = "); Serial.print(GyY);
  Serial.print(" | Z = "); Serial.println(GyZ);
  Serial.println(" ");
  delay(1000);
  */
}
void loop() {
  
  gait();
  cadance();
}
