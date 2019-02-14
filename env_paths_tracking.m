function paths = env_paths_tracking(varargin)
    paths.net_base = '/home/aia/Matlab/cfnetMaster/pretrained/networks/'; % e.g. '/home/luca/cfnet/networks/';
    paths.eval_set_base = '/home/aia/Matlab/cfnetMaster/data/'; % e.g. '/home/luca/cfnet/data/';
    paths.stats = '/home/aia/Matlab/cfnetMaster/data/cfnet_ILSVRC2015.stats.mat'; % e.g.'/home/luca/cfnet/data/ILSVRC2015.stats.mat';
    paths = vl_argparse(paths, varargin);
end
