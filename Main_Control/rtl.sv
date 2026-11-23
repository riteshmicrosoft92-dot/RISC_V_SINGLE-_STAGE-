module main_control (
    input  logic [6:0] opcode,
    input  logic [2:0] fn3,
    output logic [1:0] memtoreg,    // write-back select
    output logic       branch,
    output logic       mux_inp,     // 1 = JALR (target comes from the ALU)
    output logic       memread,
    output logic       memwrite,
    output logic       alusrc,      // 0 = rs2, 1 = immediate
    output logic       reg_write,
    output logic [2:0] aluop        // operation class for the ALU control
);
    always_comb begin
        {memtoreg, branch, mux_inp, memread, memwrite, alusrc, reg_write, aluop} = '0;
        case (opcode)
            7'h33: reg_write = 1'b1;
            7'h13: {alusrc, reg_write, aluop} = {2'b11, 3'b001};
            7'h03: {memtoreg, memread, alusrc, reg_write, aluop} = {2'b01, 3'b111, 3'b010};
            7'h23: {memtoreg, memwrite, alusrc, aluop} = {2'b11, 2'b11, 3'b011};
            7'h63: {branch, aluop} = {1'b1, 3'b100};
            7'h6f, 7'h37: {memtoreg, alusrc, reg_write, aluop} = {2'b10, 2'b11, 3'b110};
            7'h67: {memtoreg, mux_inp, alusrc, reg_write, aluop} = {2'b10, 3'b111, 3'b001};
            7'h17: {memtoreg, alusrc, reg_write} = {2'b10, 2'b11};
            default: ;
        endcase
    end
endmodule
