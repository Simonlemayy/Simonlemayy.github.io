/*
  A simple rocket class, operating in a vacuum (no friction)
 but with gravity pulling it down.
 by Charlie McDowell 
 */
class Rocket {
  /*
   Initial location of the rocket.
   @param startX - horizontal location
   @param startY - vertical location
   */
   //booleans
  boolean z = false;
  boolean crash = false;
  
  //int
  int score=0;
  
  //floats
  float fuel = FUEL_CONSUMPTION;
  float r;
  float lifeSupport = 100;
  
  Rocket(int startX, int startY) {
    x = startX;
    y = startY;
  }

  /*
   Decrease the thrust by the specified amount where decreasing by 100 will
   immediately reduce thrust to zero.
   */
  void setThrust(int amount) {
    amount = constrain(amount, 0, 100);
    thrust = MAX_THRUST*amount/100;
    if (thrust < 0) thrust = 0;
    if (z==false && fuel>0) {
      fuel = fuel-FUEL_CONSUMPTION*thrust/20;//setting the fuel proportional to thrust
    } else if (fuel<=0) {
      thrust = 0;
      fuel = 0;
    }
    //displaying the fuel level, which goes from yellow to red once fuel is empty
    if (fuel<=0) {
      textSize(25);
      fill(255, 0, 0);
      text("FUEL LEVEL:", 3*width/4, height/7);
      text(fuel, 8*width/9, height/7);
    } else if (fuel>0) {
      textSize(25);
      fill(255, 255, 0);
      text("FUEL LEVEL:", 3*width/4, height/7);
      text(fuel, 8*width/9, height/7);
    }
  }
  /*
   Rotate the rocket positive means right or clockwise, negative means
   left or counter clockwise.
   */
  void rotateRocket(int amt) {
    tilt = tilt + amt*TILT_INC;
  }

