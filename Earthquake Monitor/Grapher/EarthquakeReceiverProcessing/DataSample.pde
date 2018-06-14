class DataSample
{
  int timestamp;
  int value;
  boolean markedForRemoval = false;
  
  DataSample(int ts, int v)
  {
    timestamp = ts;
    value = v;
  }
  
  int getTime()
  {
    return timestamp;
  }
  
  int getValue()
  {
    return value;
  }
  
  boolean isMarkedForRemoval()
  {
    return markedForRemoval;
  }
  
  void markForRemoval()
  {
    markedForRemoval = true;
  }
}