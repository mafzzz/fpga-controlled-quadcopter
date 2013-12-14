module channel(clk, pwmsignal ,ratio);
input clk;
input pwmsignal;


output [12:0] ratio;
reg [31:0] counter;
reg [31:0] signalon;		//# of times a sec pwm signal is at 1

reg [12:0] ratio;
reg [31:0] tempcounter;
reg [31:0] tempratio;
reg [31:0] preratio;

always @ (posedge clk)
begin
if (counter<32'd50)	//whenever the counter is reset, signalon is also reset
begin
signalon <= 32'd0;
end
else
begin
end

tempcounter <= tempcounter+1;
counter <= counter+1;


if (pwmsignal == 1'b1)	
begin
signalon <= signalon+1;	//keeps adding 1 to signalon as long as signal is 1
end
else							//when signal is 0, this starts the calculations
begin
if (signalon>48000)
begin
tempratio <= ((signalon - (32'd49300))/(32'd50));
signalon <= 1'b0;
counter <= 1'b0;
end
else
begin
end
end


if (tempcounter >= (32'd2500000))
begin
tempcounter <= 32'd0;
ratio <= preratio;
end

if ((tempratio<32'd1000)&&(tempratio>=32'd0))
preratio <= tempratio;

if ((tempratio>32'd1000)&&(tempratio<32'd2000))
preratio <= 32'd1000;

if (tempratio<32'd0)
preratio <= 32'd0;



end




endmodule



