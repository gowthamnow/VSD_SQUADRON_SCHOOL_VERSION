// 8N1 UART Module, transmit only
module uart_tx_8n1 (
    input clk,        // input clock (should be the 9600 Hz clock)
    input [7:0] txbyte, // outgoing byte
    input senddata,    // trigger tx
    output reg txdone,  // outgoing byte sent
    output tx          // tx wire
);

    /* Parameters */
    parameter STATE_IDLE    = 8'd0;
    parameter STATE_STARTTX = 8'd1;
    parameter STATE_TXING   = 8'd2;
    parameter STATE_TXDONE  = 8'd3;

    /* State variables */
    reg [7:0] state = STATE_IDLE;
    reg [7:0] buf_tx = 8'b0;
    reg [3:0] bits_sent = 4'b0;
    reg txbit = 1'b1;

    /* Wiring */
    assign tx = txbit;

    /* always */
    always @ (posedge clk) begin
        case (state)
            STATE_IDLE: begin
                txbit <= 1'b1;      // Idle state (TX held high)
                txdone <= 1'b0;     // Clear txdone signal
                if (senddata) begin
                    buf_tx <= txbyte;
                    state <= STATE_STARTTX;
                end
            end
            
            STATE_STARTTX: begin
                txbit <= 1'b0;      // Send start bit (low)
                state <= STATE_TXING;
            end
            
            STATE_TXING: begin
                if (bits_sent < 8) begin
                    txbit <= buf_tx[0];    // Transmit LSB first
                    buf_tx <= buf_tx >> 1; // Shift buffer right
                    bits_sent <= bits_sent + 1;
                end 
                else begin
                    txbit <= 1'b1;       // Send stop bit (high)
                    bits_sent <= 0;
                    state <= STATE_TXDONE;
                end
            end
            
            STATE_TXDONE: begin
                txdone <= 1'b1;   // Indicate transmission is done
                state <= STATE_IDLE;
            end
            
            default: state <= STATE_IDLE;
        endcase
    end

endmodule
