function patch_list = crop_img(img, crop_size, crop_gap)
    OMS = img;
    SoM = crop_size;
    crop_gap = 
    if length(size(img))==3
        [size1, size2, ~] = size(img);
    elseif length(size(img))==2
        [size1, size2]= size(img);
    end
    t1 = 1;
    for i=1:SoM:size1-SoM
       for j=1:SoM:size2-SoM
           NMS=OMS(i:i+SoM-1,j:j+SoM-1,:);
           ct=num2str(t1);
           imagenameforMS=strcat(OimagenameforMS,ct);
           t1=t1+1;
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
           %����8λͼƬ
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
   
   t2=1
   [size3,size4]=size(OPan);
   for i=1:SoP:size3-SoP
       for j=1:SoP:size4-SoP
           NPan=OPan(i:i+SoP-1,j:j+SoP-1);
           ct=num2str(t2);
           imagenameforPan=strcat(OimagenameforPan,ct);
           t2=t2+1;
           imagenameforPan=strcat(imagenameforPan,'.npy');
           if (max(max(NPan))>255)
%                imwrite(uint16(NPan),imagenameforPan);
               writeNPY(uint16(NPan),imagenameforPan);
           else
               imwrite(uint8(NPan),imagenameforPan);
           end
           clear imagenameforPan;
       end
   end
   clear NPan;
   clear OPan;

end