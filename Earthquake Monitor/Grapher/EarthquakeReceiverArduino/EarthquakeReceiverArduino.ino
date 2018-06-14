#include <SPI.h>
#include <Mirf.h>
#include <nRF24L01.h>
#include <MirfHardwareSpiDriver.h>

// 1 start byte + 5 bytes for ID + 2 bytes for the magnitude reading + 1 end byte = 9 bytes
int payloadSize = 9;

void setup()
{
  initialiseRadio();
  Serial.begin(9600);
  Serial.println("Listening...");
}

void initialiseRadio()
{
  Mirf.spi = &MirfHardwareSpi;
  Mirf.init();
  Mirf.setRADDR("GRAPH");
  Mirf.payload = payloadSize;
  Mirf.channel = 90;
  Mirf.config();
}

void loop()
{
  checkForIncomingMessage();
  // The fake bit
  // String id = "FAKE" + String(int(random(0,9)));
  // int mag = random(0,1111);
  //Serial.println(id + " " + mag);
  delay(100);
}

void checkForIncomingMessage()
{
  byte payload[payloadSize];
  if (Mirf.dataReady()) {
    Mirf.getData(payload);
    // Ignore any bad packets (that don't begin and end with the right bytes)
    if ((payload[0] == 0x00) && (payload[payloadSize-1] == 0xFF)) {
      String id = "";
      for (int i = 1; i <= 5 ; i++) id = id + (char)payload[i];
      int mag = joinBytes(payload[6], payload[7]);
      // Composite printlns in Arduino should always begin with a String variable !!!
      Serial.println(id + " " + mag);
    }
  }
}

int joinBytes(byte high, byte low)
{
  return (high * 256) + low;
}

