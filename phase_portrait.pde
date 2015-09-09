// This program displays a phase portrait for a 2-variable linear homogeneous system.
// Click to start an integration path

/* Begin Configuration: */
// Linear system:  x' = Ax
final float[][] A = {{1,-2},{2,1}};
// axis limits:
final float xscale = 3;
final float yscale = 3;
// maximum iterations per path:
final int max_iter = 1000;
/* End Configuration */

// convert window pixel coordinates to mathematical coordinates
// functional inverse of coord2win
void win2coord(float[] input){
  input[0] =  2*xscale * (input[0]-width/2) / width;
  input[1] = -2*yscale * (input[1]-height/2) / height;
}

// convert math coordinates to window coordinates
// inverse of win2coord
void coord2win(float[] input){
  input[0] =  input[0] * width/2 / xscale + width/2;
  input[1] = -input[1] * height/2 / yscale + height/2;
}

// multiply matrix 2x2 A into vector 2x1 x, store in 2x1 b:
void matMul(float[][] A, float[] x, float[] b){
  b[0] = A[0][0] * x[0] + A[0][1] * x[1];
  b[1] = A[1][0] * x[0] + A[1][1] * x[1];
}

// returns a string representation of input, rounded to 2 decimal places, with leading +/-
String format(float f){
  return (f >= 0? "+" : "-") + abs(int(f)) + "." + int(100*abs(f%1));
}

void setup(){
  size(400,400);
  background(255);
  stroke(0);
  // draw axis lines:
  line(width/2,0,width/2,height);
  line(0,height/2,width,height/2);
  cursor(CROSS);
}

void draw(){
  // display mouse coordinates in upper left corner:
  fill(255);
  rect(0,0,95,23);
  float[] p = new float[2];
  p[0] = mouseX;
  p[1] = mouseY;
  win2coord(p);
  fill(0);
  text("(" + format(p[0]) + "," + format(p[1]) + ")",5,15);
  //display linear system in upper right corner:
  fill(255);
  rect(width-100,0,100,35);
  fill(0);
  text("A=",width-90,20);
  text(format(A[0][0]),width-70,15);
  text(format(A[0][1]),width-35,15);
  text(format(A[1][0]),width-70,30);
  text(format(A[1][1]),width-35,30);
}

void mousePressed(){
  float[] x = new float[2];
  x[0] = mouseX;
  x[1] = mouseY;
  win2coord(x);
  // abort after 1000 iterations, or if outside the window
  for(int i = 0; i < max_iter; i++){
    float[] dx = new float[2];
    matMul(A,x,dx);
    dx[0] = dx[0] / 75;
    dx[1] = dx[1] / 75;
    x[0] = x[0] + dx[0];
    x[1] = x[1] + dx[1];
    float[] p = new float[2];
    arrayCopy(x,p);
    coord2win(p);
    if(abs(p[0]) > width || abs(p[1]) > height 
    || Float.isNaN(p[0]) || Float.isNaN(p[1]) 
    || Float.isInfinite(p[0]) || Float.isInfinite(p[1])){
      break;
    }
    point(p[0],p[1]);
  }
}
