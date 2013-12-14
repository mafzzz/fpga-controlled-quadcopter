module criuspwm(clk, control, pwm);
input clk;
input [9:0] control;
output pwm;

reg pwm;
reg [31:0] counter = 32'd0;

always @ (posedge clk)
begin
counter <= counter+1;


if (counter < ((control*8'd50)+32'd50000)) //control*9'150
begin				//1,000,000/4(amount of values from switches)=250,000
pwm <= 1'b1;		//however, we need the pulse to be on for 1-2ms with 1ms pulse
end				//when control=0. 1/20=0.05. 0.05*1,000,000=50,000
else				//if we wanted 500hz refresh rate, Counter=50,000,000/500
begin				//Counter = 100,000 then instead of 50,000, use 5,000
pwm <= 1'b0;		//control*12,500 comes from 250,000/20. For 500hz 1,250
end
//#############################

if (counter >= 32'd1000000)	//clock speed is 50,000,000hz
begin						//we want to refresh signal 488 time a sec
counter <= 32'b0;					//50,000,000/50=1,000,000
end
else
begin
end




end




endmodule