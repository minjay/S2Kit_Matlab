function a = spharmonic_tran(fun_sample_file, bw, directory)
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
%
% Outputs:
%   a: the spherical harmonic coefficients. It is a bw-by-(2*bw-1) matrix. 
%   The entry in the i-th row and the j-th column is the spherical harmonic 
%   coefficient with l=i-1, m=j-bw.
%
%   See the packages SpharmonicKit and S2Kit for details.
%
%   Written by Minjie Fan

filename = ['coef', fun_sample_file];
system([directory, '/test_s2_semi_memo_for ', fun_sample_file, ' ', filename, ' ',...
    num2str(bw),' 0']);
tmp = textread( filename );
index = 0;
a = zeros(bw, 2*bw-1);
for m = 0:bw-1
    for l = m:bw-1
        index = index+1;
        a(l+1,m+bw) = tmp( 2*index-1 )+tmp( 2*index )*1i;
    end
end
for m = 1-bw:-1
    for l = abs(m):bw-1
        index = index+1;
        a(l+1,m+bw) = tmp( 2*index-1 )+tmp( 2*index )*1i;
    end
end
system(['rm ', filename]);

end