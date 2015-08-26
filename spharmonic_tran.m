function alm = spharmonic_tran(samples, bw, directory)
%SPHARMONIC_TRAN Spherical harmonic transform using the semi-naive
%DLT. Precomputes all necessary associated Legendre functions prior to
%transforming.
%
%   spharmonic_tran(fun_sample_file, bw, directory);
%
% Inputs:
%   fun_sample_file: the name of the file that stores the samples of a
%   bandlimited function. The samples are arranged in interleaved 
%   real/imaginary format. 
%   bw: the bandwidth of the bandlimited function. 
%   directory: the directory where you put S2Kit, e.g., 
%   /path/to/directory/s2kit10
%
% Outputs:
%   a: the spherical harmonic coefficients. It is a bw-by-(2*bw-1) matrix. 
%   The entry in the i-th row and the j-th column is the spherical harmonic 
%   coefficient with l=i-1, m=j-bw.
%
%   See the packages SpharmonicKit and S2Kit for details.
%
%   Written by Minjie Fan

n = length(samples);

% open the file
fid = fopen('samples.dat', 'w');

% write to the file
for i = 1:n
    fprintf(fid, '%.15f\n', samples(i));
    fprintf(fid, '%.15f\n', 0);
end

% close the file
fclose(fid);

% spherical harmonic transform
system([directory, '/test_s2_semi_memo_for', ' samples.dat coefs.dat ',...
    num2str(bw),' 0']);

% remove the file
system('rm samples.dat');

% obtain the coefficients
tmp = textread('coefs.dat');
index = 0;
alm = zeros(bw, 2*bw-1);
for m = 0:bw-1
    for l = m:bw-1
        index = index+1;
        alm(l+1, m+bw) = tmp(2*index-1)+tmp(2*index)*1i;
    end
end
for m = 1-bw:-1
    for l = abs(m):bw-1
        index = index+1;
        alm(l+1, m+bw) = tmp(2*index-1)+tmp(2*index)*1i;
    end
end 
system('rm coefs.dat');

end