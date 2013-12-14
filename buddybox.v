module buddybox(clk,ch1in,ch2in,ch3in,ch4in,	//looks at inputs from 2 different radios
c1in, c2in, c3in, c4in,							//and uses ch1... radio as master, c1... as slave
ch1out,ch2out,ch3out,ch4out,					//ch1... goes out if there are some stick movement + time
buzzer);														//otherwise c1... goes out
input [10:0] ch1in,ch2in,ch3in,ch4in;		//time is 2 seconds
input [10:0] c1in, c2in, c3in, c4in;
input clk;

output buzzer;
output [10:0] ch1out,ch2out,ch3out,ch4out;

reg [10:0] ch1out,ch2out,ch3out,ch4out;
reg [31:0] counter;
reg [31:0] tempcounter;
reg [31:0] second;
reg [31:0] beepcounter;
reg [31:0] beep2counter;
reg buzzer;




/*always @ (*)
begin

if (second<2)
buzzer = 1'b1;
else
buzzer = 1'b0;


//if there is any input from ch1..., seconds is reset


if (((ch1in>500)&&(ch1in<530))&&((ch2in>500)&&(ch2in<530))&&((ch4in>500)&&(ch4in<530))&&(second>1))
begin
//slave has no control if master moves sticks or has moved them for past 3 seconds

if (beepcounter<4)
buzzer = 1'b1;
else 
buzzer = 1'b0;

beep2counter = 31'd0;

ch1out = c1in;
ch2out = c2in;
ch3out = ch3in;
ch4out = c4in;
end


else
begin
if (beep2counter<2)
buzzer = 1'b1;
if ((beep2counter<5)&&(beep2counter>2))
buzzer = 1'b0;

if ((beep2counter<7)&&(beep2counter>5))
buzzer = 1'b1;

if ((beep2counter>7))
buzzer = 1'b0;



beepcounter = 31'd0;


ch1out = ch1in;
ch2out = ch2in;
ch3out = ch3out;
ch4out = ch4in;

end



end
*/


always @ (posedge clk)
begin

tempcounter <= tempcounter+1;
counter <= counter+1;

//if there is any input from master..., seconds is reset


if (tempcounter>=50000000)
begin
second <= second +1;
tempcounter <= 32'd0;
end


if (counter>=5000000)
begin
beepcounter <= beepcounter +1;
beep2counter <= beep2counter +1;
counter <= 32'd0;
end









if (((ch1in>500)&&(ch1in<530))&&((ch2in>500)&&(ch2in<530))&&((ch4in>500)&&(ch4in<530)))
begin
//slave has no control if master moves sticks or has moved them for past 3 seconds

if (beepcounter<4)
buzzer <= 1'b1;
else 
buzzer <= 1'b0;

beep2counter <= 31'd0;

ch1out <= c1in;
ch2out <= c2in;
ch3out <= ch3in;
ch4out <= c4in;
end


else
begin
if (beep2counter<2)
buzzer <= 1'b1;
else
buzzer <= 1'b0;




beepcounter <= 31'd0;


ch1out <= ch1in;
ch2out <= ch2in;
ch3out <= ch3in;
ch4out <= ch4in;

end


if (((ch1in<490)||(ch1in>540))||((ch2in<490)||(ch2in>540))||((ch4in<490)||(ch4in>540)))
second <= 32'd0;




end

endmodule