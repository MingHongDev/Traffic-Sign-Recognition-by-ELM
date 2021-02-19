function Orient_Hist=HoGv(img)
%cell_size=6
stride=6;

%%  A. Image Preprocessing
img=double(rgb2gray(img)); 
img = imresize(img, [48 48], 'bilinear');
%remove margin
img(1:5,:)=0;
img(44:48,:)=0;
img(:,1:5)=0;
img(:,44:48)=0;

img=img.^0.5;              %gamma r=0.5

%% B. Gradient Accumalation
aug_img=[img(1,1),img(1,:),img(1,48);
         img(:,1),   img,  img(:,48);
        img(48,1),img(48,:),img(48,48)]; 
%Extent img in order to compute the gradient nearby the margin.

Magnitude=zeros(48,48);
Theta_C=zeros(48,48); %C(p,q): 0~180, 7  bins
Theta_D=zeros(48,48); %D(p,q): 0~360, 14 bins
for i=2:48+1
    for j=2:48+1
        Gx=aug_img(i+1,j)-aug_img(i-1,j);
        Gy=aug_img(i,j+1)-aug_img(i,j-1);
       temp=Gx;
        Gx=Gy;
        Gy=temp;
        
        Magnitude(i-1,j-1)=abs(Gx)+abs(Gy);
        Theta_C(i-1,j-1)=atan(Gy/(Gx+eps))/pi*180+(Gy*(Gx+eps)<0)*180;%no sign ,[0 180]
        Theta_D(i-1,j-1)=atan(Gy/(Gx+eps))/pi*180+((Gy>0)*((Gx+eps)<0))*180+((Gy<0)*((Gx+eps)<0))*180+((Gy<0)*((Gx+eps)>0))*360; %sign ,[0 360] 
    end
end


% B.2: Define hist of C&D



Hist_C_cell=cell(1,1); Hist_D_cell=cell(1,1); %histogram of orietiation
Cell_row=1; Cell_col=1; 

for i = 1:stride:48 
    for j=1:stride:48
    
         Theta_C_flatten=Theta_C(i:i+5,j:j+5);
         Theta_D_flatten=Theta_D(i:i+5,j:j+5);
         Magnitude_flatten=Magnitude(i:i+5,j:j+5);
         
         Hist_C=zeros(1,7);
         Hist_D=zeros(1,14);
         for z=1:36
               index=floor(Theta_C_flatten(z)/26)+1; %0~180,7bins 
               Hist_C(index)=Hist_C(index)+Magnitude_flatten(z);
           
               index=floor(Theta_D_flatten(z)/26)+1; %0~360,14 bins
               Hist_D(index)=Hist_D(index)+Magnitude_flatten(z);
         end
         Hist_C_cell{Cell_row,Cell_col}=Hist_C;
         Hist_D_cell{Cell_row,Cell_col}=Hist_D;
         Cell_col=Cell_col+1; 
    end
         Cell_col=1;
         Cell_row=Cell_row+1; 
end



%% C. Normalization
%Extent the martrix in order to normalize it nearby the margin.

aug_Hist_C_cell=[Hist_C_cell(1,1),Hist_C_cell(1,:),Hist_C_cell(1,8);
                 Hist_C_cell(:,1),Hist_C_cell,Hist_C_cell(:,8);
                 Hist_C_cell(8,1),Hist_C_cell(8,:),Hist_C_cell(8,8)];
             
aug_Hist_D_cell=[Hist_D_cell(1,1),Hist_D_cell(1,:),Hist_D_cell(1,8);
                 Hist_D_cell(:,1),Hist_D_cell,Hist_D_cell(:,8);
                 Hist_D_cell(8,1),Hist_D_cell(8,:),Hist_D_cell(8,8)];

             
F=zeros(4,21);
F_pointer=zeros(64,25);
Orient_Hist=zeros(2500,1);

