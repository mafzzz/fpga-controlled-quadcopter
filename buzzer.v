module buzzer(clk,ch5ratio,on);
input clk;
input [8:0] ch5ratio;
output on;


reg on;
reg [31:0] counter;
reg [4:0] temp;

always @ (posedge clk)
begin
counter <= counter+1;




if (counter >= 32'd10000000)	
begin						
counter <= 32'b0;		
temp <= (ch5ratio/100);
end




end


always @(*)
begin
if ((ch5ratio/100)!=temp)
on = 1'b1;
else
on = 1'b0;


end


endmodule