
--------------------------------------------------------------
--------------------------------------------------------------
-- Copyright Jordan Aley, Howard University 02/27/2020
-- Adv. Dig. Design. II (496)
-- Dr. Michaela E. Amoo
-- CSM Multiplier
-- Homework 3
--------------------------------------------------------------
--------------------------------------------------------------


LIBRARY IEEE;
USE work.CLOCKS.all;  		 -- Entity that uses CLOCKS
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_textio.all;
USE std.textio.all;
USE work.txt_util.all;
 
ENTITY tb_Aley_CSMultiplier IS
END;

ARCHITECTURE TESTBENCH OF tb_Aley_CSMultiplier IS

CONSTANT W : integer := 24;
CONSTANT BITS2 : integer := 2;
CONSTANT BITS4 : integer := 4;
CONSTANT BITS6 : integer := 6;
CONSTANT BITS8 : integer := 8;

---------------------------------------------------------------
-- COMPONENTS -- Entity In/out Ports
---------------------------------------------------------------

COMPONENT Aley_CSMultiplier
  generic(W: integer :=24; BITS2: integer :=2; BITS4:integer :=4; BITS6:integer :=6; BITS8:integer :=8);
	PORT(	clk: IN std_logic;
                reset: IN std_logic;
                en: IN std_logic;
                InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(2*W-1 DOWNTO 0));
END COMPONENT;

COMPONENT CLOCK
	port(	CLK: out std_logic);
END COMPONENT;

---------------------------------------------------------------
-- Read/Write FILES
---------------------------------------------------------------


FILE in_file : TEXT open read_mode is 	"ALEY_Multipliers_input.txt";   	-- Inputs (binary)
FILE exo_file : TEXT open read_mode is  	"ALEY_Multipliers_output.txt";   	-- Expected output (binary)
FILE out_file : TEXT open  write_mode is  	"ALEY_Multipliers_dataout.txt";
FILE xout_file : TEXT open  write_mode is 	"ALEY_Multipliers_TestOut.txt";
FILE hex_out_file : TEXT open  write_mode is "ALEY_Multipliers_hex_out.txt";

---------------------------------------------------------------
-- SIGNALS 
---------------------------------------------------------------
  

  SIGNAL reset: STD_LOGIC;
  SIGNAL en: STD_LOGIC;
  SIGNAL OP_A: STD_LOGIC_VECTOR(W-1 downto 0):= (OTHERS=>'X');
  SIGNAL OP_B: STD_LOGIC_VECTOR(W-1 downto 0):= (OTHERS=>'X');
  SIGNAL CLK: STD_LOGIC;
 
  SIGNAL SumOut: STD_LOGIC_VECTOR(2*W-1 downto 0):= (OTHERS=>'X');
  SIGNAL Exp_SumOut : STD_LOGIC_VECTOR(2*W-1 downto 0):= (OTHERS=>'X');

  SIGNAL Test_OutS : STD_LOGIC:= 'X';
  SIGNAL LineNumber: integer:=0;

---------------------------------------------------------------
-- BEGIN 
---------------------------------------------------------------

BEGIN

---------------------------------------------------------------
-- Instantiate Components 
---------------------------------------------------------------


U0: CLOCK port map (CLK );
InstAley_CSMultiplier: Aley_CSMultiplier generic map (W,BITS2, BITS4, BITS6, BITS8) port map (clk, reset, en, Op_A, Op_B, SumOut);

---------------------------------------------------------------
-- PROCESS 
---------------------------------------------------------------
PROCESS

variable in_line, exo_line, out_line, xout_line : LINE;
variable comment, xcomment : string(1 to 128);
variable i : integer range 1 to 128;
variable simcomplete : boolean;

variable vreset: std_logic:='X';
variable ven: std_logic:='X';
variable vOp_A   : std_logic_vector(W-1 downto 0):= (OTHERS => 'X');
variable vOp_B   : std_logic_vector(W-1 downto 0):= (OTHERS => 'X');

variable vSumOut : std_logic_vector(2*W-1 downto 0):= (OTHERS => 'X');


variable vExp_SumOut : std_logic_vector(2*W-1 downto 0):= (OTHERS => 'X');


