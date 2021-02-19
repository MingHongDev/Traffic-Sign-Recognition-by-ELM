clear all;
clc;
sBasePath = 'C:\DataBase\GTSRB\GTSRB\Final_Test\Images'; 

[ImgFiles, Rois, Classes] = readSignData([sBasePath, '\GT-final_test.csv']);

ResultFile = [sBasePath, '\classification_results.csv'];

test_data=zeros(2500+1,numel(ImgFiles));
try
    for i = 1:numel(ImgFiles)
        ImgFile = [sBasePath, '\', ImgFiles{i}];
        Img = imread(ImgFile);

        fprintf(1, 'Currently classifying: %s Sample: %d / %d\n', ImgFiles{i}, i, numel(ImgFiles));

        % TODO!
        % if you want to work with a border around the traffic sign
        % comment the following line
        Img = Img(Rois(i, 2) + 1:Rois(i, 4) + 1, Rois(i, 1) + 1:Rois(i, 3) + 1, :);

        
        feature = HoGv(Img);        
        test_data(:,i) = [double(Classes(i)) ; feature];
    end
catch ME
    getReport(ME)
end


test_data=test_data';

save ../test_HoGv test_data