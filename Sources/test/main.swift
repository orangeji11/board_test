import SwiftIO
let func_button = DigitalIn(Id.D12)
var button_num:Int = 1
extension Float {
    func format(_ f: Int) -> Float {
        guard f > 0 else {return self}
        var mul = 10
        for _ in 1..<f {
            mul *= 10
        }
        let data = Int(self * Float(mul))
        return Float(data) / Float(mul)
    }
}
func button(){
    if(!func_button.read()){
        button_num+=1
        if  button_num>10{
            print("press reset button.")
        }
        else{
            print("Mission_num:",button_num)
        }
    }
}
func do_nothing(){
    
}
func_button.setInterrupt(.falling,callback:button)

while true
{
    if button_num==1 {
        print("Mission_num:",button_num)
        let led = DigitalOut(Id.BLUE)
        while button_num==1 {
            led.write(false)
            sleep(ms: 1000)
            led.write(true)
            sleep(ms: 1000)
        }
    }
    if button_num==2 {
        let red = DigitalOut(Id.D16)
        let green = DigitalOut(Id.D17)
        let blue = DigitalOut(Id.D18)
        while button_num==2 {
            // red on for 1 second, then off
            red.write(true)
            sleep(ms: 1000)
            red.write(false)
            // green on for 1 second, then off      
            green.write(true)
            sleep(ms: 1000)
            green.write(false)
            // blue on for 1 second, then off        
            blue.write(true)
            sleep(ms: 1000)
            blue.write(false)
        }
    }
    if button_num==3 {
        let led2 = DigitalOut(Id.RED)
		let button1 = DigitalIn(Id.D10)
        while button_num==3 {
   			sleep(ms: 50)
            if button1.read() {
                led2.write(false)
            } else {
                led2.write(true)
            }
		}
    }
    if button_num==4 {
        let a0 = AnalogIn(Id.A0)		// initialize an AnalogIn to Id.A0
        let led3 = DigitalOut(Id.RED)
        while button_num==4 {
            let value = a0.readPercent()
            led3.toggle()
            sleep(ms: Int(value*500))
        }
    }
    if button_num==5 {
        let a0 = AnalogIn(Id.A0)
        let buzzer = PWMOut(Id.PWM2)
        while button_num==5 {
            let value = a0.readPercent()
            let frequency = Int(1000 + 2000 * value)		// convert float type to UInt type
            buzzer.set(period: frequency, pulse: frequency/2)       // reset PWM parameters
            sleep(ms: 50)
		}
	}
    if button_num==6 {
        let number = 6
        let sevenSeg = SevenSegment()
        while button_num==6 {  
        	sevenSeg.print(number)
        }
    }
    if button_num==7 {
        let a0 = AnalogIn(Id.A0)
        let motor = PWMOut(Id.PWM2, frequency: 1000, dutycycle: 0)
        while button_num==7 {
        	let value = a0.readPercent()
        	motor.setDutycycle(value)        // public func setDutycycle(_ dutycycle: Float)
        	sleep(ms: 50)
		}
    }
    if button_num==8 {
        let a0 = AnalogIn(Id.A0)     
		let servo = PWMOut(Id.PWM6)
		while button_num==8 {
            let value = a0.readPercent()
            let pulse = Float(500 + 2000 * value)
            servo.set(period:20000,pulse:Int(pulse))        
            sleep(ms: 100)
		}
    }
    if button_num==9 {
        let i2c = I2C(Id.I2C0)
		let lcd = LCD1602(i2c)
		lcd.write(x: 0, y: 0, "Hello World!")        
        while button_num==9 {

        }
    }
    if button_num==10 {
        let i2c = I2C(Id.I2C0)
        let lcd = LCD16X02(i2c)
        let sht = SHT3X(i2c)
        sht.Init()
        while button_num==10{   
            let array = i2c.read(count:2,from:0x44)
            let value:UInt16 = UInt16(UInt16(array[0]) << 8) | UInt16(array[1])
            let data:Float = 175 * Float(value) / 65535 - 45

            // display for example
            // Temperature:
            // 26.8  C
            lcd.print("Temperature:",x:0,y:0)
            lcd.print(String(data.format(1)),x: 0,y: 1)
            lcd.print(" ",x:4,y:1)
            lcd.print("C",x:5,y:1)

            sleep(ms: 1000)
        }
    }
}
