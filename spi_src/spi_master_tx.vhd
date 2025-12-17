library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_master_tx is
    Port (
        clk       : in  STD_LOGIC;                      -- system clk
        reset     : in  STD_LOGIC;                      -- async reset
        start     : in  STD_LOGIC;                      -- transmission start
        data_in   : in  STD_LOGIC_VECTOR(7 downto 0);   -- Input data byte
        sck       : out STD_LOGIC;                      -- SPI clk
        mosi      : out STD_LOGIC;                      -- Input line
        ss        : out STD_LOGIC;                      -- Chip Select (active low)
        busy      : out STD_LOGIC;                      -- busy flag
        done      : out STD_LOGIC                       -- done flag
    );
end spi_master_tx;

architecture Behavioral of spi_master_tx is
    -- FSM states
    type state_type is (IDLE, LOAD, TRANSMIT, DONE_STATE);
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
            done <= '0';
            mosi <= '0';
            
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    ss <= '1';              -- deactivate SS
                    busy <= '0';
                    done <= '0';
                    sck_reg <= '0';
                    bit_counter <= 0;
                    
                    if start = '1' then
                        state <= LOAD;
                    end if;
                
                -- State LOAD: data load
                when LOAD =>
                    shift_reg <= data_in;
                    ss <= '0';              -- activate SS
                    busy <= '1';
                    done <= '0';
                    bit_counter <= 0;
                    state <= TRANSMIT;
                
                -- State TRANSMIT: transmit byte
                when TRANSMIT =>
                    -- SCK freq divider
                    if clk_divider = 3 then
                        clk_divider <= 0;
                        sck_reg <= not sck_reg;
                        
                        if sck_reg = '0' then
                            mosi <= shift_reg(7);
                            shift_reg <= shift_reg(6 downto 0) & '0'; -- left shift
                            bit_counter <= bit_counter + 1;
                        end if;
                        
                        -- Check if transmission is done
                        if bit_counter = 8 and sck_reg = '1' then
                            state <= DONE_STATE;
                        end if;
                    else
                        clk_divider <= clk_divider + 1;
                    end if;
                
                -- State DONE: end of transmit
                when DONE_STATE =>
                    ss <= '1';              -- deactivate SS
                    sck_reg <= '0';
                    busy <= '0';
                    done <= '1';
                    state <= IDLE;
                    
            end case;
        end if;
    end process;
    
    -- Assign input signals
    sck <= sck_reg;
    
end Behavioral;
