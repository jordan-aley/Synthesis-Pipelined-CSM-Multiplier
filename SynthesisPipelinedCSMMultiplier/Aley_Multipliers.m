function y = Aley_Multipliers()


%Create output file
input_file = fopen('ALEY_Multipliers_input.txt', 'w');
mat_outfile = fopen('ALEY_Multipliers_output.txt', 'w');


%number of input_bits
bits = 24;

for i = 1:2^bits
    inputA =i;
    inA = dec2bin(inputA, 24);
    inputB = inputA-1;
    inB = dec2bin(inputB, 24); 
    enable = 1;
    en = dec2bin(enable,1);
    reset = 0;
    rst = dec2bin(reset,1);
    
    sum = inputA*inputB;

    y = [rst ' ' en ' ' inA ' ' inB];

    x = dec2bin(sum, 2*bits);
    fprintf(input_file, '%s\r\n', y);
    fprintf(mat_outfile, '%s\r\n', x);
end

fprintf(input_file, '.\n')
fprintf(mat_outfile, '.\n')
end