itera=0;
for Cell_row=2:9
    for Cell_col=2:9
        
        itera=itera+1;
        %NC/ND -1,-1
        x=aug_Hist_C_cell{Cell_row,Cell_col}.^2 + aug_Hist_C_cell{Cell_row-1,Cell_col}.^2 + aug_Hist_C_cell{Cell_row,Cell_col-1}.^2 +aug_Hist_C_cell{Cell_row-1,Cell_col-1}.^2;
        y=aug_Hist_D_cell{Cell_row,Cell_col}.^2 + aug_Hist_D_cell{Cell_row-1,Cell_col}.^2 + aug_Hist_D_cell{Cell_row,Cell_col-1}.^2 +aug_Hist_D_cell{Cell_row-1,Cell_col-1}.^2;
        x=sum(x)^0.5; y=sum(y)^0.5;
        F(1,:) = [Hist_C_cell{Cell_row-1,Cell_col-1}./(x+eps) , Hist_D_cell{Cell_row-1,Cell_col-1}./(y+eps)];
        %NC/ND +1,-1
        x=aug_Hist_C_cell{Cell_row,Cell_col}.^2 + aug_Hist_C_cell{Cell_row+1,Cell_col}.^2 + aug_Hist_C_cell{Cell_row,Cell_col-1}.^2 +aug_Hist_C_cell{Cell_row+1,Cell_col-1}.^2;
        y=aug_Hist_D_cell{Cell_row,Cell_col}.^2 + aug_Hist_D_cell{Cell_row+1,Cell_col}.^2 + aug_Hist_D_cell{Cell_row,Cell_col-1}.^2 +aug_Hist_D_cell{Cell_row+1,Cell_col-1}.^2;
        x=sum(x)^0.5; y=sum(y)^0.5;
        %NC/ND +1,+1
        x=aug_Hist_C_cell{Cell_row,Cell_col}.^2 + aug_Hist_C_cell{Cell_row+1,Cell_col}.^2 + aug_Hist_C_cell{Cell_row,Cell_col+1}.^2 +aug_Hist_C_cell{Cell_row+1,Cell_col+1}.^2;
        y=aug_Hist_D_cell{Cell_row,Cell_col}.^2 + aug_Hist_D_cell{Cell_row+1,Cell_col}.^2 + aug_Hist_D_cell{Cell_row,Cell_col+1}.^2 +aug_Hist_D_cell{Cell_row+1,Cell_col+1}.^2;
        x=sum(x)^0.5; y=sum(y)^0.5;
        F(3,:) = [Hist_C_cell{Cell_row-1,Cell_col-1}./(x+eps) , Hist_D_cell{Cell_row-1,Cell_col-1}./(y+eps)];
        %NC/ND -1,+1
        x=aug_Hist_C_cell{Cell_row,Cell_col}.^2 + aug_Hist_C_cell{Cell_row-1,Cell_col}.^2 + aug_Hist_C_cell{Cell_row,Cell_col+1}.^2 +aug_Hist_C_cell{Cell_row-1,Cell_col+1}.^2;
        y=aug_Hist_D_cell{Cell_row,Cell_col}.^2 + aug_Hist_D_cell{Cell_row-1,Cell_col}.^2 + aug_Hist_D_cell{Cell_row,Cell_col+1}.^2 +aug_Hist_D_cell{Cell_row-1,Cell_col+1}.^2;
        x=sum(x)^0.5; y=sum(y)^0.5;
        F(4,:) = [Hist_C_cell{Cell_row-1,Cell_col-1}./(x+eps) , Hist_D_cell{Cell_row-1,Cell_col-1}./(y+eps)];
        
%% D.Dimensionality Reduction      
        F_pointer(itera,:)=[F(1,:)+F(2,:)+F(3,:)+F(4,:),sum(F(1,:)),sum(F(2,:)),sum(F(3,:)),sum(F(4,:))];
   
    end
end
F_pointer=[F_pointer(10:15,:); F_pointer(18:23,:); F_pointer(26:31,:); F_pointer(34:39,:);F_pointer(42:47,:);F_pointer(50:55,:)];  

%% E. Concatenation
for i=1:5
    for j=1:5
        index=j+6*(i-1);
        Orient_Hist((i-1)*500+(j-1)*100+1:(i-1)*500+(j-1)*100+100,1)=[F_pointer(index,:) ,F_pointer(index+1,:) , F_pointer(index+6,:) , F_pointer(index+7,:)];
    end
end



end
