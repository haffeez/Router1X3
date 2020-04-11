module router_fifo_tb();

reg clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
reg [7:0]data_in;
wire full,empty;
wire [7:0]data_out;

parameter cycle=10;
reg[7:0]header,parity;

reg[1:0]addr;
integer i;

router_fifo DUT(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,full,empty,data_out);

//--------------------------Clock Generation Block----------------------------------

always
begin
  clock=1'b0;
  #(cycle/2);
  clock=1'b1;
  #(cycle/2);
end

//-----------------------------Reset Task Block--------------------------------------

task rst();
  begin
    @(negedge clock)
    resetn=1'b0;
    @(negedge clock)
    resetn=1'b1;
  end
endtask

task soft_rst();
  begin
      @(negedge clock)
      soft_reset=1'b1;
      @(negedge clock)
      soft_reset=1'b0;
  end
endtask

//----------------------------Initialization Task Block------------------------------- 

task initialize();
  begin
    write_enb=1'b0;
    soft_reset=1'b0;
    read_enb=1'b0;
    data_in=0;
    lfd_state=1'b0;
  end
endtask

//---------------------------Read & Write Task Block----------------------------------



task pkt_gen;
	reg[7:0]payload_data;
	reg[5:0]payload_len;
     begin
     @(negedge clock);
     payload_len=6'd4;
     addr=2'b01;
     header={payload_len,addr};
     data_in=header;
     lfd_state=1'b1; write_enb=1;
     
     for(i=0;i<payload_len;i=i+1)

     begin
    
     @(negedge clock);
     lfd_state = 0;
     payload_data={$random}%256;
     data_in=payload_data;
     end
   
     @(negedge clock);
     parity={$random}%256;
     data_in=parity;
     end

endtask

initial
begin
rst();

soft_rst;
pkt_gen;

repeat(2)
@(negedge clock);
read_enb=1;
write_enb=0;
@(negedge clock)
wait(empty)
@(negedge clock)
read_enb=0;

#100 $finish;
end

initial
begin
$dumpfile("file.vcd");
$dumpvars();
//#1000;
end

initial
$monitor("write_p %d read_p %d Values of Resetn=%b, Write enable=%b, Read enable=%b, LFD State=%b, Soft reset=%b, Empty=%b, Full=%b, Input data=%b, Output data=%b,",DUT.wr_addr,DUT.rd_addr,resetn,write_enb,read_enb,lfd_state,soft_reset,empty,full,data_in,data_out);

endmodule