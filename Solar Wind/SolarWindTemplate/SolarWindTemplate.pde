String URL = "http://services.swpc.noaa.gov/text/ace-swepam.txt";
String[] data;
// Start on line number 18 (previous lines are information and header lines)
int lineNumber = 18;

void setup()
{
  // Set the graphics window to 700x700
  size(700,700);
  // Set colour mode to HSB - no need to worry about this bit just yet
  colorMode(HSB, 360, 100, 100);
  data = loadStrings(URL);
}

void draw()
{
  if(lineNumber < data.length) {
    // Slice out a string containing the density value from the line of data
    String densityString = data[lineNumber].substring(45,48);
    // Convert the density string into a floating point number (needed for calculations !)
    float density = float(densityString);
    println("Density is " + density);
  }
  lineNumber++;
}