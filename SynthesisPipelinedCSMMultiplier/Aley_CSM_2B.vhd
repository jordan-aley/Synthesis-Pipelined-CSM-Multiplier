---------------------------------------------------------
-- TOP_LEVEL MODULE OF w-bit CARRY SAVE MULTIPLIER
---------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSM_2B IS
  generic(W: integer :=24; BITS2: integer :=2; BITS4:integer :=4; BITS6:integer :=6; BITS8:integer :=8);
	PORT(	clk: IN std_logic;
                reset: IN std_logic;
                 en: IN std_logic;
                InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(2*W-1 DOWNTO 0));
END Aley_CSM_2B;

ARCHITECTURE CSM_2B OF Aley_CSM_2B IS

COMPONENT Aley_CSMSlice_2B
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice_2B
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END COMPONENT;

COMPONENT Aley_GenReg 
	
	generic(w: integer:= 24; bbits: integer:=2);
        port (
		clk: in std_logic;
		reset: in std_logic;
		en:  in std_logic;
		InA: in std_logic_vector(w-1 downto 0);
		InB: in std_logic_vector(w-bbits-1 downto 0); 
		SumIn: in std_logic_vector(w-1 downto 0);
		CarryIn: in std_logic_vector(w-1 downto 0);
                Aout: out std_logic_vector(w-1 downto 0);
		Bout: out std_logic_vector(w-bbits-1 downto 0);
		SumOut: out std_logic_vector(w-1 downto 0);
		Carryout: out std_logic_vector(w-1 downto 0)
);

END COMPONENT;


COMPONENT Aley_GenRegLast 
	
	generic(w: integer:= 24);
        port (
		clk: in std_logic;
		reset: in std_logic;
		en:  in std_logic;
		SumIn: in std_logic_vector(w-1 downto 0);
		CarryIn: in std_logic_vector(w-1 downto 0);
		SumOut: out std_logic_vector(w-1 downto 0);
		Carryout: out std_logic_vector(w-1 downto 0)
);

END COMPONENT;

SIGNAL sSumOut0 : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sSumOut1 : std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sSumOut4 : std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sSumOut5 : std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sSumOut6 : std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sSumOut7 : std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sSumOut8 : std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sSumOut9 : std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sSumOut10 : std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sSumOut11 : std_logic_vector(W+11*BITS2-1 downto 0);
SIGNAL sSumOut12 : std_logic_vector(W+12*BITS2-1 downto 0);

SIGNAL sAoutR1: std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sAoutR2: std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sAoutR3: std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sAoutR4: std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sAoutR5: std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sAoutR6: std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sAoutR7: std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sAoutR8: std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sAoutR9: std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sAoutR10: std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sAoutR11: std_logic_vector(W+11*BITS2-1 downto 0);

SIGNAL sBoutR1: std_logic_vector(W-BITS2-1 downto 0);
SIGNAL sBoutR2: std_logic_vector(W-2*BITS2-1 downto 0);
SIGNAL sBoutR3: std_logic_vector(W-3*BITS2-1 downto 0);
SIGNAL sBoutR4: std_logic_vector(W-4*BITS2-1 downto 0);
SIGNAL sBoutR5: std_logic_vector(W-5*BITS2-1 downto 0);
SIGNAL sBoutR6: std_logic_vector(W-6*BITS2-1 downto 0);
SIGNAL sBoutR7: std_logic_vector(W-7*BITS2-1 downto 0);
SIGNAL sBoutR8: std_logic_vector(W-8*BITS2-1 downto 0);
SIGNAL sBoutR9: std_logic_vector(W-9*BITS2-1 downto 0);
SIGNAL sBoutR10: std_logic_vector(W-10*BITS2-1 downto 0);
SIGNAL sBoutR11: std_logic_vector(W-11*BITS2-1 downto 0);

SIGNAL sSumOutR1: std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sSumOutR2: std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sSumOutR3: std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sSumOutR4: std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sSumOutR5: std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sSumOutR6: std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sSumOutR7: std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sSumOutR8: std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sSumOutR9: std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sSumOutR10: std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sSumOutR11: std_logic_vector(W+11*BITS2-1 downto 0);
SIGNAL sSumOutR12: std_logic_vector(W+12*BITS2-1 downto 0);

