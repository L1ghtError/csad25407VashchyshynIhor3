library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_master_tb is
end spi_master_tb;

architecture Behavioral of spi_master_tb is
    -- Test components:
    component spi_master_tx is
        Port (
            clk       : in  STD_LOGIC;
            reset     : in  STD_LOGIC;
            start     : in  STD_LOGIC;
            data_in   : in  STD_LOGIC_VECTOR(7 downto 0);
            sck       : out STD_LOGIC;
            mosi      : out STD_LOGIC;
            ss        : out STD_LOGIC;
            busy      : out STD_LOGIC;
            done      : out STD_LOGIC
        );
    end component;
    
    -- Test signals
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '0';
    signal start     : STD_LOGIC := '0';
    signal data_in   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal sck       : STD_LOGIC;
    signal mosi      : STD_LOGIC;
    signal ss        : STD_LOGIC;
    signal busy      : STD_LOGIC;
    signal done      : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz
    
begin
    -- Module instances
    UUT: spi_master_tx
        port map (
            clk       => clk,
            reset     => reset,
            start     => start,
            data_in   => data_in,
            sck       => sck,
            mosi      => mosi,
            ss        => ss,
            busy      => busy,
            done      => done
        );
    
    -- CLK generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Test scenario
    stimulus: process
    begin
        -- Init
        reset <= '1';
        start <= '0';
        data_in <= X"00";
        wait for 100 ns;
        
        reset <= '0';
        wait for 50 ns;
        
        -- Test 1: Transmission of byte 0xA5 (10100101)
        report "Test 1: Sending 0xA5";
        data_in <= X"A5";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        -- Wait unitl it ends
        wait until done = '1';
        wait for 100 ns;
        
        -- Test 2: Transmission of byte 0x5A (01011010)
        report "Test 2: Sending 0x5A";
        data_in <= X"5A";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        wait until done = '1';
        wait for 100 ns;
        
        -- Test 3: Transmission of byte 0xFF (11111111)
        report "Test 3: Sending 0xFF";
        data_in <= X"FF";
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        wait until done = '1';
        wait for 200 ns;
        
        report "All tests completed successfully!";
        wait;
    end process;
    
end Behavioral;
