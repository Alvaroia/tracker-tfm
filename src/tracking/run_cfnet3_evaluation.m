%% Sample execution for Baseline on CFNet-conv3
% hyper-parameters reported in Supp.material for CVPR'17, Table 2 for arXiv version
tracker_par.join.method = 'corrfilt';
tracker_par.net = 'baseline-conv3-on-cfnet-conv3_e100.mat';
tracker_par.net_gray = 'baseline-conv3-on-cfnet-conv3_gray_e70.mat';
tracker_par.scaleStep = 1.034;
tracker_par.scalePenalty = 0.9820;
tracker_par.scaleLR = 0.66;
tracker_par.wInfluence = 0.27;
tracker_par.zLR = 0.008;

[~,~,dist,overlap,~,~,~,~,distPerVideo, iouPerVideo] = run_tracker_evaluation('all', tracker_par);
resultsCFNetConv3 = [distPerVideo iouPerVideo];
% dist: 45.00	overlap: 42.17	fps: 30.9 (stop_on_failure=false)