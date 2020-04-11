module router_top_tb();

reg [7:0]data_in;
reg pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2;
wire[7:0]data_out_0,data_out_1,data_out_2;
wire vld_out_0,vld_out_1,vld_out_2,err,busy;

parameter cycle=10;
integer i;
event t1,t2,t3,t4,t5,t6;



router_top DUT(data_in,pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2,data_out_0,data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);

//--------------------------Clock Generation Block-----------------------------

always
begin
  clock=1'b0;
  #(cycle/2);
  clock=1'b1;
  #(cycle/2);
end

//-----------------------------Reset Task Block--------------------------------add
task rst();
  begin
    @(negedge clock)
    resetn=1'b0;
    @(negedge clock)
    resetn=1'b1;
  end
endtask
   
//----------------------------Initialization Task Block------------------------

task initialize();
  begin
    pkt_valid=1'b0;
    read_enb_0=1'b0;
    read_enb_1=1'b0;
    read_enb_2=1'b0;
  end
endtask

//----------------------------Packet Generation Task---------------------------
task pkt_gen_14_sft; //scenario 0

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;

   begin
      @(negedge clock);
      wait(~busy)
      @(negedge clock);
      payload_len=6'd14;
      addr=2'b00;
      header1={payload_len,addr};
      parity1=0;
      data_in=header1;
      pkt_valid=1;
      read_enb_0=0;
      parity1=parity1^header1;
      @(negedge clock)
      wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      @(negedge clock)
      wait(~busy)
      pkt_valid=0;
      data_in=parity1;
      
     // read_enb_0=1;

   end 
 endtask

task pkt_gen_14; //scenario 1

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;

   begin
       read_enb_0=1;

      @(negedge clock);
      wait(~busy)
      @(negedge clock);
      payload_len=6'd14;
      addr=2'b00;
      header1={payload_len,addr};
      parity1=0;
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
      @(negedge clock)
      wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      @(negedge clock)
      wait(~busy)
      pkt_valid=0;
      data_in=parity1;
      
   end 
 endtask

task pkt_gen_16; //scenario 2

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;

   begin
      read_enb_2=1;
      @(negedge clock);
      wait(~busy)
      @(negedge clock);
      payload_len=6'd16;
      addr=2'b10;
      header1={payload_len,addr};
      parity1=0;
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
      @(negedge clock)
      wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      @(negedge clock)
      wait(~busy)
      pkt_valid=0;
      data_in=parity1;
      #200;
      read_enb_2=1;

   end 
 endtask

task pkt_gen_17e; //scenario 3

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;
   begin
      @(negedge clock);
      wait(~busy)
      @(negedge clock);
      payload_len=6'd17;
      addr=2'b01;
      header1={payload_len,addr};
      parity1=0;
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
      @(negedge clock)
      wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      
     // ->t1;
      @(negedge clock)
       ->t1;

      wait(~busy)
      pkt_valid=0;
      
      //@(negedge clock);
      //pkt_valid=0;
      data_in=parity1;
      #200;

   end 
 endtask

task pkt_gen_random; //scenario 4

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;
   begin
      @(negedge clock);
       ->t2;
      wait(~busy)
      @(negedge clock);
      payload_len={$random}%63+1;
      addr=2'b01;
      header1={payload_len,addr};
      parity1=0;
  
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
     //   @(negedge clock)
       
     @(negedge clock)
     wait(~busy)
        // ->t2;

      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
       // ->t2;

	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      
           // @(negedge clock)
   //  ->t2;
     //pkt_valid=0;

      
      @(negedge clock);
      wait(~busy)
   
      pkt_valid=0;
      data_in=parity1;
   
     // #200;

   end 
 endtask

task pkt_gen_random_timeout; //scenario 5

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;
   begin
      @(negedge clock);
       ->t3;
      wait(~busy)
      @(negedge clock);
      payload_len={$random}%63+1;
      addr=2'b10;
      header1={payload_len,addr};
      parity1=0;
  
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
     @(negedge clock)
     wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
      	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      @(negedge clock);
      wait(~busy)
   
      pkt_valid=0;
      data_in=parity1;

   end 
 endtask

task bad_pkt_gen_random; //scenario 6

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;
   begin
      @(negedge clock);
       ->t4;
      wait(~busy)
      @(negedge clock);
      payload_len={$random}%63+1;
      addr=2'b10;
      header1={payload_len,addr};
      parity1=0;
  
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
     @(negedge clock)
     wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
      	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1+payload_data;
      end
      @(negedge clock);
      wait(~busy)
   
      pkt_valid=0;
      data_in=parity1;

   end 
 endtask

task pkt_gen_random_wait; //scenario 7

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;
   begin
      @(negedge clock);
       ->t5;
      wait(~busy)
      @(negedge clock);
      payload_len={$random}%63+1;
      addr=2'b10;
      header1={payload_len,addr};
      parity1=0;
  
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
     @(negedge clock)
     wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
      	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      @(negedge clock);
      wait(~busy)
   
      pkt_valid=0;
      data_in=parity1;

   end 
 endtask

