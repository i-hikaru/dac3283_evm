--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2014/11/14 18:31:38
-- Design Name: 
-- Module Name: dac3283_evm_top_tb - Behavioral
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
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity dac3283_evm_top_tb is
end dac3283_evm_top_tb;

architecture Behavioral of dac3283_evm_top_tb is

  component dac3283_evm_top is
    port (
      reset        : in  std_logic;
      led          : out std_logic_vector(7 downto 0);
      -- DAC3283 I/O
      cdcoutp      : in  std_logic;
      cdcoutn      : in  std_logic;
      dac_dataclkp : out std_logic;
      dac_dataclkn : out std_logic;
      dac_framep   : out std_logic;
      dac_framen   : out std_logic;
      dac_datap    : out std_logic_vector(7 downto 0);
      dac_datan    : out std_logic_vector(7 downto 0));
  end component dac3283_evm_top;

  -- input
  signal reset   : std_logic := '0';
  signal cdcoutp : std_logic := '0';
  signal cdcoutn : std_logic := '0';

  -- output
  signal led          : std_logic_vector(7 downto 0);
  signal dac_dataclkp : std_logic;
  signal dac_dataclkn : std_logic;
  signal dac_framep   : std_logic;
  signal dac_framen   : std_logic;
  signal dac_datap    : std_logic_vector(7 downto 0);
  signal dac_datan    : std_logic_vector(7 downto 0);

  -- clock period definitions
--  constant clk_period : time := 10 ns;    -- 100 MHz
  constant clk_period : time := 6.51 ns;  -- 153.6 MHz
  
begin

  -- instantiate the unit under test (uut)
  uut : dac3283_evm_top
    port map (
      reset        => reset,
      led          => led,
      cdcoutp      => cdcoutp,
      cdcoutn      => cdcoutn,
      dac_dataclkp => dac_dataclkp,
      dac_dataclkn => dac_dataclkn,
      dac_framep   => dac_framep,
      dac_framen   => dac_framen,
      dac_datap    => dac_datap,
      dac_datan    => dac_datan);

  -- clock process definitions
  clk_process : process
  begin
    cdcoutp <= '1';
    cdcoutn <= '0';
    wait for clk_period/2;
    cdcoutp <= '0';
    cdcoutn <= '1';
    wait for clk_period/2;
  end process;

  -- stimulus process
  stim_proc : process
  begin
    -- hold reset state for 100 ns.
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
--    wait for clk_period * 100;
    -- insert stimulus here
    wait;
  end process;

end Behavioral;
