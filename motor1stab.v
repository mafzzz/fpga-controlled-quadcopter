module motor1stab(clk, rst,
m1in, m2in, m3in, m4in, ch6ratio, ch3ratio,
m1ratio,m2ratio,m3ratio,m4ratio);

input [10:0] m1in, m2in, m3in, m4in,  ch6ratio, ch3ratio;
input clk,rst;

output [10:0] m1ratio,m2ratio,m3ratio,m4ratio;
reg [10:0] m1ratio,m2ratio,m3ratio,m4ratio;

reg [31:0] counter;
reg [31:0] tempcounter;
reg [31:0] seconds;		

reg[3:0]S;	//state
reg[3:0]NS; //next state


reg[31:0]count1;
reg[16:0]count2;
reg[16:0]count3;
reg[16:0]count4;
reg[16:0]count5;

reg[16:0]cnt1;
reg[16:0]cnt2;
reg[16:0]cnt3;
reg[16:0]cnt4;
reg[16:0]cnt5;
reg[16:0]cnt6;
reg[16:0]cnt7;
reg[16:0]cnt8;
reg [16:0] second;

reg [10:0] tempm1;
reg [10:0] tempm2;
reg [10:0] tempm3;
reg [10:0] tempm4;

reg [10:0] m1dif;
reg [10:0] m2dif;
reg [10:0] m3dif;
reg [10:0] m4dif;

reg [10:0] m1dif1;
reg [10:0] m2dif1;
reg [10:0] m3dif1;
reg [10:0] m4dif1;

reg [10:0] m1dif2;
reg [10:0] m2dif2;
reg [10:0] m3dif2;
reg [10:0] m4dif2;

reg [10:0] m1dif3;
reg [10:0] m2dif3;
reg [10:0] m3dif3;
reg [10:0] m4dif3;

reg [10:0] tempch6;
reg [10:0] tempx;
reg [10:0] tempy;
reg [10:0] tempz;

reg [10:0] m1deri;
reg [10:0] m2deri;
reg [10:0] m3deri;		//change between dif1 and def2
reg [10:0] m4deri;

reg [10:0] m1deri2;
reg [10:0] m2deri2;	//change between dif2 and dif3
reg [10:0] m3deri2;
reg [10:0] m4deri2;

reg [12:0] m2avg;
reg [12:0] m3avg;


parameter	
			START					= 4'd0,
			GETMOTOR2 			= 4'd2,
			GETMOTOR3 			= 4'd3,
			ADJUSTMOTOR1		= 4'd4,
			ADJUSTMOTOR2		= 4'd5;			
			
			
			



always @(posedge clk)
begin


	case(S)
		START:

			
			begin
			cnt1<=second;
			cnt2<=second;

				NS <= GETMOTOR2;
				
				
		end
		
		
		
		GETMOTOR2:
		begin
		cnt1 <= seconds;
		cnt2 <= 31'd0;
	
				if (((m1dif3!=m1dif2)||(m2dif3!=m2dif2)||(m2dif3!=m2dif2)||(m2dif3!=m2dif2))||(seconds>(cnt1+1)))
				NS <= ADJUSTMOTOR1;
				
		end
		
		GETMOTOR3:
		begin
		cnt2 <= seconds;
		cnt1 <= 31'd0;
				if ((m1dif3!=m1dif2)||(m2dif3!=m2dif2)||(m2dif3!=m2dif2)||(m2dif3!=m2dif2)||(seconds>(cnt2+1)))
				NS <= ADJUSTMOTOR2;	
				
		end
		
		ADJUSTMOTOR1:
		begin
			

		
			NS <= GETMOTOR3;	
					
		end
		
		
		
		ADJUSTMOTOR2:
		begin
			

		
			NS <= GETMOTOR2;	
					
		end
		
		
		
		default:
		begin
		NS <= START;
		
		end
	endcase
end
//#####################end of states and next states


always @(posedge clk or negedge rst)
begin

	if (rst == 1'b0)
	begin
		S <= START;
		counter <= 32'd0;
		second <= 32'd0;

		
		
	end
	else
	begin
		S <= NS;		
		
counter <= counter +1;


if (counter == (32'd50000))
begin						
tempcounter <= 32'd0;
seconds <= seconds + 1'b1;
counter <= 32'b0;	
end


end
end


always @(*)
begin


case (S)

	START:
		begin
		
m1dif3 = m1in;
m2dif3 = m2in;
m3dif3 = m3in;
m4dif3 = m4in;
			
		end
		


		
		GETMOTOR2:
		begin		
m1dif2 = m1in;
m2dif2 = m2in;
m3dif2 = m3in;
m4dif2 = m4in;
				
m1deri = (m1dif3-m1dif2);
m2deri = (m2dif3-m2dif2);
m3deri = (m3dif3-m3dif2);
m4deri = (m4dif3-m4dif2);				
		end
		
	GETMOTOR3:
		begin
		
m1dif3 = m1in;
m2dif3 = m2in;
m3dif3 = m3in;
m4dif3 = m4in;
		
m1deri2 = (m1dif2-m1dif3);
m2deri2 = (m2dif2-m2dif3);
m3deri2 = (m3dif2-m3dif3);
m4deri2 = (m4dif2-m4dif3);		
		
		end
		
	ADJUSTMOTOR1:
		begin
		
		if (ch3ratio<50)
		begin
		m1ratio = 0;
		m2ratio = 0;
		m3ratio = 0;
		m4ratio = 0;
		end
		else
		begin
		
		
		m2avg = ((m1dif2+m2dif2+m3dif2+m4dif2)/4);
		
		if ((m1dif2>m2avg)&&(m1deri>0))
		m1ratio = (m1in-((m1deri*ch6ratio)/50));
		else
		m1ratio = m1in;
		
		if ((m2dif2>m2avg)&&(m2deri>0))
		m2ratio = (m2in-((m2deri*ch6ratio)/50));
		else
		m2ratio = m2in;
		
		
		if ((m3dif2>m2avg)&&(m3deri>0))
		m3ratio = (m3in-((m3deri*ch6ratio)/50));
		else
		m3ratio = m3in;
		
		
		if ((m4dif2>m2avg)&&(m4deri>0))
		m4ratio = (m4in-((m4deri*ch6ratio)/50));
		else
		m4ratio = m4in;
		end
		
		end
		
		ADJUSTMOTOR2:
		begin
		
		if (ch3ratio<50)
		begin
		m1ratio = 0;
		m2ratio = 0;
		m3ratio = 0;
		m4ratio = 0;
		end
		else
		begin
		
		m3avg = ((m1dif3+m2dif3+m3dif3+m4dif3)/4);
		
		if ((m1dif3>m3avg)&&(m1deri2>0))
		m1ratio = (m1in-((m1deri2*ch6ratio)/50));
		else
		m1ratio = m1in;
		
		if ((m2dif3>m3avg)&&(m2deri2>0))
		m2ratio = (m2in-((m2deri2*ch6ratio)/50));
		else
		m2ratio = m2in;
		
		
		if ((m3dif3>m3avg)&&(m3deri2>0))
		m3ratio = (m3in-((m3deri2*ch6ratio)/50));
		else
		m3ratio = m3in;
		
		
		if ((m4dif3>m3avg)&&(m4deri2>0))
		m4ratio = (m4in-((m4deri2*ch6ratio)/50));
		else
		m4ratio = m4in;
		
		end
		end
		
		
	endcase
	
end


endmodule