task pkt_gen_random_wait1; //scenario 7_1

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;
   begin
      @(negedge clock);
       ->t6;
      wait(~busy)
      @(negedge clock);
      payload_len={$random}%63+1;
      addr=2'b10;
      header1={payload_len,addr};
      parity1=0;
  
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
     @(negedge clock)
     wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
      	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      @(negedge clock);
      wait(~busy)
   
      pkt_valid=0;
      data_in=parity1;

   end 
 endtask




task pkt_gen_17;//scenario unwanted

reg[7:0]payload_data,parity1,header1;
reg[5:0]payload_len;
reg[1:0]addr;

   begin
      @(negedge clock);
      wait(~busy)
      @(negedge clock);
      payload_len=6'd17;
      addr=2'b01;
      header1={payload_len,addr};
      parity1=0;
      data_in=header1;
      pkt_valid=1;
      parity1=parity1^header1;
      @(negedge clock)
      wait(~busy)
      for(i=0;i<payload_len;i=i+1)
      begin
	 @(negedge clock)
	 wait(~busy)
	 payload_data={$random}%256;
	 data_in=payload_data;
	 parity1=parity1^payload_data;
      end
      @(negedge clock)
      wait(~busy)
       begin
      pkt_valid=0;
      data_in=parity1;
     end

      //read_enb_1=1;

   end 
 endtask

 

 





//-------------------------------INITIALIZING---------------------------------

initial
begin
@(t1);
@(negedge clock);
read_enb_1=1;
@(negedge clock);
wait(~vld_out_1)
@(negedge clock);
read_enb_1=0;
end

initial
begin
@(t2);
@(negedge clock);
wait(vld_out_1)
read_enb_1=1;
@(negedge clock);
wait(~vld_out_1)
@(negedge clock);
read_enb_1=0;
end

initial
begin
@(t3);
@(negedge clock);
wait(vld_out_2)
read_enb_2=0;
@(negedge clock);
wait(~vld_out_2)
@(negedge clock);
read_enb_2=0;
end

initial
begin
@(t4);
@(negedge clock);
wait(vld_out_2)
read_enb_2=0;
@(negedge clock);
wait(~vld_out_2)
@(negedge clock);
read_enb_2=0;
end

initial
begin
@(t5);
@(negedge clock);
wait(vld_out_2)
read_enb_2=0;
@(negedge clock);
wait(~vld_out_2)
@(negedge clock);
read_enb_2=0;
end


initial
begin
@(t6);
@(negedge clock);
wait(vld_out_2)
read_enb_2=1;
@(negedge clock);
wait(~vld_out_2)
@(negedge clock);
read_enb_2=0;
end



