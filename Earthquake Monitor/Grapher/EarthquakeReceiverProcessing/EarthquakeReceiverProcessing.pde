import processing.serial.*;

Serial port;
HashMap<String,ArrayList> sensorHistories = new HashMap<String,ArrayList>();

void setup() 
{
  size(800, 550);
  smooth();
  colorMode(HSB, 255, 100, 100);
  strokeWeight(2);
  port = new Serial(this, "COM16", 9600);
}

void draw()
{
  if(port.available() > 0) {
    String line = port.readStringUntil('\n');
    if((line != null) && (line.indexOf("Listening...") == -1)) {
      String id = safelyExtractName(line);
      int mag = safelyExtractValue(line);
      if( ! sensorHistories.containsKey(id)) sensorHistories.put(id, new ArrayList());
      sensorHistories.get(id).add(new DataSample(millis(),mag));
    }
  }
  clear();
  DataSample previous, current;
  int currentX = 0, currentY = 0, previousX = 0, previousY = 0;
  ArrayList<DataSample> history;
  Object[] keys = sensorHistories.keySet().toArray();
  for (int sensorIndex=0; sensorIndex<keys.length ;sensorIndex++) {
    history = sensorHistories.get(keys[sensorIndex]);
    stroke(convertNameToHue((String)keys[sensorIndex]),100,100);
    if(history.size() > 1) {
      for(int sampleIndex=1; sampleIndex<history.size() ;sampleIndex++) {
        previous = history.get(sampleIndex-1);
        current = history.get(sampleIndex);
        currentX = width - 80 - ((millis() - current.getTime()) / 100);
        currentY = height - (current.getValue() * 2);
        previousX = width - 80 - ((millis() - previous.getTime()) / 100);
        previousY = height - (previous.getValue() * 2);
        // If the calculated position of the current is off the screen, mark previous for removal
        if(currentX < 0) previous.markForRemoval();
        line(previousX, previousY, currentX, currentY);
      }
      // Draw the label at the position of the last point
      text((String)keys[sensorIndex], currentX + 5, currentY + 5);
      for(int sampleIndex=0; sampleIndex<history.size() ;sampleIndex++) {
        if(history.get(sampleIndex).isMarkedForRemoval()) history.remove(sampleIndex);
      }
    }
  }
}

String safelyExtractName(String line)
{
  if(line.length() > 5) return line.substring(0,5);
  else return line;
}

int safelyExtractValue(String line)
{
  if(line.length() > 6) return int(line.substring(6,line.length()-2));
  else return 0;
}

int convertNameToHue(String name)
{
  int count = 0;
  for(int i=0; i<name.length() ;i++) count += (name.charAt(i) * 25);
  return count % 255;
}