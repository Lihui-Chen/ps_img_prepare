clear all;
addpath(genpath('npy-matlab-master'));
path_list = {
%     '/media/yg/My Passport/backup/Pycharm/data/PanSharp_dataset/IK/train/PAN_full_resolution',
    '/media/yg/My Passport/backup/Pycharm/data/PanSharp_dataset/QB/value/PAN_full_resolution',
%     '/media/yg/My Passport/backup/Pycharm/data/PanSharp_dataset/IK/train/MS_full_resolution',
    '/media/yg/My Passport/backup/Pycharm/data/PanSharp_dataset/QB/value/MS_full_resolution'
    };
for i_dir = 1: length(path_list)
path = path_list{i_dir};
savepath = strcat(path, '_npy');
if ~exist(savepath,'dir')
    mkdir(savepath)
end
list=dir(fullfile(path,'*.tif'));
for i=1:length(list)
    image=double(imread((strcat(list(i).folder,'/',list(i).name))));
    name=list(i).name(1:end-4);
    writeNPY(uint16(image), strcat(savepath,'/',name,'.npy'))
end
end 