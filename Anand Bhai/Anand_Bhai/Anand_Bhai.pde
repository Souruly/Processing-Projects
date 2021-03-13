import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

boolean blinking = false;
PImage[] frames = new PImage[15]; 
int counter  = 0;
int lastBlink = -1;

void setup() {
  frameRate(15);
  size(548,548);
  for (int i=0; i<15; i++)
  {
    String FrameName = "Frames/Frame " + Integer.toString(i+1) + ".jpg";
    frames[i] = loadImage(FrameName);
  }

  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
}

void draw() {
  scale(2);
  image(frames[counter], 0, 0);

  opencv.loadImage(video);
  Rectangle[] faces = opencv.detect();
  if (faces.length!=1)
  {
    blinking = false;
    if (faces.length>1)
    {
      lastBlink = 0;
      counter = 0;
      fill(255, 255, 0);
    } else
    {
      fill(255, 0, 0);
    }
  } else
  {
    if(lastBlink>random(90,150))
    {
      blinking = true;
      lastBlink = 0;
    }
    else
    {
      blinking = false;
    }
    fill(0, 255, 0);
  }
  ellipse(260, 260, 10, 10);
  if (blinking || (!blinking && counter!=0))
  { 
    counter++;
  }
  else
  {
   counter = 0; 
  }
  counter = counter%15;
  lastBlink++;
  //text(lastBlink,0,260);
}

void captureEvent(Capture c) {
  c.read();
}
