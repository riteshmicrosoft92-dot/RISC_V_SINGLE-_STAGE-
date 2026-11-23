module alu_control (
    input  logic [2:0] alu_op,        // operation class from main_control
    input  logic [2:0] fn3,
    input  logic [6:0] imm11_5,       // instruction[31:25]: shift qualifier (I-type)
    input  logic       fn7_5,         // instruction[30]: SUB / SRA qualifier (R-type)
    output logic [4:0] control_out
);
    logic r_type;
    assign r_type = alu_op == 3'b000;

    always_comb begin
        control_out = 5'd0;
        case (alu_op)
            3'b000, 3'b001: begin
                case (fn3)
                    3'd0: control_out = r_type && fn7_5 ? 5'd1 : 5'd0;
                    3'd1: control_out = 5'd5;
                    3'd2: control_out = 5'd8;
                    3'd3: control_out = 5'd9;
                    3'd4: control_out = 5'd2;
                    3'd5: control_out = (r_type ? fn7_5 : imm11_5 == 7'h20) ? 5'd7 : 5'd6;
                    3'd6: control_out = 5'd3;
                    3'd7: control_out = 5'd4;
                    default: ;
                endcase
            end
            3'b100: begin
                case (fn3)
                    3'd0: control_out = 5'd10;
                    3'd1: control_out = 5'd11;
                    3'd4: control_out = 5'd12;
                    3'd5: control_out = 5'd13;
                    3'd6: control_out = 5'd14;
                    3'd7: control_out = 5'd15;
                    default: ;
                endcase
            end
            default: ;
        endcase
    end
endmodule
