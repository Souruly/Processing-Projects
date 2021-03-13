import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

Capture video;

int imgW = 320;
int imgH = 240;
OpenCV opencv;
Rectangle[] faces;

PImage img;

Drop[] Rain;;
Person u;

int numberOfDrops = 20;
int camView = -1;

void setup()
{
    size(640,480);
    ellipseMode(RADIUS);
    rectMode(CORNERS);
    Rain = new Drop[numberOfDrops];
    for(int i=0 ; i<numberOfDrops ; i++)
    {
       Rain[i] = new Drop(random(5,width),0);
    }    
    video = new Capture(this, 640, 480);  
    video.start();
    u = new Person(width/2 , height-100);
}

void captureEvent(Capture video) 
{  
  // Step 4. Read the image from the camera.  
  video.read();
}

void draw()
{
    background(255);
    img = video.copy();
    img.resize(imgW,imgH);
    opencv = new OpenCV(this, img);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    faces = opencv.detect();
    if(camView>0)
    {
      image(img, 0, 0);
    }
    
    float xP,yP,count;
    xP = yP = 0;
    count = 0;
    
    for (int i = 0; i < faces.length; i++) 
    {
      int w = faces[i].width;
      int h = faces[i].height;
      int x = faces[i].x + w/2;
      int y = faces[i].y + h/2;
      
      xP = xP + x;
      yP = yP + y;
      count++;
      /*
      Person p= new Person(X,Y,W,H);
      People.add(p);
      */
      if(camView>0)
      {
        fill(0,255,0);
        ellipse(x,y,5,5);
      }
    }
    
    if(count>0)
    {
        xP = xP/count;
        yP = yP/count;
        xP = map(xP,0,imgW,width,0);
        yP = map(yP,0,imgH,0,height);
        
    }
    else
    {
       xP = width/2;
       yP = height-100;
    }

    PVector extObject = new PVector(xP,yP);
    u.update(extObject);
    if(camView<0)
    {
       /*
        for(Person p : People)
        {
           p.show(); 
        }
        */
       u.show();
    }
     
    for(int i = 0; i<numberOfDrops ; i++)
    {  
       if(camView<0)
       {
           Rain[i].show();
       }
       Rain[i].update(extObject);
    }
    
    textAlign(CENTER,CENTER);
    textSize(16);
    stroke(0);
    strokeWeight(2);
    noFill();
    rect(500,30,640,0);
    fill(0);
    text("CHANGE VIEW",570,10);
}

void mousePressed()
{
    float x = pmouseX;
    float y = pmouseY;
    if(x<width && x>=500 && y>=0 && y<=30)
    {
       camView = camView*-1;
    }
    
}
