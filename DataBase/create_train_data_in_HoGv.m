clear all;
clc;
%Read data
sBasePath = 'C:\DataBase\GTSRB\GTSRB\Final_Training\Images'; 
train_data = [];

for nNumFolder = 0:42
    sFolder = num2str(nNumFolder, '%05d');
    
    sPath = [sBasePath, '\', sFolder, '\'];
    
    eval(['data_',num2str(nNumFolder),' = [];']);
    if isfolder(sPath)
        [ImgFiles, Rois, Classes] = readSignData([sPath, '\GT-', num2str(nNumFolder, '%05d'), '.csv']);
        eval(['data_',num2str(nNumFolder),' = zeros(2500+1,numel(ImgFiles));']);
        for i = 1:numel(ImgFiles)
            ImgFile = [sPath, '\', ImgFiles{i}];
            Img = imread(ImgFile);
            
            %fprintf(1, 'Currently training: %s Class: %d Sample: %d / %d\n', ImgFiles{i}, Classes(i), i, numel(ImgFiles));
            
            % TODO!
            % if you want to work with a border around the traffic sign
            % comment the following line
            Img = Img(Rois(i, 2) + 1:Rois(i, 4) + 1, Rois(i, 1) + 1:Rois(i, 3) + 1, :);

            feature = HoGv(Img);            
            eval(['data_',num2str(nNumFolder),'(:,i) = [double(Classes(i));feature];']);

             
            
        end
        
    end
        
end
for nNumFolder = 0:42
    train_data = [train_data,eval(['data_',num2str(nNumFolder)])];
    clear eval(['data_',num2str(nNumFolder)]);
end
train_data=train_data';

save ../train_HoGv train_data