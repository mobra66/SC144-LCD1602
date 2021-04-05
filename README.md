# LCD1602 I2C Turbo Pascal 3 Driver
Demo of LCD1602 display connected with I2C to SC144 I2C bus master. Developed with Turbo Pascal 3.02A.

# Compatibility and Limitations
A few things to note: The software has *only* been tested with SC140/SC144 and SC126 at 18 MHz. It is only configured for a 16x2 display, so don't expect it to work with anything else, like 20x4. My LCD has a HD44780 controller, anything else probably won't work.
Also, make sure your Turbo Pascal has been configured for the correct CPU frequency using TINST.COM. THe program uses delays which are wrong if the Turbo Pascal is not configured. This also means you cannot move a .COM file from one system to another if CPU is a different frequency. You must then compile it again with a Turbo Pascal configured for that CPU.

# How to run
Copy the three .PAS files to your CP/M computer, compile and run LCD.PAS using Turbo Pascal.
Make sure your LCD is properly connected to the SC144 I2C bus (or SC126 I2C connector).

This code was tested on SC140 mainboard and SC144 I2C bus master with an HD44780 compatible 16x2 character LCD display with I2C connector, using 4-bit interface mode. Also tested on SC126. Both boards running 18 MHz Z180 CPU. 

# Structure
The LCD.PAS main program include I2CLIB.PAS and LCDLIB.PAS. The includes must be in this order, because LCDLIB depends on I2CLIB.

You must define the const DEVICE_WR with the I2C address of the LCD1602 before the includes!

LCDLIB defines the type lcdString as a string of 16 chars. Also note the global variable lcd_backlightVal which must be set to LCD_Bl to enable backlight, if you want that.

# References
* https://www.sparkfun.com/datasheets/LCD/HD44780.pdf
* https://en.wikipedia.org/wiki/Hitachi_HD44780_LCD_controller
* https://www.8051projects.net/lcd-interfacing/lcd-4-bit.php


