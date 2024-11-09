/******************************************************************************
*
* Module: Private - Door_Controller
*
* File Name: Door_Controller.v
*
* Description:  Activate push button (user) trigger the Up motor when the Door
*               down and trigger the Down motor when the Door UpUP_Max (Sensor) 
*               becomes high when the Door is completely open.DN_Max (Sensor) 
*               becomes high when the Door is completely close.Always the Door 
*               is completely close or completely open.Finite state machine is 
*               initialized to IDLE state using Asynchronous reset
*               States Diagram:
*               
* Author: Mohamed A. Eladawy
*
*******************************************************************************/
//************************** Port Declaration ********************************//

module Door_Controller (

input      wire        CLK      , //Declaring the Variable As an Input Port with width 1 bit 
input      wire        RST      , //Declaring the Variable As an Input Port with width 1 bit 
input      wire        Activate , //Declaring the Variable As an Input Port with width 1 bit  
input      wire        Up_Max   , //Declaring the Variable As an Input Port with width 1 bit 
input      wire        Dn_Max   , //Declaring the Variable As an Input Port with width 1 bit 
output     reg         Up_M     , //Declaring the Variable As an Output Port with width 1 bit 
output     reg         Dn_M       //Declaring the Variable As an Output Port with width 1 bit 

);

//******************** Parameters Initialization  ******************//

localparam          IDLE  = 2'b00 ,
                    Mv_Up = 2'b01 ,                    
                    Mv_Dn = 2'b10 ;
                    
//******************** Internal Signal Declaration *****************//

reg      [1:0]      current_state ,
                    next_state ;

//************************* The RTL Code ***************************//

/*************** Starting The Sequential Always Block ***************/

always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
    
       begin
 
          current_state <= IDLE ;
          
       end
  else
   
       begin
   
          current_state <= next_state ;
 
       end

 end

/*************** Starting The Combinational Always Block ***************/

always @ (*)
 
 begin
 
   case (current_state)
 
   IDLE   :  begin
             
              Up_M  = 1'b0 ;
              Dn_M  = 1'b0 ;
              
              if(Activate && Up_Max && !Dn_Max)
             
                begin
               
                   next_state = Mv_Up  ;
               
                end
             
              else if(Activate && Dn_Max && !Up_Max)
             
                begin
             
                 next_state = Mv_Dn     ;
             
                end
              
              else   
              
                begin
              
                 next_state = IDLE  ;
              
                end  
             end
             
   Mv_Up  :  begin
              
              Up_M  = 1'b1 ;
              
              if(Up_Max)
            
                begin
            
                 next_state = IDLE  ;
            
                end
            
              else  
                begin
                 next_state = Mv_Up  ;
                end        
             end
  
   Mv_Dn  :  begin
              
              Dn_M  = 1'b1 ;
              
              if(Dn_Max)
               
                begin
               
                 next_state = IDLE  ;
               
                end
             
              else  
             
                begin
             
                 next_state = Mv_Dn  ;
             
                end        
             end
  
   default : 
             begin
             
                 next_state = IDLE  ;
                 Up_M  = 1'b0 ;
                 Dn_M  = 1'b0 ;
             
             end  
   endcase   
 end



/*********************************************************************/

endmodule

