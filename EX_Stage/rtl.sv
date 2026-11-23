module ex_stage (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,
    input  logic [31:0] address,       // current PC
    input  logic        branch,
    input  logic        alu_src,       // 0 = rs2_data, 1 = imm_out
    input  logic        fn7_5,
    input  logic        mux_inp,       // 1 = JALR
    input  logic [2:0]  fn3,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic [6:0]  opcode,
    output logic        and_out_ex,    // branch / jump taken
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out      // branch / jump target
);
    logic [4:0] control_out;
    logic [31:0] operand_b;
    logic zero;

    assign operand_b = alu_src ? imm_out : rs2_data;
    assign pc_ex_out = mux_inp ? {alu_out[31:1], 1'b0} : address + imm_out;
    assign and_out_ex = (branch && zero) || opcode == 7'h6f || opcode == 7'h67;

    alu_control control (
        .alu_op(aluop), .fn3(fn3), .imm11_5(imm11_5), .fn7_5(fn7_5),
        .control_out(control_out)
    );
    alu datapath (
        .alu_control(control_out), .rs1_data(rs1_data), .rs2_data(operand_b),
        .alu_out(alu_out), .zero(zero)
    );
endmodule
