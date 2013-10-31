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
int flag_changeAnime=0;
float c_c = 0.0;

//+++++++++++ball definition+++++++++++
int numBalls = 100;
int fps;
float scalez;
// PVector fingerPos;
int shapeType;
float maxVelocity = 16,minAccel = 0.8, maxAccel = 1.8;;

Seeker[] ball = new Seeker[numBalls];

float hantei_pos_x,hantei_pos_y,hantei_area = 60;
int flag_count = 0,count_max = 60;
int flag_r=0;
int flag_tap_sakura=0;
float r_x,r_y; 

//+++++++++++kasa definition+++++++++++
float theta = 0;
float x , y; 

float gesture_flag = 0;

int flag_1= 0,flag_2= 0;

PVector velocity;

PVector handPos;

float sphereRadius;

float turns=0;
int flag_turns=0;

int anyu_p = 100;
int anyu_v = 300;

 
void setup(){
  // size(1440,900);
  // size(800,600);
  size(1280,800);

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
  // numBalls = 400;

  leap = new LeapMotionP5(this);

  fs = new FullScreen(this); 
  fs.enter();

  frameRate(60);
}

void draw(){

  if(flag_changeAnime == 1){
    if(200 < c_c){
      c_c = 0;
      flag_changeAnime = 0;
      flag_turns = 0;
    }
    fill(0, (c_c/10));
    noStroke();
    rect(0, 0, 2*width, 2*height);
    c_c  = c_c + 1.5;
    return;
  }

  background(#000000);

  Hand hand = leap.getHand(0);
  handPos = leap.getPosition(hand);

  // fingerPos = leap.getTip(leap.getFinger(0));

  if(flag_cp==0){                         //+++++++++++ball program+++++++++++
    leap.disableGesture(Type.TYPE_CIRCLE);
    leap.disableGesture(Type.TYPE_SCREEN_TAP);
    noStroke();
    if(handPos.z > 0){
      scalez = 1 + handPos.z/1000;
      maxVelocity = 16 + handPos.z/50;

      if(scalez > 2){
        scalez = 2;
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

    ;

    float shikaku = (((height/2) - 30)/sqrt(2)) - 30;
    if(flag_r==0){
      r_x = random(width/2 - shikaku,width/2 + shikaku);
      r_y = random(height/2 - shikaku, height/2 + shikaku);
      flag_r = 1;
    }
    hantei_pos_x = r_x;
    hantei_pos_y = r_y;

    sakura(r_x,r_y,50 + flag_count*3);

    if(hantei_pos_x + hantei_area > handPos.x && hantei_pos_x - hantei_area < handPos.x){
      if(hantei_pos_y + hantei_area > handPos.y && hantei_pos_y - hantei_area < handPos.y){
        flag_count++;
      }
    }else{
      flag_count = 0;
    }

    if(flag_count > count_max){
      flag_count = 0;
      flag_r = 0;
      if(flag_tap_sakura > 4){
        flag_tap_sakura = 0;
        programChange();
        }else{
          flag_tap_sakura++;
        }
    }

    // System.out.println("count" + flag_count);

    rectMode(CENTER);
    for(int i=0; i<numBalls; i++){
      ball[i].seek(new PVector(handPos.x, handPos.y));
    // ball[i].seek(new PVector(mouseX, mouseY));
      ball[i].render(scalez);
    }

    if(flag_count > count_max){
      sakura(r_x,r_y,255);
      flag_count = 0;
      flag_r = 0;
      if(flag_tap_sakura > 4){
        flag_tap_sakura = 0;
        programChange();
      }else{
          flag_tap_sakura++;
      }
    }

  }else if(flag_cp == 1){                         //+++++++++++bangasa program+++++++++++

    leap.enableGesture(Type.TYPE_CIRCLE);
    velocity = leap.getVelocity(hand);
    sphereRadius = leap.getSphereRadius(hand);
    fill(60,100,80,200);
    noStroke();
    ellipse(handPos.x, handPos.y, 10, 10);

    sphereRadius = sphereRadius-50;
    if(sphereRadius<0){
      sphereRadius = 0;
    }
    int line_p = 16; 
    int c_red=0, c_blue = 180;
    float v = (height/2) - 30; 
    strokeWeight(2);
    for(int count = 0; count < line_p; count++){
      x =width/2 + v*cos(theta+PI*count/line_p);
      y = height/2 + v*sin(theta+PI*count/line_p);
      stroke( c_red, 100, c_blue, 255 );
      line(x,y,width/2,height/2);
      x =width/2 + -v*cos(theta+PI*count/line_p);
      y = height/2 + -v*sin(theta+PI*count/line_p);
      stroke( c_red, 100, c_blue, 255 );
      line(x,y,width/2,height/2);

      c_red = c_red + 255/line_p;
      // c_blue = c_blue - 255/line_p;
    }

    strokeWeight(10);
    stroke(0,0,150,255);
    noFill();

    if(flag_turns == 0){
      if(flag_1 == 1){
        arc( width/2, height/2, v+3, v+3, 3*PI/2, (turns/3)*PI + 3*PI/2);
      }else if(flag_1 == -1){
        arc( width/2, height/2, v+3, v+3, 3*PI/2, 2*PI + 3*PI/2);
        strokeWeight(12);
        stroke(0,0,0,255);
        arc( width/2, height/2, v+4, v+4, 3*PI/2, 2*PI + 3*PI/2 - (turns/3)*PI);
      }
    }

    if(flag_turns == 1){
      leap.enableGesture(Type.TYPE_SCREEN_TAP);
      arc( width/2, height/2, v+3, v+3, 3*PI/2, 2*PI + 3*PI/2);
      fill(0, 0, 255, 255);
      textSize(80);
      textAlign(CENTER, CENTER);
      text("PUSH",width/2,height/2);
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
    turns=0;
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
    PVector f1 = leap.vectorToPVector(gesture.normal());
    // PVector f2 = leap.vectorToPVector(gesture.pointabl());
    // PVector velocity = leap.getVelocity(hand);
    float  vv, vx ,vy;
    turns = gesture.progress();

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

    if(turns>6){
      turns = 0;
      flag_turns = 1;
      // programChange();
    }

    gesture_flag = flag_1 * vv;
    
  }
}


public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    if(flag_turns==1){
      flag_turns = 0;
      programChange();
    }
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}


void programChange(){
  flag_cp = 1 - flag_cp;
  // background(#000000);
  // flag_turns = 0;
  leap.disableGesture(Type.TYPE_CIRCLE);
  if(flag_cp==1){
    maxVelocity = 16;
    scalez = 1;
  }else{
  }
  flag_changeAnime = 1;
}


void keyPressed() {
  if (key == 't' || key == 'T') {
    shapeType = 1-shapeType;
  }
  if ((key == 'z' || key == 'Z') ) {
    exit();
  }
  if (key == 'a' || key == 'A') {
    programChange();
  }
}



void sakura(float x,float y, float meid) {
    
    translate(x, y);
    float inner_s;
      for (int i = 0; i < 5;i++) {
        //translate(x, y);
        pushMatrix();
        colorMode(HSB, 255);
        rotate(radians(360 * i / 5));
        fill(255,200, meid,255);
//         heart(0, -3, 15, 30);
        heart(0, -30*0.4,45*0.4, 75*0.4);
        popMatrix();
      }
    translate(-x, -y);
  }
 
  //お借りしました
  //Proce55ing.walker,blog Processingで五角形・六角形・ハート形を描く
  //http://blog.p5info.com/?p=28
  void heart(float centerX, float centerY, float width, float height) {
    final float WIDTH = width / 2 * 0.85;
    final float HEIGHT = height / 2;
    final float OFFSET = centerY - (HEIGHT / 6 * 5);
    beginShape();
    for (int i = 0; i < 30; i++) {
      float tx = abs(sin(radians(i * 12))) * (1 + cos(radians(i * 12))) * sin(radians(i * 12)) * WIDTH + centerX;
      float ty = (0.8 + cos(radians(i * 12))) * cos(radians(i * 12)) * HEIGHT + OFFSET;
      vertex(tx, ty);
    }
    endShape(CLOSE);
  }


public void stop() {
  leap.stop();
}