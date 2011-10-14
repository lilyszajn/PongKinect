import processing.net.*;
import SimpleOpenNI.*; 
SimpleOpenNI kinect;
import java.lang.Runtime;

PVector prevRightHandLocation;

Client c;
String input;
int data[];
boolean identified = false;

void setup() { 
  kinect = new SimpleOpenNI(this); 
  kinect.enableDepth(); 
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  size(640, 480); 
  fill(255, 0, 0);

  //initialize prevRightHandLocation
  prevRightHandLocation = new PVector(0, 0, 0);
  // Connect to the server's IP address and port
  c = new Client(this, "128.122.151.161", 8080); // Replace with your server's IP and port
}

void draw() { 
  //set up the kinect part
  kinect.update(); 
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector(); 
  kinect.getUsers(userList);

  if (userList.size() > 0) { 
    int userId = userList.get(0);

    if (kinect.isTrackingSkeleton(userId)) { 
      drawSkeleton(userId);

      // make a vector to store the right hand
      PVector rightHandLocation = new PVector();
      // put the position of the left hand into that vector
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, rightHandLocation);
      
      //find left hand so player can exit
      PVector leftHandLocation = new PVector(); 
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHandLocation);



      float distanceBetweenHands = rightHandLocation.dist(leftHandLocation);

  //is the client connected?
  c.connected();
      //check for information coming from the client
      if (c.available() > 0) {
//        c.write('i');
//        identified = true;
        print((char)c.read());
      }
      if (c.available() > 0 && rightHandLocation.x > (prevRightHandLocation.x + 50)) {
        c.write('r');
        println("move the paddle RIGHT");
      }
        if (c.available() > 0 && rightHandLocation.x < (prevRightHandLocation.x - 50)) {
        c.write('l');
        println("move the paddle LEFT");
      }

        if (c.available() > 0 && rightHandLocation.y < (prevRightHandLocation.y - 10)) {
        c.write('u');
        println("move the paddle UP");
      }
        if (c.available() > 0 && rightHandLocation.y > (prevRightHandLocation.y + 10)) {
        c.write('d');
        println("move the paddle DOWN");
      }
      
      /*else if (distanceBetweenHands < 100) {
        c.write('x');
        println("PLAYER HAS LEFT THE BUILDING");
      }*/

      /*if (rightHandLocation.x < (prevRightHandLocation.x)) {
        println("move right");
        println(rightHandLocation.x);
      }
      if (rightHandLocation.x > (prevRightHandLocation.x)) {
        println("move left");
        println(rightHandLocation.x);
      }

      if (rightHandLocation.y > (prevRightHandLocation.y)) {
        println("move up");
        println(rightHandLocation.y);
      }

      if (rightHandLocation.y < (prevRightHandLocation.y)) {
        println("move down");
        println(rightHandLocation.y);
      }*/
      //make a vector to store the updated position of the right hand to compare to previous position.
      //if different, then locations can be compared
      prevRightHandLocation = rightHandLocation;
    } // end TrackingSkeleton
  } // end userDataAvaialable
}





void drawSkeleton(int userId) { 
  stroke(0); 
  strokeWeight(5);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT); 
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);

  noStroke();

  fill(50, 255, 0); 
  drawJoint(userId, SimpleOpenNI.SKEL_HEAD); 
  drawJoint(userId, SimpleOpenNI.SKEL_NECK); 
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER); 
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW); 
  drawJoint(userId, SimpleOpenNI.SKEL_NECK); 
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER); 
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW); 
  drawJoint(userId, SimpleOpenNI.SKEL_TORSO); 
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP); 
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE); 
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP); 
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT); 
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE); 
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP); 
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT); 
  drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND); 
  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
}

void drawJoint(int userId, int jointID) { 
  PVector joint = new PVector(); 
  float confidence = kinect.getJointPositionSkeleton(userId, jointID, joint); 
  if (confidence < 0.5) {
    return;
  } 
  PVector convertedJoint = new PVector(); 
  kinect.convertRealWorldToProjective(joint, convertedJoint); 
  ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

// user-tracking callbacks! void onNewUser(int userId) {
void onNewUser(int userID) {
  println("start pose detection"); 
  kinect.startPoseDetection("Psi", userID);
}

void onEndCalibration(int userId, boolean successful) { 
  if (successful) {
    println(" User calibrated !!!"); 
    kinect.startTrackingSkeleton(userId);
  } 
  else {
    println(" Failed to calibrate user !!!"); 
    kinect.startPoseDetection("Psi", userId);
  }
}
void onStartPose(String pose, int userId) { 
  println("Started pose for user"); 
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

//map to distance from head


//172.26.14.137
