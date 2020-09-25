Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSM_4B IS
  generic(W: integer :=24; BITS2: integer :=2; BITS4:integer :=4; BITS6:integer :=6; BITS8:integer :=8);
	PORT(	clk: IN std_logic;
                reset: IN std_logic;
                 en: IN std_logic;
                InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(2*W-1 DOWNTO 0));
END Aley_CSM_4B;
-----------------------------------------------------------

ARCHITECTURE CSM_4B OF Aley_CSM_4B IS

COMPONENT Aley_CSMSlice_4B
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice_4B
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END COMPONENT;

COMPONENT Aley_GenReg 
	
	generic(w: integer:= 24; bbits: integer:=8);
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
SIGNAL sSumOut1 : std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sSumOut4 : std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sSumOut5 : std_logic_vector(W+5*BITS4-1 downto 0);
SIGNAL sSumOut6 : std_logic_vector(W+6*BITS4-1 downto 0);

SIGNAL sAoutR1: std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sAoutR2: std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sAoutR3: std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sAoutR4: std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sAoutR5: std_logic_vector(W+5*BITS4-1 downto 0);

SIGNAL sBoutR1: std_logic_vector(W-BITS4-1 downto 0);
SIGNAL sBoutR2: std_logic_vector(W-2*BITS4-1 downto 0);
SIGNAL sBoutR3: std_logic_vector(W-3*BITS4-1 downto 0);
SIGNAL sBoutR4: std_logic_vector(W-4*BITS4-1 downto 0);
SIGNAL sBoutR5: std_logic_vector(W-5*BITS4-1 downto 0);

SIGNAL sSumOutR1: std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sSumOutR2: std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sSumOutR3: std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sSumOutR4: std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sSumOutR5: std_logic_vector(W+5*BITS4-1 downto 0);
SIGNAL sSumOutR6: std_logic_vector(W+6*BITS4-1 downto 0);

SIGNAL sCarryOutR1: std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sCarryOutR2: std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sCarryOutR3: std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sCarryOutR4: std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sCarryOutR5: std_logic_vector(W+5*BITS4-1 downto 0);
SIGNAL sCarryOutR6: std_logic_vector(W+6*BITS4-1 downto 0);

SIGNAL sAout1 : std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sAout3 : std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sAout4 : std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sAout5 : std_logic_vector(W+5*BITS4-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sCarryOut4 : std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sCarryOut5 : std_logic_vector(W+5*BITS4-1 downto 0);
SIGNAL sCarryOut6 : std_logic_vector(W+6*BITS4-1 downto 0);


begin

InstAley_CSMSlice_4B1: Aley_CSMSlice_4B generic map (W) port map( InA, InB(BITS4-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);

InstAley_GenReg1: Aley_GenReg generic map(w+BITS4, 2*BITS4) port map(clk, reset, en, sAout1, InB(6*BITS4-1 downto BITS4), sSumOut1, sCarryOut1, sAoutR1, sBoutR1, sSumOutR1, sCarryOutR1);

InstAley_CSMSlice_4B2: Aley_CSMSlice_4B generic map (W+BITS4) port map( sAoutR1, sBoutR1(BITS4-1 downto 0), sSumOutR1, sCarryOutR1, sAout2, sSumOut2, sCarryOut2);

InstAley_GenReg2: Aley_GenReg generic map(w+2*BITS4, 4*BITS4) port map(clk, reset, en, sAout2, sBoutR1(5*BITS4-1 downto BITS4), sSumOut2, sCarryOut2, sAoutR2, sBoutR2, sSumOutR2, sCarryOutR2);

InstAley_CSMSlice_4B3: Aley_CSMSlice_4B generic map (W+2*BITS4) port map( sAoutR2, sBoutR2(BITS4-1 downto 0), sSumOutR2, sCarryOutR2, sAout3, sSumOut3, sCarryOut3);

InstAley_GenReg3: Aley_GenReg generic map(w+3*BITS4, 6*BITS4) port map(clk, reset, en, sAout3, sBoutR2(4*BITS4-1 downto BITS4), sSumOut3, sCarryOut3, sAoutR3, sBoutR3, sSumOutR3, sCarryOutR3);

InstAley_CSMSlice_4B4: Aley_CSMSlice_4B generic map (W+3*BITS4) port map( sAoutR3, sBoutR3(BITS4-1 downto 0), sSumOutR3, sCarryOutR3, sAout4, sSumOut4, sCarryOut4);

InstAley_GenReg4: Aley_GenReg generic map(w+4*BITS4, 8*BITS4) port map(clk, reset, en, sAout4, sBoutR3(3*BITS4-1 downto BITS4), sSumOut4, sCarryOut4, sAoutR4, sBoutR4, sSumOutR4, sCarryOutR4);

InstAley_CSMSlice_4B5: Aley_CSMSlice_4B generic map (W+4*BITS4) port map( sAoutR4, sBoutR4(BITS4-1 downto 0), sSumOutR4, sCarryOutR4, sAout5, sSumOut5, sCarryOut5);

InstAley_GenReg5: Aley_GenReg generic map(w+5*BITS4, 10*BITS4) port map(clk, reset, en, sAout5, sBoutR4(2*BITS4-1 downto BITS4), sSumOut5, sCarryOut5, sAoutR5, sBoutR5, sSumOutR5, sCarryOutR5);

InstAley_CSMLastSlice_4B: Aley_CSMLastSlice_4B generic map (W+5*BITS4) port map( sAoutR5, sBoutR5(BITS4-1 downto 0), sSumOutR5, sCarryOutR5, sSumOut6, sCarryOut6);

InstAley_GenReg6: Aley_GenRegLast generic map(w+6*BITS4) port map(clk, reset, en, sSumOut6, sCarryOut6, sSumOutR6, sCarryOutR6);


SumOut <= sSumOutR6+sCarryOutR6;


end CSM_4B;
