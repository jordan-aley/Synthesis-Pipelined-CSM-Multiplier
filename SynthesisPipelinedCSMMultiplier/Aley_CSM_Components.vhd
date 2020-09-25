--------------------------------------------------------------
--------------------------------------------------------------
-- Copyright Jordan Aley, Howard University 02/2020
-- 02/2020
-- Adv. Dig. Design. II (496)
-- Dr. Michaela E. Amoo
-- Bit Slice for Carry-Save Multiplier
-- Jordan Aley
-- 
--------------------------------------------------------------
-- CSM GENERIC SLICE
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMSlice IS
  generic(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END Aley_CSMSlice;

ARCHITECTURE behv OF Aley_CSMSlice IS

	SIGNAL AB : std_logic_vector(W-1 DOWNTO 0):=(OTHERS=>'0');

BEGIN
	loop1:FOR i IN W-1 DOWNTO 0 GENERATE
			AB(i) <= InA(i) and InB;
		END GENERATE;
	loop2:FOR i IN W-1 DOWNTO 0 GENERATE
    SumOut(i)	<= AB(i) xor SumIn(i) xor CarryIn(i);
		CarryOut(i+1) <= (AB(i) and SumIn(i)) or (AB(i) and CarryIn(i)) or (SumIn(i) and CarryIn(i));
	END GENERATE;
    SumOut(W)	<= '0';
    CarryOut(0) <= '0';
    Aout(W downto 1) <= InA(W-1 downto 0);
    Aout(0)<= '0';
END behv;

--------------------------------------------------------------------
-- CSM LAST SLICE
---------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMLastSlice IS
  generic(W: integer :=24);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic;
		SumIn		: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END Aley_CSMLastSlice;

ARCHITECTURE behv OF Aley_CSMLastSlice IS

	SIGNAL AB : std_logic_vector(W-1 DOWNTO 0):=(OTHERS=>'0');

BEGIN
	loop1:FOR i IN W-1 DOWNTO 0 GENERATE
			AB(i) <= InA(i) and InB;
		END GENERATE;
	loop2:FOR i IN W-1 DOWNTO 0 GENERATE
    SumOut(i)	<= AB(i) xor SumIn(i) xor CarryIn(i);
		CarryOut(i+1) <= (AB(i) and SumIn(i)) or (AB(i) and CarryIn(i)) or (SumIn(i) and CarryIn(i));
	END GENERATE;
    SumOut(W)	<= '0';
    CarryOut(0) <= '0';
END behv;

-----------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164. all;
entity Aley_GenReg is
	
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

end Aley_GenReg;

architecture reg16bit_arch of Aley_GenReg is
signal sAout: std_logic_vector(w-1 downto 0);
signal sBout: std_logic_vector(w-bbits-1 downto 0);
signal sSumout: std_logic_vector(w-1 downto 0);
signal scarryout: std_logic_vector(w-1 downto 0);

begin
   process(clk)
          begin
      		if (clk ='1' and clk'event)then
			if(reset='1')then
				sAout <= (others => '0');
				sBout <= (others => '0');
				sSumout <= (others => '0');
				sCarryout <= (others => '0');
			elsif (en='1')then
				sAout <= InA;
				sBout <= InB;
				sSumout <= SumIn;
				sCarryout <= CarryIn;
			else
				sAout <= sAout;
				sBout <= sBout;
				sSumout <= sSumout;
				sCarryout <= sCarryout;
			end if;
		else
			sAout <= sAout;
			sBout <= sBout;
			sSumout <= sSumout;
			sCarryout <= sCarryout;
		end if;
	end process;
Aout <= sAout;
Bout <= sBout;
Sumout <= sSumout;
Carryout <= sCarryout;
end reg16bit_arch;


-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164. all;
entity Aley_GenRegLast is
	
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

end Aley_GenRegLast;

architecture reg16bit_arch of Aley_GenRegLast is
signal sSumout: std_logic_vector(w-1 downto 0);
signal scarryout: std_logic_vector(w-1 downto 0);

begin
   process(clk)
          begin
      		if (clk ='1' and clk'event)then
			if(reset='1')then
				sSumout <= (others => '0');
				sCarryout <= (others => '0');
			elsif (en='1')then
				sSumout <= SumIn;
				sCarryout <= CarryIn;
			else
				sSumout <= sSumout;
				sCarryout <= sCarryout;
			end if;
		else
			sSumout <= sSumout;
			sCarryout <= sCarryout;
		end if;
	end process;
Sumout <= sSumout;
Carryout <= sCarryout;
end reg16bit_arch;


--------------------------------------------------------------
-- Multiplier Slice(2 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMSlice_2B IS
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMSlice_2B;

ARCHITECTURE behv OF Aley_CSMSlice_2B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+bbits-1 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+BBITS-1 downto 0);


begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMSlice2: Aley_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);

Aout <= sAout2;
Sumout <= s2;
CarryOut <= c2;

END behv;

--------------------------------------------------------------
-- Multiplier LAST Slice(2 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMLastSlice_2B IS
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn		: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMLastSlice_2B;

ARCHITECTURE behv OF Aley_CSMLastSlice_2B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+BBITS-1 downto 0);


begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMLastSlice: Aley_CSMLastSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, s2, c2);

SumOut <= s2;
CarryOut <= c2;

END behv;

----------------------------------------------------------------------------------------------------------
--------------------------------------------------------------
-- Multiplier Slice(4 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMSlice_4B IS
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMSlice_4B;

ARCHITECTURE behv OF Aley_CSMSlice_4B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+BBITS-1 downto 0);

begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMSlice2: Aley_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstAley_CSMSlice3: Aley_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstAley_CSMSlice4: Aley_CSMSlice generic map (W+BBITS-1) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);

