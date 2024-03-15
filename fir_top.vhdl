library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

library work;
use work.firtypes.all;

entity fir_top is
	port ( clk, rstb, new_sample : in Std_Logic;
		   xn : in Std_Logic_Vector (7 downto 0);   -- echantillon d'entree
           yn  : out Std_Logic_Vector (7 downto 0 ); -- sortie du filtre
		   valid : out Std_Logic );	-- signal d'indication de fin de calcul
end fir_top;

architecture RTL of fir_top is

	signal X : Std_Logic_vector(7 downto 0):=(others => '0');
	signal H: Std_Logic_vector(7 downto 0):=(others => '0');
	signal count : integer range 0 to 7;
	signal Y : std_logic_vector (15 downto 0);
	signal endof : std_logic:='0'; 

	signal loadR1R2, loadR3, loadR4, clear, EN_RAM : Std_Logic;
	
	component UC is
	port (  Rstb : in Std_Logic;
                Clk : in Std_Logic ;
                Cpt_rom : in integer range 0 to N-1;
                start : in Std_Logic;
                endof : out Std_Logic;
                R1R2 : out Std_Logic;
                R3, R4, clear : out std_logic;
                En_RAM : out std_logic);
	end component UC;
	
	component UT 
    	port (  X : in Std_Logic_Vector(7 downto 0);
           	H : in Std_Logic_Vector(7 downto 0);
           	clk : in Std_Logic;
           	loadR1R2 : in Std_Logic;
           	loadR3, loadR4 : in Std_Logic;
           	clear : in Std_Logic;
           	Y : out Std_Logic_Vector(15 downto 0) );
	end component;
	
	component UM is
    	port (  X : out Std_Logic_Vector(7 downto 0);
           	H : out Std_Logic_Vector(7 downto 0);
           	count : out integer range 0 to 7;
           	rstb,clk : in Std_Logic;
           	start : in Std_Logic;
           	En_ROM : in Std_Logic;
           	En_RAM : in Std_Logic;
           	Xn : in Std_Logic_Vector(7 downto 0) );
   	end component UM;
	
begin
	
	ctrl : uc port map (
		R1R2 => loadR1R2, 
                R3 => loadR3,
                R4 => loadR4,
                clear => clear,
                endof => endof,
                En_RAM => EN_RAM,
                Cpt_rom => count,
                start => new_sample,
                Rstb => rstb,
                Clk => clk  ) ;

				valid <= endof; -- bit de validité , à l'état haut on sait que yn contient le bon résultat
		
	trait : ut port map (
		X => X,
	        H => H,
	        clk => clk, 
	        loadR1R2 => loadR1R2,
	        loadR3 => loadR3, 
		loadR4 => loadR4,
	        clear => clear,
	        Y => Y );
		
	yn <= Y(14 downto 7);      
	
	memoire : UM port map (
		X => X,
        	H => H,
        	count => count,
           	rstb => rstb,
		clk => clk,
           	start => new_sample,
           	En_ROM => loadR1R2, 
           	En_RAM => EN_RAM, 
           	Xn => xn     );
	
end RTL;

