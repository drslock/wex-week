#include <SPI.h>
#include <Mirf.h>
#include <nRF24L01.h>
#include <MirfHardwareSpiDriver.h>

float stationaryX, stationaryY, stationaryZ;
byte id[5] = "STEVE";
int payloadSize = 9;

void setup()
{
  Mirf.spi = &MirfHardwareSpi;
  Mirf.init();
  Mirf.setRADDR(id);
  Mirf.setTADDR("GRAPH");
  Mirf.payload = payloadSize;
  Mirf.channel = 90;
  Mirf.config();
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  pinMode(A5, INPUT);
  stationaryX = float(analogRead(A3));
  stationaryY = float(analogRead(A4));
  stationaryZ = float(analogRead(A5));
  Serial.begin(9600);
}

void loop()
{
  byte message[payloadSize];
  int currentX = analogRead(A3);
  int currentY = analogRead(A4);
  int currentZ = analogRead(A5);
  int diffX = currentX - stationaryX;
  int diffY = currentY - stationaryY;
  int diffZ = currentZ - stationaryZ;
  int mag = sqrt((diffX * diffX) + (diffY * diffY) + (diffZ * diffZ));
  if (mag > 1) {
    message[0] = 0x00;
    message[1] = id[0];
    message[2] = id[1];
    message[3] = id[2];
    message[4] = id[3];
    message[5] = id[4];
    message[6] = highByte(mag);
    message[7] = lowByte(mag);
    message[8] = 0xFF;
    Mirf.send(message);
    while (Mirf.isSending()) delay(1);
  }
  // Very slowly adapt the stationary values to current rest condition
  stationaryX = lerp(stationaryX, float(currentX), 0.01);
  stationaryY = lerp(stationaryY, float(currentY), 0.01);
  stationaryZ = lerp(stationaryZ, float(currentZ), 0.01);
}

float lerp(float a, float b, float x)
{
  return a + x * (b - a);
}
