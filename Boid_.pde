

class BoidObject
{
  PImage sprite;
  PVector position;
  PVector velocity;

  private float maxDistance;
  private int maxFriends = 5;
  private ArrayList<BoidObject> friends = new ArrayList<BoidObject>();

  public BoidObject(PImage boidSprite, PVector startPos, float personalSpace)
  {
    maxDistance = personalSpace;
    sprite = boidSprite;
    position = startPos;
    velocity = new PVector(random(-1,1), random(-1,1)); //up
  }

  //whether or not a friend can be added is handled by BoidManager
  public void AddFriends(BoidObject friend)
  {
    friends.add(friend);
  }

  //removing friends can be done locally
  public void RemoveFriends(BoidObject friend)
  {
    friends.remove(friend);
  }

  //calls methods run constantly//
  public void Update()
  {
    DrawMe();
    Move();
    //boid functions
    if (friends.size() > 0)
    {
      Cohesion();
      Alignment();
    }

    boundingBox();
  }

  private void Alignment()
  {
    PVector avgVel = new PVector(0,0);
    for (var friend : friends)
    {
      avgVel.add(friend.velocity());
    }

    avgVel.div(friends.size());

    RotateTowards(avgVel.normalize(),radians(3));
  }


  public void SpeedMod(float closenessMod) //varies speed based on how close boids are
  {
    velocity.setMag(0.5 + (exp(-closenessMod * 0.001)));
  }

  public void Seperation(BoidObject friend) //need for seperation is detected in the boid manager to ensure all the boids are being check if they're too close (not just in friends)
  {
    PVector VecTo = Vec2Points(position, friend.position());
    VecTo.normalize();
    VecTo.rotate(radians(180));//inverts
    RotateTowards(VecTo,radians(4));
  }

  
  
  public void MouseSeperation(PVector mousePos)
  {
    PVector VecTo = Vec2Points(position, mousePos);
    VecTo.normalize();
    VecTo.rotate(radians(180)); //inverts
    RotateTowards(VecTo,radians(7));   
  }

  private void Cohesion()
  {
    float avgX = 0;
    avgX += position.x;

    float avgY = 0;
    avgY += position.y;

    int count = 1;
    for (var friend : friends)
    {
      avgX += friend.position().x;
      avgY += friend.position().y;
      count++;
    }
    avgX = avgX/count;
    avgY = avgY/count;

    PVector avgPos = new PVector(avgX, avgY);

    PVector targetVec = Vec2Points(position, avgPos);
    RotateTowards(targetVec,radians(3.2));
  }

  private void Move()
  {
    position.add(velocity);
  }

  private void RotateTowards(PVector target, float rotRateRadians) {
    float currentAngle = velocity.heading();
    float targetAngle = target.heading();

    float angleDiff = targetAngle - currentAngle;
    angleDiff += (angleDiff > Math.PI) ? -2 * Math.PI : (angleDiff < -Math.PI) ? 2 * Math.PI : 0;

    float rotation = Math.min(Math.abs(angleDiff), rotRateRadians);
    rotation = angleDiff < 0 ? -rotation : rotation;

    velocity.rotate(rotation);
  }


  private void DrawMe()
  {
    pushMatrix();

    translate(position.x, position.y);

    float angle = velocity.heading() + PI/2; // Adjust according to your coordinate system
    rotate(angle);

    imageMode(CENTER);
    image(sprite, 0, 0);
    popMatrix();
  }




  private void boundingBox()
  {
    if (position.x > width)
    {
      position = new PVector(position.x % width, position.y);
    } else if (position.x < 0)
    {
      position = new PVector(width - position.x, position.y);
    }

    if (position.y > height)
    {
      position = new PVector(position.x, position.y % height);
    } else if (position.y < 0)
    {
      position = new PVector(position.x, height - position.y);
    }
  }

  public boolean CanFriend()
  {
    return friends.size() < maxFriends; //returns true when list isn't full (max length)
  }

  public boolean AlreadyFriends(BoidObject friend)
  {
    if (friends.contains(friend)) return true;
    return false;
  }

  public PVector position()
  {
    return position;
  }

  public PVector velocity()
  {
    return velocity;
  }
}
