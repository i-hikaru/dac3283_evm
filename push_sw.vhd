--------------------------------------------------------------------------------
-- file name:      push_sw.vhd
-- author:         ISHITSUKA Hikaru
--
-- create date:    2014-11-11 13:59:25
-- module name:    push_sw
-- project name:   
-- target devices: 
-- tool versions:  
-- description:    Prevent chattering
-- dependencies:   
--
-- revision:       
-- comments:       
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity push_sw is
  port (
    clk : in  std_logic;
    i   : in  std_logic;
    o   : out std_logic);
end entity push_sw;

architecture Behaivioral of push_sw is

  signal edge : std_logic;
  
begin  -- architecture Behaivioral

  o <= (not edge) and i;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      edge <= i;
    end if;
  end process;

end architecture Behaivioral;
