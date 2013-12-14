module finalprojectmain(clk, rst,buzzer,
motor1out, motor2out,motor3out,motor4out,	//motoroutputs (in pwm)
ch1in,ch2in,ch3in,ch4in,ch5in,ch6in,
c1in, c2in, c3in, c4in, //rc stuff
gyroxin,gyroyin,gyrozin,				//gyro stuff
m1in, m2in, m3in, m4in,					//crius motor outputs coming into FPGA			
ch1crius,ch2crius,ch3crius,ch4crius,
lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7,sf_ce0); //lcd stuff


input clk,rst;													//x=pitch y=roll z=yaw
input ch1in, ch2in, ch3in, ch4in, ch5in, ch6in; //ch1 = aileron (roll)
input gyroxin, gyroyin, gyrozin;						//ch2 = elevator (pitch)
																//ch3 = throttle
																//ch4 = rudder (yaw)
input c1in, c2in, c3in, c4in; //secondary controller				
input m1in, m2in, m3in, m4in; //inputs from crius board for motors. 490hz										
output motor1out, motor2out, motor3out, motor4out;	//  3    1 ccw |front
																	//	  \  /
																	//		\/
																	//		/\
																	//   /  \
																	//  2    4 cw |rear
																	//c1in=a4,2=a6,3=a8,3=a5	
output lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5, lcd_6, lcd_7,sf_ce0;
output ch1crius,ch2crius,ch3crius,ch4crius;
output buzzer;

wire [31:0] ch1ratio;
wire [31:0] ch2ratio;
wire [31:0] ch3ratio;
wire [31:0] ch4ratio;	//0-999 from master controller																
wire [31:0] ch5ratio;
wire [31:0] ch6ratio;																	
								
wire [31:0] c1ratio;
wire [31:0] c2ratio;		//0-999 from slave controller
wire [31:0] c3ratio;
wire [31:0] c4ratio;
 
wire [31:0] m1stab;
wire [31:0] m2stab;		//0-999 from motor1stab module
wire [31:0] m3stab;
wire [31:0] m4stab; 
 
wire [31:0] ch1buddy;
wire [31:0] ch2buddy;	//0-999 from buddybox
wire [31:0] ch3buddy;
wire [31:0] ch4buddy; 
							
wire [31:0] m1ratio;
wire [31:0] m2ratio;		//0-999 from crius board. These would to to ESCs
wire [31:0] m3ratio;
wire [31:0] m4ratio;
						
wire[31:0] premotor1out;	
wire[31:0] premotor2out;
wire[31:0] premotor3out;		//pwm to be sent to motors
wire[31:0] premotor4out;						
																	
wire[31:0] motor1ratio;	
wire[31:0] motor2ratio;
wire[31:0] motor3ratio;		//0-999 of each motor
wire[31:0] motor4ratio;

wire [31:0] gyroxratio;
wire [31:0] gyroyratio;
wire [31:0] gyrozratio;


reg [31:0] ch1outratio;
reg [31:0] ch2outratio;	//0-999 that goes into crius before pwm
reg [31:0] ch3outratio;
reg [31:0] ch4outratio;		

reg		motor1out;
reg		motor2out;
reg		motor3out;	//motor outputs. 1-0 pwm
reg		motor4out;				
wire prebuzzer;
reg buzzer;

																
		 channel channelpwmtoratio	(clk, ch1in, ch1ratio);		
		 channel channe2pwmtoratio	(clk, ch2in, ch2ratio);	
		 channel channe3pwmtoratio	(clk, ch3in, ch3ratio);	
		 channel channe4pwmtoratio (clk, ch4in, ch4ratio);	
		 channel channe5pwmtoratio	(clk, ch5in, ch5ratio);	
		 channel channe6pwmtoratio (clk, ch6in, ch6ratio);	
		 
		 channel channelpwmtoratioslave	(clk, c1in, c1ratio);		
		 channel channe2pwmtoratioslave	(clk, c2in, c2ratio);	
		 channel channe3pwmtoratioslave	(clk, c3in, c3ratio);	
		 channel channe4pwmtoratioslave  (clk, c4in, c4ratio);	
		 
		 
		 motorouts (clk, m1stab, premotor1out);
		 motorouts (clk, m2stab, premotor2out);
		 motorouts (clk, m3stab, premotor3out);
		 motorouts (clk, m4stab, premotor4out);
		 
		 
		 
		 motor1stab(clk, rst,
m1ratio, m2ratio, m3ratio, m4ratio, ch6ratio, ch3ratio,
m1stab,m2stab,m3stab,m4stab);
		
		
		 
		 criuspwm (clk, ch1outratio, ch1crius);
		 criuspwm (clk, ch2outratio, ch2crius);
		 criuspwm (clk, ch3outratio, ch3crius);	//these convert 0-999 to a 50hz pwm signal
		 criuspwm (clk, ch4outratio, ch4crius);	//that goes to crius board
		 
		 criuspwmin(clk, m1in ,m1ratio);
		 criuspwmin(clk, m2in ,m2ratio);
		 criuspwmin(clk, m3in ,m3ratio);
		 criuspwmin(clk, m4in ,m4ratio);
		 
		 
		 screen (clk, sf_ce0, lcd_rs, lcd_rw, lcd_e, lcd_4, lcd_5,
		 lcd_6, lcd_7,m1stab,m2stab,m3stab,m4stab,ch6ratio); 
		//lcd_6, lcd_7,ch1buddy,ch2buddy,ch3buddy,ch4buddy,ch5ratio); 
		
		 buddybox(clk,ch1ratio,ch2ratio,ch3ratio,ch4ratio,
		 c1ratio, c2ratio, c3ratio, c4ratio,
		 ch1buddy,ch2buddy,ch3buddy,ch4buddy,
		 prebuzzer);
		
		
		
		
		
		
		always @ (*)		//choosing modes with a switch assigned ch5
		begin
		
		case (ch5ratio/100)	
		
		1:
		begin
		ch1outratio = ch3ratio;
		ch2outratio = ch1ratio;
		ch3outratio = ch2ratio;
		ch4outratio = ch4ratio;
		
		motor1out = m1in;
		motor2out = m2in;
		motor3out = m3in;
		motor4out = m4in;
		
		buzzer = 1'b0;
		
		
		end
		
		2:
		
		begin
		ch1outratio = ch3ratio;
		ch2outratio = ch1ratio;
		ch3outratio = ch2ratio;
		ch4outratio = ch4ratio;
		
		motor1out = premotor1out;
		motor2out = premotor2out;
		motor3out = premotor3out;
		motor4out = premotor4out;
		end
		
		
		6:
		
		begin
		ch1outratio = ch3buddy;
		ch2outratio = ch1buddy;
		ch3outratio = ch2buddy;
		ch4outratio = ch4buddy;
		
		motor1out = m1in;
		motor2out = m2in;
		motor3out = m3in;
		motor4out = m4in;
		
		buzzer = prebuzzer;
		end
		
		7:
		
		begin
		ch1outratio = ch1ratio;
		ch2outratio = ch3ratio;
		ch3outratio = ch3ratio;
		ch4outratio = ch4ratio;
		end
		
		
		8:
		begin
		ch1outratio = ch1buddy;
		ch2outratio = ch3buddy;
		ch3outratio = ch3buddy;
		ch4outratio = ch4buddy;
		end
		
		default:
		
		begin
		ch1outratio = ch1buddy;
		ch2outratio = ch3buddy;
		ch3outratio = ch3buddy;
		ch4outratio = ch4buddy;
		end
		
		endcase
		end
		
endmodule