-------------------------------------------------------------------------------
-- file name      : dac3283_evm_top.vhd
-- author         : hikaru
--
-- create date    : 2014-11-06 00:19:52
-- module name    : dac3283_evm_top
-- project name   : rhea
-- target devices : xc7k325tffg900-2
-- tool versions  : Vivado 2014.2
-- description    : 
-- dependencies   : 
--
-- revision       : 
-- comments       : 
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity dac3283_evm_top is
  
  port (
    reset        : in  std_logic;
    led          : out std_logic_vector(7 downto 0);
    -- DAC3283
    cdcoutp      : in  std_logic;       -- 153.6 MHz
    cdcoutn      : in  std_logic;
    dac_dataclkp : out std_logic;
    dac_dataclkn : out std_logic;
    dac_framep   : out std_logic;
    dac_framen   : out std_logic;
    dac_datap    : out std_logic_vector(7 downto 0);
    dac_datan    : out std_logic_vector(7 downto 0));

end entity dac3283_evm_top;

architecture behavioral of dac3283_evm_top is

  component push_sw is
    port (
      clk : in  std_logic;
      i   : in  std_logic;
      o   : out std_logic);
  end component push_sw;

  component mmcm_clk is
    port (
      clk_in1  : in  std_logic;
      clk_out1 : out std_logic;
      clk_out2 : out std_logic;
      reset    : in  std_logic;
      locked   : out std_logic);
  end component mmcm_clk;

  component dac3283_waveGen is
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      sin_data : out std_logic_vector(15 downto 0);
      cos_data : out std_logic_vector(15 downto 0));
  end component dac3283_waveGen;

  signal rst             : std_logic;
  signal clk_buf         : std_logic;
  signal clk             : std_logic;   -- 153.6 MHz
  signal clk_2x          : std_logic;   -- 307.2 MHz
  signal clk_loc         : std_logic;
  signal dac_dataclk_buf : std_logic;
  signal cnt             : std_logic_vector(3 downto 0);
  signal dac_frame_buf   : std_logic;
  signal sin_data        : std_logic_vector(15 downto 0);
  signal cos_data        : std_logic_vector(15 downto 0);
  signal dac_data_buf    : std_logic_vector(7 downto 0);

  -- debug
  signal cnt_dbg, cnt_dbg_2x : std_logic_vector(27 downto 0);
  
begin  -- architecture behavioral

  dac_dataclk_buf <= not clk;
  dac_frame_buf   <= '1' when cnt = X"F" else '0';
  led(7)          <= '1' when rst = '1'  else '0';
  led(6 downto 2) <= "00000";

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if rst = '1' then
        cnt <= (others => '0');
      else
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  push_sw_rst : push_sw
    port map (
      clk => clk,
      i   => reset,
      o   => rst);

  ibufds_cdcout : ibufds
    generic map (
      diff_term    => false,
      ibuf_low_pwr => true,
      iostandard   => "default")
    port map (
      o  => clk_buf,
      i  => cdcoutp,
      ib => cdcoutn);

  mmcm_clk_dac_data : mmcm_clk
    port map (
      clk_in1  => clk_buf,
      clk_out1 => clk,
      clk_out2 => clk_2x,
      reset    => rst,
      locked   => clk_loc);

  obufds_dac_dataclk : obufds
    generic map (
      iostandard => "default",
      slew       => "slow")
    port map (
      o  => dac_dataclkp,
      ob => dac_dataclkn,
      i  => dac_dataclk_buf);

  obufds_dac_frame : obufds
    generic map (
      iostandard => "default",
      slew       => "slow")
    port map (
      o  => dac_framep,
      ob => dac_framen,
      i  => dac_frame_buf);

  wavegen_dac : dac3283_waveGen
    port map (
      clk      => clk,
      rst      => rst,
      sin_data => sin_data,
      cos_data => cos_data);

  dac_data : for i in 0 to 7 generate
    oserdese2_dac_data : oserdese2
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
        oq        => dac_data_buf(i),
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
        rst       => not clk_loc,
        shiftin1  => '0',
        shiftin2  => '0',
        t1        => '0',
        t2        => '0',
        t3        => '0',
        t4        => '0',
        tbytein   => '0',
        tce       => '0');

    obufds_dac_data : obufds
      generic map (
        iostandard => "default",
        slew       => "slow")
      port map (
        o  => dac_datap(i),
        ob => dac_datan(i),
        i  => dac_data_buf(i));
  end generate dac_data;

  -- debug
  led(1) <= '1' when cnt_dbg(27) = '1'    else '0';
  led(0) <= '1' when cnt_dbg_2x(27) = '1' else '0';

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if rst = '1' then
        cnt_dbg <= (others => '0');
      else
        cnt_dbg <= cnt_dbg + 1;
      end if;
    end if;
  end process;

  process(clk_2x)
  begin
    if (clk_2x'event and clk_2x = '1') then
      if rst = '1' then
        cnt_dbg_2x <= (others => '0');
      else
        cnt_dbg_2x <= cnt_dbg_2x + 1;
      end if;
    end if;
  end process;

end architecture behavioral;
