root = fileparts(mfilename('fullpath'));
addpath(fullfile(root,'2analyze'));
addpath(fullfile(root,'3estimate'));

load(fullfile(root,'patient20_12h.mat'));

beatq = beatq(1:size(feat,1),:);
[co,to,~,fea] = estimateCO_v3(t_on,feat,beatq,5,0);
t = to*60 + time(1); 

%% TCO values
N   = readmatrix(fullfile(root,'s00020-2567-03-30-17-47n.txt'),'Delimiter','\t','NumHeaderLines',2);
ok  = N(:,16) > 0 & N(:,1) <= 12*3600;     % column 16 = CO, column 1 = time [s]
tT  = N(ok,1);
tco = N(ok,16);

%% C2 calibration
idx = t > tT(1)-60 & t <= tT(1);
k = tco(1) / mean(co(idx));
co_cal = k*co;

%% Values of PP, MAP, HR at each TCO time   <-- NEW BLOCK
HR = 60*125./fea(:,7);                      % moved up from the plot section
ppT = nan(size(tco)); mapT = nan(size(tco)); hrT = nan(size(tco));
for i = 1:numel(tT)
    j = t > tT(i)-60 & t <= tT(i);          % minute before each TCO
    ppT(i)  = mean(fea(j,5));
    mapT(i) = mean(fea(j,6));
    hrT(i)  = mean(HR(j));
end

%% Plot
figure
subplot(4,1,1); plot(t/3600,co_cal); hold on; stem(tT/3600,tco,'filled'); ylabel('CO [L/min]')
subplot(4,1,2); plot(t/3600,fea(:,5)); hold on; stem(tT/3600,ppT,'k');  ylabel('PP [mmHg]')   % <-- CHANGED
subplot(4,1,3); plot(t/3600,fea(:,6)); hold on; stem(tT/3600,mapT,'k'); ylabel('MAP [mmHg]')  % <-- CHANGED
subplot(4,1,4); plot(t/3600,HR);       hold on; stem(tT/3600,hrT,'k');  ylabel('HR [bpm]')    % <-- CHANGED
xlabel('Time [hours]')