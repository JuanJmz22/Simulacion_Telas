import peasy.*;
import toxi.physics3d.*;
import toxi.physics3d.behaviors.*;
import toxi.physics3d.constraints.*;
import toxi.geom.*;

boolean hayViento= false, hayEsfera=false, hayTextura=true, hayInstr=true, hayValores=false; 
float tiempo = 0, cont = 0, zoff = 0;


int cols = 30, filas = 30;
float resis = 1.2, peso = 0.8, tam = 10;

Particula[][] particulas = new Particula[cols][filas];
ArrayList<Resorte> resortes;
ArrayList<ResMin> resMin;
ArrayList<ResMax> resMax;
VerletPhysics3D fisicas;

PImage ito, rojo, negro, imagen, cobertor, fondo;
PeasyCam cam;

void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this,300,300,0,500);
  ito = loadImage("ito.jpg");
  rojo = loadImage("red.jpg");
  cobertor = loadImage("paliacate.jpg");
  fondo =loadImage("azotea.jpg");
  imagen = rojo;
  resortes = new ArrayList<Resorte>();
  resMin = new ArrayList<ResMin>();
  resMax = new ArrayList<ResMax>();
  fisicas = new VerletPhysics3D();
  Vec3D g = new Vec3D(0, 1, 0);
  GravityBehavior3D gravedad = new GravityBehavior3D(g);
  fisicas.addBehavior(gravedad);

  vertical();
  //horizontal();
  
  resMax();
  resMin();
  
  particulas[0][0].lock();
  particulas[cols-1][0].lock();
  //particulas[0][filas-1].lock();
  //particulas[cols-1][filas-1].lock();
}


void draw() {  
  colorMode(RGB);
  background(84, 153, 199);
  pushMatrix();
  //translate(-200,-400,-400);
  //image(fondo,0,0);
  //translate(200,400,400);
  //fill(252,195,55);
  //rect(0,150,1000,3);
  popMatrix();
  translate(width/2, height/2);
  
  lights(); 
  if(hayTextura) textura();
  else tela();
  if(hayViento) vientoPerlin();
  if(hayEsfera){
    cont+=0.4;
    esfera(0,120,-100+cont,50);
  }
  else cont=0;
  if (hayInstr)instr();
  if (hayValores) valores();
  cambiarResis(); 
  cambiarPeso();
  fisicas.update();
  
}

void textura(){
  noFill();
  noStroke();
  textureMode(NORMAL);
  for (int j = 0; j < filas-1; j++) {
     fill(255);
    beginShape(TRIANGLE_STRIP);
    texture(imagen);
    for (int i = 0; i < cols; i++) {
      float x1 = particulas[i][j].x;
      float y1 = particulas[i][j].y;
      float z1 = particulas[i][j].z;
      float u = map(i, 0, cols-1, 0, 1);
      float v1 = map(j, 0, filas-1, 0, 1);
      vertex(x1, y1, z1, u, v1);
      float x2 = particulas[i][j+1].x;
      float y2 = particulas[i][j+1].y;
      float z2 = particulas[i][j+1].z;
      float v2 = map(j+1, 0, filas-1, 0, 1);
      vertex(x2, y2, z2, u, v2);
    }
    endShape();
  } 
}

void tela(){ 
  for (ResMax r : resMax)
    r.display();
    
  for (int i = 0; i < cols; i++){ 
    for (int j = 0; j < filas; j++){ 
      particulas[i][j].display();
    }
  }
}

void vientoPerlin(){
  float xoff = 0;
  for (int i = 0; i < cols; i++) {
    float yoff = 0;
    for (int j = 0; j < filas; j++) {
      float windx = map(noise(xoff, yoff, zoff), 0, 1,  -0.25, 0.25);
      float windy = map(noise(xoff, yoff, zoff), 0, 1, -0.5, 0);
      float windz = map(noise(xoff, yoff, zoff), 0, 1, -1, 1);
      Vec3D wind= new Vec3D(windx, windy, windz);
      particulas[i][j].addForce(wind);
      yoff += 0.1;
    }
    xoff += 0.1;
  }
  zoff += 0.1;
}

void esfera(float x, float y, float z, float r){
  Esfera esfera = new Esfera(x,y,z,r);
  esfera.display();
  for (int i = 0; i < cols; i++){ 
    for (int j = 0; j < filas; j++){ 
      esfera.apply(particulas[i][j]);
    }
  }
}

void cubo(float cx, float cy, float cz,float ext){
  Cubo cubo = new Cubo(cx,cy,cz,ext);
  cubo.display();
  for (int i = 0; i < cols; i++){ 
    for (int j = 0; j < filas; j++){ 
      cubo.apply(particulas[i][j]);
    }
  }
}

