----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:24:04 12/28/2022 
-- Design Name: 
-- Module Name:    via_control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity via_control is

	Port ( clk : in STD_LOGIC;
			 rst : in STD_LOGIC;
			 SI, SD : in STD_LOGIC;
			 AI, AD : out STD_LOGIC);

end via_control;

architecture Behavioral of via_control is
	type clase_estado is (reposo, llega1, llega2, sale1, sale2);
	signal estado_actual: clase_estado := reposo;
	signal estado_siguiente: clase_estado := reposo;
	signal entrada : std_logic_vector (1 downto 0);
	
begin
	
	entrada <= SI&SD;
	
	process (clk)
	begin
		if (clk='1' and clk'event) then
			if (rst='0') then 
				estado_actual <= reposo;
			else
				estado_actual <= estado_siguiente;
			end if;
		end if;
	end process;
	
	
	process (estado_actual, SI, SD, entrada)
	begin
		case estado_actual is
		
			when reposo =>
				if (entrada = "00") then
					estado_siguiente <= reposo;
				elsif (entrada = "10") then
					estado_siguiente <= llega1;
				elsif (entrada = "01") then
					estado_siguiente <= llega2;
				else 
					estado_siguiente <= reposo;
				end if;
					
			when llega1 =>
				if (entrada="01") then
					estado_siguiente <= sale1;
				else 
					estado_siguiente <= llega1;
				end if;
				
			when llega2 => 
				if (entrada="10") then
					estado_siguiente <= sale2;
				else
					estado_siguiente <= llega2;
				end if;
				
			when sale1 => 
				if (entrada="00") then
					estado_siguiente <= reposo;
				end if;
				
			when sale2 => 
				if (entrada="00") then
					estado_siguiente <= reposo;
				end if;
			
			when others =>
				estado_siguiente <= reposo;
		
		end case;
	end process;
	
	
	process (estado_actual)
	begin
		case estado_actual is
			when llega1 =>
				AI <= '1';
				AD <= '1';
			
			when llega2 =>
				AI <= '0';
				AD <= '0';
				
			when sale1 =>
				AI <= '1';
				AD <= '1';
				
			when sale2 =>
				AI <= '0';
				AD <= '0';
				
			when others =>
				AI <= '0';
				AD <= '0';
		end case;
	end process;

end Behavioral;

