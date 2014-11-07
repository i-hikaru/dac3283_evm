--------------------------------------------------------------------------------
-- file name     : dac3283_evm_top.vhd
-- author        : ISHITSUKA Hikaru
--
-- create date   : 2014-11-06 00:19:52
-- module name   : dac3283_evm
-- project name  : RHEA
-- target devices: Kintex-7
-- tool versions : ISE 14.7
-- description   : 
-- dependencies  : 
--
-- revision      : 
-- comments      : 
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dac3283_evm_top is
  port (
--    clk          : in  std_logic;       -- 204.8 MHz
    rst          : in  std_logic;
    fpga_clkoutp : in  std_logic;
    fpga_clkoutn : in  std_logic;
    dataclkp     : out std_logic;
    dataclkn     : out std_logic;
    dac_framep   : out std_logic;
    dac_framen   : out std_logic;
    datap        : out std_logic_vector(7 downto 0);
    datan        : out std_logic_vector(7 downto 0));
end entity dac3283_evm_top;

architecture Behavioral of dac3283_evm_top is

  component clk_lvds is
    generic (      
      sys_w : integer := 1;  -- width of the data for the system
      dev_w : integer := 1); -- width of the data for the device
    port (
      -- clock and reset signals
      data_in_from_pins_p : in  std_logic_vector(sys_w-1 downto 0);
      data_in_from_pins_n : in  std_logic_vector(sys_w-1 downto 0);
      data_in_to_device   : out std_logic_vector(dev_w-1 downto 0);
      clk_in_p            : in  std_logic;
      clk_in_n            : in  std_logic;
      clk_out             : out std_logic;
      io_reset            : in  std_logic);
  end component clk_lvds;

  component dac3283_waveGen is
    port (
      CLK_409_7MHz : in  std_logic;
      CLK_204_8MHz : in  std_logic;
      RST          : in  std_logic;
      DAC_DATAP    : out std_logic_vector(7 downto 0);
      DAC_DATAN    : out std_logic_vector(7 downto 0);
      DAC_FRAMEP   : out std_logic;
      DAC_FRAMEN   : out std_logic;
      DAC_DATACLKP : out std_logic;
      DAC_DATACLKN : out std_logic);
  end component dac3283_waveGen;

  signal clk : std_logic;
  
begin  -- architecture Behavioral

  x0 : clk_lvds
    port map (
      data_in_from_pins_p => '0',
      data_in_from_pins_n => '0',
      data_in_to_device   => '0',
      clk_in_p            => fpga_clkoutp,
      clk_in_n            => fpga_clkoutn,
      clk_out             => clk,
      io_reset            => rst);


end architecture Behavioral;
