typedef class IdleState;
typedef class Mv_Up_State;
typedef class Mv_Dn_State;
///////////////////////////////////////////////////////////////////
// MODELED VARIABLES
    logic Up_M_model;
    logic Dn_M_model;
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// MODELED STATES
typedef enum  {
    IDLE   = 2'b00,
    UP     = 2'b01,
    DOWN   = 2'b10
} STATES ;

STATES  current_state;
STATES  next_state;

///////////////////////////////////////////////////////////////////
class State;
    // The function should return a State handle rather than create a new instance inline
    virtual function State transition(logic Activate_tb, logic Up_Max_tb, logic Dn_Max_tb, logic reset_n);
        return this; // Default to stay in the same state
    endfunction

    function State reset_triggered();
        IdleState next_state;
        $display("reset state triggered !!");
        next_state = new();
        return next_state;
    endfunction
    
    function State go_to_idle_state();
        IdleState next_state;
        next_state = new();
        return next_state;
    endfunction

    function State go_to_up_state();
        Mv_Up_State next_state;
        next_state = new();
        return next_state;
    endfunction

    function State go_to_down_state();
        Mv_Dn_State next_state;
        next_state = new();
        return next_state;
    endfunction

endclass : State

class IdleState   extends State;
    function State transition(logic Activate_tb, logic Up_Max_tb, logic Dn_Max_tb, logic reset_n);
        current_state = IDLE;
        Up_M_model = 0;
        Dn_M_model = 0;
        if (!reset_n) begin
            next_state = IDLE;
            return reset_triggered();
        end else if (Activate_tb && Up_Max_tb && !Dn_Max_tb) begin 
            $display("we are in IdleState and going to Mv_Up_State !!");
            next_state = UP;
            return go_to_up_state();
        end else if (Activate_tb && !Up_Max_tb && Dn_Max_tb) begin 
            $display("we are in IdleState and going to Mv_Dn_State !!");
            next_state = DOWN;
            return go_to_down_state();
        end 
        return this;
    endfunction
endclass 

class Mv_Up_State extends State;
    function State transition(logic Activate_tb, logic Up_Max_tb, logic Dn_Max_tb, logic reset_n);
        current_state = UP;
        Up_M_model = 1;
        $display("[model UP State]the value of Activ: %0b up: %0b dwn: %0b t:%0p",Activate_tb,Up_Max_tb,Dn_Max_tb,$time);
        if (!reset_n) begin
            next_state = IDLE;
            return reset_triggered();
        end  else if (Up_Max_tb) begin 
            $display("we are in Mv_Up_State and going to IdleState !!");
            next_state = IDLE;
            return go_to_idle_state;
        end 
        $display("we are in Mv_Up_State and going to Mv_Up_State !!");
        return this;
    endfunction
endclass

class Mv_Dn_State extends State;
    function State transition(logic Activate_tb, logic Up_Max_tb, logic Dn_Max_tb, logic reset_n);
        Dn_M_model = 1 ;
        current_state = DOWN;
        if (!reset_n) begin
            next_state = IDLE;
             return reset_triggered();
        end else if (Dn_Max_tb) begin 
            $display("we are in Mv_Dn_State and going to IdleState !!");
            next_state = DOWN; 
            return go_to_down_state;
        end 
        $display("we are in Mv_Dn_State and going to Mv_Dn_State !!");
        return this;
    endfunction
endclass
     
module Door_Controller_tb();
  
  
//-----------------------------------------------------------------------
//                    Signals Decleration  
//-----------------------------------------------------------------------
    reg   Activate_tb;
    reg   UP_Max_tb;
    reg   DN_Max_tb;
    reg   CLK_tb;
    reg   RST_tb;
    wire  UP_M_tb;
    wire  DN_M_tb;

    IdleState starting_state;
    State current_state;
    State next_state ;
//-----------------------------------------------------------------------
//                         Initial BLock   
//-----------------------------------------------------------------------

