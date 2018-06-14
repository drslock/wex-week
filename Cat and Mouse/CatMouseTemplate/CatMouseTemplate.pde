import processing.video.*;
import java.awt.*;

Capture camera;
int cameraWidth = 640;
int cameraHeight = 480;
Robot mouseController;

void setup()
{
  // P2D Specifies that we use a hardware accelerated rendering mode !
  size(640, 480, P2D);
  // Set colour mode to HSB - no need to worry about this bit just yet
  colorMode(HSB, 360, 100, 100);
  camera = new Capture(this, cameraWidth, cameraHeight);
  camera.start();
  // Set image drawing mode to center images on the specified x and y positions
  imageMode(CENTER);
}

void draw()
{
  camera.read();
  // Draw the current image from the camera, centered in the middle of the window
  image(camera, cameraWidth/2, cameraHeight/2);
  int pixel;
  for (int x = 0; x<cameraWidth; x++) {
    for (int y = 0; y<cameraHeight; y++) {
      pixel = get(x,y);
      if (brightness(pixel) > 50) {
          set(x, y, color(0,0,0)); // Black colour in HSB
      }
      else {
          set(x, y, color(0,0,100)); // White colour in HSB
      }
    }
  }
}

void mousePressed()
{
  println("Mouse pressed at " + mouseX + " " + mouseY);
}