#include <WiFi.h>
#include "time.h"
#include <Adafruit_NeoPixel.h>

#define PIN 5
#define TOUCH_SENSOR_PIN 17
#define NUMPIXELS 11

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

const char* ssid       = "skynet";
const char* password   = "rikki-tikki-tavi";

const char* ntpServer = "pool.ntp.org";
const long  gmtOffset = 10800; 
const int   daylightOffset = 0; 

const int leds [] = { 
  1, 2, 4, 8, 16, // hours
  32, 16, 8, 4, 2, 1 // minutes
};

void connectWiFi() {
  Serial.printf("Connecting to %s ", ssid);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(" 🐗");
  }

  Serial.println(" CONNECTED");
}

void disconnectWifi() {
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
}

void syncWithNTP() {
  configTime(gmtOffset, daylightOffset, ntpServer);
  delay(500);
}

void printLocalTime() {
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return;
  }
  Serial.println(&timeinfo, "%A, %B %d %Y %H:%M:%S");
}

tm timeinfo() {
  struct tm timeinfo;
  getLocalTime(&timeinfo);

  return timeinfo;
}

void turnOnLed(int index) {
  pixels.setPixelColor(index, pixels.Color(1, 0, 1));
}
void turnOffLed(int index) {
  pixels.setPixelColor(index, pixels.Color(0, 0, 0));
}

void switchLeds(int ledPosition, int shift, int decimalValue) {
  const int maxIndex = sizeof(leds)/sizeof(leds[0]) - 1;
  if(ledPosition < 0 || ledPosition > maxIndex) { return; }

  const int remainder = decimalValue - leds[ledPosition];
  if (remainder >= 0 ) { 
    turnOnLed(ledPosition);
    return switchLeds(ledPosition + shift, shift, remainder);
  }         

  turnOffLed(ledPosition);
  return switchLeds(ledPosition + shift, shift, decimalValue);
}

void setup() {
  Serial.begin(115200);

  connectWiFi();
  syncWithNTP();
  disconnectWifi();
}

void loop() {
  delay(1000);
  printLocalTime();

  switchLeds(4, -1,  timeinfo().tm_hour);
  switchLeds(5, 1,  timeinfo().tm_min);

  pixels.show();  
}
