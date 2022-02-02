function runEyeTrack(subId,runList)
% run eye tracking preprocessing
%
% Inputs: 
% sn: subject number
% all details to change are specified in the function Settings/Settings_EyeTrack

for run = 1:length(runList)
    
    runNum = runList(run);
    
    %% Print info
    fprintf(['Subject: ',subId, '\n'])
    fprintf('Run: %0.f \n', runNum);
    
    %% setup directories
    root = pwd;
    addpath([root,'/EyeTrack_Functions']) % add EyeTrack_Functions        
    
    %% load in the preprocessing settings
    settings = Settings_EyeTrack(subId);
    
    %% convert the edf file to a mat file (and save)
    edf_name = [settings.dir.raw_filename,num2str(runNum)];
    eye = edf2mat(settings.dir.raw_data_path,edf_name,settings.dir.processed_data_path);
    
    %% preprocess eyetracking data and save file
    eyeData = doEyeTracking(eye,settings);
    
    %% save data
    eyeData.settings = settings; % save settings to eyeData structure
    save([settings.dir.processed_data_path,settings.dir.raw_filename,num2str(runNum),'_EYE_SEG.mat'],'eyeData')
    
    clear eye
    clear eyeData
    
end
    
%% create compiled data
tmp = {};
tmp.runList = runList;

for run = 1:length(runList)
    
    runNum = runList(run);
    load([settings.dir.processed_data_path,settings.dir.raw_filename,num2str(runNum),'_EYE_SEG.mat'])
    
    if run == 1
        
        tmp.sRate = eyeData.sRate;
        tmp.rateAcq = eyeData.rateAcq;
        tmp.settings = eyeData.settings;
        tmp.RecordedEye = eyeData.RecordedEye;
        tmp.trial.times = eyeData.trial.times;
        tmp.trial.timeLockTimes = eyeData.trial.timeLockTimes;
        tmp.trial.startTimes = eyeData.trial.startTimes;
        tmp.trial.endTimes = eyeData.trial.endTimes;
        tmp.trial.xDeg = eyeData.trial.xDeg;
        tmp.trial.yDeg = eyeData.trial.yDeg;
        tmp.trial.pa = eyeData.trial.pa;
        tmp.trial.exist = eyeData.trial.exist;
       
    else
        
        tmp.RecordedEye = [tmp.RecordedEye, eyeData.RecordedEye];
        tmp.trial.timeLockTimes = [tmp.trial.timeLockTimes, eyeData.trial.timeLockTimes];
        tmp.trial.startTimes = [tmp.trial.startTimes, eyeData.trial.startTimes];
        tmp.trial.endTimes = [tmp.trial.endTimes, eyeData.trial.endTimes];
        tmp.trial.xDeg = [tmp.trial.xDeg; eyeData.trial.xDeg];
        tmp.trial.yDeg = [tmp.trial.yDeg; eyeData.trial.yDeg];
        tmp.trial.pa = [tmp.trial.pa; eyeData.trial.pa];
        tmp.trial.exist = [tmp.trial.exist; eyeData.trial.exist];
        
    end
    
    clear eyeData
       
end

eyeData = tmp;
save([settings.dir.processed_data_path,'S',subId,'_EyeTrack.mat'],'eyeData')
clear all;
