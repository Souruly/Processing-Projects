import processing.serial.*;

PImage rainbow;    //rainbow image
PImage logo;    //TEDxPICT LOGO
int pos;    //Initial position of Pointer Triangle 
int score;    //Raw Score
int nScore;    //Normalized Score
int x;    //stores string length
int timer;    //timer of 20s
String val;        // To store input from Arduino
int colorDecider = 0;
boolean firstContact = false;

boolean keyP = false;


Serial myPort;    //Serial connection to Arduino


void resetVariables()
{
  pos = 0;    //Initial position of Pointer Triangle 
  score = 0;    //Raw Score
  nScore = 0;    //Normalized Score
  timer = 0;    //timer of 20s
}
void setup() 
{
  //Sketch setup
  frameRate(60);
  size(800,600);
  
  //Loading Images
  rainbow = loadImage("Rainbow-3.png");
  logo = loadImage("Logo_Black.png");
  
  //Arduino Connection
   String portName = Serial.list()[0];
   myPort = new Serial(this, portName, 9600);

  resetVariables();
}

void draw() 
{  
  background(0);    //Black Background
  
  //Displaying images - Rainbow,Logo
  imageMode(CORNERS);
  image(rainbow, 50, 50, 750, 550);
  image(logo,633,0,800,50);
  /*
  //Getting input from Arduino
  if(myPort.available()>0)
  {
    val = myPort.readStringUntil('\n');
  }
  if(val!=null)
  {
    x = val.length()-2;
    if(timer<1200)
    {
      score = x;
    }
  }
  */
  
  if(keyPressed == true)
  {
     if(keyCode == UP) 
     {
        keyP = true;
        resetVariables();
        myPort.write('1');
     }
  }
  nScore = score;
  if(score>0 && timer<1200)
  {
    timer ++; 
  }
  if(score>105)
  {
    //score = 84;
    textSize(32);
    fill(255); 
    text("LIMIT REACHED",100,35,200);
  }
  
  //Calculate position of pointer from score
  pos = int(nScore*6.6666666667);    //6.6666666667=700/105. 105 is highest possible score
  textSize(32);
  
  if(timer>=1200)
  {
    fill(255,0,0);
  }
  else
  {
    fill(255); 
  }
  
  text(score,15,35);
  triangle(40+pos, 570, 50+pos, 560, 60+pos, 570);
  fill(255);
  text(int(timer/60),550,35);
  
  colorDecider = floor(nScore/15);
  rectMode(CORNERS);
  stroke(255);
  switch(colorDecider)
  {
     case 0 : 
       fill(147,29,208);
       rect(500,10,530,40);
       fill(255);
       break;
     
     case 1 : 
       fill(73,13,128);
       rect(500,10,530,40);
       fill(255);
       break;
       
     case 2 : 
       fill(11,36,251);
       rect(500,10,530,40);
       fill(255);
       break;
     
     case 3 : 
       fill(41,253,47);
       rect(500,10,530,40);
       fill(255);
       break;
       
     case 4 : 
       fill(255,253,53);
       rect(500,10,530,40);
       fill(255);
       break;
       
     case 5 : 
       fill(253,127,35);
       rect(500,10,530,40);
       fill(255);
       break;
     
     case 6 : 
       fill(252,13,27);
       rect(500,10,530,40);
       fill(255);
       break;
       
     case 7 : 
       fill(0);
       rect(500,10,530,40);
       fill(255);
       break;
  }
  noStroke();
}

void serialEvent( Serial myPort) 
{
//put the incoming data into a String - 
//the '\n' is our end delimiter indicating the end of a complete packet
  val = myPort.readStringUntil('\n');
//make sure our data isn't empty before continuing
  if (val != null) 
  {
    //trim whitespace and formatting characters (like carriage return)
    val = trim(val);
    println(val.length());
    //look for our 'A' string to start the handshake
    //if it's there, clear the buffer, and send a request for data
    if (firstContact == false)
    {
      if (val.equals("A")) 
      {
        myPort.clear();
        firstContact = true;
        myPort.write("A");
        println("contact");
      }
    }
    else 
    { 
      //if we've already established contact, keep getting and parsing data
      //println(val);
      
      if (keyP==true) 
      {                           //if we clicked in the window
         myPort.write('1');        //send a 1
         //resetVariables();
         keyP=false;
        
        //println("1");
      }
      
     // when you've parsed the data you have, ask for more:
     //myPort.write("A");
     /*
      if(myPort.available()>0)
      {
        val = myPort.readStringUntil('\n');
      }
     */ 
     // if(val!=null)
     // {
        x = val.length();
        if(timer<1200)
        {
          score = x;
        }
    }
  }
}