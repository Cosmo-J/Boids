class BoidManager //<>//
{
  PImage boidSprite;
  int numBoids;
  float personalSpace;
  public boolean mouseDown = false;
  float seperationSpace;
  
  public ArrayList<BoidObject> boidList = new ArrayList<BoidObject>();

  public BoidManager(int numBoids, float personalSpace, float seperationSpace, PImage sprite)
  {
    this.numBoids = numBoids;
    this.personalSpace = personalSpace;
    this.seperationSpace = seperationSpace;
    boidSprite = sprite;

    GenerateBoids();
  }

  private void GenerateBoids()
  {
    PVector spawnPos;
    for (int i = 0; i < numBoids; i++)
    {
      spawnPos = new PVector(random(0, width), random(0, height)); //generates random spawn position within the bounds of the tank
      boidList.add(new BoidObject(boidSprite, spawnPos, personalSpace));
    }
  }

  public void Update()
  {
    UpdateBoids();
  }

  private void UpdateBoids()
  {
    for (BoidObject boid : boidList)
    {
      
      if(mouseDown)
      {
        if(MouseSeperation(boid.position())) boid.MouseSeperation(new PVector(mouseX,mouseY));
      }
      boid.Update();
      for (BoidObject nearBoid : boidList)
      {
        if (boid == nearBoid) continue;//stops doing comparisons with self


        if(!InBlindSpot(boid, nearBoid)) //speed mod
        {
           boid.SpeedMod(PVector.dist(boid.position(), nearBoid.position()));
        }
        
        
        //seperation called here so it doesn't discriminate between friends and non friends
        if ( PVector.dist(boid.position, nearBoid.position) < seperationSpace) //seperation
        {
          boid.Seperation(nearBoid);
        }


        if ((PVector.dist(boid.position, nearBoid.position) < personalSpace) //addfriends
          && boid.CanFriend()
          && !InBlindSpot(boid, nearBoid)
          && !boid.AlreadyFriends(nearBoid))
        {
          boid.AddFriends(nearBoid);
        }

        if ( PVector.dist(boid.position, nearBoid.position) > personalSpace || InBlindSpot(boid, nearBoid)) //remove friends
        {
          boid.RemoveFriends(nearBoid);
        }
      }
    }
  }


  private boolean MouseSeperation(PVector boidPos)
  {    
    float effectRadius = 100;
    PVector mousePos = new PVector(mouseX,mouseY);
    return (PVector.dist(boidPos,mousePos) < effectRadius);
  }

  float tollerance = 135; //blind spot in degrees
  private boolean InBlindSpot(BoidObject b1, BoidObject b2) //checks if b2 is in b1s blind spot
  {
    PVector VecTo = Vec2Points(b1.position(), b2.position());
    float angleBetween = PVector.angleBetween(b1.velocity(), VecTo);

    return abs(angleBetween) < radians(tollerance);
  }
}
