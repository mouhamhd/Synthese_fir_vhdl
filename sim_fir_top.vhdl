library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_SIGNED.all;

library work;
use work.firtypes.all;

entity test_fir_top is
end test_fir_top;

architecture test of test_fir_top is

	signal Clk: std_logic := '0';
	signal Rstb: std_logic := '0';
  signal valid: std_logic := '0'; -- verifier si le resultat est correct
	signal new_sample: std_logic := '0';
	signal xn: std_logic_vector (Nbit-1 downto 0) := (others =>'0');
	signal yn: std_logic_vector (Nbit-1 downto 0) := (others =>'0');

	constant NbStimuli: integer := 25;
	type ArrayStimuli is array (0 to NbStimuli-1) of integer range -128 to 127;

	-- impulse response and then step response
  constant Stimuli:        ArrayStimuli := (0,127, 0,  0, 0, 0,  0, 0, 0,0,0,0,127,127,127,127,127,127,127,127,127,127,127,127, 0); 
  constant ExpectedOutput: ArrayStimuli := (0,12, 21,-38,50,50,-38,21,12,0,0,0, 12, 34, -3, 47, 98, 60, 82, 95, 95, 95, 95, 95,82); 

	signal test_yn: integer range -128 to 127 := 0;
	signal yn_int: integer range -128 to 127 := 0;
  signal sample: integer := 0;
  signal simok: bit := '1';

	component fir_top is
	port (clk, rstb, new_sample: in Std_Logic;
        xn: in Std_Logic_Vector (Nbit-1 downto 0);   
        yn: out Std_Logic_Vector (Nbit-1 downto 0);
        valid : out Std_Logic );	
	end component fir_top;

  --for instance_fir:fir_top use entity work.fir_top(specification);
  for instance_fir:fir_top use entity work.fir_top(RTL);
  --for instance_fir:fir_top use entity work.fir_top(SYN_RTL);

begin

  instance_fir: fir_top 
  PORT MAP (clk, rstb, new_sample, xn, yn , valid);	

  yn_int <= CONV_INTEGER(SIGNED(yn));

  clock: process
  begin
    clk <= '1';
    wait for clock_cycle/2;
    clk <= '0';
    wait for clock_cycle/2;
  end process;
  
  reset: process
  begin
    rstb <= '0';
	  wait for clock_cycle;
    rstb <= '1';
    wait;
  end process;

  simulation: process 
  begin
	  wait for clock_cycle*5;
    for i in 0 to NbStimuli-1 loop
      sample <= i;
		  xn <= CONV_STD_LOGIC_VECTOR(Stimuli(i),Nbit); 
		  new_sample <= '1';
		  wait for clock_cycle;
		  new_sample <= '0';
		  wait for clock_cycle*12;
		  test_yn <= ExpectedOutput(i); 
    end loop;
    report "end of simulation";
    if simok = '1' then
      report "ALL TESTS PASSED";
    else
      report "PROBLEM DURING SIMULATION";
    end if;
   	wait;
  end process;

  spy: Process (new_sample)
  begin
    if new_sample'event and new_sample='1' then
        assert (yn_int = test_yn) 
 	      report  "Sample " & integer'image(sample) & ": Problem on output:" & " yn = " & integer'image(yn_int) & "; expected yn = " & integer'image(test_yn)
          severity warning;
        if yn_int = test_yn then
         report "Sample " & integer'image(sample) & ": Output ok:" & " yn = " & integer'image(yn_int);
        else
         simok <= '0';
        end if; 
    end if;
  end process;
end test;
