/*gcrll.net
 LUTs: look up tables.
 LUT cube visualization.
 Cubes made with LUT_3DInterpolado.pde
 CPU based.
 theory: http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter24.html
 interpolation from: https://github.com/openframeworks/openFrameworks/tree/develop/examples/graphics/lutFilterExample
 */


PImage img;
color[][][] lut=new color[32][32][32];
String lutLines[];
int ind;
boolean lutHasHeader=true;
void setup() {
  size(800, 700, P3D);
  img=loadImage("patitos.jpg");

  lutLines= loadStrings("/LUTs/odd1.cube");
  println(lutLines.length);
  
  if(lutHasHeader){
  ind=5;
  }
  else{
  ind=0;
  }
  for (int k=0;k<32;k++) {
    for (int j=0;j<32;j++) {
      for (int i=0;i<32;i++) {
        String lutSingleLine=lutLines[ind];
        String[] components=new String[3];
        components=split(lutSingleLine, ' ');
        lut[i][j][k]=color(int(float(components[0])*255), int(float(components[1])*255), int(float(components[2])*255));
        ind++;
      }
    }
  }
  background(0);
  noStroke();
  noLoop();
}


void draw() {
  background(0); 

  image(img, 0, 0); 
  img.loadPixels();   

  for (int i=0;i<img.pixels.length;i++) {
    color c=img.pixels[i];

    int rc=(int)red(c);
    int gc=(int)green(c);
    int bc=(int)blue(c);     

    int ri=rc/8;
    int gi=gc/8;
    int bi=bc/8;

    int rf=ri+1;
    int gf=gi+1;
    int bf=bi+1;

    float amountR = (rc % 8) / 8.0f;
    float amountG = (gc % 8) / 8.0f;
    float amountB = (bc % 8) / 8.0f;

    c=color(red(lut[ri][gi][bi])+amountR*(red(lut[rf][gf][bf])-red(lut[ri][gi][bi])), 
    green(lut[ri][gi][bi])+amountG*(green(lut[rf][gf][bf])-green(lut[ri][gi][bi])), 
    blue(lut[ri][gi][bi])+amountR*(blue(lut[rf][gf][bf])-blue(lut[ri][gi][bi]))
      );

    img.pixels[i]=c;
  }  


  img.updatePixels(); 
  image(img, width/2, 0);
  pushMatrix();
  translate(0, 320);
  for (int i=0;i<32;i++) {
    for (int j=0;j<32;j++) {
      for (int k=0;k<32;k++) {
        pushMatrix();
        translate(i*1+(k%10)*32, j*1+(k/10)*32, 0);
        int rc=int(map(i, 0, 32, 0, 255));
        int gc=int(map(j, 0, 32, 0, 255));
        int bc=int(map(k, 0, 32, 0, 255));
        stroke(rc, gc, bc);
        point(0, 0);
        popMatrix();
      }
    }
  }
  popMatrix();

  pushMatrix();  
  translate(400, 320);
 
  for (int i=0;i<32;i++) {
    for (int j=0;j<32;j++) {
      for (int k=0;k<32;k++) {
        pushMatrix();
        translate(i*1+(k%10)*32, j*1+(k/10)*32, 0);
        stroke(lut[i][j][k]);
        point(0, 0);
        popMatrix();
      }
    }
  }
  popMatrix();

  pushMatrix();  
  translate(100, 450);
  for (int i=0;i<8;i++) {
    for (int j=0;j<8;j++) {
      for (int k=0;k<8;k++) {
        pushMatrix();
        translate(i*15, k*25, j*15);
        rotateX(PI/2);
        int rc=int(map(i, 0, 8, 0, 255));
        int gc=int(map(j, 0, 8, 0, 255));
        int bc=int(map(k, 0, 8, 0, 255));
        noStroke();
        fill(rc, gc, bc);
        rect(0, 0, 10, 10);
        popMatrix();
      }
    }
  }
  popMatrix();  




  pushMatrix();  
  translate(580, 450);
  for (int i=0;i<8;i++) {
    for (int j=0;j<8;j++) {
      for (int k=0;k<8;k++) {
        pushMatrix();
        translate(i*15, j*25, k*15);
        rotateX(PI/2);
        int iSub=int(map(i, 0, 8, 0, 32));
        int jSub=int(map(j, 0, 8, 0, 32));
        int kSub=int(map(k, 0, 8, 0, 32));
        //rotateX(PI/2);
        fill(lut[iSub][kSub][jSub]);
        rect(0, 0, 10, 10);
        popMatrix();
      }
    }
  }
  popMatrix();
}




void keyPressed() {
  if (key==' ') {
    saveFrame(int(random(1000, 9999))+".jpg");
  }
}