void vertical(){
  float x = -cols*tam/2;
  for (int i = 0; i < cols; i++) {
    float y = -filas*tam/2;
    for (int j = 0; j < filas; j++) {
      Particula p = new Particula(x,  y, 0, peso);
      particulas[i][j] = p;
      fisicas.addParticle(p);
      y = y + tam;
    }
    x = x + tam;
  }
}

void horizontal(){
  float x = -cols*tam/2;
  for (int i = 0; i < cols; i++) {
    float z = 0;
    for (int j = 0; j < filas; j++) {
      Particula p = new Particula(x,  0, z, peso);
      particulas[i][j] = p;
      fisicas.addParticle(p);
      z = z + tam;
    }
    x = x + tam;
  }
}


void resortes(){
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < filas; j++) {
      Particula a = particulas[i][j];
      if (i != cols-1) {
        Particula b1 = particulas[i+1][j];
        Resorte r1 = new Resorte(a, b1);
        resortes.add(r1);
        fisicas.addSpring(r1);
      }
      if (j != filas-1) {
        Particula b2 = particulas[i][j+1];
        Resorte r2 = new Resorte(a, b2);
        resortes.add(r2);
        fisicas.addSpring(r2);
      }
    }
  }
}

void resMin(){
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < filas; j++) {
      Particula a = particulas[i][j];
      if (i != cols-1) {
        Particula b1 = particulas[i+1][j];
        ResMin r1 = new ResMin(a, b1);
        resMin.add(r1);
        fisicas.addSpring(r1);
      }
      if (j != filas-1) {
        Particula b2 = particulas[i][j+1];
        ResMin r2 = new ResMin(a, b2);
        resMin.add(r2);
        fisicas.addSpring(r2);
      }
    }
  }
}

void resMax(){
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < filas; j++) {
      Particula a = particulas[i][j];
      if (i != cols-1) {
        Particula b1 = particulas[i+1][j];
        ResMax r1 = new ResMax(a, b1);
        resMax.add(r1);
        fisicas.addSpring(r1);
      }
      if (j != filas-1) {
        Particula b2 = particulas[i][j+1];
        ResMax r2 = new ResMax(a, b2);
        resMax.add(r2);
        fisicas.addSpring(r2);
      }
    }
  }
}
void instr(){
  pushMatrix();
  textSize(12);
  fill(0);
  text("Activar/Desactivar Aire: espacio\nActivar/Desactivar esfera: e"+
        "\nActivar/Desactivar textura: t\nCambiar Textura: 1,2,3"+
        "\nAumentar/Reducir Peso: ← →"+"\nAumentar/Reducir Resistencia: ↑ ↓"+
        "\nEsconder este texto: i\nPuedes mover la camara con el mouse", -280,-270, 10);
  popMatrix();
}

void valores(){
  pushMatrix();
  textSize(20);
  fill(0);
  text("Peso:"+particulas[1][1].getWeight()+"\nResistencia:"+resMax.get(0).getStrength(), -270,220, 10);
  popMatrix();
}
void keyPressed() {
  if (key == ' ')
    hayViento =! hayViento;
  else if (key == 'e')
    hayEsfera =! hayEsfera;
  else if (key == 't')
    hayTextura =! hayTextura;
  else if (key == '1')
    imagen = ito;
  else if (key == '2')
    imagen = rojo;
  else if (key == '3')
    imagen = cobertor;
  else if (key == 'i')
    hayInstr =! hayInstr;
  else if (key == 'v')
    hayValores =! hayValores;

}

void cambiarResis(){
  if(keyPressed){
    if (keyCode == UP){
      if(resis<1.7)
        resis+=0.01;
      for (ResMax r : resMax)
        r.setStrength(resis);
      for (ResMin r : resMin)
        r.setStrength(resis);
    }
    if (keyCode == DOWN){
      if(resis>0.8)
        resis-=0.01;
      for (ResMax r : resMax)
        r.setStrength(resis);
      for (ResMin r : resMin)
        r.setStrength(resis);
    }
  }
}

void cambiarPeso(){
  if(keyPressed){
    if (keyCode == RIGHT){
      if(peso<1.2)
        peso+=0.01;
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < filas; j++) {
          Particula a = particulas[i][j];
            a.setWeight(peso);
        }
      }
    }
    if (keyCode == LEFT){
      if(peso>0.3)
        peso-=0.01;
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < filas; j++) {
          Particula a = particulas[i][j];
          a.setWeight(peso);
        }
      }
    }
  }
}
