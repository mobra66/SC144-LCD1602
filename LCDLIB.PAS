{
    Copyright 2021 by Mogens Bramm

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

const
  RS_DATA   = 1;
  RS_INST   = 0;
  RW_READ   = 1;
  RW_WRITE  = 0;

  LCD_En    = $04;
  LCD_Rw    = $02;
  LCD_Rs    = $01;
  LCD_Bl    = $08;

type
  lcdString = string[16];

var
  lcd_backlightVal: byte;

  { Driver code for LCD1602 }

  procedure sendInstructionCode(rs, rw, data: byte);
  var hi, hi_en, lo, lo_en, mode, an: byte;
  begin
    { build the high order and low order nibbles, without and with Enable set }
    mode := rs or (rw shl 1) or lcd_backLightVal;
    lo := (data shl 4) and $F0 or mode;
    lo_en := lo or LCD_En;
    hi := data and $F0 or mode;
    hi_en := hi or LCD_En;

    startSequence;
    an := writeByte(DEVICE_WR);
    an := writeByte(hi);
    an := writeByte(hi_en);
    an := writeByte(lo);
    an := writeByte(lo_en);
    endSequence;
  end;

  procedure lcdClrHome;
  begin
    sendInstructionCode(RS_INST, RW_WRITE, $02); { RETURN HOME }
    delay(2);
    sendInstructionCode(RS_INST, RW_WRITE, $01); { CLR DISP }
    sendInstructionCode(RS_INST, RW_WRITE, $0C); { DISP ON/OFF D=1 (display on), C=0 (no cursor), B=0 (no cursor blink) }
  end;

  procedure lcdCursor(line, column: byte);
  var offset: byte;
  begin
    offset := (line - 1) * $40 + column - 1;
    sendInstructionCode(RS_INST, RW_WRITE, $02); { RETURN HOME }
    delay(2);
    sendInstructionCode(RS_INST, RW_WRITE, $0C); { DISP ON/OFF D=1 (display on), C=0 (no cursor), B=0 (no cursor blink) }
    sendInstructionCode(RS_INST, RW_WRITE, $80 or offset); { DDRAM AD SET }
  end;

  procedure lcdInitialize;
  var ack_nack: byte;
  begin
    startSequence;
    ack_nack := writeByte(DEVICE_WR);
    if ack_nack = 0 then begin
      writeln('LCD found on I2C bus');
      {
        The following data sequence is described in the HD44780U datasheet.
        It is the 4-bit initialization figure 24 on page 46.
      }
      delay(15); ack_nack := writeByte($30); { FUNC SET 8-bit interface }
      delay(5);  ack_nack := writeByte($30); { FUNC SET 8-bit interface }
      delay(1);  ack_nack := writeByte($30); { FUNC SET 8-bit interface }
      ack_nack := writeByte($20); { FUNC SET 4-bit interface }
      endSequence;
      {
        End of Hitachi HD44780U initalization procedure.
      }
      sendInstructionCode(RS_INST, RW_WRITE, $28); { FUNC SET N=1 (2-line), F=0 (5x8 font)}
      sendInstructionCode(RS_INST, RW_WRITE, $06); { ENTRY MODE I/D=1 (increment), S=0 (no shift) }
      lcdClrHome;
    end
    else begin
      endSequence;
      writeln('LCD not found at I2C address ', DEVICE_WR);
    end;
  end;

  procedure lcdWrite(str: lcdString);
  var i: byte;
  begin
    for i := 1 to length(str) do
      sendInstructionCode(RS_DATA, RW_WRITE, ord(str[i]));
  end;

  procedure lcdWriteAt(line, column: byte; str: lcdString);
  begin
    lcdCursor(line, column);
    lcdWrite(str);
  end;
