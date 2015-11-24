/*
By: Austin Owens
*/
import processing.opengl.*;
import processing.serial.*;

Serial port;

float x = 255;
float y = 255;
float xHat = 0;
float yHat = 0;

float xEnemy;
float yEnemy;
float rEnemy;

float score = 1;
float maxScore = 0;

float valX;
float valY;
float dial;
float photoCell;

void setup()
{
  size(500, 500, OPENGL);
  port = new Serial(this, "/dev/tty.usbserial-A6006eIo", 38400);
  port.bufferUntil('\n');
  frameRate(30);
  strokeWeight(2.5);
  smooth();
}

void draw()
{
  fill(255, 25);
  rect(0, 0, height-1, width-1);
  fill(0, 25);
  rect(0, 0, height-1, width-1);
  fill(255);
  println();
  print(x);
  print("  ---  ");
  print(y);
  println("  ---  ");
  ellipse(x, y, 50, 50);
  update();
  UpdateEnemy();
  Score();
  if(millis() < 2200)
  {
    fill(0, 0, 255);
    rect(0, 0, height, width);
  }
}

void fadingBackground()
{
  for(int i=0; i<255; i++)
  {
  stroke(i, photoCell, dial);
  line(i, 0, i, height);
  }
  for(int j=255; j<500; j++)
  {
  float k = map(j, 255, 500, 255, 0);
  stroke(k, photoCell, dial);
  line(j, 0, j, height);
  }
}

void breadboard()
{
  pushMatrix();
  translate(height/2, width/2, 200);
  rotateX(valY*.003);
  rotateZ(valX*.003);
  stroke(255, photoCell, dial);
  strokeWeight(4);
  fill(dial);
  box(200, 25, 100);
  popMatrix();
}

void serialEvent (Serial port)
{
  println("habtdfgx");
  valX = float(port.readStringUntil('\t'));
  valY = float(port.readStringUntil(' '));
  dial = float(port.readStringUntil('.'));
  photoCell = float(port.readStringUntil('\n'));
}

void update()
{
  if(x != x)
  {
    x = 255;
  }
  if(y != y)
  {
    y = 255;
  }
  
  yHat = -valY/3;
  xHat = valX/3;
  //yHat = yHat - valY/50;
  //xHat = xHat + valX/50;
  
  print(xHat);
  print("  ");
  print(yHat);
  print("  ");
  x = x+xHat;
  y = y+yHat;
  if(y >= height-25)
  {
    y = height-26;
    yHat = -yHat;
  }
  if((y <= 25))
  {
    y = 26;
    yHat = -yHat;
  }
  if(x <= 25)
  {
    x = 26;
    xHat = -xHat;
  }
  if(x >= width - 25)
  {
    x = width - 26;
    xHat = -xHat;
  }
}

void UpdateEnemy()
{
  if(sqrt(sq(x-xEnemy) + sq(y-yEnemy)) < (15+rEnemy))
  {
    fill(255, 0, 0);
    ellipse(xEnemy, yEnemy, rEnemy, rEnemy);
    fill(255);
    score++;
    NewEnemy();
  }
  if(rEnemy < 1)
  {
    score--;
    NewEnemy();
  }
  else
  {
    rEnemy = rEnemy - score/50;
  }
  ellipse(xEnemy, yEnemy, rEnemy, rEnemy);
}

void NewEnemy()
{
  xEnemy = (random(height-50) + 25);
  yEnemy = (random(width-50) + 25);
  rEnemy = 25;
}

void Score()
{
  if(score > maxScore)
  {
    maxScore = score;
  }
  print((int)score);
  print("    ");
  println((int)maxScore);
}
