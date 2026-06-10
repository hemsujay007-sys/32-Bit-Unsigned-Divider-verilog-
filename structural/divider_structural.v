`timescale 1ns / 1ps

module dividerstructural(
    input clk,
    input reset,
    input start,
    
    input [31:0]A,
    input [31:0]B,
    
    output [31:0]D,
    output [31:0]R,
    
    output ok,
    output err
    );
    
    wire active ;
    wire active_d;
    
    wire [31:0]result;
    wire [31:0]result_d;
    
    wire [31:0]denom;
    wire [31:0]denom_d;
    
    wire [4:0]cycle;
    wire [4:0]cycle_d;
    
    wire start_n;
    wire clr;
    
    wire [31:0]work;
    wire [31:0]work_d;
    
    wire [32:0]sub;
    
    assign sub = { 1'b0, work[30:0], result[31] } - {1'b0 , denom} ;
    
    assign D = result ;
    assign R = work ; 
    assign ok = ~active; 
    assign err = (B==0);
    
    //control logic
    not n1(start_n , start);
    or  O1(clr , reset , start_n);
    
    //next state logic
    
    assign active_d = 
        active?
        ((cycle==0)?1'b0 : active):
        1'b1 ;
     
     
    assign cycle_d = 
        active?
        cycle-1 :
        5'd31;
        
        
    assign denom_d=
        active?
        denom :
        B;
        
    assign result_d=
        active?
        (sub[32]==0?{result[30:0] , 1'b1} :  {result[30:0] , 1'b0}):
        A;
        
    assign work_d=
        active?
        (sub[32]==0? sub[31:0] :{work[30:0] , result[31] }):
        32'd0 ;  
        
    //registers
    dff active_reg(
        active,
        active_d,
        clr,
        clk
    );
    
    //cycle register
    register_5  cycle_reg( cycle , cycle_d , 1'b1 , clr , clk ) ;
    
    //denominator register
    register_32 denom_reg( denom , denom_d , 1'b1 , clr , clk);
    
    //work register 
    register_32 work_reg( work ,work_d , 1'b1 , clr , clk); 
    
    //result register
    register_32 result_reg(result , result_d , 1'b1 , clr , clk );    
endmodule

    module regbit(
        output bitout , 
        input bitdata , 
        input writeen , 
        input reset , 
        input clk
        );
        
        wire d;
        wire f1;
        wire f2;
        
        //MUX for write enable 
        
        and  u1( f1 , bitout  ,~writeen);
        and  u2( f2 , bitdata , writeen);
        or   u3( d , f1 , f2);
        
        dff dff0(bitout , d , reset , clk );
        
        endmodule
        
        module register_5(
            output [4:0]regout ,
            input  [4:0]regin  ,
            input  writeen     ,
            input  reset       ,
            input  clk       
        );
        
        regbit bit4(regout[4], regin[4], writeen, reset, clk);
        regbit bit3(regout[3], regin[3], writeen, reset, clk);
        regbit bit2(regout[2], regin[2], writeen, reset, clk);
        regbit bit1(regout[1], regin[1], writeen, reset, clk);
        regbit bit0(regout[0], regin[0], writeen, reset, clk);
        
        endmodule
        
        module register_32(
            output [31:0]regout ,
            input  [31:0]regin  ,
            input   writeen     ,
            input   reset       ,
            input   clk       
        );
        
        regbit bit31 (regout[31], regin[31], writeen, reset, clk);
        regbit bit30 (regout[30], regin[30], writeen, reset, clk);
        regbit bit29 (regout[29], regin[29], writeen, reset, clk);
        regbit bit28 (regout[28], regin[28], writeen, reset, clk);
        regbit bit27 (regout[27], regin[27], writeen, reset, clk);
        regbit bit26 (regout[26], regin[26], writeen, reset, clk);
        regbit bit25 (regout[25], regin[25], writeen, reset, clk);
        regbit bit24 (regout[24], regin[24], writeen, reset, clk);
        regbit bit23 (regout[23], regin[23], writeen, reset, clk);
        regbit bit22 (regout[22], regin[22], writeen, reset, clk);
        regbit bit21 (regout[21], regin[21], writeen, reset, clk);
        regbit bit20 (regout[20], regin[20], writeen, reset, clk);
        regbit bit19 (regout[19], regin[19], writeen, reset, clk);
        regbit bit18 (regout[18], regin[18], writeen, reset, clk);
        regbit bit17 (regout[17], regin[17], writeen, reset, clk);
        regbit bit16 (regout[16], regin[16], writeen, reset, clk);
        regbit bit15 (regout[15], regin[15], writeen, reset, clk);
        regbit bit14 (regout[14], regin[14], writeen, reset, clk);
        regbit bit13 (regout[13], regin[13], writeen, reset, clk);
        regbit bit12 (regout[12], regin[12], writeen, reset, clk);
        regbit bit11 (regout[11], regin[11], writeen, reset, clk);
        regbit bit10 (regout[10], regin[10], writeen, reset, clk);
        regbit bit9  (regout[9] , regin[9] , writeen, reset, clk);
        regbit bit8  (regout[8] , regin[8] , writeen, reset, clk);
        regbit bit7  (regout[7] , regin[7] , writeen, reset, clk);
        regbit bit6  (regout[6] , regin[6] , writeen, reset, clk);
        regbit bit5  (regout[5] , regin[5] , writeen, reset, clk);
        regbit bit4  (regout[4] , regin[4] , writeen, reset, clk);
        regbit bit3  (regout[3] , regin[3] , writeen, reset, clk);
        regbit bit2  (regout[2] , regin[2] , writeen, reset, clk);
        regbit bit1  (regout[1] , regin[1] , writeen, reset, clk);
        regbit bit0  (regout[0] , regin[0] , writeen, reset, clk);
               
        endmodule  
        
        module dff(
            output reg q    ,
            input  d    ,
            input  reset,
            input  clk 
        );
         always@ (posedge clk or posedge reset)
         begin
            if(reset)
                q <= 1'b0 ;
            else
                q <= d   ;
         end
            
        
        
        endmodule         