Aout <= sAout4;
Sumout <= s4;
CarryOut <= c4;

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(4 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMLastSlice_4B IS
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMLastSlice_4B;

ARCHITECTURE behv OF Aley_CSMLastSlice_4B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+BBITS-1 downto 0);


begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMSlice2: Aley_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstAley_CSMSlice3: Aley_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);

InstAley_CSMLastSlice: Aley_CSMLastSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, s4, c4);

Sumout <= s4;
CarryOut <= c4;

END behv;

--------------------------------------------------------------
-- Multiplier Slice(6 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMSlice_6B IS
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMSlice_6B;

ARCHITECTURE behv OF Aley_CSMSlice_6B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+BBITS-1 downto 0);


begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMSlice2: Aley_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstAley_CSMSlice3: Aley_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstAley_CSMSlice4: Aley_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstAley_CSMSlice5: Aley_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstAley_CSMSlice6: Aley_CSMSlice generic map (W+BBITS-1) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);

Aout <= sAout6;
Sumout <= s6;
CarryOut <= c6;

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(6 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMLastSlice_6B IS
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMLastSlice_6B;

ARCHITECTURE behv OF Aley_CSMLastSlice_6B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+BBITS-1 downto 0);


begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMSlice2: Aley_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstAley_CSMSlice3: Aley_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstAley_CSMSlice4: Aley_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstAley_CSMSlice5: Aley_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstAley_CSMLastSlice: Aley_CSMLastSlice generic map (W+BBITS-1) port map( sAout5, InB(5), s5, c5, s6, c6);

Sumout <= s6;
CarryOut <= c6;
END behv;

--------------------------------------------------------------
-- Multiplier Slice(8 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMSlice_8B IS
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMSlice_8B;

ARCHITECTURE behv OF Aley_CSMSlice_8B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+5 downto 0);
SIGNAL sAout7: std_logic_vector(w+6 downto 0);
SIGNAL sAout8: std_logic_vector(w+7 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);
SIGNAL s7: std_logic_vector(w+6 downto 0);
SIGNAL s8: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+5 downto 0);
SIGNAL c7: std_logic_vector(w+6 downto 0);
SIGNAL c8: std_logic_vector(w+BBITS-1 downto 0);

begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMSlice2: Aley_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstAley_CSMSlice3: Aley_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstAley_CSMSlice4: Aley_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstAley_CSMSlice5: Aley_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstAley_CSMSlice6: Aley_CSMSlice generic map (W+5) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);
InstAley_CSMSlice7: Aley_CSMSlice generic map (W+6) port map( sAout6, InB(6), s6, c6, sAout7, s7, c7);
InstAley_CSMSlice8: Aley_CSMSlice generic map (W+BBITS-1) port map( sAout7, InB(7), s7, c7, sAout8, s8, c8);

Aout <= sAout8;
Sumout <= s8;
CarryOut <= c8;

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(8 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMLastSlice_8B IS
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END Aley_CSMLastSlice_8B;

ARCHITECTURE behv OF Aley_CSMLastSlice_8B IS

COMPONENT Aley_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+5 downto 0);
SIGNAL sAout7: std_logic_vector(w+6 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);
SIGNAL s7: std_logic_vector(w+6 downto 0);
SIGNAL s8: std_logic_vector(w+7 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+5 downto 0);
SIGNAL c7: std_logic_vector(w+6 downto 0);
SIGNAL c8: std_logic_vector(w+7 downto 0);

begin

InstAley_CSMSlice1: Aley_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstAley_CSMSlice2: Aley_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstAley_CSMSlice3: Aley_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstAley_CSMSlice4: Aley_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstAley_CSMSlice5: Aley_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstAley_CSMSlice6: Aley_CSMSlice generic map (W+5) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);
InstAley_CSMSlice7: Aley_CSMSlice generic map (W+6) port map( sAout6, InB(6), s6, c6, sAout7, s7, c7);
InstAley_CSMLastSlice: Aley_CSMLastSlice generic map (W+BBITS-1) port map( sAout7, InB(7), s7, c7, s8, c8);

Sumout <= s8;
CarryOut <= c8;
END behv;

