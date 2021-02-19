clear all;clc;

Train=1;

if Train
    [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM_classifier('.\DataBase\train_HoGv.mat', '.\DataBase\test_Hogv.mat', 1, 10000, 'sig');
else
    Img=imread('C:\DataBase\GTSRB\GTSRB\Final_Training\Images\00004\00000_00013.ppm');
    Rois=[5,5,48,48];
    Img = Img(Rois(2) + 1:Rois(4) + 1, Rois(1) + 1:Rois(3) + 1, :);
    imshow(Img,[]);
    Predicted_class=ELM_inference(HoGv(Img),'.\Weighting\TSR_GTSRB.mat');
end