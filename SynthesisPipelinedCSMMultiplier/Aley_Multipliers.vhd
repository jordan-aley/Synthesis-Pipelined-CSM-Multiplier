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


---------------------------------------------------------
-- TOP_LEVEL MODULE OF w-bit CARRY SAVE MULTIPLIER
---------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY Aley_CSMultiplier IS
  generic(W: integer :=24; BITS2: integer :=2; BITS4:integer :=4; BITS6:integer :=6; BITS8:integer :=8);
	PORT(	clk: IN std_logic;
                reset: IN std_logic;
                 en: IN std_logic;
                InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(2*W-1 DOWNTO 0));
END Aley_CSMultiplier;

ARCHITECTURE CSM_2B OF Aley_CSMultiplier IS

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

InstAley_CSMSlice_2B2: Aley_CSMSlice_2B generic map (W+BITS2) port map( sAoutR1, sBoutR1(BITS2-1 downto 0), sSumOutR1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);

InstAley_GenReg2: Aley_GenReg generic map(w+2*BITS2, 4*BITS2) port map(clk, reset, en, sAout2, sBoutR1(11*BITS2-1 downto BITS2), sSumOut2, sCarryOut2, sAoutR2, sBoutR2, sSumOutR2, sCarryOutR2);

InstAley_CSMSlice_2B3: Aley_CSMSlice_2B generic map (W+2*BITS2) port map( sAoutR2, sBoutR2(BITS2-1 downto 0), sSumOutR2, sCarryOut2, sAout3, sSumOut3, sCarryOut3);

InstAley_GenReg3: Aley_GenReg generic map(w+3*BITS2, 6*BITS2) port map(clk, reset, en, sAout3, sBoutR2(10*BITS2-1 downto BITS2), sSumOut3, sCarryOut3, sAoutR3, sBoutR3, sSumOutR3, sCarryOutR3);

InstAley_CSMSlice_2B4: Aley_CSMSlice_2B generic map (W+3*BITS2) port map( sAoutR3, sBoutR3(BITS2-1 downto 0), sSumOutR3, sCarryOut3, sAout4, sSumOut4, sCarryOut4);

InstAley_GenReg4: Aley_GenReg generic map(w+4*BITS2, 8*BITS2) port map(clk, reset, en, sAout4, sBoutR3(9*BITS2-1 downto BITS2), sSumOut4, sCarryOut4, sAoutR4, sBoutR4, sSumOutR4, sCarryOutR4);

InstAley_CSMSlice_2B5: Aley_CSMSlice_2B generic map (W+4*BITS2) port map( sAoutR4, sBoutR4(BITS2-1 downto 0), sSumOutR4, sCarryOut4, sAout5, sSumOut5, sCarryOut5);

InstAley_GenReg5: Aley_GenReg generic map(w+5*BITS2, 10*BITS2) port map(clk, reset, en, sAout5, sBoutR4(8*BITS2-1 downto BITS2), sSumOut5, sCarryOut5, sAoutR5, sBoutR5, sSumOutR5, sCarryOutR5);

InstAley_CSMSlice_2B6: Aley_CSMSlice_2B generic map (W+5*BITS2) port map( sAoutR5, sBoutR5(BITS2-1 downto 0), sSumOutR5, sCarryOut5, sAout6, sSumOut6, sCarryOut6);

InstAley_GenReg6: Aley_GenReg generic map(w+6*BITS2, 12*BITS2) port map(clk, reset, en, sAout6, sBoutR5(7*BITS2-1 downto BITS2), sSumOut6, sCarryOut6, sAoutR6, sBoutR6, sSumOutR6, sCarryOutR6);

InstAley_CSMSlice_2B7: Aley_CSMSlice_2B generic map (W+6*BITS2) port map( sAoutR6, sBoutR6(BITS2-1 downto 0), sSumOutR6, sCarryOut6, sAout7, sSumOut7, sCarryOut7);

InstAley_GenReg7: Aley_GenReg generic map(w+7*BITS2, 14*BITS2) port map(clk, reset, en, sAout7, sBoutR6(6*BITS2-1 downto BITS2), sSumOut7, sCarryOut7, sAoutR7, sBoutR7, sSumOutR7, sCarryOutR7);

