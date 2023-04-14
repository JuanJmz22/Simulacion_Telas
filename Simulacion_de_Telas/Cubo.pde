class Cubo extends BoxConstraint{
  float cx,cy,cz,ext;
  Cubo(float cx,float cy,float cz,float ext){
    super(new AABB(new Vec3D(cx,cy,cz),ext));
    this.cx = cx;
    this.cy = cy;
    this.cz = cz;
    this.ext = ext;
  }
  
  void display(){
    pushMatrix();
    translate(cx,cy,cz);
    noStroke();
    fill(100);
    box(ext*2-10,ext*2-10,ext*2-10);
    popMatrix();
  }
}
