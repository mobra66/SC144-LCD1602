# LCD1602 I2C Turbo Pascal 3 Driver
Demo of LCD1602 display connected with I2C to SC144 I2C bus master.

# How to run
Copy the three .PAS files to your CP/M computer, compile and run LCD.PAS using Turbo Pascal 3.
Make sure your LCD is properly connected to the SC144 I2C bus (or SC126 I2C connector).

This code was tested with an HD44780 compatible 16x2 character LCD display with I2C bus adapter, using 4-bit interface mode.

# Structure
The LCD.PAS main program include I2CLIB.PAS and LCDLIB.PAS. The includes must be in this order, because LCDLIB depends on I2CLIB.

You must define the const DEVICE_WR with the I2C address of the LCD1602 before the includes!

LCDLIB defines the type lcdString as a string of 16 chars. Also note the global variable lcd_backlightVal which must be set to LCD_Bl to enable backlight, if you want that.