InstAley_CSMSlice_2B8: Aley_CSMSlice_2B generic map (W+7*BITS2) port map( sAoutR7, sBoutR7(BITS2-1 downto 0), sSumOutR7, sCarryOut7, sAout8, sSumOut8, sCarryOut8);

InstAley_GenReg8: Aley_GenReg generic map(w+8*BITS2, 16*BITS2) port map(clk, reset, en, sAout8, sBoutR7(5*BITS2-1 downto BITS2), sSumOut8, sCarryOut8, sAoutR8, sBoutR8, sSumOutR8, sCarryOutR8);

InstAley_CSMSlice_2B9: Aley_CSMSlice_2B generic map (W+8*BITS2) port map( sAoutR8, sBoutR8(BITS2-1 downto 0), sSumOutR8, sCarryOut8, sAout9, sSumOut9, sCarryOut9);

InstAley_GenReg9: Aley_GenReg generic map(w+9*BITS2, 18*BITS2) port map(clk, reset, en, sAout9, sBoutR8(4*BITS2-1 downto BITS2), sSumOut9, sCarryOut9, sAoutR9, sBoutR9, sSumOutR9, sCarryOutR9);

InstAley_CSMSlice_2B10: Aley_CSMSlice_2B generic map (W+9*BITS2) port map( sAoutR9, sBoutR9(BITS2-1 downto 0), sSumOutR9, sCarryOut9, sAout10, sSumOut10, sCarryOut10);

InstAley_GenReg10: Aley_GenReg generic map(w+10*BITS2, 20*BITS2) port map(clk, reset, en, sAout10, sBoutR9(3*BITS2-1 downto BITS2), sSumOut10, sCarryOut10, sAoutR10, sBoutR10, sSumOutR10, sCarryOutR10);

InstAley_CSMSlice_2B11: Aley_CSMSlice_2B generic map (W+10*BITS2) port map( sAoutR10, sBoutR10(BITS2-1 downto 0), sSumOutR10, sCarryOut10, sAout11, sSumOut11, sCarryOut11);

InstAley_GenReg11: Aley_GenReg generic map(w+11*BITS2, 22*BITS2) port map(clk, reset, en, sAout11, sBoutR10(2*BITS2-1 downto BITS2), sSumOut11, sCarryOut11, sAoutR11, sBoutR11, sSumOutR11, sCarryOutR11);

InstAley_CSMLastSlice_2B12: Aley_CSMLastSlice_2B generic map (W+11*BITS2) port map( sAoutR11, sBoutR11(BITS2-1 downto 0), sSumOutR11, sCarryOut11, sSumOut12, sCarryOut12);

InstAley_GenReg12: Aley_GenRegLast generic map(w+12*BITS2) port map(clk, reset, en, sSumOut12, sCarryOut12, sSumOutR12, sCarryOutR12);

SumOut <= sSumOut12 + sCarryOut12;


end CSM_2B;

-----------------------------------------------------------

ARCHITECTURE CSM_4B OF Aley_CSMultiplier IS

COMPONENT Aley_CSMSlice_4B
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice_4B
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
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

InstAley_CSMSlice_4B2: Aley_CSMSlice_4B generic map (W+BITS4) port map( sAoutR1, sBoutR1(BITS4-1 downto 0), sSumOutR1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);

InstAley_GenReg2: Aley_GenReg generic map(w+2*BITS4, 4*BITS4) port map(clk, reset, en, sAout2, sBoutR1(5*BITS4-1 downto BITS4), sSumOut2, sCarryOut2, sAoutR2, sBoutR2, sSumOutR2, sCarryOutR2);

InstAley_CSMSlice_4B3: Aley_CSMSlice_4B generic map (W+2*BITS4) port map( sAoutR2, sBoutR2(BITS4-1 downto 0), sSumOutR2, sCarryOut2, sAout3, sSumOut3, sCarryOut3);

