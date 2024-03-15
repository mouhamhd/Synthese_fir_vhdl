library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.firtypes.all;

entity UM is

    port ( X : out Std_Logic_Vector(7 downto 0);
           H : out Std_Logic_Vector(7 downto 0);
           count : out integer range 0 to 7;
           rstb,clk : in Std_Logic;
           start : in Std_Logic;
           En_ROM : in Std_Logic;
           En_RAM : in Std_Logic;
           Xn : in Std_Logic_Vector(7 downto 0) );

end UM;

----------------------------------------------------------------------

architecture RTL OF UM is
	signal ADR_ROM : integer range 0 to 7;
	signal ADR_RAM : integer range 0 to 7;
	signal RAM : mem := (others => 0);

	begin
			
		Counter_ROM : process(clk , rstb)
		begin
			if rstb = '0' then
				ADR_ROM <= 0;
			elsif clk'event and clk='1' then
					if EN_ROM = '1' then 
						if ADR_ROM = N-1 then -- revenir a 0 quand on arrive a 7
							ADR_ROM <= 0;
						else	
							ADR_ROM <= ADR_ROM + 1;
						end if;
					end if;
					
				end if ;
		end process ;
		count <= ADR_ROM; --affectation immediat , 
		
		Counter_RAM : process(clk , rstb)
		begin
			if rstb = '0' then
				ADR_RAM <= 0;
			elsif clk'event and clk='1' then
					if EN_RAM = '1' then 
						if ADR_RAM = 7 then  -- revenir a 0 quand on arrive a 7
							ADR_RAM <= 0;
						else	
							ADR_RAM <= ADR_RAM + 1;
						end if;
					end if;
				end if ;
		end process ;
		
		
		H <=  std_logic_vector(to_signed(ROM(ADR_ROM) , N));  -- affectation immediat. On converti la donnée dans la RAM en std_logic_vector 
		
		RAM_memory : process(clk)
		begin
			if clk'event and clk='1' then
				if start = '1' then 
					RAM(ADR_RAM) <= to_integer(signed(Xn)); -- ecriture dans la ram qui est synchro avec l'horloge donc au sein d'un process avec comme sensibilite clk
				end if;
			end if;
		end process;

		X <= std_logic_vector(to_signed(RAM(ADR_RAM) , 8));  -- affectation  immediat

end RTL;