  /*
   Adjust the position and velocity, and draw the rocket.
   */
  void update() {
    pushStyle();
    x = x + xVel;
    y = y + yVel;
    xVel = xVel - cos(tilt)*thrust;
    yVel = yVel - sin(tilt)*thrust + GRAVITY;
    // to make it more stable set very small values to 0
    if (abs(xVel) < 0.00005) xVel = 0;
    if (abs(yVel) < 0.00005) yVel = 0;

    //display x and y velocity
    text("Life Support:", 3*width/4, height/4-15);
    text(lifeSupport, 7*width/8, height/4-15);
    // draw it
    if (crash==true) {
      r = r + 0.1;
      pushMatrix();
      translate(x, y);
      rotate(tilt - HALF_PI); 
      // draw the rocket body

      rotate(r);
      fill(255);


      stroke(0);
      triangle(0, -35, -12, -25, 13, -25);
      ellipse(-14, -10, 15, 15);
      ellipse(14, -10, 15, 15);

      rect(-12, -25, 25, 25); // bad magic numbers here for the simple rocket body
      fill(0);
      ellipse(0, -15, 10, 10);
      stroke(255);
      line(-10, 0, -15, 10);
      line(10, 0, 15, 10);
      rect(-20, 10, 7, 1);
      rect(15, 10, 7, 1);
      // draw the rocket thrust "flames"
      fill(0);
      textSize(7);
      text("NASA", -10, -3);
      pushStyle();
      fill(255, 0, 0);
      stroke(200, 0, 0);
      triangle(-2, 0, 2, 0, 0, thrust * FLAME_SCALE);
      triangle(-4, 0, 0, 0, 0, thrust * FLAME_SCALE/2);
      triangle(2, 0, 4, 0, 0, thrust * FLAME_SCALE/2);
      popStyle();
      popMatrix();
    } else {
      pushMatrix();
      translate(x, y);
      rotate(tilt - HALF_PI); 
      // draw the rocket body
      fill(255);


      stroke(0);
      triangle(0, -35, -12, -25, 13, -25);
      ellipse(-14, -10, 15, 15);
      ellipse(14, -10, 15, 15);

      rect(-12, -25, 25, 25); // bad magic numbers here for the simple rocket body
      fill(0);
      ellipse(0, -15, 10, 10);
      stroke(255);
      line(-10, 0, -15, 10);
      line(10, 0, 15, 10);
      rect(-20, 10, 7, 1);
      rect(15, 10, 7, 1);
      // draw the rocket thrust "flames"
      fill(0);
      textSize(7);
      text("NASA", -10, -3);
      pushStyle();
      fill(255, 0, 0);
      stroke(200, 0, 0);
      triangle(-2, 0, 2, 0, 0, thrust * FLAME_SCALE);
      triangle(-4, 0, 0, 0, 0, thrust * FLAME_SCALE/2);
      triangle(2, 0, 4, 0, 0, thrust * FLAME_SCALE/2);
      popStyle();
      popMatrix();
    }
    if (fuel==0) {
      lifeSupport =lifeSupport-.5;
    }
    if (lifeSupport==0) {
      crash=true;
    } else if (lifeSupport==0) {
      lifeSupport=0;
    }
    if (xVel>0.5 || xVel<-0.5) {
      fill(255, 0, 0);
      textSize(25);
      text("xVel:", 3*width/4, height/6+5);
      text(xVel, 4*width/5, height/6+5);
    } else if (xVel<=0.5 || xVel>=-0.5) {
      fill(255, 255, 0);
      textSize(25);
      text("xVel:", 3*width/4, height/6+5);
      text(xVel, 4*width/5, height/6+5);
    }
    if (yVel>1) {
      fill(255, 0, 0);
      textSize(25);
      text("yVel:", 3*width/4, height/5);
      text(yVel, 4*width/5, height/5);
    } else if (yVel<=1 || yVel>=-1) {
      fill(255, 255, 0);
      textSize(25);
      text("yVel:", 3*width/4, height/5);
      text(yVel, 4*width/5, height/5);
    }
    if (tilt>=2 || tilt<=1) {
      textSize(25);
      fill(255, 0, 0);
      text("Tilt:", 3*width/4, height/4+10);
      text(tilt, 8*width/9, height/4+10);
    } else if (tilt<2 && tilt>1 ) {
      textSize(25);
      fill(255, 255, 0);
      text("Tilt:", 3*width/4, height/4+10);
      text(tilt, 8*width/9, height/4+10);
    }
  }
  void landingSafe() {
    //safe landing code
    if ((y+10>3*height/4 && yVel <= 1 &&  abs(xVel)<=0.5 && (tilt >=1 || tilt<=2))) {
      z = true;
    }
    if (z==true) {
      yVel = 0;
      xVel = 0;
      textSize(25);
      fill(255, 255, 0);
      text("Safe Landing", 2*width/5+30, height/2);
      text("Press R to land again", 2*width/5, height/2+30);
      image(astronaut, width/2, 6*height/8, width/15, height/7);
      image(aFlag, width/2-100, 50+6*height/8, width/15, height/18);
      image(cFlag, width/2+100, 6*height/8, width/15, height/8);
    }
  }
  boolean landingCrash() {
    if (y+10>3*height/4 && (yVel > 1 || xVel>0.5 || xVel<-.5 || tilt<1 || tilt>2)) {
      crash = true;
    }
    if (crash==true) {
      fuel=0;
      lifeSupport=0;
      yVel = -2;
      xVel = 2;
      textSize(25);
      fill(255, 0, 0);
      text("Game Over", 2*width/5+30, height/2);
      text("Press R to restart", 2*width/5, height/2+30);
      image(boom, x-80, y-80);
    }
    return crash;
  }

  private float x, y, xVel, yVel, thrust = GRAVITY, tilt = HALF_PI;
  // the values below were arrived at by trial and error
  // for something that had the responsiveness desired
  static final float GRAVITY = 0.009;
  static final float MAX_THRUST = 2*GRAVITY;
  static final float TILT_INC = 0.01;
  static final int FLAME_SCALE = 2000; // multiplier to determine how long the flame should be based on thrust
  static final float FUEL_CONSUMPTION = 5000; // FUEL STARTING LEVEL

  void score(int s, int x) {
    textSize(25);
    fill(255);
    text(s, x, 3*height/4-10);
  }
  void scoreCounter() {
    textSize(25);
    fill(255);
    text("Score:", 50, 50);

    if (z==true && y+10>3*height/4 && x>6*width/8 && x<6*width/8+25) {
      score = +80;
    }
    if (z==true && y+10>3*height/4 && x>7*width/8 && x<7*width/8+25) {
      score =+100;
    }
    if (z==true && y+10>3*height/4 && x>5*width/8 && x<5*width/8+25) {
      score = +50;
    }
    if (z==true && y+10>3*height/4 && x>4*width/8 && x<4*width/8+25) {
      score = +40;
    }
    if (z==true && y+10>3*height/4 && x>3*width/8 && x<3*width/8+25) {
      score = +30;
    }

    text(score, 130, 50);
  }
}