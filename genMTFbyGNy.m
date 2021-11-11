% Description: 
%           Generate a bank of filters shaped on the MTF of the sensor. Each filter
%           corresponds to a band acquired by the sensor. 
% 
% Interface:
%           h = genMTF(ratio, sensor, nbands)
%
% Inputs:
%           ratio:              Scale ratio between MS and PAN. Pre-condition: Integer value.
%           sensor:             String for type of sensor (e.g. 'WV2','IKONOS');
%           nbands:             Number of spectral bands.
%
% Outputs:
%           h:                  Gaussian filter mimicking the MTF of the MS sensor
% 
% References:
%           [Aiazzi02]          B. Aiazzi, L. Alparone, S. Baronti, and A. Garzelli, ?Context-driven fusion of high spatial and spectral resolution images based on
%                               oversampled multiresolution analysis,? IEEE Transactions on Geoscience and Remote Sensing, vol. 40, no. 10, pp. 2300?2312, October
%                               2002.
%           [Aiazzi06]          B. Aiazzi, L. Alparone, S. Baronti, A. Garzelli, and M. Selva, ?MTF-tailored multiscale fusion of high-resolution MS and Pan imagery,?
%                               Photogrammetric Engineering and Remote Sensing, vol. 72, no. 5, pp. 591?596, May 2006.
%           [Vivone14a]         G. Vivone, R. Restaino, M. Dalla Mura, G. Licciardi, and J. Chanussot, ?Contrast and error-based fusion schemes for multispectral
%                               image pansharpening,? IEEE Geoscience and Remote Sensing Letters, vol. 11, no. 5, pp. 930?934, May 2014.
%           [Vivone15]          G. Vivone, L. Alparone, J. Chanussot, M. Dalla Mura, A. Garzelli, G. Licciardi, R. Restaino, and L. Wald, ?A Critical Comparison Among Pansharpening Algorithms?, 
%                               IEEE Transactions on Geoscience and Remote Sensing, vol. 53, no. 5, pp. 2565?2586, May 2015.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = genMTFbyGNy(ratio, GNyq)

%%% MTF
N = 41;
% h = zeros(N, N);
fcut = 1/ratio;
alpha = sqrt(((N-1)*(fcut/2))^2/(-2*log(GNyq)));
H = fspecial('gaussian', N, alpha);
Hd = H./max(H(:));
h = fwind1(Hd,kaiser(N));
end