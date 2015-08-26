% An example of
% (1) Randomly generating spherical harmonic coefficients;
% (2) Performing an inverse spherical harmonic transform and obtaining the
% samples of a function;
% (3) Performing a spherical harmonic transform
% (4) Comparing the fitted and the true values of the spherical harmonic 
% coefficients.

% We assume that the function is real-valued. Thus, the spherical
% harmonic coefficients a_{l,m} satisfy:
% a_{l,0}'s are real numbers;
% a_{l,m}=(-1)^m*conj(a_{l,-m}), where m \neq 0.

% specify the bandwidth bw
% bw = l_max+1
% typically bw<=500
bw = 16;

% open the file
filename = 'gen_coefs.dat';
fid = fopen(filename, 'w');

% init
% a[l+1, m+bw] saves a_{l,m}
a = zeros(bw, 2*bw-1);

% randomly generate the coefficients a_{l,m}
for l = 0:bw-1
    for m = 1:l
        a(l+1, m+bw) = randn+randn*1i;
    end
    for m = -l:-1
        a(l+1, m+bw) = (-1)^m*conj(a(l+1, -m+bw));
    end
    a(l+1, bw)=randn;
end

% write to a file
for m = 0:bw-1
    for l = m:bw-1
        fprintf(fid, '%.15f\n', real(a(l+1, m+bw)));
        fprintf(fid, '%.15f\n', imag(a(l+1, m+bw)));
    end
end
for m = 1-bw:-1
    for l = abs(m):bw-1
        fprintf(fid, '%.15f\n', real(a(l+1, m+bw)));
        fprintf(fid, '%.15f\n', imag(a(l+1, m+bw)));
    end
end

fclose(fid);

system(['./test_s2_semi_memo_inv ', 'gen_coefs.dat', ' gen_fun_samples.dat ', num2str(bw)]);

system('rm gen_coefs.dat');

tmp = textread('gen_fun_samples.dat');
samples = tmp(1:2:length(tmp));

a_fitted = spharmonic_tran('gen_fun_samples.dat', bw, pwd);

system('rm gen_fun_samples.dat');

% compare
sum(sum(abs(a-a_fitted)))
    