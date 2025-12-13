library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_master_rx is
    Port (
        clk       : in  STD_LOGIC;                      -- system clk
        reset     : in  STD_LOGIC;                      -- async reset
        start     : in  STD_LOGIC;                      -- start receiving
        miso      : in  STD_LOGIC;                      -- input line
        sck       : out STD_LOGIC;                      -- SPI clock
        ss        : out STD_LOGIC;                      -- Chip Select
        data_out  : out STD_LOGIC_VECTOR(7 downto 0);   -- Received data
        busy      : out STD_LOGIC;                      -- busy flag
        valid     : out STD_LOGIC                       -- validity flag
    );
end spi_master_rx;

architecture Behavioral of spi_master_rx is
    type state_type is (IDLE, RECEIVE, DONE_STATE);
    signal state : state_type := IDLE;
    
    signal shift_reg   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal bit_counter : INTEGER range 0 to 8 := 0;
    signal sck_reg     : STD_LOGIC := '0';
    signal clk_divider : INTEGER range 0 to 3 := 0;
    
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            shift_reg <= (others => '0');
            bit_counter <= 0;
            sck_reg <= '0';
            clk_divider <= 0;
            ss <= '1';
            busy <= '0';
            valid <= '0';
            
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    ss <= '1';
                    busy <= '0';
                    valid <= '0';
                    sck_reg <= '0';
                    bit_counter <= 0;
                    
                    if start = '1' then
                        state <= RECEIVE;
                        ss <= '0';
                        busy <= '1';
                    end if;
                
                when RECEIVE =>
                    if clk_divider = 3 then
                        clk_divider <= 0;
                        sck_reg <= not sck_reg;
                        
                        -- 
                        if sck_reg = '0' then
                            shift_reg <= shift_reg(6 downto 0) & miso;
                            bit_counter <= bit_counter + 1;
                        end if;
                        
                        if bit_counter = 8 and sck_reg = '1' then
                            state <= DONE_STATE;
                        end if;
                    else
                        clk_divider <= clk_divider + 1;
                    end if;
                
                when DONE_STATE =>
                    ss <= '1';
                    sck_reg <= '0';
                    busy <= '0';
                    valid <= '1';
                    data_out <= shift_reg;
                    state <= IDLE;
                    
            end case;
        end if;
    end process;
    
    sck <= sck_reg;
    
end Behavioral;
