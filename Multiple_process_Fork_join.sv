// fork join
// To execute multiple process in a parallel
// We need to use this in a procedural block
// fork join will not allow execution after join unless and until all blocks inside it are executed

module tb;

  int i = 0;
  bit [7:0] data1,data2;
  event done;
  event next; // to let know that driver has completed the task

  task generator();
    for(i=0;i<10;i++) begin
      data1 = $urandom();
      $display("Data Sent: %0d", data1);
      #10;
      wait(next.triggered); // after this generater should send next sample
    end
   -> done; // We are ready to finish the simulation
  endtask

   // Receiver or driver
  task receiver();
    forever begin
      #10;
      data2 = data1;
      $display("Data RCVD: %0d", data2);
      ->next;
    end
  endtask

  task wait_event();
    wait(done.triggered);
    $display("Completed sending all stimulus");
    $finish;
  endtask


  // for execution of all these processes in parallel we require fork join

  initial begin
    fork
      // Order doesnt matter
      // Just for readability added in order
      generator();
      receiver();
      wait_event();
    join

    // blocks execution until fork join gets completed
  end
  
// Too many initial blocks could lead to race around condition that we dont know ehich inital block is getting priorty of execution

endmodule
