class Esfera extends SphereConstraint{
  float x,y,z,r;
  Esfera(float x, float y, float z, float r){
      super(new Vec3D(x,y,z),r,false);
      this.x = x;
      this.y = y;
      this.z = z;
      this.r = r;
  }
  
  void display(){
    pushMatrix();
    translate(x,y+2,z-2);
    noStroke();
    fill(0,0,180);
    sphere(r-5);
    popMatrix();
  }
}
