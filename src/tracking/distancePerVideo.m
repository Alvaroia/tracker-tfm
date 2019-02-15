function [videoDistance, videoIOU] = distancePerVideo(dist_fun, IOU_fun, videoBoxes,videoGroundThruth)
%alv
applyToGivenRow = @(func, matrix1, matrix2) @(row) func(matrix1(row, :), matrix2(row, :));
applyToRows = @(func, matrix1, matrix2) arrayfun(applyToGivenRow(func, matrix1, matrix2), 1:size(matrix1,1))';
videoDistance = applyToRows(dist_fun, videoBoxes, videoGroundThruth);
videoIOU = applyToRows(IOU_fun, videoBoxes, videoGroundThruth);

end