root = fileparts(mfilename('fullpath'));      % folder that contains dataextract.m
addpath(fullfile(root,'2analyze'));           % wabp, abpfeature, jSQI
addpath(fullfile(root,'3estimate'));          % est05_Lilj and the other estimators

data = readmatrix('s00020-2567-03-30-17-47_ABP.txt');
time = data(:,1);
abp = data(:,2);
keepdata = time<= 12*3600;
timeProcessed = time(keepdata);
abpProcessed = abp(keepdata);

t_on = wabp(abpProcessed);
feat = abpfeature(abpProcessed,t_on);
[beatq, goodfrac] = jSQI(feat, t_on, abpProcessed);

save(fullfile(root,'patient20_12h.mat'),'timeProcessed','abpProcessed','t_on','feat','beatq','goodfrac');