variable vTest_OutS : std_logic:= 'X';

variable vlinenumber: integer;

BEGIN

simcomplete := false;

while (not simcomplete) LOOP
  
	if (not endfile(in_file) ) then
		readline(in_file, in_line);
	else
		simcomplete := true;
	end if;

	if (not endfile(exo_file) ) then
		readline(exo_file, exo_line);
	else
		simcomplete := true;
	end if;
	
	if (in_line(1) = '-') then  --Skip comments
		next;
	elsif (in_line(1) = '.')  then  --exit Loop
	  Test_OutS <= 'Z';
		simcomplete := true;
	elsif (in_line(1) = '#') then        --Echo comments to out.txt
	  i := 1;
	  while in_line(i) /= '.' LOOP
		comment(i) := in_line(i);
		i := i + 1;
	  end LOOP;

	elsif (exo_line(1) = '-') then  --Skip comments
		next;
	elsif (exo_line(1) = '.')  then  --exit Loop
	  	  Test_OutS  <= 'Z';
		   simcomplete := true;
	elsif (exo_line(1) = '#') then        --Echo comments to out.txt
	     i := 1;
	   while exo_line(i) /= '.' LOOP
		 xcomment(i) := exo_line(i);
		 i := i + 1;
	   end LOOP;

	
	  write(out_line, comment);
	  writeline(out_file, out_line);
	  
	  write(xout_line, xcomment);
	  writeline(xout_file, xout_line);

	  
	ELSE      --Begin processing

		read(in_line, vreset );
		reset  <= vreset;
		read(in_line, ven );
		en  <= ven;

		read(in_line, vOp_A );
		Op_A  <= vOp_A;

		read(in_line, vOp_B );
		Op_B  <= vOp_B;
	
		read(exo_line, vexp_SumOut );
		exp_SumOut  <= vexp_SumOut;

    vlinenumber :=LineNumber;
    
    write(out_line, vlinenumber);
    write(out_line, STRING'("."));
    write(out_line, STRING'("    "));

	

    CYCLE(1,CLK);
   
      
    if (Exp_SumOut = SumOut) then
      Test_OutS <= '0';
    else
      Test_OutS <= 'X';
    end if;

          		
		write(out_line, vSumOut, left, 32);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab

		write(out_line,vTest_OutS, left, 5);                           --ht is ascii for horizontal tab
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		write(out_line, vexp_SumOut, left, 32);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		writeline(out_file, out_line);
		print(xout_file,    str(LineNumber)& "." & "    " &    str(SumOut) & "       " &   str(Exp_SumOut)  & "     " & str(Test_OutS));
	
	END IF;
	LineNumber<= LineNumber+1;

	END LOOP;
	WAIT;
	
	END PROCESS;

END TESTBENCH;

---------------------------------------------------------------
-- Configurations
---------------------------------------------------------------

CONFIGURATION cfg_tb_Aley_CSMultiplier_2B OF tb_Aley_CSMultiplier IS
	FOR TESTBENCH
		FOR InstAley_CSMultiplier: Aley_CSMultiplier
			 use entity work.Aley_CSMultiplier(CSM_2B);		
		END FOR;
	END FOR;
END;

CONFIGURATION cfg_tb_Aley_CSMultiplier_4B OF tb_Aley_CSMultiplier IS
	FOR TESTBENCH
		FOR InstAley_CSMultiplier: Aley_CSMultiplier
			use entity work.Aley_CSMultiplier(CSM_4B);
		END FOR;
	END FOR;
END;

CONFIGURATION cfg_tb_Aley_CSMultiplier_6B OF tb_Aley_CSMultiplier IS
	FOR TESTBENCH
		FOR InstAley_CSMultiplier: Aley_CSMultiplier
			use entity work.Aley_CSMultiplier(CSM_6B);		
		END FOR;
	END FOR;
END;

 CONFIGURATION cfg_tb_Aley_CSMultiplier_8B OF tb_Aley_CSMultiplier IS
	FOR TESTBENCH
		FOR InstAley_CSMultiplier: Aley_CSMultiplier
			use entity work.Aley_CSMultiplier(CSM_8B);
			
		END FOR;
	END FOR;
END;