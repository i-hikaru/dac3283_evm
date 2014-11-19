library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity oserdese2_sim is
  
  port (
    rst : in  std_logic;
    d   : in  std_logic_vector(7 downto 0);
    q   : out std_logic);

end entity oserdese2_sim;

architecture behavioral of oserdese2_sim is

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
      reset    : in  std_logic);
  end component mmcm_clk;

begin  -- architecture behavioral

  

end architecture behavioral;