InstAley_GenReg3: Aley_GenReg generic map(w+3*BITS4, 6*BITS4) port map(clk, reset, en, sAout3, sBoutR2(4*BITS4-1 downto BITS4), sSumOut3, sCarryOut3, sAoutR3, sBoutR3, sSumOutR3, sCarryOutR3);

InstAley_CSMSlice_4B4: Aley_CSMSlice_4B generic map (W+3*BITS4) port map( sAoutR3, sBoutR3(BITS4-1 downto 0), sSumOutR3, sCarryOut3, sAout4, sSumOut4, sCarryOut4);

InstAley_GenReg4: Aley_GenReg generic map(w+4*BITS4, 8*BITS4) port map(clk, reset, en, sAout4, sBoutR3(3*BITS4-1 downto BITS4), sSumOut4, sCarryOut4, sAoutR4, sBoutR4, sSumOutR4, sCarryOutR4);

InstAley_CSMSlice_4B5: Aley_CSMSlice_4B generic map (W+4*BITS4) port map( sAoutR4, sBoutR4(BITS4-1 downto 0), sSumOutR4, sCarryOut4, sAout5, sSumOut5, sCarryOut5);

InstAley_GenReg5: Aley_GenReg generic map(w+5*BITS4, 10*BITS4) port map(clk, reset, en, sAout5, sBoutR4(2*BITS4-1 downto BITS4), sSumOut5, sCarryOut5, sAoutR5, sBoutR5, sSumOutR5, sCarryOutR5);

InstAley_CSMLastSlice_4B: Aley_CSMLastSlice_4B generic map (W+5*BITS4) port map( sAoutR5, sBoutR5(BITS4-1 downto 0), sSumOutR5, sCarryOutR5, sSumOut6, sCarryOut6);

InstAley_GenReg6: Aley_GenRegLast generic map(w+6*BITS4) port map(clk, reset, en, sSumOut6, sCarryOut6, sSumOutR6, sCarryOutR6);


SumOut <= sSumOut6+sCarryOut6;


end CSM_4B;

-----------------------------------------------------------

ARCHITECTURE CSM_6B OF Aley_CSMultiplier IS

COMPONENT Aley_CSMSlice_6B
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice_6B
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
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
SIGNAL sSumOut1 : std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS6-1 downto 0);
SIGNAL sSumOut4 : std_logic_vector(W+4*BITS6-1 downto 0);

SIGNAL sAoutR1: std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sAoutR2: std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sAoutR3: std_logic_vector(W+3*BITS6-1 downto 0);

SIGNAL sBoutR1: std_logic_vector(W-BITS6-1 downto 0);
SIGNAL sBoutR2: std_logic_vector(W-2*BITS6-1 downto 0);
SIGNAL sBoutR3: std_logic_vector(W-3*BITS6-1 downto 0);

SIGNAL sSumOutR1: std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sSumOutR2: std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sSumOutR3: std_logic_vector(W+3*BITS6-1 downto 0);
SIGNAL sSumOutR4: std_logic_vector(W+4*BITS6-1 downto 0);

SIGNAL sCarryOutR1: std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sCarryOutR2: std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sCarryOutR3: std_logic_vector(W+3*BITS6-1 downto 0);
SIGNAL sCarryOutR4: std_logic_vector(W+4*BITS6-1 downto 0);

SIGNAL sAout1 : std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sAout3 : std_logic_vector(W+3*BITS6-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS6-1 downto 0);
SIGNAL sCarryOut4 : std_logic_vector(W+4*BITS6-1 downto 0);

begin

