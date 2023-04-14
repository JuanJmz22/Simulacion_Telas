class Particula extends VerletParticle3D {
  
  Particula(float x, float y, float z, float peso) {
    super(x, y, z, peso);
  }
  
  void display() {
    pushMatrix();
    translate(x,y,z);
    fill(255);
    stroke(255);
    circle(0,0,peso*4+1);
    popMatrix();
  }
}
