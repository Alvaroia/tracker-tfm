%% Sample execution for Baseline-conv5 (improved Siam-FC)
% hyper-parameters reported in Supp.material for CVPR'17, Table 2 for arXiv version
clear variables; close all;
tracker_par.join.method = 'xcorr';
tracker_par.net = 'baseline-conv5_e55.mat';
tracker_par.net_gray = 'baseline-conv5_gray_e100.mat';
tracker_par.scaleStep = 1.0470;
tracker_par.scalePenalty = 0.9825;
tracker_par.scaleLR = 0.68;
tracker_par.wInfluence = 0.175;
tracker_par.zLR = 0.0102;
tracker_par.visualization = false;
tracker_par.debug = false;
try
    [~,~,dist,overlap,~,~,~,~,distPerVideo,iouPerVideo] = run_tracker_evaluation('all', tracker_par);
    reset(gpuDevice);
    gpuDevice([]);
%     find(cell2mat(result(:,2)) > 90)
%     result{ans,1}
catch Err1
    try
        reset(gpuDevice);
        disp 'GPU reset';
        gpuDevice([]);
        disp 'GPU free now';
        rethrow(Err1);
    catch
        gpuDevice([]);
        rethrow(Err1);
    end
end