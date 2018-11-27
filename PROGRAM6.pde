/*
  A rocket that could be used in several different 2D video games.
 You control it with the arrow keys or 'a' and 'd' plus the mouse for thrust.
 by Charlie McDowell
 */
 
//images loaded
PImage boom;
PImage earth;
PImage ship;
PImage astronaut;
PImage aFlag;
PImage cFlag;

// the twinlking star locations
int[] starX = new int[1000];
int[] starY = new int[1000];
int starSize = 3; // the size of the twinkling stars
color[] starColor = new color[1000];

// the tail of the shooting star
int[] shootX = new int[30];
int[] shootY = new int[30];
int METEOR_SIZE = 10; // initial size when it first appears
float meteorSize = METEOR_SIZE; // size as it fades
float meteorSpeed = 0.05;
int meteorDuration = 40;

// distance a shooting star moves each frame - varies with each new shooting star
float ssDeltaX, ssDeltaY; 
// -1 indicates no shooting star, this is used to fade out the star
int ssTimer = -1;
// starting point of a new shooting star, picked randomly
int startX, startY;

void setup() {
  size(1300, 900);
  frameRate(60);
  for (int i = 0; i < starX.length; i++) {
    starX[i] =(int)random(width);
    starY[i] = (int)random(height);
    starColor[i] = color((int)random(100, 255));
  }
  rocket = new Rocket(width/5, height/3);
  //adding images to make the program more asthetically pleasing
  boom = loadImage("201.gif");
  astronaut =loadImage("astronaut.png");
  aFlag =loadImage("flag1.png");
  cFlag=loadImage("flag2.png");
  ship=loadImage("spaceship.png");
  earth=loadImage("earth.png");
}

Rocket rocket;
void draw() {
  background(0, 0, 50); // dark blue night sky

  // draw the stars
  // the stars seem to show best with black outlines that aren't really perceived by the eye
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i < starX.length; i++) {
    fill(random(50, 255)); // makes them twinkle
    if (random(10) < 1) {
      starColor[i] = (int)random(100, 255);
    }
    fill(starColor[i]);

    ellipse(starX[i], starY[i], starSize, starSize);
  }
  pushStyle();
  // draw the shooting star (if any)
  for (int i = 0; i < shootX.length-1; i++) {
    int shooterSize = max(0, int(meteorSize*i/shootX.length));
    // to get the tail to disappear need to switch to noStroke when it gets to 0
    if (shooterSize > 0) {
      strokeWeight(shooterSize);
      stroke(255);
    } else
      noStroke();
    line(shootX[i], shootY[i], shootX[i+1], shootY[i+1]);
    // ellipse(shootX[i], shootY[i], meteorSize*i/shootX.length,meteorSize*i/shootX.length);
  }
  popStyle();
  meteorSize*=0.9; // shrink the shooting star as it fades

  // move the shooting star along it's path
  for (int i = 0; i < shootX.length-1; i++) {
    shootX[i] = shootX[i+1];
    shootY[i] = shootY[i+1];
  }

  // add the new points into the shooting star as long as it hasn't burnt out
  if (ssTimer >= 0 && ssTimer < meteorDuration) {
    shootX[shootX.length-1] = int(startX + ssDeltaX*(ssTimer));
    shootY[shootY.length-1] = int(startY + ssDeltaY*(ssTimer));
    ssTimer++;
    if (ssTimer >= meteorDuration) {
      ssTimer = -1; // end the shooting star
    }
  }

  // create a new shooting star with some random probability
  if (random(5) < 1 && ssTimer == -1) {
    newShootingStar();
  }
  drawMoon();
  rocket.scoreCounter();
  adjustControls(rocket);
  rocket.update();
  rocket.landingSafe();
  rocket.landingCrash();
  //point system on specific locations on the moon
  rocket.score(80, 6*width/8);
  rocket.score(100, 7*width/8);
  rocket.score(50, 5*width/8);
  rocket.score(40, 4*width/8);
  rocket.score(30, 3*width/8);
  reset();
}

/*
  Control the rocket using mouseY for thrust and 'a' or left-arrow for rotating
 counter-clockwise and 'd' or right-arrow for rotating clockwise.
 It takes a single parameter, which is the rocket being controlled.
 */
void adjustControls(Rocket rocket) {
  // control thrust with the y-position of the mouse
  if (mouseY < height/2) {
    rocket.setThrust(height/2 - mouseY);
  } else {
    rocket.setThrust(0);
  }
  // allow for right handed control with arrow keys or
  // left handed control with 'a' and 'd' keys

  // right hand rotate controls
  if (keyPressed) {
    if (key == CODED) { // tells us it was a "special" key
      if (keyCode == RIGHT) {
        rocket.rotateRocket(1);
      } else if (keyCode == LEFT) {
        rocket.rotateRocket(-1);
      }
    }
    // left hand rotate controls
    else if (key == 'a') {
      rocket.rotateRocket(-1);
    } else if (key == 'd') {
      rocket.rotateRocket(1);
    }
  }
}
void drawMoon() {
  image(earth, 700, 400, width/4, height/3);
  fill(254, 252, 215);
  rect(0, 3*height/4, width, height);
  image(ship, width/12, 3*height/4-40, 75, 50);
}
void newShootingStar() {
  int endX, endY;
  startX = (int)random(width);
  startY = (int)random(height);
  endX = (int)random(width);
  endY = (int)random(height);
  ssDeltaX = meteorSpeed*(endX - startX);
  ssDeltaY = meteorSpeed*(endY - startY);
  ssTimer = 0; // starts the timer 
  meteorSize = METEOR_SIZE;
  // by filling the array with the start point all lines will essentially form a point initialy
  for (int i = 0; i < shootX.length; i++) {
    shootX[i] = startX;
    shootY[i] = startY;
  }
}
//resets the code if 'r' is pressed
void reset() {
  if (keyPressed) {
    //if the landing is safe, pressing the restart key will reset the rocket with the remaining fuel and score
    if (key == 'r' & rocket.z==true) {
      rocket.z=false; 
      rocket.x =width/5;
      rocket.y=height/3;
    }
  }
  if (keyPressed) {
    //if the rocket crashes, pressing the restart key will reset fuel and score back to starting values
    if (key == 'r' & rocket.crash==true) {
      rocket= new Rocket(width/5, height/3);
    }
  }
}