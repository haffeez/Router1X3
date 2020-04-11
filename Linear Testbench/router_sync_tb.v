module router_sync_tb();
	wire [2:0]write_enb;
	wire fifo_full;
	wire vld_out_0,vld_out_1,vld_out_2;
	wire soft_reset_0,soft_reset_1,soft_reset_2;
	reg  clock,resetn,detect_add;
	reg  [1:0]data_in;
	reg  full_0,full_1,full_2;
	reg  empty_0,empty_1,empty_2;
        reg write_enb_reg;
        reg read_enb_0,read_enb_1,read_enb_2;
        parameter CYCLE=10;
    
router_sync DUT(clock,resetn,data_in,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,write_enb,fifo_full,vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2);
	
          always 
            begin
             #(CYCLE/2)
              clock=1'b0;
              #(CYCLE/2)
               clock=1'b1;
            end      
//task initialize	
           task initialize;
 	      begin
		{detect_add,data_in,full_0,full_1,full_2}=0;
		{write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2}=0;

	      end
	   endtask
//task reset
	      task reset_dut();
                  begin
                    @(negedge clock)
                      resetn=1'b0; 
		    @(negedge clock)
                      resetn=1'b1; 
                  end
              endtask
//task valid out
                task validout(input r1,r2,r3);
                   begin
                     // {vld_out_0,vld_out_1,vld_out_2}={v1,v2,v3};
                      {read_enb_0,read_enb_1,read_enb_2}={r1,r2,r3};
		   end 
               endtask
//task input and detect addresee
                 task detect_ad(input [1:0]d1,input detect_ad1);
                    begin
                      data_in=d1;
		      detect_add=detect_ad1;
                    end
      		endtask
//task fifo_full     
		task fifo_ful(input f1,f2,f3);
                    begin
                      full_0=f1;
                      full_1=f2;
                      full_2=f3;
                     // data_in=d2;
                    end
                endtask
//task empty
               task empty_dut(input e1,e2,e3);
                  begin
		    empty_0=e1;
		    empty_1=e2;
                    empty_2=e3;
		  end
		endtask
                task write_reg(input l1);
                    begin
                    write_enb_reg=l1;

                    end
               endtask
       initial
         begin
		initialize;
		reset_dut();
                @(negedge clock)
		validout(1,0,0);
                detect_ad(10,1);
		fifo_ful(0,0,0);
                 write_reg(1);

	        empty_dut(0,0,0);
                #100;
         end
 initial
   $monitor("clock=%b,resetn=%b,data_in=%b,detect_add=%b",clock,resetn,data_in,detect_add);
initial
     begin
	$dumpfile("router_sync.vcd");
	$dumpvars();
	#1000 $finish;
     end
endmodule


