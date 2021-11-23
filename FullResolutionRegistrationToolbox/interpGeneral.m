%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
%           General function for polynomial interpolation. 
% 
% Interface:
%           I_Interpolated = interpGeneral(I_Interpolated,ratio,tap,tag_interp,shift,shift2)
%
% Inputs:
%           I_Interpolated:     Image to interpolate;
%           ratio:              Scale ratio between MS and PAN. Pre-condition: Integer value.
%           tap:                Filter tap;
%           tag_interp:         Indicate odd (o) or even (e) coefficients for filtering on rows and columns (possible options: 'e_e', 'o_o', 'e_o', 'o_e')
%           shift:              Shift on rows;
%           shift2:             Shift on columns.
%
% Outputs:
%           I_Interpolated:     Interpolated image.
%           
% Reference:
% [Vivone21]      G. Vivone, M. Dalla Mura, A. Garzelli, and F. Pacifici, "A Benchmarking Protocol for Pansharpening: Dataset, Pre-processing, and Quality Assessment", 
%                 IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing, 2021.
% 
% % % % % % % % % % % % % 
% 
% Version: 1
% 
% % % % % % % % % % % % % 
% 
% Copyright (C) 2021
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function I_Interpolated = interpGeneral(I_Interpolated,ratio,tap,tag_interp,shift,shift2)

if nargin < 4
    tag_interp ='o_o';
    shift = 3;
    shift2 = 3;
end

L = tap;

[r,c,b] = size(I_Interpolated);

if strcmp(tag_interp(1),'o')
    BaseCoeff = ratio.*fir1(L,1./ratio);
else
    BaseCoeff = ratio.*fir1(L+1,1./ratio);
end

if strcmp(tag_interp(3),'o')
    BaseCoeff2 = ratio.*fir1(L,1./ratio);
else
    BaseCoeff2 = ratio.*fir1(L+1,1./ratio);
end


I1LRU = zeros(ratio.*r, ratio.*c, b);
I1LRU(floor(ratio/2)+shift:ratio:end,floor(ratio/2)+shift2:ratio:end,:) = I_Interpolated;

for ii = 1 : b
    t = I1LRU(:,:,ii);
    t = imfilter(t',BaseCoeff2,'circular');
    I1LRU(:,:,ii) = imfilter(t',BaseCoeff,'circular');
end

I_Interpolated = I1LRU;

end