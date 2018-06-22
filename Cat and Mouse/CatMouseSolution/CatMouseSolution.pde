import processing.video.*;
import java.awt.*;

// For testing purposes, try using mouse with:
// http://www.freewebarcade.com/game/tough-growth/

Capture camera;
PImage kittenImage;
int cameraWidth = 640;
int cameraHeight = 480;
Robot mouseController;

void setup()
{
  // P2D Specifies that we used a hardware accelerated rendering mode !
  size(640, 480, P2D);
  // Set colour mode to HSB - no need to worry about this bit just yet
  colorMode(HSB, 360, 100, 100);
  camera = new Capture(this, cameraWidth, cameraHeight);
  camera.start();
  kittenImage = loadImage("kitten.png");
  // Set image drawing mode to center images on the specified x and y positions
  imageMode(CENTER);
  try { mouseController = new Robot();
  } catch(AWTException awte) { }
}

void draw()
{
  int pixelCount = 0;
  camera.read();
  // Draw the current image from the camera, centered in the middle of the window
  image(camera, cameraWidth/2, cameraHeight/2);
  int pixel;
  int totalX = 0;
  int totalY = 0;
  for (int x = 0; x<cameraWidth; x++) {
    for (int y = 0; y<cameraHeight; y++) {
      pixel = get(x, y);
      if ((hue(pixel)>350) || (hue(pixel)<10)) {
        if ((saturation(pixel)>50) && (brightness(pixel)>50)) {
          set(x,y,color(255,255,255));
          totalX = totalX + x;
          totalY = totalY + y;
          pixelCount++;
        }
      }
    }
  }
  if (pixelCount > 6) {
    float kittenX = totalX/pixelCount;
    float kittenY = totalY/pixelCount;
    // Draw the image in the correct position and scaled to the right size
    image(kittenImage, kittenX, kittenY, 50+(pixelCount*0.025), 60+(pixelCount*0.03));
    // Scale position within window, to position within screen (need to mirror hoizontally)
    int pointerX = displayWidth - int((kittenX/cameraWidth) * displayWidth);
    int pointerY = int((kittenY/cameraHeight) * displayHeight);
    mouseController.mouseMove(pointerX, pointerY);
  }
}

void mousePressed()
{
  println("Mouse pressed at " + mouseX + " " + mouseY);
}