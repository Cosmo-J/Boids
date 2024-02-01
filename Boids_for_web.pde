PImage boidSprite;
int numberOfBoids = 200;
float personalSpace = 80;
float seperationSpace = 35;

BoidManager bm;

void setup()
{
  boidSprite = loadImage("Boid.png");
  boidSprite.resize(9,16);
  size(700, 700);
  bm = new BoidManager(numberOfBoids, personalSpace, seperationSpace, boidSprite);
}



void mousePressed()
{
  bm.mouseDown = true;
}

void mouseReleased()
{
  bm.mouseDown = false;
}


void draw()
{
  background(4, 10, 50);
  bm.Update();
  DrawBorders();
}

void DrawBorders()
{
  strokeWeight(20);
  line(0, 0, width, 0);
  line(0, 0, 0, height);
  line(width, height, 0, height);
  line(width, height, width, 0);
}

PVector Vec2Points (PVector p2, PVector p1)
{
  float x = p1.x - p2.x;
  float y = p1.y - p2.y;

  return new PVector(x, y);
}
