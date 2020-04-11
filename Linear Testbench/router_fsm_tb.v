module router_fsm_tb();

reg clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid;
reg [1:0] data_in;
wire write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

parameter cycle=10;

router_fsm DUT(clock,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

   always
   begin
    #cycle;
    clock=1'b1;
    #cycle;
    clock=(~clock);
   end

   task initialize;
   begin
   {pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,fifo_full,parity_done,low_packet_valid}=0;
   end
   endtask

   task rst;
   begin
   @(negedge clock)
    resetn=1'b0;
   @(negedge clock)
    resetn=1'b1;
   end
   endtask

   task t1;
   begin
   @(negedge clock)
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end
   @(negedge clock)
   @(negedge clock)
   begin
   fifo_full<=0;
   pkt_valid<=0;
   end
   @(negedge clock)
   @(negedge clock)
   fifo_full<=0;
   end
   endtask

   task t2;
   begin
   @(negedge clock)//LFD
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end
   @(negedge clock)//LD
   @(negedge clock)//FFS
   fifo_full<=1;
   @(negedge clock)//LAF
   fifo_full<=0;
   @(negedge clock)//LP
   begin
   parity_done<=0;
   low_packet_valid<=1;
   end
   @(negedge clock)//CPE
   @(negedge clock)//DA
   fifo_full<=0;
   end
   endtask

   task t3;
   begin
   @(negedge clock)
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end
   @(negedge clock)
   @(negedge clock)
   fifo_full<=1;
   @(negedge clock)
   fifo_full<=0;
   @(negedge clock)
   begin
      low_packet_valid<=0;
	parity_done<=0;

   end
   @(negedge clock)
   begin
   fifo_full<=0;
   pkt_valid<=0;
   end
   @(negedge clock)
   @(negedge clock)
   fifo_full<=0;
   end
   endtask
   
   task t4;
   begin
   @(negedge clock)
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end
   @(negedge clock)
   @(negedge clock)
   begin
   fifo_full<=0;
   pkt_valid<=0;
   end
   @(negedge clock)
   @(negedge clock)
   fifo_full<=1;
 //  @(negedge clock)
   @(negedge clock)
   fifo_full<=0;
  @(negedge clock)
   parity_done=1;
   end
   endtask


   initial
   begin
   rst;
   initialize;
  // low_packet_valid<=0;
    // t1;
   //  t2;
   // t3;
     t4;
   
   end

   initial $monitor("Reset=%b, State=%d, det_add=%b, write_enb_reg=%b, full_state=%b, lfd_state=%b, busy=%b, ld_state=%b, laf_state=%b, rst_int_reg=%b, low_packet_valid=%b",resetn,DUT.state,detect_add,write_enb_reg,full_state,lfd_state,busy,ld_state,laf_state,rst_int_reg,low_packet_valid);
   
   initial
   begin
   $dumpfile("router_fsm.vcd");
   $dumpvars();
   #1000 $finish;
   end
   endmodule   