initial
begin
rst();
initialize();
/*pkt_gen_14;
pkt_gen_14_sft; 
pkt_gen_16;
pkt_gen_17e;
#200;
pkt_gen_random; 
#300;
pkt_gen_random_timeout;
#200;
bad_pkt_gen_random;
#200;
pkt_gen_random_wait;
#200;
pkt_gen_random_wait1;
#8000;
end

initial
begin
$dumpfile("Router_top1.vcd");
$dumpvars;
#8000 $finish;
end

endmodule

/*module router_top_tb();

parameter cycle = 10;

reg pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2;
reg [7:0]data_in;

wire vld_out_0,vld_out_1,vld_out_2,err,busy;
wire [7:0]data_out_0,data_out_1,data_out_2;
integer i;
event t2;
event t3;
event t4;
event t5;
event t6;
event t7;
event t8;
event t9,t10;

router_top DUT(data_in,pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2,data_out_0,data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);


initial
 begin
 clock = 1'b1;
 forever #(cycle/2) clock=~clock;
 end

task initialize;
begin
read_enb_0 = 0;
read_enb_1 = 0;
read_enb_2 = 0;
pkt_valid = 0;
end
endtask

task rst;
begin
 @(negedge clock)
 resetn = 0;
 @(negedge clock)
 resetn = 1;
end
endtask

//scenario 1:payload_length = 14bytes

task pkt_gen_14;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd14;
 addr = 2'b00; //valid packet
 header = {payload_len,addr};
 parity = 0;
 data_in = header;
 pkt_valid = 1'b1;
 parity = parity^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = parity ^ payload_data;
 end
 @(negedge clock)
 wait(~busy)
 pkt_valid = 0;
 data_in = parity;
end
endtask

//-----------------task for payload length 16------------------------------

task pkt_gen_16;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd16;
 addr = 2'b01; //valid packet
 header = {payload_len,addr};
 parity = 0;
 data_in = header;
 pkt_valid = 1'b1;
 parity = parity^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = parity ^ payload_data;
 end
 @(negedge clock)
 wait(~busy)
 pkt_valid = 0;
 data_in = parity;
end
endtask

//--------------------task for payload length 17-----------------------


event t1;

task pkt_gen_17;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd17;
 addr = 2'b10; //valid packet
 header = {payload_len,addr};
 parity = 0;
 data_in = header;
 pkt_valid = 1'b1;
 parity = parity ^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = parity ^ payload_data;
 end
 @(negedge clock)
 ->t1;
 wait(~busy)
 pkt_valid = 0;
 data_in = parity;
end
endtask


initial 
begin 
 @(t1);
 @(negedge clock);
 read_enb_2 = 1;
 @(~vld_out_2);
 @(negedge clock);
 read_enb_2 = 0;
 ->t3;
end


 
initial
begin
rst;
initialize;
@(negedge clock)
//read_enb_1= 1;
pkt_gen_14;
repeat(2)
@(negedge clock);
read_enb_0=1;
@(~vld_out_0);
read_enb_0=0;
pkt_gen_16;
read_enb_1 = 1;
@(~vld_out_1);
read_enb_1 = 0;

pkt_gen_17;
@(t3);
pkt_gen_random;
@(t4);
pkt_gen_without_readenb;

@(t8);
pkt_gen_bad_packet;

@(t6);
//repeat(2)
pkt_gen_fsm;
pkt_gen_after_fsm;
 

//---------------------random size----------------------


task pkt_gen_random;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd40;
 addr = 2'b10; //valid packet
 header = {payload_len,addr};
 parity = 0;
  data_in = header;
 pkt_valid = 1'b1;
  ->t2;
 parity = parity^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = parity ^ payload_data;
 end
 @(negedge clock)
 wait(~busy)
 pkt_valid = 0;
 data_in = parity;
end
endtask

initial
begin
@(t2);
@(negedge clock);
read_enb_2 = 1'b1;
@(negedge clock);
@(negedge clock);
@(~vld_out_2);
@(negedge clock);
read_enb_2 = 1'b0;
->t4;
end

//---------------------bad_packet_generation--------------------


task pkt_gen_bad_packet;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd40;
 addr = 2'b00; //valid packet
 header = {payload_len,addr};
 parity = 0;
  data_in = header;
 pkt_valid = 1'b1;
  ->t5;
 parity = parity^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = (parity ^ payload_data)+1'b1;
 end
 @(negedge clock)
 wait(~busy)
 pkt_valid = 0;
 data_in = parity;
end
endtask

initial
 begin
@(t5);
@(negedge clock);
read_enb_0 = 1'b1;
@(negedge clock);
@(negedge clock);
@(~vld_out_0);
@(negedge clock);
read_enb_0 = 1'b0;
->t6;
end


//------------------pkt gen without read enable--------------


task pkt_gen_without_readenb;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd14;
 addr = 2'b00; //valid packet
 header = {payload_len,addr};
 parity = 0;
  data_in = header;
 pkt_valid = 1'b1;
  ->t7;
 parity = parity^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = parity ^ payload_data;
 end
 @(negedge clock)
 wait(~busy)
 pkt_valid = 0;
 data_in = parity;
end
endtask

initial
begin
@(t7);
@(negedge clock);
@(negedge clock);
@(negedge clock);

@(~vld_out_0);
@(negedge clock);
//read_enb_0 = 1'b0;
->t8;
end

//------------------------pkt_gen_fsm-------------------------

task pkt_gen_fsm;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd6;
 addr = 2'b00; //valid packet
 header = {payload_len,addr};
 parity = 0;
  data_in = header;
 pkt_valid = 1'b1;
 parity = parity^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = parity ^ payload_data;
 end
 @(negedge clock)
 wait(~busy)
  pkt_valid = 0;
 data_in = parity;
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 ->t9;
end
endtask

//-------------------------pkt gen after fsm pkt generation-------------------


task pkt_gen_after_fsm;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;

begin
 @(negedge clock);
 wait(~busy)
 @(negedge clock);
 payload_len = 6'd14;
 addr = 2'b00; //valid packet
 header = {payload_len,addr};
 parity = 0;
  data_in = header;
 pkt_valid = 1'b1;
 ->t10; 
 parity = parity^header;
@(negedge clock);
 wait(~busy)
 for(i=0;i<payload_len;i=i+1)
 begin
  @(negedge clock)
	wait(~busy)
 	payload_data = {$random}%256;
	data_in = payload_data;
 	parity = parity ^ payload_data;
 end
 @(negedge clock)
 wait(~busy)
  pkt_valid = 0;
 data_in = parity;
end
endtask

initial
begin
@(t10);
@(negedge clock);
read_enb_0 = 1'b1;
@(negedge clock);
@(negedge clock);
@(~vld_out_0);
@(negedge clock);
read_enb_0 = 1'b0;
end

initial
begin
 $dumpfile("router_top.vcd");
 $dumpvars();
 #5000 $finish;
end

endmodule



