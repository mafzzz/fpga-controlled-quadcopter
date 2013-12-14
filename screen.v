module screen (clk, sf_ce0, lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7, //http://www.edaboard.com/thread79344.html
motor1ratio,motor2ratio,motor3ratio,motor4ratio,extra3digit);
                    parameter       k = 18;
						  input           clk;        // synthesis attribute PERIOD clk "50 MHz"
                    reg   [k+8-1:0] count=0;
input [31:0] motor1ratio;	
input [31:0] motor2ratio;
input [31:0] motor3ratio;
input [31:0] motor4ratio;
input [31:0] extra3digit;
     output reg      sf_ce0;     // high for full LCD access
                    reg             lcd_busy=1;
                    reg             lcd_stb;
                    reg       [5:0] lcd_code;
                    reg       [6:0] lcd_stuff;
     output reg      lcd_rs;
     output reg      lcd_rw;
     output reg      lcd_7;
     output reg      lcd_6;
     output reg      lcd_5;
     output reg      lcd_4;
     output reg      lcd_e;
  
  reg [6:0] temp1;
  reg [6:0] temp2;
  reg [6:0] temp3;
  reg [6:0] temp4;
  reg [8:0] tempextra;
  reg [6:0] temp1extra;
  
  
  reg [3:0] motor10;
  reg [3:0] motor20;
  reg [3:0] motor30;
  reg [3:0] motor40;
  
  reg [3:0] motor11;
  reg [3:0] motor21;
  reg [3:0] motor31;
  reg [3:0] motor41;
  
  reg [3:0] extra1;
  reg [3:0] extra2;
  reg [3:0] extra3;

   
	
	always @ (*)
  begin
  
  
  
  temp1 = (motor1ratio/10);
  temp2 = (motor2ratio/10);
  temp3 = (motor3ratio/10);
  temp4 = (motor4ratio/10);
  tempextra = (extra3digit/100);
  temp1extra = (extra3digit/10);
  
  if (temp1>99)		//these if statements make sure that the number 
  begin					//isnt bigger than 99 since we only have 2 digits
  motor11 = 9;
  motor10 = 9;
  end
  else
  begin
  motor11 = (temp1/10);	//2nd digit (ex 6x, 8x)
  motor10 = (temp1%10);	//1st digit, (ex x1, x8)
  end
  
  if (temp2>99)
  begin
  motor21 = 9;
  motor20 = 9;
  end
  else
  begin
  motor21 = (temp2/10);	//2nd digit (ex 6x, 8x)
  motor20 = (temp2%10);	//1st digit, (ex x1, x8)
  end
  
  if (temp3>99)
  begin
  motor31 = 9;
  motor30 = 9;
  end
  else
  begin
  motor31 = (temp3/10);	//2nd digit (ex 6x, 8x)
  motor30 = (temp3%10);	//1st digit, (ex x1, x8)
  end
  
  if (temp4>99)
  begin
  motor41 = 9;
  motor40 = 9;
  end
  else
  begin
  motor41 = (temp4/10);	//2nd digit (ex 6x, 8x)
  motor40 = (temp4%10);	//1st digit, (ex x1, x8)
  end
  

  if (extra3digit>999)
  begin
  extra1 = 9;
  extra2 = 9;
  extra3 = 9;
  end
  else
  begin
 extra1 = 0;
  extra2 = (tempextra%10);
  extra3 = (tempextra);
  end
  
  
  
  end
	
  always @ (posedge clk) begin
    
	 sf_ce0 <= 1;
	 
	
	 
	 count  <= count + 1;
    sf_ce0 <= 1;
   case (count[k+7:k+2])
       0: lcd_code <= 6'h03;        // power-on initialization
       1: lcd_code <= 6'h03;
       2: lcd_code <= 6'h03;
       3: lcd_code <= 6'h02;
       4: lcd_code <= 6'h02;        // function set
       5: lcd_code <= 6'h08;
       6: lcd_code <= 6'h00;        // entry mode set
       7: lcd_code <= 6'h06;
       8: lcd_code <= 6'h00;        // display on/off control
       9: lcd_code <= 6'h0C;
      10: lcd_code <= 6'h00;        // display clear
      11: lcd_code <= 6'h01;
      12: lcd_code <= 6'h23;        // H //starts here
      13: lcd_code <= (motor11+6'd32);
      14: lcd_code <= 6'h23;        // e
      15: lcd_code <= (motor10+6'd32);			   
      16: lcd_code <= 6'h22;         // l              
      17: lcd_code <= 6'h20;			// ends here
		18: lcd_code <= 6'h23;        // H //starts here
      19: lcd_code <= (motor21+6'd32);
      20: lcd_code <= 6'h23;        // e
      21: lcd_code <= (motor20+6'd32);			   
      22: lcd_code <= 6'h22;         // l              
      23: lcd_code <= 6'h20; 				//ends here
		24: lcd_code <= 6'h23;        // H //starts here
      25: lcd_code <= (motor31+6'd32);
      26: lcd_code <= 6'h23;        // e
      27: lcd_code <= (motor30+6'd32);			   
      28: lcd_code <= 6'h22;         // l              
      29: lcd_code <= 6'h20;			// ends here
		30: lcd_code <= 6'h23;        // H //starts here
      31: lcd_code <= (motor41+6'd32);
      32: lcd_code <= 6'h23;        // e
      33: lcd_code <= (motor40+6'd32);			   
      34: lcd_code <= 6'h22;         // l              
      35: lcd_code <= 6'h20;		// ends here
		36: lcd_code <= 6'h23;        // H //starts here
      37: lcd_code <= (extra3+6'd32);
      38: lcd_code <= 6'h23;        // e
      39: lcd_code <= (extra2+6'd32);			   
      40: lcd_code <= 6'h23;         // l              
      41: lcd_code <= (6'd32);		// ends here
      default: lcd_code <= 6'h10;
    endcase
	 
  //if (lcd_rw)                     // comment-out for repeating display
   //lcd_busy <= 0;                // comment-out for repeating display
    lcd_stb <= ^count[k+1:k+0] & ~lcd_rw & lcd_busy;  // clkrate / 2^(k+2)
    lcd_stuff <= {lcd_stb,lcd_code};
    {lcd_e,lcd_rs,lcd_rw,lcd_7,lcd_6,lcd_5,lcd_4} <= lcd_stuff;
  end
endmodule