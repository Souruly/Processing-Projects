import com.thomasdiewald.ps3eye.PS3EyeP5;

PS3EyeP5 ps3eye;
PImage video;

int blobCounter = 0;

int maxLife = 50;

color trackColor; 
float threshold = 40;
float distThreshold = 50;

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(640, 480);

  ps3eye = PS3EyeP5.getDevice(this);

  if (ps3eye == null) {
    System.out.println("No PS3Eye connected. Good Bye!");
    exit();
    return;
  }
  ps3eye.start();

  // White
  trackColor = color(255, 128, 0);
}

void keyPressed() {
  if (key == 'a') {
    distThreshold+=5;
  } else if (key == 'z') {
    if (distThreshold>5)
    {
      distThreshold-=5;
    }
  }
  if (key == 's') {
    threshold+=5;
  } else if (key == 'x') {
    if (threshold>5)
    {
      threshold-=5;
    }
  }
}

void draw() 
{
  video = ps3eye.getFrame();
  video.resize(640, 480);
  video.loadPixels();
  image(video, 0, 0);

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {

        boolean found = false;
        for (Blob b : currentBlobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          currentBlobs.add(b);
        }
      }
    }
  }

  for (int i = currentBlobs.size()-1; i >= 0; i--) {
    if (currentBlobs.get(i).size() < 500) {
      currentBlobs.remove(i);
    }
  }

  // There are no blobs!
  if (blobs.isEmpty() && currentBlobs.size() > 0) {
    println("Adding blobs!");
    for (Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()) {
    // Match whatever blobs you can match
    for (Blob b : blobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !cb.taken) {
          recordD = d; 
          matched = cb;
        }
      }
      matched.taken = true;
      b.become(matched);
    }

    // Whatever is leftover make new blobs
    for (Blob b : currentBlobs) {
      if (!b.taken) {
        b.id = blobCounter;
        blobs.add(b);
        blobCounter++;
      }
    }
  } else if (blobs.size() > currentBlobs.size()) {
    for (Blob b : blobs) {
      b.taken = false;
    }


    // Match whatever blobs you can match
    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !b.taken) {
          recordD = d; 
          matched = b;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.lifespan = maxLife;
        matched.become(cb);
      }
    }

    for (int i = blobs.size() - 1; i >= 0; i--) {
      Blob b = blobs.get(i);
      if (!b.taken) {
        if (b.checkLife()) {
          blobs.remove(i);
          blobCounter--;
          int l = blobs.size()-1;
          if (l>0)
          {
            blobs.get(l).id--;
          }
        }
      }
    }
  }

  for (Blob b : blobs) {
    b.show();
  } 

  if (blobs.size()>0)
  {
    float playerLocation = round(map(blobs.get(0).minx, 0, width, 48, 35));
    float index = (playerLocation-49)/12;
    float mul = pow(base, index);
    frequency = mul * 440;

    //amp = map(blobs.get(0).miny, 0, height, 0.9, 0);
    amp = 1.5;
    sine.freq(frequency);
    if (keyPressed == true) 
    {
      if (keyCode == DOWN) 
      {
        amp=0;
      }
    } 
    sine.amp(amp);
  } else
  {
    sine.amp(0);
  }

  for (int i=0; i<width; i+=keyWidth)
  {
    stroke(255);
    line(i, 0, i, height);
  }
  textAlign(RIGHT);
  fill(255);
  //text(currentBlobs.size(), width-10, 40);
  //text(blobs.size(), width-10, 80);
  textSize(24);
  text("color threshold: " + threshold, width-10, 50);  
  text("distance threshold: " + distThreshold, width-10, 25);
  text("Frequency : " + frequency, width-10, 75);  
  text("Amplitude : " + amp, width-10, 100);  
  text("KeyWidth : " + keyWidth, width-10, 125);
  
  textSize(32);
  float offset = 32; 
  text("C",offset,height/2);
  offset += keyWidth;
  text("B",offset,height/2);
  offset += keyWidth + 12;
  text("A#",offset,height/2);
  offset += keyWidth;
  text("A",offset-13,height/2);
  offset += keyWidth;
  text("G#",offset,height/2);
  offset += keyWidth;
  text("G",offset-13,height/2);
  offset += keyWidth;
  text("F#",offset,height/2);
  offset += keyWidth;
  text("F",offset-13,height/2);
  offset += keyWidth;
  text("E",offset-13,height/2);
  offset += keyWidth;
  text("D#",offset,height/2);
  offset += keyWidth;
  text("D",offset-13,height/2);
  offset += keyWidth;
  text("C#",offset,height/2);
  offset += keyWidth;
  text("C",offset-13,height/2);
  offset += keyWidth;
}


float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
  println(red(trackColor), green(trackColor), blue(trackColor));
}