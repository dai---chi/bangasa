class Seeker{
  PVector position;
  float accelRate, radius;
  PVector velocity = new PVector(512, 512);
  color fillColor;
  float rnd;
    
  public Seeker(PVector pos){
    position = pos;
    rnd = random(1);
    // fillColor = color((int) (rnd*255), 180, 255);
    fillColor = color((int) (rnd*255), 100,180);
  }
  
  public void seek(PVector target){
    accelRate = map(rnd, 0, 1, minAccel, maxAccel);
    target.sub(position);
    target.normalize();
    target.mult(accelRate);
    velocity.add(target);
    velocity.limit(maxVelocity);

    position.add(velocity);
  }
  
  public void render(float sl){
    fill(fillColor);
    radius = sq(map(velocity.mag(), 0, maxVelocity, 4, 1));
    if(shapeType == 0){
      ellipse(position.x, position.y, sl*radius, sl*radius);
    }
    else{
      rect(position.x, position.y, sl*radius, sl*radius);
    }
  }
}

