%% Aperture Photometry on the Sloan-r' Image
%Reads in the co-added final calibrated science image
rim=rfits('rcoaddfinal.fit');

%Rotates the image in order for the object to be oriented straight up and
%down for higher accuracy apertures and crops it to the same size as the
%original image
rimturn=imrotate(rim.data,30,'crop');

%Defines a variable for the gain of the CCD
gain=2.5999999046325684;

%Runs the aperE function, which determines the flux and error in the flux
%from the specified apertures and adds a title and axes titles to the
%resultant image
figure(1)
[rflx,rerr]=aperE(rimturn,568,806,73,137,165,192,180,220,1/gain);
title('Sloan-r\prime Apertures')
xlabel('Pixel Number')
ylabel('Pixel Number')

%% Aperture Photometry on the Sloan-g' Image
%Reads in the co-added final calibrated science image
gim=rfits('gfinal.fits');

%Rotates the image in order for the object to be oriented straight up and
%down for higher accuracy apertures and crops it to the same size as the
%original image
gimturn=imrotate(gim.data,30,'crop');

%Runs the aperE function, which determines the flux and error in the flux
%from the specified apertures and adds a title and axes titles to the
%resultant image
figure(2)
[gflx,gerr]=aperE(gimturn,237,595,34,80,49,85,69,95,1/gain);
title('Sloan-g\prime Apertures')
xlabel('Pixel Number')
ylabel('Pixel Number')