initial
begin
  
  $dumpfile("Door_Controller.vcd") ;
   $dumpvars;
  
  //                      initial values
  
    Activate_tb = 1'b0 ;  
    UP_Max_tb = 1'b0 ;    
    DN_Max_tb = 1'b0 ;
    CLK_tb = 1'b0 ;
    RST_tb = 1'b1 ;
    starting_state = new();
    current_state = starting_state;
    current_state = current_state.transition(Activate_tb, UP_Max_tb, DN_Max_tb,RST_tb);
    
    //                      TEST CASE 1

        $display ("TEST CASE 1") ;  
        #3
        Activate_tb = 1'b0 ;  
        UP_Max_tb = 1'b0 ;    
        DN_Max_tb = 1'b0 ;
        #7;
        $display("TB : the value of Activ: %0b up: %0b dwn: %0b t:%0p",Activate_tb,UP_Max_tb,DN_Max_tb,$time);

    //                      TEST CASE 2
    
        $display ("TEST CASE 2") ;  
        #3
        Activate_tb = 1'b1 ;  
        UP_Max_tb = 1'b1 ;    
        DN_Max_tb = 1'b0 ;
        $display("TB : the value of Activ: %0b up: %0b dwn: %0b t:%0p",Activate_tb,UP_Max_tb,DN_Max_tb,$time);
        #7;

    //                      TEST CASE 3

        $display ("TEST CASE 3") ;  
        #3
        Activate_tb = 1'b0 ;  
        UP_Max_tb = 1'b0 ;    
        DN_Max_tb = 1'b1 ;
        $display("TB : the value of Activ: %0b up: %0b dwn: %0b t:%0p",Activate_tb,UP_Max_tb,DN_Max_tb,$time);
        #7;

    //                      TEST CASE 4
    
        $display ("TEST CASE 4") ;  
        #3
        Activate_tb = 1'b1 ;  
        UP_Max_tb = 1'b0 ;    
        DN_Max_tb = 1'b1 ;
        #7;
      
    //                      TEST CASE 5
    
        $display ("TEST CASE 5") ;  
        #3
        Activate_tb = 1'b0 ;  
        UP_Max_tb = 1'b1 ;    
        DN_Max_tb = 1'b0 ;
        #7;
      
    //          
    #100
    $finish ;                                                                                      
end

always @(*) begin 
    next_state = current_state.transition(Activate_tb, UP_Max_tb, DN_Max_tb,RST_tb);
end 
initial begin 
    forever begin   
        @(posedge CLK_tb);
        current_state = next_state;
        next_state = next_state.transition(Activate_tb, UP_Max_tb, DN_Max_tb,RST_tb);
    end 
end
//-----------------------------------------------------------------------
//                        Clock Generator  
//-----------------------------------------------------------------------
  
always 
  begin
  #4 CLK_tb = 1'b1 ;
  #6 CLK_tb = 1'b0 ;
end
  
  
//-----------------------------------------------------------------------
//                       instaniate design instance   
//-----------------------------------------------------------------------

Door_Controller DUT (
    .Activate(Activate_tb),
    .Up_Max(UP_Max_tb),
    .Dn_Max(DN_Max_tb),
    .CLK(CLK_tb),
    .RST(RST_tb),
    .Up_M(UP_M_tb),
    .Dn_M(DN_M_tb)
);

//-----------------------------------------------------------------------
//                       ASSERTIONS  
//-----------------------------------------------------------------------

property check_signal_UP;
  @(posedge CLK_tb) UP_M_tb == Up_M_model;
endproperty

property check_signal_DW;
  @(posedge CLK_tb) DN_M_tb == Dn_M_model;
endproperty

UP: assert property  (check_signal_UP)
    else  $error("UP Assertion failed at time %0t: Expected signal_Up_M_model = %0t, but Actual signal = %0d", $time,Up_M_model,UP_M_tb);
DW: assert property  (check_signal_DW)
    else  $error("DW Assertion failed at time %0t: Expected signal_Dn_M_model = %0t, but Actual signal = %0d", $time,Dn_M_model,DN_M_tb);

endmodule



