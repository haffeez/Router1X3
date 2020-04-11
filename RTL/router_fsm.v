module router_fsm(clock,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

input clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid;
input [1:0] data_in;
output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

parameter DECODE_ADDRESS=    8'b00000001,//1
	  LOAD_FIRST_DATA=   8'b00000010,//2
	  LOAD_DATA=         8'b00000100,//4
	  WAIT_TILL_EMPTY=   8'b00001000,//8
	  CHECK_PARITY_ERROR=8'b00010000,//16
	  LOAD_PARITY=       8'b00100000,//32
	  FIFO_FULL_STATE=   8'b01000000,//64
	  LOAD_AFTER_FULL=   8'b10000000;//128

reg [7:0] state,next_state;

always@(posedge clock )
begin
   if(~resetn)
      state<=DECODE_ADDRESS;
   else if(soft_reset_0||soft_reset_1||soft_reset_2) 
      state<=DECODE_ADDRESS;
   else
      state<=next_state;
end


always@(*)
begin
 next_state=DECODE_ADDRESS;
   case(state)
       DECODE_ADDRESS:	   begin
			       if((pkt_valid&&(data_in[1:0]==0)&&fifo_empty_0)||
				  (pkt_valid&&(data_in[1:0]==1)&&fifo_empty_1)||
				  (pkt_valid&&(data_in[1:0]==2)&&fifo_empty_2))
				 
				 next_state=LOAD_FIRST_DATA;
			       				
			       	else if((pkt_valid&&(data_in[1:0]==0)&&(~fifo_empty_0))||
				        (pkt_valid&&(data_in[1:0]==1)&&(~fifo_empty_1))||
				        (pkt_valid&&(data_in[1:0]==2)&&(~fifo_empty_2)))

				  next_state=WAIT_TILL_EMPTY;

				else 
				
				  next_state=DECODE_ADDRESS;
			   end

       LOAD_FIRST_DATA:	   begin
			      next_state=LOAD_DATA;
			   end

       LOAD_DATA:	   begin
			      if(fifo_full)
				 next_state=FIFO_FULL_STATE;
			      else if(fifo_full==0&&pkt_valid==0)
				 next_state=LOAD_PARITY;
			      else
				 next_state=LOAD_DATA;
			   end
       
       WAIT_TILL_EMPTY:	   begin
			      if((~fifo_empty_0)||(~fifo_empty_1)||(~fifo_empty_2))
				 next_state=WAIT_TILL_EMPTY;
			      else if(fifo_empty_0||fifo_empty_1||fifo_empty_2)
				 next_state=LOAD_FIRST_DATA;
			      else
				 next_state=state;
			   end

       CHECK_PARITY_ERROR: begin
			    if(fifo_full)
			      	 next_state=FIFO_FULL_STATE;
			    else
			         next_state=DECODE_ADDRESS;

			   end

       LOAD_PARITY:	   begin
			   next_state=CHECK_PARITY_ERROR;
			   end

       FIFO_FULL_STATE:	   begin
			      if(fifo_full==0)
			         next_state=LOAD_AFTER_FULL;
			      else if(fifo_full==1)
			         next_state=FIFO_FULL_STATE;
			   end

       LOAD_AFTER_FULL:	   begin
			      if((parity_done==0)&&(low_packet_valid==0))
			   	next_state=LOAD_DATA;
			      else if((parity_done==0)&&(low_packet_valid==1))
			   	next_state=LOAD_PARITY;

			      else if(parity_done)
			   	next_state=DECODE_ADDRESS;
			   end
   endcase
end

assign detect_add = ((state==DECODE_ADDRESS)?1:0); 
assign write_enb_reg=((state==LOAD_DATA||state==LOAD_PARITY||state==LOAD_AFTER_FULL)?1:0);
//assign write_enb_reg=((state==FIFO_FULL_STATE||state==LOAD_AFTER_FULL||state==WAIT_TILL_EMPTY)?0:1);
assign full_state=((state==FIFO_FULL_STATE)?1:0);
assign lfd_state=((state==LOAD_FIRST_DATA)?1:0);
assign busy=((state==FIFO_FULL_STATE||state==LOAD_AFTER_FULL||state==WAIT_TILL_EMPTY||state==LOAD_FIRST_DATA||state==LOAD_PARITY||state==CHECK_PARITY_ERROR)?1:0);
//assign busy=((state==LOAD_DATA)?0:1);
assign ld_state=((state==LOAD_DATA)?1:0);
assign laf_state=((state==LOAD_AFTER_FULL)?1:0);
assign rst_int_reg=((state==CHECK_PARITY_ERROR)?1:0);
//assign low_packet_valid=((state==CHECK_PARITY_ERROR)?0:1);


endmodule






