class Drop
{
    PVector position;
    PVector initialPosiition;
    PVector velocity;
    PVector acceleration;
    float maxForce = 0.3;
    float maxSpeed = 4;
    int radius;
    float desiredSeparation;
    
    Drop(float x,float y)
    {
        position = new PVector(x,y);
        initialPosiition = position.copy();
        velocity = new PVector(random(-5,5),0);
        acceleration = new PVector(0,0);
        radius = 5;
        desiredSeparation = 100;
    }
    
    void show()
    {
       fill(0);
       stroke(0);
       ellipse(position.x,position.y,5,5);
    }
    
    void update(PVector extObject)
    {
       applyBehaviours(extObject);
       position.add(velocity);
       velocity.add(acceleration);
       acceleration = new PVector(0,0);
       if(position.x>width || position.x<0 || position.y>height )
       {
          position = new PVector(random(5,width-5),random(-100,0));
          velocity.mult(0);
       }
    } 
    
    void applyBehaviours(PVector extObject)
    {
       PVector gravity = gravitate();
       PVector repulsion = repel(extObject);
        
       gravity.mult(1);
       repulsion.mult(7);
       
       applyForce(gravity);
       applyForce(repulsion);      
    }
    
    PVector gravitate()
    {
        PVector gravity = new PVector(0,2);
        gravity.limit(maxForce);
        return gravity;
    }
    
   PVector repel(PVector extObject)
    {
        PVector sum = new PVector(0,0);
        PVector steer = new PVector(0,0);
        int count = 0;
        //for(Bird other : B)
        //{
          float d = PVector.dist(position,extObject);
          if(d>0 && d<desiredSeparation)
          {
             PVector diff = PVector.sub(position,extObject);
             diff.normalize();
             diff.div(d);
             sum.add(diff);
             count++;
          }
        //}
        if(count>0)
        {
         sum.div((float)count);
         sum.normalize();
         sum.mult(maxSpeed);
         steer = PVector.sub(sum,velocity);
         steer.limit(maxForce);
         
          //applyForce(steer);
        }
        return steer;
    }
    
    void applyForce(PVector force) 
    {
        acceleration.add(force);
    }
}