module router_fifo(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,full,empty,data_out);

input clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
input [7:0]data_in;
output full,empty;
output reg [7:0]data_out;
reg [6:0]count;
reg [4:0]wr_addr,rd_addr;
integer i;
reg [8:0]mem[15:0];
reg lfd_state_1;

//--------------------------READ & WRITE BLOCK----------------------------------
always@(posedge clock)
begin
lfd_state_1 <= lfd_state;
end


always@(posedge clock)
  begin
  if(~resetn)
    begin
    data_out<=0;
    end
  
  else if(soft_reset)
    begin
    data_out<=8'bz;
    end

 else if(read_enb&&~empty)
      begin
      data_out<=mem[rd_addr[3:0]][7:0];
      end

 else if(count==0)
    data_out<=8'bz;
  end
//------------------------------------------------------------------------------


always@(posedge clock)
 begin
 if(~resetn)
 begin
  for(i=0;i<16;i=i+1)
    mem[i]<=0;
 end

 else if(soft_reset)
    begin
        for(i=0;i<16;i=i+1)
    mem[i]<=0;
    end
  else if(write_enb&&(~full))   
      begin
	if(lfd_state_1)
	begin
	mem[wr_addr[3:0]][8]<=1'b1;
	mem[wr_addr[3:0]][7:0]<=data_in;
	end
      
	else
	begin
	mem[wr_addr[3:0]][8]<=1'b0;
	mem[wr_addr[3:0]][7:0]<=data_in;
	end
      end
end


//---------------------------Address Generation Block------------------------------


always@(posedge clock) //Write address
  begin
    if(~resetn)
    wr_addr<=0;
    else if(write_enb && (~full))
    wr_addr<=wr_addr+1;
  end
   
always@(posedge clock) //Read address
  begin
    if(~resetn)
    rd_addr<=0;
    else if(read_enb && (~empty))
    rd_addr<=rd_addr+1;
  end

//----------------------------Counter Generation Block---------------------------------

always@(posedge clock)
  begin
  if(read_enb&&(~empty))
    begin
    if(mem[rd_addr][8]==1'b1)
    count<=mem[rd_addr[3:0]][7:2]+1'b1;
    else if(count!=0)
    count<=count-1;
    end
  end
  
//----------------------------Empty & Full block----------------------------------------


assign full=(((wr_addr[4]!=rd_addr[4]) && (wr_addr[3:0]==rd_addr[3:0]))?1:0);

assign empty= ((wr_addr==rd_addr)?1:0);

  
//---------------------------End of code-------------------------------------------- 


endmodule
