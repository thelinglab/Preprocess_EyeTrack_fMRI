function eyeData = doEyeTracking(eye,settings)
% preprocess the eye tracking data.
%
% Inputs:
% eye: eye structure with all eye tracking data
% settings: settings structure with eye tracking settings specified


%% Grab the relevant data from the eye stucture

% sampling rate
eyeData.sRate = getSamplingRate(eye);
eyeData.rateAcq = 1000./eyeData.sRate; % calculate rate of data acquisition (ms)

% check the specified sampling rate is correct
if settings.sRate ~= eyeData.sRate
    error('specified sampling rate does not match data file.')
end

% message and codestrings
eyeData.messages = {eye.FEVENT(:).message}; % grab messages sent from PsychToolbox
eyeData.codestrings = {eye.FEVENT(:).codestring}; % grab codestrings (includes STARTSACC,ENDSACC,STARTFIX,ENDFIX,STARTBLINK,ENDBLINK among other things)
eyeData.eventTimes = [eye.FEVENT(:).sttime]; % when events occured

% which eye was recorded on each trial
RecordedEyeVec = [eye.RECORDINGS(:).('eye')]; % the eye that was tracked (left or right)
RecordedEyeIdx = [1:2:length(RecordedEyeVec)]; % RECORDINGS taken at start and end of each trial, only grab the starts (i.e. odd entries)
eyeData.RecordedEye=RecordedEyeVec(RecordedEyeIdx);

% eye tracking data
eyeData.sampleTimes = [eye.FSAMPLE(:).time]; % the times at which data was sampled
eyeData.gx = eye.FSAMPLE(:).gx(eyeData.RecordedEye,:); % head referenced x coords
eyeData.gy = eye.FSAMPLE(:).gy(eyeData.RecordedEye,:); % head referenced y coords
eyeData.pa = eye.FSAMPLE(:).pa(eyeData.RecordedEye,:); % head referenced pupil size / area

% remove blinks
[eyeData.gx_cleaned, eyeData.gy_cleaned, eyeData.pa_cleaned] = removeBlinks(eyeData.gx,eyeData.gy,eyeData.pa,settings);

% calculate eye position in degrees of visual angle
eyeData.xDeg = (eyeData.gx_cleaned-settings.monitor.xPixels/2)/settings.monitor.ppd;
eyeData.yDeg = (eyeData.gy_cleaned-settings.monitor.yPixels/2)/settings.monitor.ppd;

% Segment data
eyeData.trial = segment_eyetracking(eyeData,settings); 