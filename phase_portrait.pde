// This program displays a phase portrait for a first order 2-variable system.
// Click to start an integration path

/* Begin Configuration: */
// system:  
// x' = f(x,y)
// y' = g(x,y)
float f(float x, float y){
  return -3*y;
}
float g(float x, float y){
  return sin(3*x);
}
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
  stroke(200);
  fill(200);
  for(int i = 0; i < width; i += 15){
    for(int j = 0; j < height; j+=15){
      float[] coord = new float[]{i,j};
      win2coord(coord);
      float dx = f(coord[0],coord[1]);
      float dy = -1*g(coord[0],coord[1]);
      PVector p = new PVector(dx,dy);
      p.normalize();
      p.mult(-8);
      ellipse(i,j,2,2);
      line(i,j,i+p.x,j+p.y);
    }    
  }
  stroke(0);
  fill(0);
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
}

void mousePressed(){
  float[] x = new float[2];
  x[0] = mouseX;
  x[1] = mouseY;
  win2coord(x);
  // abort after 1000 iterations, or if outside the window
  for(int i = 0; i < max_iter; i++){
    float[] dx = new float[2];
    dx[0] = f(x[0], x[1]);
    dx[1] = g(x[0], x[1]);
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
