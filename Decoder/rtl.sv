module decoder(
    input  logic [31:0] instruction,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [6:0]  imm11_5,      // instruction[31:25] (I-type ALU only)
    output logic [2:0]  fn3,
    output logic [11:0] imm,          // I / S / B immediate bits
    output logic [19:0] imm_uj,       // U / J immediate bits
    output logic        fn7_5         // instruction[30] (R-type only)
);
    assign opcode = instruction[6:0];

    always_comb begin
        {rs1, rs2, rd, imm11_5, fn3, imm, imm_uj, fn7_5} = '0;
        case (opcode)
            7'h33: begin
                {rd, fn3, rs1, rs2} = {instruction[11:7], instruction[14:12],
                                       instruction[19:15], instruction[24:20]};
                fn7_5 = instruction[30];
            end
            7'h13, 7'h03, 7'h67: begin
                {rd, fn3, rs1, imm} = {instruction[11:7], instruction[14:12],
                                       instruction[19:15], instruction[31:20]};
                if (opcode == 7'h13)
                    imm11_5 = instruction[31:25];
            end
            7'h23, 7'h63: begin
                {fn3, rs1, rs2} = {instruction[14:12], instruction[19:15], instruction[24:20]};
                if (opcode == 7'h23)
                    imm = {instruction[31:25], instruction[11:7]};
                else
                    imm = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
            end
            7'h6f: begin
                rd = instruction[11:7];
                imm_uj = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
            end
            7'h37, 7'h17: begin
                rd = instruction[11:7];
                imm_uj = instruction[31:12];
            end
            default: ;
        endcase
    end
endmodule
