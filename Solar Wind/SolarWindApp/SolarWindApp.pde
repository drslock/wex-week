import ketai.sensors.*;

String URL = "http://services.swpc.noaa.gov/text/ace-swepam.txt";
String[] data;
int lineNumber = 18;
float offset = 0.0;

void setup()
{
//  size(700,700);
  // data = loadStrings(URL);
  data = loadStrings("ace-swepam.txt");
  noStroke();
  colorMode(HSB, 360, 100, 100);
  KetaiSensor sensor = new KetaiSensor(this);
  sensor.start();
}

void draw()
{
  fill(0,0,0,5);
  rect(0,0,width,height);
  // Roll over to the first line of data (line 18)
  if(lineNumber == data.length) lineNumber = 18;
  String densityString = data[lineNumber].substring(45,48);
  float density = float(densityString);
  if(density != 9.9) {
    fill(120-(density * 35), 100, 100, 20);
    ellipse(width/2 + offset*200, height/2, density*200, density*200);
  }
  lineNumber++;
}

void onGyroscopeEvent(float x, float y, float z)
{
  offset += x;
}