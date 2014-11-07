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
    clk_2x   : in  std_logic;           -- 409.6 MHz
    clk      : in  std_logic;           -- 204.8 MHz
    rst      : in  std_logic;
--    fpga_clkoutp : out std_logic;
--    fpga_clkoutn : out std_logic;
--    dataclkp : out std_logic;
--    dataclkn : out std_logic;
    framep   : out std_logic;
    framen   : out std_logic;
    datap    : out std_logic_vector(7 downto 0);
    datan    : out std_logic_vector(7 downto 0));
end entity dac3283_waveGen;

architecture Behavioral of dac3283_waveGen is

  component dds_compiler_dac_iq is
    port (
      -- clk
      aclk                : in  std_logic;
      s_axis_phase_tvalid : in  std_logic;
      s_axis_phase_tdata  : in  std_logic_vector(15 downto 0);
      m_axis_data_tvalid  : out std_logic;
      m_axis_data_tdata   : out std_logic_vector(31 downto 0));
  end component dds_compiler_dac_iq;

  -- dds_compiler_dac_iq
  signal pinc_en      : std_logic;
  signal pinc_data    : std_logic_vector(15 downto 0) := X"0064";  -- 100
  signal sin_cos_en   : std_logic;
  signal sin_cos_data : std_logic_vector(31 downto 0);
  signal sin_data     : std_logic_vector(15 downto 0);
  signal cos_data     : std_logic_vector(15 downto 0);
  -- dac_data_clk signal
  signal dataclk_buff : std_logic;
  signal frame_buff   : std_logic;
  signal data_buff    : std_logic_vector(7 downto 0);
  
begin  -- architecture Behavioral

  pinc_en    <= '1'     when rst = '0';
  pinc_data  <= X"0064" when rst = '0';
  sin_cos_en <= '1'     when rst = '0';
  sin_data   <= sin_cos_data(31 downto 16);
  cos_data   <= sin_cos_data(15 downto 0);

  wavegen : dds_compiler_dac_iq
    port map (
      aclk                => clk,
      s_axis_phase_tvalid => pinc_en,
      s_axis_phase_tdata  => pinc_data,
      m_axis_data_tvalid  => sin_cos_en,
      m_axis_data_tdata   => sin_cos_data);

  -----------------------------------------------------------------------------
  -- Output serdes and LVDS buffer for DAC clock
  -----------------------------------------------------------------------------
  oserdes_data_clk : oserdese2
    generic map (
      data_rate_oq   => "ddr",
      data_rate_tq   => "ddr",
      data_width     => 4,
      init_oq        => '0',
      init_tq        => '0',
      serdes_mode    => "master",
      srval_oq       => '0',
      srval_tq       => '0',
      tbyte_ctl      => "false",
      tbyte_src      => "false",
      tristate_width => 1)
    port map (
      ofb       => open,
      oq        => dataclk_buff,
      shiftout1 => open,
      shiftout2 => open,
      tbyteout  => open,
      tfb       => open,
      tq        => open,
      clk       => clk_2x,
      clkdiv    => clk,
      d1        => '1',
      d2        => '0',
      d3        => '1',
      d4        => '0',
      d5        => '0',
      d6        => '0',
      d7        => '0',
      d8        => '0',
      oce       => '1',
      rst       => rst,
      shiftin1  => '0',
      shiftin2  => '0',
      t1        => '0',
      t2        => '0',
      t3        => '0',
      t4        => '0',
      tbytein   => '0',
      tce       => '0');

  -- Output buffer
  obufds_data_clk : obufds_lvds_25
    port map (
      i  => dataclk_buff,
      o  => dataclkp,
      ob => dataclkn);

  -----------------------------------------------------------------------------
  -- Output sedes and LVDS buffer for DAC data
  -----------------------------------------------------------------------------
  data : for i in 0 to 7 generate

    -- oserdes in data path
    oserdes_data : oserdes2
      generic map (
        data_rate_oq   => "ddr",
        data_rate_tq   => "ddr",
        data_width     => 4,
        init_oq        => '0',
        init_tq        => '0',
        serdes_mode    => "master",
        srval_oq       => '0',
        srval_tq       => '0',
        tbyte_ctl      => "false",
        tbyte_src      => "false",
        tristate_width => 1)
      port map (
        ofb       => open,
        oq        => data_buff(i),
        shiftout1 => open,
        shiftout2 => open,
        tbyteout  => open,
        tfb       => open,
        tq        => open,
        clk       => clk_2x,
        clkdiv    => clk,
        d1        => sin_data(i+8),
        d2        => sin_data(i),
        d3        => cos_data(i+8),
        d4        => cos_data(i),
        d5        => '0',
        d6        => '0',
        d7        => '0',
        d8        => '0',
        oce       => '1',
        rst       => rst,
        shiftin1  => '0',
        shiftin2  => '0',
        t1        => '0',
        t2        => '0',
        t3        => '0',
        t4        => '0',
        tbytein   => '0',
        tce       => '0');

    -- Output buffers
    obufds_data : obufds_lvds_25
      port map (
        i  => data_buff(i),
        o  => datap(i),
        ob => datan(i));
  end generate data;
  
end architecture behavioral;
