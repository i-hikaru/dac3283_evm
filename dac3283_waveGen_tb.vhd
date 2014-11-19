----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2014/11/14 17:58:37
-- Design Name: 
-- Module Name: dac3283_waveGen_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity dac3283_waveGen_tb is
end dac3283_waveGen_tb;

architecture Behavioral of dac3283_waveGen_tb is

  component dac3283_waveGen is
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      sin_data : out std_logic_vector(15 downto 0);
      cos_data : out std_logic_vector(15 downto 0));
  end component dac3283_waveGen;

  -- input
  signal rst : std_logic := '0';
  signal clk : std_logic := '0';

  -- output
  signal sin_data : std_logic_vector(15 downto 0);
  signal cos_data : std_logic_vector(15 downto 0);

  -- clock period definitions
  constant clk_period : time := 10 ns;  -- 100 MHz

begin

  -- instantiate the unit under test (uut)
  uut : dac3283_waveGen
    port map (
      clk      => clk,
      rst      => rst,
      sin_data => sin_data,
      cos_data => cos_data);

  -- clock process definitions
  clk_process : process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process;

  -- stimulus process
  stim_proc : process
  begin
    -- hold reset state for 100 ns.
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
--    wait for clk_period * 100;
    -- insert stimulus here
    wait;
  end process;

end Behavioral;
