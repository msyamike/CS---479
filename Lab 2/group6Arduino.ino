/*
 * Group 6
 * 
 * Arduino Code - Responsible for retrieving values from the user; 
 *                Acts as an ECG that prints the pulse on the serial monitor
 * Reference: Casey Kuhns @ SparkFun Electronics
 *            6/27/2014
 *            https://github.com/sparkfun/AD8232_Heart_Rate_Monitor
 */

int fsrAnalogPin = 1; // FSR is connected to analog 1
int fsrReading;      // the analog reading from the FSR resistor divide

void setup() {
  // 115200 baud
  Serial.begin(115200);
  pinMode(10, INPUT);
  pinMode(11, INPUT);
  pinMode(12, INPUT);
}

void loop() {

  // If the censor pad is not against your chest, then return an error message
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    Serial.println("Error! Band not against the chest!");
  } else{
    // Receive analog output
    // Display in serial monitor
    Serial.println(analogRead(A1));
    fsrReading = analogRead(fsrAnalogPin);
    Serial.print("Analog reading = ");
    Serial.println(fsrReading);  
  }

  // Gathering data
  delay(10);
}
