class ResMax extends VerletConstrainedSpring3D{
  
  ResMax(Particula a, Particula b) {
    super(a, b, tam, resis, tam*1.2);
  }
  
  void display() {
    pushMatrix();
    colorMode(HSB);
    int c = int(map(resis, 0.7, 1.75, 0, 120));
    stroke(c, 255, 255);
    strokeWeight(1);
    line(a.x, a.y, a.z, b.x, b.y, b.z);
    popMatrix();
  } 
}
