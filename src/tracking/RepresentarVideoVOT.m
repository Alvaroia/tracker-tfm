%% Representar video y groundtruth
clear variables; close all;
videoName = "handball1";
videoPath = "/home/aia/Matlab/cfnetMaster/data/validation/vot2016_";
gtPath = "/home/aia/Downloads/vot17/SiamFC/baseline/"+videoName+"/";
trackerResults = fopen(gtPath+videoName+"_001.txt",'r');
frames  = dir(videoPath+videoName+"/*.jpg");
nImgs = numel(frames);
figure(1);
for i = 1:nImgs
    coordinates = fgetl(trackerResults);
    boundingBox = cell2mat(textscan(coordinates,"%f", 'Delimiter', ","));
    ima = imread(videoPath+videoName+"/"+frames(i).name);
    if length(boundingBox)==8
        ima = insertShape(ima, 'Polygon', boundingBox', 'LineWidth', 1, 'Color', 'green');
    elseif length(boundingBox)==4
        ima = insertShape(ima, 'Rectangle', boundingBox', 'LineWidth', 1, 'Color', 'green');
    end
    figure(1);imshow(ima);
    pause(0.05);
    ima = [];
end