class Resorte extends VerletSpring3D {
  
  Resorte(Particula a, Particula b) {
    super(a, b, tam, resis);
  }
  
  void display() {
    pushMatrix();
    colorMode(HSB);
    int c = int(map(resis, 0.1, 1.9, 0, 120));
    stroke(c, 255, 255);
    strokeWeight(1);
    line(a.x, a.y, a.z, b.x, b.y, b.z);
    popMatrix();
  } 
}
