library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_SIGNED.all;

library work;
use work.firtypes.all;

entity UT is
    port ( X : in Std_Logic_Vector(7 downto 0);
           H : in Std_Logic_Vector(7 downto 0);
           clk : in Std_Logic;
           loadR1R2 : in Std_Logic;
           loadR3, loadR4 : in Std_Logic;
           clear : in Std_Logic;
           Y : out Std_Logic_Vector(15 downto 0) );
end UT;

----------------------------------------------------------------------

architecture RTL OF UT is

   signal R1 : Std_Logic_Vector(7 downto 0) := (others =>'0'); -- Registres R1 
   signal R2 : Std_Logic_Vector(7 downto 0) := (others =>'0'); -- Registres R2
   signal R3 : Std_Logic_Vector(15 downto 0) := (others =>'0'); -- Registres R3 et R4
   signal R4 : Std_Logic_Vector(15 downto 0) := (others =>'0'); -- Registres R3 et R4
   signal M  : Std_Logic_Vector(15 downto 0); -- Sortie du Mult
   signal A  : Std_Logic_Vector(15 downto 0); -- Sortie de l'Add

begin

	load1 : process(clk)
	begin
		if clk'event and clk='1' then
			if loadR1R2 = '1' then
				R1 <= X;
				R2 <= H;
			end if;
		end if ;
	end process;
	
	M <= R1*R2; -- calcul en dehors du process car l'affectation ne depend pas du clock , immediat

	load2 : process(clk)
	begin
		if clk'event and clk='1' then
			if clear = '1' then
				R3 <= (others =>'0');
				R4 <= (others =>'0');
			end if;
			if loadR3 = '1' then -- comme loadR3 est loadR4 sont actif en meme temps , je fais le test que sur loadR3
				R3 <= M;
			end if;

			if loadR4 = '1' then 
				R4 <= A;
			end if;
			
		end if;		
	end process;
	A <= R3 + R4; -- calcul en dehors du process car l'affectation ne depend pas du clock , immediat (toujours égale à R3 + R4)
	Y  <= R4;     -- calcul en dehors du process car l'affectation ne depend pas du clock , immediat
	
end RTL;


