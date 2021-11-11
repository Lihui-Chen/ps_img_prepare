
clear all; clc; close all;
clear;
ms_dir='../PanSharpenDataSet/WV3_Rio_Tripoli/4bands_MS_tif';
pan_dir='../PanSharpenDataSet/WV3_Rio_Tripoli/4bands_Pan_tif';
save_ms_dir = strcat(ms_dir(1:end-4),'_chop');
save_pan_dir = strcat(pan_dir(1:end-4), '_chop'); 

if ~exist(save_ms_dir, 'dir')
    mkdir(save_ms_dir);
end
if ~exist(save_pan_dir, 'dir')
    mkdir(save_pan_dir);
end

radiance_resolution = 2^11; 
SoM=256;
SoP=256*4;
files=dir(fullfile(ms_dir, '*.TIF')); 
Num1 = length(files);
% [Num1,Num2]=size(files);


for t=2:Num1

    %%
    %
    fprintf('processing the %d-th img \n',t);
    strMS=fullfile(ms_dir,files(t).name); %     
    strPan = fullfile(pan_dir, strrep(files(t).name, '-M', '-P'));
  
    OMS=imread(strMS);
    OPan=imread(strPan);
    OMS=double(OMS);
    OMS(OMS>radiance_resolution) = radiance_resolution;
    OMS(OMS<0) = 0;
    OPan=double(OPan);
    OPan(OPan>radiance_resolution) = radiance_resolution;
    OPan(OPan<0)=0;
    
    tt = num2str(t+100);
    tt = tt(2:end);
    
    %%
   
    [size1,size2]=size(OMS(:,:,1));
    t1=1;
   for i=1:SoM:size1-SoM
       for j=1:SoM:size2-SoM
           NMS=OMS(i:i+SoM-1,j:j+SoM-1,:);
           ct= num2str(10000+t1);
           ct = ct(2:end);
           
           imagenameforMS=fullfile(save_ms_dir,strcat('MS', tt, '_', ct));
           t1=t1+1;
%            imagenameforMS2=strcat(imagenameforMS,'.tif');
           imagenameforMS2=strcat(imagenameforMS,'.npy');
           imagenameforMS1=strcat(imagenameforMS,'.bmp');
           if (max(max(max(OMS(:,:,1))))>255)
%                imwrite(uint16(NMS),imagenameforMS2);
%                t=Tiff('imagenameforMS2','w');
%                tagstruct.ImageLength=size(uint16(NMS),1);
%                tagstruct.ImageWidth=size(uint16(NMS),2);
%                t.setTag(tagstruct);
%                t.write(uint16(NMS));
                 writeNPY(uint16(NMS),imagenameforMS2);
           else
               imwrite(uint8(NMS),imagenameforMS2);
           end
           
           for k=1:3
               M(:,:,k)=NMS(:,:,k)/max((max(NMS(:,:,k))));
               M(:,:,k) = imadjust(M(:,:,k),stretchlim(M(:,:,k)),[0.1,0.9]);
           end
            imwrite(uint8(M*255),imagenameforMS1);
            clear imagenameforMS;
            clear imagenameforMS1;
            clear imagenameforMS2;
       end
   end
   
   clear OMS;
   clear NMS;
   clear M;
%    
   t2=1;
   [size3,size4]=size(OPan);
   for i=1:SoP:size3-SoP
       for j=1:SoP:size4-SoP
           NPan=OPan(i:i+SoP-1,j:j+SoP-1);
           ct=num2str(10000+t2);
           ct = ct(2:end);
           imagenameforPan=fullfile(save_pan_dir,strcat('MS', tt, '_', ct));
           t2=t2+1;
           imagenameforPan1=strcat(imagenameforPan,'.npy');
           imagenaemforPan2 = strcat(imagenameforPan, '.bmp');
           if (max(max(NPan))>255)
%                imwrite(uint16(NPan),imagenameforPan);
               writeNPY(uint16(NPan),imagenameforPan1);
%            else
%                imwrite(uint8(NPan),imagenameforPan1);
           end
           NPan = NPan / max(NPan(:));
           NPan =   imadjust(NPan,stretchlim(NPan,[0.01,0.99]));
           imwrite(uint8(NPan*255), imagenaemforPan2);
           clear imagenameforPan;
       end
   end
   clear NPan;
   clear OPan;
end


