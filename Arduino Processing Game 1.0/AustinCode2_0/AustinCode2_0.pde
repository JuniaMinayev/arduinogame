/*
By: Austin Owens
*/
//used a 560 ohm resistor for photocell

// have you gotten this to work?
int xPin = 2;	
int yPin = 3;	
int potPin = A0;
int photocell = A1;
int accelerationX, accelerationY;
int dial, photoCell;
int accArrayX[5];
int accArrayY[5];
float accX;
float accY;


void setup() 
{
  Serial.begin(38400);
  pinMode(xPin, INPUT);
  pinMode(yPin, INPUT);
  pinMode(potPin, INPUT);
  pinMode(photocell, INPUT);
  UpdateaccArray(0);
}

void loop() 
{
  UpdateaccArray(1);
  dialColorChange();
  photocellColorChange();
  serialFeed();
}

void dialColorChange()
{
  dial = map(analogRead(potPin), 0, 1023, 0, 255);
}

void photocellColorChange()
{
  int val = analogRead(photocell);
  int valConstrain = constrain(val, 0, 1000);
  int photo = map(valConstrain, 0, 1000, 0, 350);
  photoCell = constrain(photo, 0, 255);
}

void movement()
{
  int pulseX, pulseY;
  pulseX = pulseIn(xPin,HIGH); 
  pulseY = pulseIn(yPin,HIGH);
  accelerationX = ((pulseX / 10) - 500) * 1;
  accelerationY = ((pulseY / 10) - 500) * 1;
}

void serialFeed()
{
  Serial.print(accX);
  Serial.print('\t');
  Serial.print(accY);
  Serial.print(' ');
  Serial.print(dial);
  Serial.print('.');
  Serial.print(photoCell);
  Serial.println();
}

void UpdateaccArray(int select)
{
  accX = 0;
  accY = 0;
  if(select == 0)
  {
    for(int x = 0; x < 5; x++)
    {
      movement();
      accArrayX[x] = accelerationX;
      accArrayY[x] = accelerationY;
    }
  }
  else
  {
    for(int x = 0; x < 5; x++)
    {
      accArrayX[x+1] = accArrayX[x];
      accArrayY[x+1] = accArrayY[x];
      accX = accX + accArrayX[x];
      accY = accY + accArrayY[x];
    }
    movement();
    accArrayX[0] = accelerationX;
    accArrayY[0] = accelerationY;
    accX = accX + accelerationX;
    accY = accY + accelerationY;
  }
  accX = accX/6;
  accY = accY/6;
}