module rectangle(
    input logic [31:0] s_x,
    input logic [31:0] s_y,
    input logic [31:0] wi,
    input logic [31:0] he,
    input logic [31:0] x,
    input logic [31:0] y,
    output logic v
    );
    assign v =
        x >= s_x &
        x < s_x + wi &
        y >= s_y &
        y < s_y + he;
endmodule

module crystal_display(
    input logic [31:0] s_x,
    input logic [31:0] s_y,
    input logic [31:0] len,
    input logic [31:0] border,
    input logic [6:0] lines,
    input logic [31:0] x,
    input logic [31:0] y,
    input logic v
    );
    
    logic [6:0] rectangle_vs;
    
    rectangle rectangle0(
        s_x + border, s_y,
        len, border, x, y, rectangle_vs[0]);
    
    rectangle rectangle6(
        s_x + border, s_y + border + len,
        len, border, x, y, rectangle_vs[6]);
    
    rectangle rectangle3(
        s_x + border, s_y + 2*(border + len),
        len, border, x, y, rectangle_vs[3]);
    
    rectangle rectangle5(
        s_x, s_y + border,
        border, len, x, y, rectangle_vs[5]);
    
    rectangle rectangle1(
        s_x + border + len, s_y + border,
        border, len, x, y, rectangle_vs[1]);
    
    rectangle rectangle4(
        s_x, s_y + 2*border + len,
        border, len, x, y, rectangle_vs[4]);
    
    rectangle rectangle2(
        s_x + border + len, s_y + 2*border + len,
        border, len, x, y, rectangle_vs[2]);
    
    assign v =
        lines[0] & rectangle_vs[0] |
        lines[1] & rectangle_vs[1] |
        lines[2] & rectangle_vs[2] |
        lines[3] & rectangle_vs[3] |
        lines[4] & rectangle_vs[4] |
        lines[5] & rectangle_vs[5] |
        lines[6] & rectangle_vs[6];
endmodule

module digit_display(
    input logic [31:0] s_x,     // position (x)
    input logic [31:0] s_y,     // position (y)
    input logic [31:0] len,     // length of each segment
    input logic [31:0] border,  // thickness of the segments
    input logic [3:0] digit,    // the current digit to show
    input logic [31:0] x,       // VGA current x
    input logic [31:0] y,       // VGA current y
    input logic v               // should output? (OR this to VGA output)
    );
    
    logic [6:0] lines;
    
    always_comb begin
        case (digit)
        4'd0: lines = 7'b0111111;
        4'd1: lines = 7'b0000110;
        4'd2: lines = 7'b1011011;
        4'd3: lines = 7'b1001111;
        4'd4: lines = 7'b1100110;
        4'd5: lines = 7'b1101101;
        4'd6: lines = 7'b1111101;
        4'd7: lines = 7'b0000111;
        4'd8: lines = 7'b1111111;
        4'd9: lines = 7'b1101111;
        default: lines = 7'b1111111;
        endcase
    end
    
    crystal_display display(
        s_x, s_y, len, border,
        lines, x, y, v);
endmodule
