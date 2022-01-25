#define inputpin1 2 //Optointerrupter
#define Reward1 10 //output
// #define Reward2 11

unsigned long RewardtimeOne = 200;
float PassiveScale = 1.0;
int Enable = 0;
int Choice = 0;
int WinStart = 0;
boolean bFlush = 0;
int ResponseWin = 1000;
int Open1 = 0;
int Sen = 0;

unsigned long lickonset = 0;
unsigned long WinTime = 0;
unsigned long runtime = 0;
unsigned long Timeout = 200;
unsigned long rewardtime = 0;
unsigned long OpenTime = 0;
unsigned long CloseTime = 0;
unsigned long looptime1 = 0;
unsigned long looptime2 = 0;
unsigned long SessionStartT = 0;
unsigned long TrlStartT = 0;

void setup()
{
  pinMode(inputpin1, INPUT_PULLUP);
  pinMode(Reward1, OUTPUT);  //fluid output
  //pinMode(Reward2, OUTPUT);  //fluid output
  attachInterrupt(digitalPinToInterrupt(inputpin1), lick, FALLING);

  Serial.begin(115200);
}

volatile int lickdetected = 0;

void lick() {
  lickdetected = 1;
}

void checkSerial() {
  if (Serial.find("I")) {
    delay(1);
    char Ctrl = Serial.read();

    switch ( Ctrl ) {

      case 'F' :
        if (bFlush == 0) {
          digitalWrite(10, HIGH);
          bFlush = 1;
          // Serial.println(bFlush);
        } else {
          digitalWrite(10, LOW);
          bFlush = 0;
          // Serial.println(bFlush);
          // Serial.println("Flushed..");
        }
        break;
      case 'L':
        //reward time for left valve
        RewardtimeOne = Serial.parseInt();
        // Serial.println("DL");
        break;
      case 'E':
        Enable = Serial.parseInt();
        Choice = Enable;
        // Serial.println("DE");
        break;
      case 'D':
        Enable = 0;
        // Serial.println("D0");
        WinStart = 0;
        break;
      case 'T':
        //minimal interval between rewards
        Timeout = Serial.parseInt();
        Serial.println("Timeout_set");
        break;
      case 'O':
        //Scale reward for passive reward
        PassiveScale = Serial.parseFloat();
        //    Serial.println(RewardtimeOne*PassiveScale);
        break;
      case 'S':
        Serial.println("TrlT:");
        Serial.println(millis() - SessionStartT);
        break;
      case 'P':
        //give passive reward
        digitalWrite(Reward1, HIGH);
        delay(RewardtimeOne * PassiveScale);
        digitalWrite(Reward1, LOW);
        Enable = 0;
        break;
      case 'X':
        Serial.print("Error: ");
        Serial.println(millis() - WinTime);
        break;
      case 'A':
        // Set response window duration
        ResponseWin = Serial.parseInt();
        Serial.println(ResponseWin);
        break;
      case 'Z':
        //give passive reward
        //digitalWrite(Reward2, HIGH);
        //delay(RewardtimeOne*PassiveScale);
        //digitalWrite(Reward2, LOW);
        //Enable = 0;
        break;
      case 'U':
        // Set session start time
        SessionStartT = millis();
        //Serial.print("ST: ");
        //Serial.println(SessionStartT);
        break;
      case 'W':
        // Start of the response window
        WinTime = millis();
        WinStart = 1;
      default:
        ;
    }
  }
}

//reward valve one open and close
void openOne( ) {
  digitalWrite(Reward1, HIGH);
  Open1 = 1;
  OpenTime = millis();
  // Serial.print("OpenTime:");
  // Serial.println(OpenTime);
}

void closeOne( ) {
  digitalWrite(Reward1, LOW);
  Open1 = 0;
  // === For testing! Comment out for actual use!!
  //    CloseTime = millis();
  //    Serial.print("OpenDuration:");
  //    Serial.println(CloseTime-OpenTime);
  //Serial.print("CloseTime:");
  //Serial.println(CloseTime);
  // ===

}


void printLick(char* m) {
  Serial.print("L");
  Serial.println(m);
  Serial.println(millis() - SessionStartT);
}

void printReward(char* m) {
  Serial.print("Reward:");
  Serial.println(m);
  Serial.println(millis() - WinTime);
}

void printError( ) {
  Serial.println("Error: ");
  Serial.println(millis() - WinTime);
}

void checkSensors() {


  //Sensor1 = 0;
  Sen = 0;
  runtime = millis();

  //buf1[Indx] = cs_4_2.capacitiveSensorRaw(1);

  //sums over previous 20 samples + this one
  //for(int i= 0; i < 20; i++){
  //Sensor1 += buf1[i];
  //}
  //if one of the sensors goes over threshold set Sen to 1 or 2
  //then wait until sensors go below threshold to detect next lick
  //if(Sensor1 - baseline1 > thres ){
  //if(bSucc){
  //Sen = 1;
  //bSucc = false;
  //printLick("1");
  //}
  //}else bSucc = true;

  if (lickdetected) {
    printLick("1");
    Sen = 1;
    lickdetected = 0;
  }

  if (Sen == 1 && WinStart == 1 && Enable == 1) {  //The combination of these 3 parameters defines a HIT, for stim trial
    Enable = 0;
    WinStart = 0;
    // SerOut =  Sensor1 - baseline1;  //output: height of response
    openOne( ); // Open valve 1, we close it later after reward duration elapsed; see below
    printReward("1");
  }
  else if (Sen == 1 && WinStart == 1 && Enable == 0) {  //The combination of these 3 parameters defines a FA, for no-stim trial
    printError();
    WinStart = 0;
  }

  if (WinStart == 1 && (millis() - WinTime) >= ResponseWin) {
    //Turn off WinStart and Enable when time lapse reaches response win duration
    Enable = 0;
    WinStart = 0;
  }

  if (Open1 == 1 && (millis() - OpenTime) >= RewardtimeOne) {
    //Close valve 1 after reward duration elapsed
    closeOne( );
  }
}

void loop()
{

  // === For testing -- Comment out for actual use!! ===
  //  looptime1 = millis();
  // ===

  if (Serial.available() > 1) {
    checkSerial();
  }

  //read sensors and integrate values over 20 samples
  checkSensors();

  //  ===For testing -- Comment out for actual use!! ===
  //    looptime2 = millis();
  //
  //    if(looptime2-looptime1 > 10 ) // if a loop takes more than 10ms
  //    {
  //      Serial.print("LongLoop: ");
  //      Serial.println(looptime2-looptime1);
  //      Serial.print(" ");
  //    }
  // ===


}
