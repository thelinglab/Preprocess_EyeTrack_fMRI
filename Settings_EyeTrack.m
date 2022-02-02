function settings = Settings_EyeTrack(subId)
% This function specifies the eye tracking settings that the preprocessing
% functions call on. 

fprintf('loading eye tracking settings... \n')

%% Directory information
settings.dir.raw_filename = ['S',subId,'_FBA_CRF_WEDGES_Run']; % name of data file (minus subject number)
settings.dir.raw_data_path = ['/Users/joshuafoster/Foster/Data/FBA_CRF_WEDGES/RawData/',subId,'/']; % where to find eyetracking data
settings.dir.processed_data_path = ['/Users/joshuafoster/Foster/Data/FBA_CRF_WEDGES/CompiledEyeTrack/']; % detination for preprocessed files

%% General setup

% eye tracker settings
settings.sRate = 500; % sampling rate (Hz)
settings.rateAcq = 1000/settings.sRate; % 500 Hz = 2 ms rateAcq

% monitor details
settings.viewDist = 99; % viewing distance (cm)
settings.monitor.xPixels = 1024;
settings.monitor.yPixels = 768;
settings.monitor.ppd = 42; % from FBA_CRF_WEDGES script

settings.blink_pad_length = 50; % (ms) padding of remove samples either side of blink

%% segmentation settings
settings.seg.timeLockMessage = {'TrialStart'}; % message for time locking
settings.seg.preTime = 1000;  % pre-stimulus end of segment, absolute value (ms)
settings.seg.postTime = 4000; % post-stimulus end of segment, absolute value (ms)
%settings.seg.bl_start = -1000; % start of baseline (e.g. -200 for 200 ms pre stimulus)
%settings.seg.bl_end = -500;     % end of basline