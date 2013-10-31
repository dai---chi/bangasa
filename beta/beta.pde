import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;


import fullscreen.*; 

FullScreen fs;

LeapMotionP5 leap;

//+++++++++++marge define+++++++++++

int flag_cp=0;

//+++++++++++ball definition+++++++++++
int numBalls = 400;
int fps;
float scalez;
// PVector fingerPos;
int shapeType;
float maxVelocity = 16,minAccel = 0.8, maxAccel = 1.8;;

Seeker[] ball = new Seeker[numBalls];

//+++++++++++kasa definition+++++++++++
float theta = 0;
float x , y; 

float gesture_flag = 0;

int flag_1= 0,flag_2= 0;

PVector velocity;

PVector handPos;

float sphereRadius;

int anyu_p = 100;
int anyu_v = 300;


void setup(){
  size(1440,900);
  // size(800,600);

  colorMode(HSB, 255);
  background(0,0,0);
  ellipseMode(RADIUS);
  // frameRate(30);
  noStroke();
  shapeType = 0;
  scalez = 1;
  
  for(int i=0; i<numBalls; i++){
    ball[i] = new Seeker(new PVector(random(width), random(height)));
  }
  
  // numBalls adjusted to a sane default for web distribution
  numBalls = 400;

  leap = new LeapMotionP5(this);

  leap.enableGesture(Type.TYPE_CIRCLE);

  fs = new FullScreen(this); 
  fs.enter();
}

void draw(){
  background(#000000);

  Hand hand = leap.getHand(0);
  handPos = leap.getPosition(hand);

  // fingerPos = leap.getTip(leap.getFinger(0));

  if(flag_cp==0){                         //+++++++++++ball program+++++++++++
    frameRate(60);
    leap.disableGesture(Type.TYPE_CIRCLE);

    if(handPos.z > 0){
      scalez = 1 + handPos.z/1000;
      maxVelocity = 16 + handPos.z/100;

      if(scalez > 3){
        scalez = 3;
      }
      if(maxVelocity > 32){
        maxVelocity = 32;
      }
    }else if(handPos.z < 0){ 
      scalez = 1 + handPos.z/1000;
      maxVelocity = 16 + handPos.z/50;
      if(scalez < 0.5){
        scalez = 0.5;
      }
      if(maxVelocity < 8){
        maxVelocity = 8;
      }
    }else{
     scalez = 1;
    }

    rectMode(CENTER);
    for(int i=0; i<numBalls; i++){
      ball[i].seek(new PVector(handPos.x, handPos.y));
    // ball[i].seek(new PVector(mouseX, mouseY));
      ball[i].render(scalez);
    }
  }else if(flag_cp == 1){                         //+++++++++++bangasa program+++++++++++

    leap.enableGesture(Type.TYPE_CIRCLE);
    velocity = leap.getVelocity(hand);
    sphereRadius = leap.getSphereRadius(hand);
    fill(60,100,80,80);
    noStroke();
    ellipse(handPos.x, handPos.y, 10, 10);

    sphereRadius = sphereRadius-50;
    if(sphereRadius<0){
      sphereRadius = 0;
    }
    int line_p = 16; 
    int c_red=0, c_blue = 240;
    float v = (height/2) - 10; 

    for(int count = 0; count < line_p; count++){
      x =width/2 + v*cos(theta+PI*count/line_p);
      y = height/2 + v*sin(theta+PI*count/line_p);
      stroke( c_red, 150, c_blue, 100 );
      line(x,y,width/2,height/2);
      x =width/2 + -v*cos(theta+PI*count/line_p);
      y = height/2 + -v*sin(theta+PI*count/line_p);
      stroke( c_red, 150, c_blue, 100 );
      line(x,y,width/2,height/2);

      c_red = c_red + 255/line_p;
      // c_blue = c_blue - 255/line_p;
    }

    theta = theta + (gesture_flag)*(PI/62);
    theta = theta % (2*PI);
}
  
}

public void circleGestureRecognized(CircleGesture gesture, String clockwiseness) {
  if (gesture.state() == State.STATE_STOP) {

    gesture_flag = 0;
    flag_1= 0;
    flag_2= 0;
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
    PVector f1 = leap.vectorToPVector(gesture.normal());
    // PVector f2 = leap.vectorToPVector(gesture.pointabl());
    // PVector velocity = leap.getVelocity(hand);
    float  vv, vx ,vy;

    PVector f2 = leap.vectorToPVector(gesture.center());

    vx =  pow(velocity.x, 2);
    vy = pow(velocity.y, 2);
    vv = vx + vy;
    vv= pow(vv, 0.5);
    vv = vv / 1000;

    if(flag_2 == 0){
      if(handPos.y > f2.y + anyu_p && handPos.x > f2.x - anyu_p && handPos.x < f2.x + anyu_p){
        if(velocity.x > anyu_v){
          flag_1 = -1;
          flag_2++;
        }else if (velocity.x < -1 * anyu_v) {
          flag_1 = 1;
          flag_2++;
        }
      }else if(handPos.y < f2.y - anyu_p && handPos.x > f2.x - anyu_p && handPos.x < f2.x + anyu_p){
        if(velocity.x > anyu_v){
          flag_1 = 1;
          flag_2++;
        }else if (velocity.x < -1 * anyu_v) {
          flag_1 = -1;
          flag_2++;
        }
      }else if(handPos.x > f2.x + anyu_p && handPos.y > f2.y - anyu_p && handPos.y < f2.y + anyu_p ){
        if(velocity.y > anyu_v){
          flag_1 = 1;
          flag_2++;
        }else if (velocity.y < -1 *anyu_v) {
          flag_1 = -1;
          flag_2++;
        }
      }else if(handPos.x < f2.x - anyu_p && handPos.y > f2.y - anyu_p && handPos.y < f2.y + anyu_p ){
        if(velocity.y > anyu_v){
          flag_1 = -1;
          flag_2++;
        }else if (velocity.y < -1 *anyu_v) {
          flag_1 = 1;
          flag_2++;
        }
      }
     }
    // System.out.println(flag_1 +"+" + (handPos.y-f2.y) );
    gesture_flag = flag_1 * vv;
    
  }
}



void keyPressed() {
  if (key == 't' || key == 'T') {
    shapeType = 1-shapeType;
  }
  if ((key == 'z' || key == 'Z') ) {
    exit();
  }
  if (key == 'a' || key == 'A') {
    flag_cp = 1 - flag_cp;
    background(#000000);
    if(flag_cp==1){
      maxVelocity = 16;
      scalez = 1;
      numBalls = 0;
    }else{
      numBalls = 400;
    }
  }
}

public void stop() {
  leap.stop();
}