function samples = inv_spharmonic_tran(alm, bw, directory)
%INV_SPHARMONIC_TRAN   Inverse spherical harmonic transform, a wrapper of 
%test_s2_semi_memo_inv.
%
%   samples = inv_spharmonic_tran(alm, bw, directory);
%
% Inputs:
%   a: the spherical harmonic coefficients. It is a bw-by-(2*bw-1) matrix. 
%   The entry in the i-th row and the j-th column is the spherical harmonic 
%   coefficient with l=i-1, m=j-bw.
%   bw: the bandwidth of the bandlimited function. 
%   directory: the directory where you put S2Kit, e.g., 
%   /path/to/directory/s2kit10.
%   
% Outputs:
%   samples: f(\theta_0, \phi_0), f(\theta_0, \phi_1),...
%
% Written by Minjie Fan, 2015

% open the file
fid = fopen('coefs.dat', 'w');

% write to the file
for m = 0:bw-1
    for l = m:bw-1
        fprintf(fid, '%.15f\n', real(alm(l+1, m+bw)));
        fprintf(fid, '%.15f\n', imag(alm(l+1, m+bw)));
    end
end
for m = 1-bw:-1
    for l = abs(m):bw-1
        fprintf(fid, '%.15f\n', real(alm(l+1, m+bw)));
        fprintf(fid, '%.15f\n', imag(alm(l+1, m+bw)));
    end
end

% close the file
fclose(fid);

% inverse spherical harmonic transform
system([directory, '/test_s2_semi_memo_inv', ' coefs.dat samples.dat ', num2str(bw)]);

% remove the file
system('rm coefs.dat');

% obtain the samples
tmp = textread('samples.dat');
samples = tmp(1:2:length(tmp));
system('rm samples.dat');

end
