library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;  

entity clk_divizat is
port (
    clk_in    : in  std_logic;
    ud_in     : in  STD_LOGIC;
    reset_in  : in  STD_LOGIC;
    Gray_out  : out STD_LOGIC_VECTOR (3 downto 0)  -- ieșire pentru codul Gray
);
end clk_divizat;

architecture Behavioral of clk_divizat is

    signal a : std_logic_vector(3 downto 0);
    signal out_div : std_logic;

begin

    -- Divizor de frecventa
    process(clk_in)
        variable n : integer range 0 to 1000000000;
    begin
        if clk_in'event and clk_in = '1' then
            if n < 100000000 then
                n := n + 1;
            else
                n := 0; 
            end if;
            if n <= 50000000 then
                out_div <= '1';
            else
                out_div <= '0';
            end if;
        end if;
    end process;

    -- Proces incrementare/decrementare
    process(out_div, ud_in, reset_in)
    begin
        if reset_in = '1' then  -- Resetare
            a <= (others => '0');
        elsif (out_div'event and out_div = '1') then
            if ud_in = '1' then  -- Incrementare
                a <= a + 1;
            elsif ud_in = '0' then  -- Decrementare
                a <= a - 1;
            end if;
        end if;
    end process;

    -- Conversia Binar - Gray
    process(a)
    begin
        -- Conversia binarului `a` într-un cod Gray
        Gray_out(3) <= a(3);         -- MSB rămâne același
        Gray_out(2) <= a(3) XOR a(2);  -- XOR între a(3) și a(2)
        Gray_out(1) <= a(2) XOR a(1);  -- XOR între a(2) și a(1)
        Gray_out(0) <= a(1) XOR a(0);  -- XOR între a(1) și a(0)
    end process;

end Behavioral;
