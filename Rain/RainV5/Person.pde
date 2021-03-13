class Person
{
   PVector position;
   PVector initPosition;
   PVector velocity;
   PVector acceleration;
   float maxSpeed;
   float maxForce;
   float W,H;
   Person(float x,float y)
   {
       position = new PVector(width/2,height);
      velocity = new PVector(0,0);
       acceleration = new PVector(0,0);
       maxSpeed = 6;
       maxForce = 2;
   }
   /*
   void show()
   {
       stroke(255,0,0);
       strokeWeight(2);
       noFill();
       float x = position.x;
       float y = position.y;
       arc(x,y,80,40,PI,TWO_PI);
   }
  */
  void update(PVector extObject) 
  {
    behaviours(extObject);
    position.add(velocity);
    velocity.add(acceleration);
    acceleration.mult(0);
    if(position.x>width-40)
    {
        position.x = width-40;
    }
    
    if(position.y>height)
    {
        position.y = height;
    }
    
    if(position.x<40)
    {
        position.x = 40;
    }
    
    if(position.y<20)
    {
        position.y = 20;
    }
  }
  
  void behaviours(PVector extObject)
  {
    PVector arrive = arrive(extObject);
   
    arrive.mult(1);

    applyForce(arrive);
  }

  void applyForce(PVector force) 
  {
    acceleration.add(force);
  }
  
  PVector arrive(PVector target) 
  {
    PVector desired = PVector.sub(target, position);
    float d = desired.mag();
    float speed = maxSpeed;
    if (d < 100)
    {
      speed = map(d, 0, 100, 0, maxSpeed);
    }
    desired.setMag(speed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }
  
  PVector getPosition()
  {
     return position; 
  }
   
  void show()
  {
        int W = 40;
        int H = 50;
       stroke(0);
       strokeWeight(2);
       fill(255,0,0);
       float x = position.x;
       float y = position.y;
       ellipse(x,y,W/2,H/2);
       rect(x-3*W/4,y+H/2,x+3*W/4,height,20);
  }
}