SIGNAL sCarryOutR1: std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sCarryOutR2: std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sCarryOutR3: std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sCarryOutR4: std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sCarryOutR5: std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sCarryOutR6: std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sCarryOutR7: std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sCarryOutR8: std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sCarryOutR9: std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sCarryOutR10: std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sCarryOutR11: std_logic_vector(W+11*BITS2-1 downto 0);
SIGNAL sCarryOutR12: std_logic_vector(W+12*BITS2-1 downto 0);

SIGNAL sAout1 : std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sAout3 : std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sAout4 : std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sAout5 : std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sAout6 : std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sAout7 : std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sAout8 : std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sAout9 : std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sAout10 : std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sAout11 : std_logic_vector(W+11*BITS2-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sCarryOut4 : std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sCarryOut5 : std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sCarryOut6 : std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sCarryOut7 : std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sCarryOut8 : std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sCarryOut9 : std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sCarryOut10 : std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sCarryOut11 : std_logic_vector(W+11*BITS2-1 downto 0);
SIGNAL sCarryOut12 : std_logic_vector(W+12*BITS2-1 downto 0);

begin

InstAley_CSMSlice_2B1: Aley_CSMSlice_2B generic map (W) port map( InA, InB(BITS2-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);

InstAley_GenReg1: Aley_GenReg generic map(w+BITS2, 2*BITS2) port map(clk, reset, en, sAout1, InB(12*BITS2-1 downto BITS2), sSumOut1, sCarryOut1, sAoutR1, sBoutR1, sSumOutR1, sCarryOutR1);

InstAley_CSMSlice_2B2: Aley_CSMSlice_2B generic map (W+BITS2) port map( sAoutR1, sBoutR1(BITS2-1 downto 0), sSumOutR1, sCarryOutR1, sAout2, sSumOut2, sCarryOut2);

InstAley_GenReg2: Aley_GenReg generic map(w+2*BITS2, 4*BITS2) port map(clk, reset, en, sAout2, sBoutR1(11*BITS2-1 downto BITS2), sSumOut2, sCarryOut2, sAoutR2, sBoutR2, sSumOutR2, sCarryOutR2);

InstAley_CSMSlice_2B3: Aley_CSMSlice_2B generic map (W+2*BITS2) port map( sAoutR2, sBoutR2(BITS2-1 downto 0), sSumOutR2, sCarryOutR2, sAout3, sSumOut3, sCarryOut3);

InstAley_GenReg3: Aley_GenReg generic map(w+3*BITS2, 6*BITS2) port map(clk, reset, en, sAout3, sBoutR2(10*BITS2-1 downto BITS2), sSumOut3, sCarryOut3, sAoutR3, sBoutR3, sSumOutR3, sCarryOutR3);

InstAley_CSMSlice_2B4: Aley_CSMSlice_2B generic map (W+3*BITS2) port map( sAoutR3, sBoutR3(BITS2-1 downto 0), sSumOutR3, sCarryOutR3, sAout4, sSumOut4, sCarryOut4);

InstAley_GenReg4: Aley_GenReg generic map(w+4*BITS2, 8*BITS2) port map(clk, reset, en, sAout4, sBoutR3(9*BITS2-1 downto BITS2), sSumOut4, sCarryOut4, sAoutR4, sBoutR4, sSumOutR4, sCarryOutR4);

InstAley_CSMSlice_2B5: Aley_CSMSlice_2B generic map (W+4*BITS2) port map( sAoutR4, sBoutR4(BITS2-1 downto 0), sSumOutR4, sCarryOutR4, sAout5, sSumOut5, sCarryOut5);

InstAley_GenReg5: Aley_GenReg generic map(w+5*BITS2, 10*BITS2) port map(clk, reset, en, sAout5, sBoutR4(8*BITS2-1 downto BITS2), sSumOut5, sCarryOut5, sAoutR5, sBoutR5, sSumOutR5, sCarryOutR5);

InstAley_CSMSlice_2B6: Aley_CSMSlice_2B generic map (W+5*BITS2) port map( sAoutR5, sBoutR5(BITS2-1 downto 0), sSumOutR5, sCarryOutR5, sAout6, sSumOut6, sCarryOut6);

InstAley_GenReg6: Aley_GenReg generic map(w+6*BITS2, 12*BITS2) port map(clk, reset, en, sAout6, sBoutR5(7*BITS2-1 downto BITS2), sSumOut6, sCarryOut6, sAoutR6, sBoutR6, sSumOutR6, sCarryOutR6);

InstAley_CSMSlice_2B7: Aley_CSMSlice_2B generic map (W+6*BITS2) port map( sAoutR6, sBoutR6(BITS2-1 downto 0), sSumOutR6, sCarryOutR6, sAout7, sSumOut7, sCarryOut7);

InstAley_GenReg7: Aley_GenReg generic map(w+7*BITS2, 14*BITS2) port map(clk, reset, en, sAout7, sBoutR6(6*BITS2-1 downto BITS2), sSumOut7, sCarryOut7, sAoutR7, sBoutR7, sSumOutR7, sCarryOutR7);

InstAley_CSMSlice_2B8: Aley_CSMSlice_2B generic map (W+7*BITS2) port map( sAoutR7, sBoutR7(BITS2-1 downto 0), sSumOutR7, sCarryOutR7, sAout8, sSumOut8, sCarryOut8);

InstAley_GenReg8: Aley_GenReg generic map(w+8*BITS2, 16*BITS2) port map(clk, reset, en, sAout8, sBoutR7(5*BITS2-1 downto BITS2), sSumOut8, sCarryOut8, sAoutR8, sBoutR8, sSumOutR8, sCarryOutR8);

InstAley_CSMSlice_2B9: Aley_CSMSlice_2B generic map (W+8*BITS2) port map( sAoutR8, sBoutR8(BITS2-1 downto 0), sSumOutR8, sCarryOutR8, sAout9, sSumOut9, sCarryOut9);

InstAley_GenReg9: Aley_GenReg generic map(w+9*BITS2, 18*BITS2) port map(clk, reset, en, sAout9, sBoutR8(4*BITS2-1 downto BITS2), sSumOut9, sCarryOut9, sAoutR9, sBoutR9, sSumOutR9, sCarryOutR9);

InstAley_CSMSlice_2B10: Aley_CSMSlice_2B generic map (W+9*BITS2) port map( sAoutR9, sBoutR9(BITS2-1 downto 0), sSumOutR9, sCarryOutR9, sAout10, sSumOut10, sCarryOut10);

InstAley_GenReg10: Aley_GenReg generic map(w+10*BITS2, 20*BITS2) port map(clk, reset, en, sAout10, sBoutR9(3*BITS2-1 downto BITS2), sSumOut10, sCarryOut10, sAoutR10, sBoutR10, sSumOutR10, sCarryOutR10);

InstAley_CSMSlice_2B11: Aley_CSMSlice_2B generic map (W+10*BITS2) port map( sAoutR10, sBoutR10(BITS2-1 downto 0), sSumOutR10, sCarryOutR10, sAout11, sSumOut11, sCarryOut11);

InstAley_GenReg11: Aley_GenReg generic map(w+11*BITS2, 22*BITS2) port map(clk, reset, en, sAout11, sBoutR10(2*BITS2-1 downto BITS2), sSumOut11, sCarryOut11, sAoutR11, sBoutR11, sSumOutR11, sCarryOutR11);

InstAley_CSMLastSlice_2B12: Aley_CSMLastSlice_2B generic map (W+11*BITS2) port map( sAoutR11, sBoutR11(BITS2-1 downto 0), sSumOutR11, sCarryOutR11, sSumOut12, sCarryOut12);

InstAley_GenReg12: Aley_GenRegLast generic map(w+12*BITS2) port map(clk, reset, en, sSumOut12, sCarryOut12, sSumOutR12, sCarryOutR12);

SumOut <= sSumOutR12 + sCarryOutR12;


end CSM_2B;

