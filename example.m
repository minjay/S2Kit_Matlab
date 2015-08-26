% An example of
% (1) Randomly generating spherical harmonic coefficients;
% (2) Performing an inverse spherical harmonic transform and obtaining the
% samples of a function;
% (3) Performing a spherical harmonic transform;
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

% init
% alm(l+1, m+bw) stores a_{l,m}
alm = zeros(bw, 2*bw-1);

% randomly generate the coefficients a_{l,m}
for l = 0:bw-1
    for m = 1:l
        alm(l+1, m+bw) = randn+randn*1i;
    end
    for m = -l:-1
        alm(l+1, m+bw) = (-1)^m*conj(alm(l+1, -m+bw));
    end
    alm(l+1, bw)=randn;
end

% inverse spherical harmonic transform
samples = inv_spharmonic_tran(alm, bw, pwd);

% spherical harmonic transform
alm_fitted = spharmonic_tran(samples, bw, pwd);

% compare
mean(mean(abs(alm-alm_fitted)))
    