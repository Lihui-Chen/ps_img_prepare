%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   FULL RESOLUTION REGISTRATION TOOLBOX 
% 
% Please, refer to the following paper:
% G. Vivone, M. Dalla Mura, A. Garzelli, and F. Pacifici, "A Benchmarking Protocol for Pansharpening: Dataset, Pre-processing, and Quality Assessment", 
% IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing, 2021.
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

clear;
close all;
clc;

%% Load original full resolution dataset

%%% MS image
I_MS_LR = double(imread('16MAY02131229-M2AS-055670633040_01_P001.TIF'));
%%% PAN image
I_PAN = double(imread('16MAY02131229-P2AS-055670633040_01_P001.TIF'));

%% Set parameters

%%% Defining the MS bounding box
% Size area MS image (number of rows MS registrated dataset)
Wr = 512;

% Size area MS image (number of columns MS registrated dataset)
Wc = Wr;

% MS bounding box center (row)
center_r_MS = 1400; %%% decided by visual inspection

% MS bounding box center (column)
center_c_MS = 1000; %%% decided by visual inspection

%%% Cut final image
flag_cut_bounds = 1;
dim_cut = 21;

%%% Threshold values out of dynamic range
thvalues = 0;

%%% Print Eps
printEPS = 0;

%%% Resize Factor
ratio = 4;

%%% Radiometric Resolution
L = 11;

%% Cut area

%%% Extract MS area
I_MS_LR_little = I_MS_LR(center_r_MS-round(Wr/2)+1:center_r_MS+round(Wr/2),center_c_MS-round(Wc/2)+1:center_c_MS+round(Wc/2),:);
size(I_MS_LR_little)

%%% Calculate equivalent PAN area
I_PAN_little = I_PAN(center_r_MS*ratio-round(Wr*ratio/2)+3:center_r_MS*ratio+round(Wr*ratio/2)+2,center_c_MS*ratio-round(Wc*ratio/2)+3:center_c_MS*ratio+round(Wc*ratio/2)+2,:);
size(I_PAN_little)

%% Interpolation MS

vect_tag_interp = {'e_e', 'o_o', 'e_o', 'o_e'};
tap = 44; % tap filter
misals = zeros(2,numel(vect_tag_interp));
vect_I_PAN_little = zeros(size(I_PAN_little,1),size(I_PAN_little,2),numel(vect_tag_interp));
for ii = 1 : numel(vect_tag_interp)
    %%% Interpolator odd or even on rows/columns checking the misalignments
    tag_interp = vect_tag_interp{ii};

    %%% Interpolation
    I_MS = interpGeneral(I_MS_LR_little,ratio,tap,tag_interp,1,1);

    %%% Check sub-pixel registration between MS and PAN 
    output = round(dftregistration(fft2(mean(I_MS,3)),fft2(I_PAN_little),100));
    
    %%% Cut the PAN image to align it to the MS image (alignment to the 2.5/3 pixel) 
    vect_I_PAN_little(:,:,ii) = I_PAN(center_r_MS*ratio-round(Wr*ratio/2)+3 - output(3):center_r_MS*ratio+round(Wr*ratio/2)+2 - output(3),center_c_MS*ratio-round(Wc*ratio/2)+3- output(4):center_c_MS*ratio+round(Wc*ratio/2)+2- output(4),:);

    %%% Check sub-pixel registration between MS and PAN 
    output = dftregistration(fft2(mean(I_MS,3)),fft2(vect_I_PAN_little(:,:,ii)),100);
    misals(:,ii) = output(3:4);
end

% Select the best combination of interpolators (row/column)
[~,indmin] = min(mean(abs(misals),1)); 

%%% Select the best aligned PAN image
I_PAN_little = vect_I_PAN_little(:,:,indmin);
tag_interp = vect_tag_interp{indmin};

%% Final products
I_MS_LR = I_MS_LR_little;
I_PAN = I_PAN_little;

%%% Interpolation
I_MS = interpGeneral(I_MS_LR,ratio,tap,tag_interp,1,1);

%% Measure the final misalignments
output = dftregistration(fft2(mean(I_MS,3)),fft2(I_PAN),100);
output(3:4)

%% Visual inspection MS and PAN final products 

%%% EXP
if size(I_MS,3) == 4   
    showImage4(I_MS,printEPS,1,flag_cut_bounds,dim_cut,thvalues,L);    
else
    showImage8(I_MS,printEPS,1,flag_cut_bounds,dim_cut,thvalues,L);
end

%%% PAN
showPan(I_PAN,printEPS,2,flag_cut_bounds,dim_cut);

%% Save data
save 'Test_FR.mat' I_MS I_MS_LR I_PAN ratio tag_interp