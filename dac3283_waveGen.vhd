--------------------------------------------------------------------------------
-- file name     : dac3283_waveGen.vhd
-- author        : ISHITSUKA Hikaru
--
-- create date   : 2014-10-30 17:28:15
-- module name   : dac3283_waveGen
-- project name  : RHEA
-- target devices: xc7k325tffg900-2
-- tool versions : Vivado 2014.2
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

entity dac3283_waveGen is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    sin_data : out std_logic_vector(15 downto 0);
    cos_data : out std_logic_vector(15 downto 0));
end entity dac3283_waveGen;

architecture Behavioral of dac3283_waveGen is

  component dds_compiler_dac_iq is
    port (
      aclk                : in  std_logic;
      s_axis_phase_tvalid : in  std_logic;
      s_axis_phase_tdata  : in  std_logic_vector(15 downto 0);
      m_axis_data_tvalid  : out std_logic;
      m_axis_data_tdata   : out std_logic_vector(31 downto 0));
  end component dds_compiler_dac_iq;

  signal sin_cos_data : std_logic_vector(31 downto 0);
  
begin  -- architecture Behavioral

  sin_data <= sin_cos_data(31 downto 16);
  cos_data <= sin_cos_data(15 downto 0);

  wavegen : dds_compiler_dac_iq
    port map (
      aclk                => clk,
      s_axis_phase_tvalid => '1',
      s_axis_phase_tdata  => X"0064",
      m_axis_data_tvalid  => '1',
      m_axis_data_tdata   => sin_cos_data);

end architecture Behavioral;
