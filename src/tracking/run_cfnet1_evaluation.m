%% Sample execution for CFNet-conv1
% hyper-parameters reported in Supp.material for CVPR'17, Table 2 for arXiv version
tracker_par.join.method = 'corrfilt';
tracker_par.net = 'cfnet-conv1_e75.mat';
tracker_par.net_gray = 'cfnet-conv1_gray_e55.mat';
tracker_par.scaleStep = 1.0355;
tracker_par.scalePenalty = 0.9825;
tracker_par.scaleLR = 0.7;
tracker_par.wInfluence = 0.2375;
tracker_par.zLR = 0.0058;
tracker_par.visualization = false;

[~,~,dist,overlap,~,~,~,~,distPerVideo,iouPerVideo] = run_tracker_evaluation('vot2016_iceskater1', tracker_par);
%dist: 41.51	overlap: 44.74	fps: 24.3 stop_on_failure=false
%result for each video saved in resultsCFNetConv1.mat