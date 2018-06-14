#include <SPI.h>
#include <Mirf.h>
#include <nRF24L01.h>
#include <MirfHardwareSpiDriver.h>

// Replace this with a unique name - must be 5 characters long !
byte id[5] = "STEVE";
// Payload size must always be 9 bytes: 1 start byte + 5 bytes for ID + 2 bytes mag + 1 end byte
int payloadSize = 9;

void setup()
{
  // Initialise the radio library
  Mirf.spi = &MirfHardwareSpi;
  Mirf.init();
  // Tell the radio what your (the sender) ID is
  Mirf.setRADDR(id);
  // Set the name of the device that should receive all sent messages
  Mirf.setTADDR("GRAPH");
  // Set the size of the message array
  Mirf.payload = payloadSize;
  // Choose a channel to communicate on (must be 90)
  Mirf.channel = 90;
  // Tell the radio board to configure itse;f and begin
  Mirf.config();
  // Start the serial line (in case you need to print messages for debugging !)
  Serial.begin(9600);
}

void loop()
{
  byte message[payloadSize];
  // Read in the X, Y and Z values
  // ...
  // Calculate magnitude
  // ...
  // Insert the "message begins" byte into the message array
  // ...
  // Copy the 5 characters from your unique ID into the message array
  // ...
  // Insert calculated magnitude into message array as two separate bytes (high byte & low byte)
  // ...
  // Insert the "message ends" byte into the message array
  // ...
  // Finally send the message
  Mirf.send(message);
  // Wait for the message to get dispatched
  while (Mirf.isSending()) delay(1);
}
