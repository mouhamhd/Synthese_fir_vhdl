library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_SIGNED.all;

library work;
use work.firtypes.all;

entity UC is
        PORT (  Rstb : in Std_Logic;
                Clk : in Std_Logic ;
                Cpt_rom : in integer range 0 to N-1;
                start : in Std_Logic;
                endof : out Std_Logic;
                R1R2 : out Std_Logic;
                R3, R4, clear : out std_logic;
                En_RAM : out std_logic);
end UC;


architecture RTL of UC is
	type states is (repos,init,mac, mac2, acc , acc2) ;
	SIGNAL CurrentState, NextState : states;
begin

 		synchronous : PROCESS(Clk, Rstb)
        BEGIN
                IF Rstb = '0' THEN
                        CurrentState <= repos;
                ELSIF Clk'event AND Clk = '1' THEN
                        CurrentState <= NextState;
                END IF;
        END PROCESS;
        
        state : process(CurrentState , start , Cpt_rom)
        begin
        	case CurrentState is 
        		
        		WHEN repos  => if start ='1' then 
									NextState <= init;
                                else 
									NextState <= repos;
                                end if;
                                      
                WHEN init   => 		NextState <= mac;
                WHEN mac    => if Cpt_rom = N-2 then 
									NextState <= mac2;
                                else 
									NextState <= mac;
                                end if;
                WHEN mac2   => 		NextState <= acc;
                WHEN acc    => 		NextState <= acc2;
                WHEN acc2   => 		NextState <= repos;
                WHEN others => 		NextState <= repos;
                                       
        	end case;
        end process;
        
        control : process(CurrentState)
        begin
		CASE  CurrentState is
			WHEN repos  =>  En_RAM   <= '0';
							endof    <= '1';
							R1R2 <= '0'; -- dans fir_top , loadR1R2 est connecter a EN_ROM donc il active en meme temps ce dernier 
							R3   <= '0';
							R4   <= '0';
							clear    <= '0';
					
		        WHEN init   =>  En_RAM   <= '1';
								endof    <= '0';
								R1R2 <= '1'; -- dans fir_top , loadR1R2 est connecter a EN_ROM donc il active en meme temps ce dernier 
								R3   <= '0';
								R4   <= '0';
								clear    <= '1';
					
		        WHEN mac    =>  En_RAM   <= '1';
								endof    <= '0';
								R1R2 <= '1'; -- dans fir_top , loadR1R2 est connecter a EN_ROM donc il active en meme temps ce dernier 
								R3   <= '1';
								R4   <= '1';
								clear    <= '0';
					
		        WHEN mac2   =>  En_RAM   <= '0';
								endof    <= '0';
								R1R2 <= '1'; -- dans fir_top , loadR1R2 est connecter a EN_ROM donc il active en meme temps ce dernier 
								R3   <= '1';
								R4   <= '1';
								clear    <= '0';
					
		        WHEN acc    =>  En_RAM   <= '0';
								endof    <= '0';
								R1R2 <= '0'; -- dans fir_top , loadR1R2 est connecter a EN_ROM donc il active en meme temps ce dernier 
								R3   <= '1';
								R4   <= '1';
								clear    <= '0';
					
		        WHEN acc2   =>  En_RAM   <= '0';
								endof    <= '0'; -- on active la fin du calcul a l'etat acc2 et on le desactive à l'etat repos
								R1R2 <= '0'; -- dans fir_top , loadR1R2 est connecter a EN_ROM donc il active en meme temps ce dernier 
								R3   <= '0';
								R4   <= '1';
								clear    <= '0';
					
		        WHEN others =>  En_RAM   <= '0';
								endof    <= '0';
								R1R2 <= '0'; -- dans fir_top , loadR1R2 est connecter a EN_ROM donc il active en meme temps ce dernier 
								R3   <= '0';
								R4   <= '0';
								clear    <= '0';
		end case;
        end process;

END RTL;  