InstAley_CSMSlice_6B1: Aley_CSMSlice_6B generic map (W) port map( InA, InB(BITS6-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);

InstAley_GenReg1: Aley_GenReg generic map(w+BITS6, 2*BITS6) port map(clk, reset, en, sAout1, InB(4*BITS6-1 downto BITS6), sSumOut1, sCarryOut1, sAoutR1, sBoutR1, sSumOutR1, sCarryOutR1);

InstAley_CSMSlice_6B2: Aley_CSMSlice_6B generic map (W+BITS6) port map( sAoutR1, sBoutR1(BITS6-1 downto 0), sSumOutR1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);

InstAley_GenReg2: Aley_GenReg generic map(w+2*BITS6, 4*BITS6) port map(clk, reset, en, sAout2, sBoutR1(3*BITS6-1 downto BITS6), sSumOut2, sCarryOut2, sAoutR2, sBoutR2, sSumOutR2, sCarryOutR2);

InstAley_CSMSlice_6B3: Aley_CSMSlice_6B generic map (W+2*BITS6) port map( sAoutR2, sBoutR2(BITS6-1 downto 0), sSumOutR2, sCarryOut2, sAout3, sSumOut3, sCarryOut3);

InstAley_GenReg3: Aley_GenReg generic map(w+3*BITS6, 6*BITS6) port map(clk, reset, en, sAout3, sBoutR2(2*BITS6-1 downto BITS6), sSumOut3, sCarryOut3, sAoutR3, sBoutR3, sSumOutR3, sCarryOutR3);

InstAley_CSMLastSlice_6B: Aley_CSMLastSlice_6B generic map (W+3*BITS6) port map( sAoutR3, sBoutR3(BITS6-1 downto 0), sSumOutR3, sCarryOutR3, sSumOut4, sCarryOut4);

InstAley_GenReg4: Aley_GenRegLast generic map(w+4*BITS6) port map(clk, reset, en, sSumOut4, sCarryOut4, sSumOutR4, sCarryOutR4);


SumOut <= sSumOut4 + sCarryOut4;


end CSM_6B;


-----------------------------------------------------------

ARCHITECTURE CSM_8B OF Aley_CSMultiplier IS

COMPONENT Aley_CSMSlice_8B
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT Aley_CSMLastSlice_8B
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
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
SIGNAL sSumOut1 : std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS8-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS8-1 downto 0);

SIGNAL sAoutR1: std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sAoutR2: std_logic_vector(W+2*BITS8-1 downto 0);

SIGNAL sBoutR1: std_logic_vector(W-BITS8-1 downto 0);
SIGNAL sBoutR2: std_logic_vector(W-2*BITS8-1 downto 0);

SIGNAL sSumOutR1: std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sSumOutR2: std_logic_vector(W+2*BITS8-1 downto 0);
SIGNAL sSumOutR3: std_logic_vector(W+3*BITS8-1 downto 0);

SIGNAL sCarryOutR1: std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sCarryOutR2: std_logic_vector(W+2*BITS8-1 downto 0);
SIGNAL sCarryOutR3: std_logic_vector(W+3*BITS8-1 downto 0);

SIGNAL sAout1 : std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS8-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS8-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS8-1 downto 0);




begin

InstAley_CSMSlice_8B1: Aley_CSMSlice_8B generic map (W) port map( InA, InB(BITS8-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);

InstAley_GenReg1: Aley_GenReg generic map(w+BITS8, 2*BITS8) port map(clk, reset, en, sAout1, InB(3*BITS8-1 downto BITS8), sSumOut1, sCarryOut1, sAoutR1, sBoutR1, sSumOutR1, sCarryOutR1);

InstAley_CSMSlice_8B2: Aley_CSMSlice_8B generic map (W+BITS8) port map( sAoutR1, sBoutR1(BITS8-1 downto 0), sSumOutR1, sCarryOutR1, sAout2, sSumOut2, sCarryOut2);

InstAley_GenReg2: Aley_GenReg generic map(w+2*BITS8, 4*BITS8) port map(clk, reset, en, sAout2, sBoutR1(2*BITS8-1 downto bitS8), sSumOut2, sCarryOut2, sAoutR2, sBoutR2, sSumOutR2, sCarryOutR2);

InstAley_CSMLastSlice_8B: Aley_CSMLastSlice_8B generic map (W+2*BITS8) port map( sAoutR2, sBoutR2(BITS8-1 downto 0), sSumOutR2, sCarryOutR2, sSumOut3, sCarryOut3);

InstAley_GenReg3: Aley_GenRegLast generic map(w+3*BITS8) port map(clk, reset, en, sSumOut3, sCarryOut3, sSumOutR3, sCarryOutR3);

SumOut <= sSumOutR3 + sCarryOutR3;

end CSM_8B;
