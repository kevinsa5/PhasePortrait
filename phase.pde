// This program displays a phase portrait for a first order 2-variable system.
// Click to start an integration path

// convert window pixel coordinates to mathematical coordinates
// functional inverse of coord2win
void win2coord(float[] input) {
  input[0] =  2*xscale * (input[0]-width/2) / width;
  input[1] = -2*yscale * (input[1]-height/2) / height;
}

// convert math coordinates to window coordinates
// inverse of win2coord
void coord2win(float[] input) {
  input[0] =  input[0] * width/2 / xscale + width/2;
  input[1] = -input[1] * height/2 / yscale + height/2;
}

// returns a string representation of input, rounded to 2 decimal places, with leading +/-
String format(float f) {
  return (f >= 0? "+" : "-") + abs(int(f)) + "." + int(100*abs(f%1));
}

var f;
var g;
float xscale;
float yscale;
int max_iter;
float step_size;
float null_tol;
void updateParameters(){
  f = math.eval("f(x,y) = " + document.getElementById('xdot').value);
  g = math.eval("g(x,y) = " + document.getElementById('ydot').value);
  xscale = math.eval("abs("+document.getElementById('xlim').value+")");
  yscale = math.eval("abs("+document.getElementById('ylim').value+")");
  max_iter = math.eval(document.getElementById('max_iter').value);
  step_size = math.eval(document.getElementById('step_size').value);
  null_tol = math.eval(document.getElementById('null_tol').value);
}

void drawNullclines(){
  stroke(100);
  fill(100);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float[] coord = new float[] {
        i, j
      };
      win2coord(coord);
      float dx = f(coord[0], coord[1]);
      float dy = -1*g(coord[0], coord[1]);
      if (abs(dx) < null_tol || abs(dy) < null_tol) {
        ellipse(i, j, 2, 2);
      }
    }
  }
}

void drawVectorField(){
  stroke(200);
  fill(200);
  for (int i = 0; i < width; i += 15) {
    for (int j = 0; j < height; j+=15) {
      float[] coord = new float[] {
        i, j
      };
      win2coord(coord);
      float dx = f(coord[0], coord[1]);
      float dy = -1*g(coord[0], coord[1]);
      PVector p = new PVector(dx, dy);
      p.normalize();
      p.mult(-8);
      ellipse(i, j, 2, 2);
      line(i, j, i+p.x, j+p.y);
    }
  }
}

void drawAxisLines(){
  stroke(0);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

void redraw(){
  background(255);
  updateParameters();
  drawVectorField();
  drawNullclines();
  drawAxisLines();
}

void setup() {
  size(500, 500);
  cursor(CROSS);
  redraw();
}

void draw() {
  // display mouse coordinates in upper left corner:
  if(update){
    update = false;
    redraw();
  }
  fill(255);
  rect(0, 0, 95, 23);
  float[] p = new float[2];
  p[0] = mouseX;
  p[1] = mouseY;
  win2coord(p);
  fill(0);
  text("(" + format(p[0]) + "," + format(p[1]) + ")", 5, 15);
}
void mousePressed() {
  float[] x = new float[2];
  x[0] = mouseX;
  x[1] = mouseY;
  win2coord(x);
  // abort after 1000 iterations, or if outside the window
  for (int i = 0; i < max_iter; i++) {
    float[] dx = new float[2];
    dx[0] = f(x[0], x[1]);
    dx[1] = g(x[0], x[1]);
    x[0] = x[0] + dx[0] * step_size;
    x[1] = x[1] + dx[1] * step_size;
    float[] p = new float[2];
    arrayCopy(x, p);
    coord2win(p);
    if (abs(p[0]) > width || abs(p[1]) > height 
      || isNaN(p[0]) || isNaN(p[1]) 
      || !isFinite(p[0]) || !isFinite(p[1])) {
      break;
    }
    stroke(0);
    fill(0);
    point(p[0], p[1]);
  }
}


