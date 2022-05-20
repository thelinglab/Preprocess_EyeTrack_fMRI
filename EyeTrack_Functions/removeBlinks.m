function [x_clean, y_clean, p_clean] = removeBlinks(x,y,p,settings)
% remove blinks from time series by setting blink periods to nans
% inputs:
% x = time series of x-coords
% y = time series of y-coords
% p = time series of pupil values
% settings struct:
% settings.blink_pad_length (in ms) determines how many samples to remove either side of a blink
% settings.rateAcq for conversion of padding to samples
% settings.xPixels and settings.yPixels for identifying periods where eye
% position falls outside the display
%
% outputs:
% time-series with blink periods set to nans
%
% Joshua Foster
% 01/28/2022

pad_length = settings.blink_pad_length/settings.rateAcq;

x_clean = x; y_clean = y; p_clean = p;
nSamps = length(x_clean);

for i = pad_length+1:nSamps-pad_length
    
    samp_idx = i-pad_length:1:i+pad_length;
    xsamps = x(samp_idx);
    ysamps = y(samp_idx);
    
    if max(abs(xsamps)) > settings.monitor.xPixels || max(abs(ysamps)) > settings.monitor.yPixels
       x_clean(samp_idx) = nan;
       y_clean(samp_idx) = nan;
       p_clean(samp_idx) = nan;
    end
 
end
