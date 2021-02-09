
// QHYFW2 emulator
// limitation : only filters from 0 to 9 supported
// allways use the same direction to avoid backlash
// sensor is A3144
// before 201409 protocol version

// using a RDV8834 at 1/32 steps with a 28BYJ-48

////////////////////////////////////////////////

#include <DigiCDC.h>

////////////////////////////////////////////////

// pins location
#define ENBL_PIN	0
#define STEP_PIN	1
#define SENS_PIN	2

// ms between each step
#define STEP_DELAY	500

// number of filter position
#define NB_POSITIONS	5

// magnet angle offset to 0 (micro steps)
#define OFFSET_0	320

// # micro steps/full revolution
#define FULL_REVOLUTION	65536


////////////////////////////////////////////////


//
// motor control
//

class Motor {

	private:
		unsigned long position;

	public:

		void init() {
			pinMode(STEP_PIN, OUTPUT);
			pinMode(ENBL_PIN, OUTPUT);
			digitalWrite(STEP_PIN, LOW);
			disable();
		}

		void enable() {
			digitalWrite(ENBL_PIN, LOW);
		}

		void disable() {
			digitalWrite(ENBL_PIN, HIGH);
		}

		void setPosition(unsigned long p) {
			position=p;
		}

		unsigned long getPosition() {
			return(position);
		}

		void step() {
			digitalWrite(STEP_PIN, HIGH);
			digitalWrite(STEP_PIN, LOW);
			delayMicroseconds(STEP_DELAY);
			position++;
			position%=FULL_REVOLUTION;
		}
} motor;


//
// sensor control
//

class Sensor {

	public:

		static const int in=LOW;
		static const int out=HIGH;

		void init() {
			pinMode(SENS_PIN, INPUT_PULLUP);
		}

		int getStatus() {
			return(digitalRead(SENS_PIN));
		}
} sensor;


//
// wheel control
//

class Wheel {

	private:
		byte position;

	public:

		void init() {
			motor.enable();
			// search for the magnet start
			// skeep the magnet if allready here
			while(sensor.getStatus()==Sensor::in)
				motor.step();

			// search the magnet again
			while(sensor.getStatus()==Sensor::out)
			motor.step();
			motor.setPosition(0);

			// offset correction
			unsigned long i=(unsigned long)FULL_REVOLUTION;
			if(OFFSET_0<0) {
				i-=abs(OFFSET_0);
			} else {
				i=OFFSET_0;
			}
			while(i--) {
				motor.step();
			}
			// we are at 0
			motor.setPosition(0);
			position=0;
			motor.disable();
		}

		void moveTo(byte p) {

			unsigned long target=(unsigned long)round((double)FULL_REVOLUTION/(double)NB_POSITIONS*(double)p);
			motor.enable();
			while(motor.getPosition()!=target) {
				motor.step();
			}

			motor.disable();
			position=p;
		}

		byte getPosition() {
			return(position);
		}

} wheel;


//
// core
//

void setup() {
	// init stepper
	motor.init();

	// init hall sensor (magnet detection at low)
	sensor.init();

	// init wheel
	wheel.init();

	// init serial
        SerialUSB.begin();
}

void loop() {
	char incomingByte;
	// look for the next command
	if(SerialUSB.available() > 0) {
		incomingByte = SerialUSB.read();
		if(!((incomingByte<'0')||(incomingByte>'9'))) {
			byte p=incomingByte-'0';
			// before 201409 compatibility
			if(p!=wheel.getPosition()) {
				wheel.moveTo(p);
				SerialUSB.write(incomingByte);
			}
		}
	}
}
