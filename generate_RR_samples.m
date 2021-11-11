clear, clc


ms_dir = '../Dataset/NBU_QB/test/MS';
pan_dir = '../Dataset/NBU_QB/test/PAN';
sensor = 'QB';
ratio = 4;

save_ms = strcat(ms_dir,'_rr_npy');
% save_gt = strcat(ms_dir, '_rrgt_npy');
save_pan = strcat(pan_dir, '_rr_npy');
save_mtf = strcat(ms_dir, '_rr_mtf_kernel_npy');

if ~exist(save_ms, 'dir')
    mkdir(save_ms);
end
if ~exist(save_pan, 'dir')
    mkdir(save_pan);
end
if ~exist(save_mtf, 'dir')
    mkdir(save_mtf);
end
% if ~exist(save_gt, 'dir')
%     mkdir(save_gt);
% end

ms_files = dir(fullfile(ms_dir, '*.mat'));
numImgs = length(ms_files);
% rng(0); % for NBU_QB train % for random gain at Nyquist frequence
% rng(100); % for NBU_QB valid
% rng(43); % for NBU_QB test
for idxImg = 1:numImgs
    idx = mod(idxImg, numImgs);
    if idx==0 
        idx=1 ;
    end
    msName = ms_files(idx).name;
    msImg = load(fullfile(ms_dir, msName));
    msImg = double(msImg.imgMS);
    panImg = load(fullfile(pan_dir, msName));
    panImg = double(panImg.imgPAN);
    fprintf('Processing the %d-th image. Maxvalue: %.4f\n', idxImg, max(panImg(:)));
    [rr_msImg, rr_panImg] = resize_images(msImg, panImg, ratio, sensor);
    %[rr_msImg, rr_panImg, mtf] = Generate_rr_samples_random(msImg, panImg, ratio, 0.3, 0.03);
    writeNPY(rr_msImg, fullfile(save_ms, strcat(string(ceil(idxImg/numImgs)), '_', msName(1:end-4),'.npy')));
    writeNPY(rr_panImg, fullfile(save_pan, strcat(string(ceil(idxImg/numImgs)), '_', msName(1:end-4), '.npy')));
%     writeNPY(msImg, fullfile(save_gt, strcat(string(ceil(idxImg/numImgs)), '_', msName(1:end-4), '.npy')));
    writeNPY(mtf, fullfile(save_mtf, strcat(string(ceil(idxImg/numImgs)), '_', msName(1:end-4), '.npy')));
end