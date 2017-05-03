//adapted from https://github.com/nok/leap-motion-processing/blob/master/examples/e1_basic/e1_basic.pde
//Sends 15 features ((x,y,z) tip of each finger) to Wekinator
// sends to port 6448 using /wek/inputs message

import de.voidplus.leapmotion.*;

import oscP5.*;
import netP5.*;

int num=0;
OscP5 oscP5;
NetAddress dest;
LeapMotion leap;
int numFound = 0;

float[] handData = new float[3*2]; // x, y, z for each hand, assuming up to 2 hands


void setup() {
  size(1000, 500, OPENGL);
  background(255);
  // ...

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);

  leap = new LeapMotion(this);  
}

void draw() {
  background(255);
  // ...
  int fps = leap.getFrameRate();
  
  //left hand ellipse
  ellipse(handData[0], handData[1], 20, 20);
  
  //right hand ellipse
  ellipse(handData[3], handData[4], 20, 20);


  // ========= HANDS =========
  numFound = 0;
  handData[0]=0;
  handData[1]=0;
  handData[2]=0;
  handData[3]=0;
  handData[4]=0;
  handData[5]=0;

  for (Hand hand : leap.getHands ()) {
    int handOffset = 0;
    numFound++;
    if (hand.isLeft()){
      handOffset = 0;
    }else if (hand.isRight()){
      handOffset = 3;
    }

    handData[0+handOffset] = hand.getStabilizedPosition().x;
    handData[1+handOffset] = hand.getStabilizedPosition().y;
    handData[2+handOffset] = hand.getStabilizedPosition().z;
  }
  
  // =========== OSC ============
  if (num % 3 == 0) {
     sendOsc();
  }
  num++;
}



// ========= CALLBACKS =========

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

//====== OSC SEND ======
void sendOsc() {
  OscMessage msg = new OscMessage("/handpositions");
  if (numFound > 0) {
    for (int i = 0; i < handData.length; i++) {
      msg.add(handData[i]);
    }
    oscP5.send(msg, dest);
  }   
}