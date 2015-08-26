function samples = inv_spharmonic_tran(alm, bw, directory)

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

