%% Sloan-r' Image Calibration
%Reading in Files for Calibrating Images
r1=rfits('NGC520-001-r.fit');
r2=rfits('NGC520-002-r.fit');
r3=rfits('NGC520-003-r.fit');
r4=rfits('NGC520-004-r.fit');
r5=rfits('NGC520-005-r.fit');
r6=rfits('NGC520-006-r.fit');
r7=rfits('NGC520-007-r.fit');
r8=rfits('NGC520-008-r.fit');
r9=rfits('NGC520-009-r.fit');
rflat1=rfits('calib-001-flat-r.fit');
rflat2=rfits('calib-002-flat-r.fit');
rflat3=rfits('calib-003-flat-r.fit');
rflat4=rfits('calib-004-flat-r.fit');
rflat5=rfits('calib-005-flat-r.fit');
rflat6=rfits('calib-006-flat-r.fit');
rflat7=rfits('calib-007-flat-r.fit');
rflat8=rfits('calib-008-flat-r.fit');
rflat9=rfits('calib-009-flat-r.fit');
rdark031=rfits('calib-001-dark03.fit');
rdark032=rfits('calib-002-dark03.fit');
rdark033=rfits('calib-003-dark03.fit');
rdark034=rfits('calib-004-dark03.fit');
rdark035=rfits('calib-005-dark03.fit');
rdark036=rfits('calib-006-dark03.fit');
rdark037=rfits('calib-007-dark03.fit');
rdark038=rfits('calib-008-dark03.fit');
rdark039=rfits('calib-009-dark03.fit');
rdark1=rfits('calib-001-dark.fit');
rdark2=rfits('calib-002-dark.fit');
rdark3=rfits('calib-003-dark.fit');
rdark4=rfits('calib-004-dark.fit');
rdark5=rfits('calib-005-dark.fit');
rdark6=rfits('calib-006-dark.fit');
rdark7=rfits('calib-007-dark.fit');

%Darks

%Concatonating the 300s darks
catdark=cat(3,rdark1.data,rdark2.data,rdark3.data,rdark4.data,rdark5.data,rdark6.data,rdark7.data);
%Pixel-by-pixel median combining the 300s darks to create a master 300s
%dark
mstr300dark=median(catdark,3);

%Concatenating the 3s darks
catdark03=cat(3,rdark031.data,rdark032.data,rdark033.data,rdark034.data,rdark035.data,rdark036.data,rdark037.data,rdark038.data,rdark039.data);
%Pixel-by-pixel median combining the 3s darks to create a master 3s dark
mstr3dark=median(catdark03,3);

%Flats
%Subtracting the 3s darks from each 3s r' filter flat
arflat1=rflat1.data-mstr3dark;
arflat2=rflat2.data-mstr3dark;
arflat3=rflat3.data-mstr3dark;
arflat4=rflat4.data-mstr3dark;
arflat5=rflat5.data-mstr3dark;
arflat6=rflat6.data-mstr3dark;
arflat7=rflat7.data-mstr3dark;
arflat8=rflat8.data-mstr3dark;
arflat9=rflat9.data-mstr3dark;
%Concatenating the dark-subtracted r' flats
catrflat=cat(3,arflat1,arflat2,arflat3,arflat4,arflat5,arflat6,arflat7,arflat8,arflat9);
%Pixel-by-pixel median combining the flat fields to create a master flat
%for the r' filter
mstrrflat=median(catrflat,3);
%Normalizing the master r' flat using the mode of the master r' flat
normrflat=mstrrflat./(mode(mstrrflat(:)));

%Science Images
%Subtracting the 300s darks from the science images
ar1=r1.data-mstr300dark;
ar2=r2.data-mstr300dark;
ar3=r3.data-mstr300dark;
ar4=r4.data-mstr300dark;
ar5=r5.data-mstr300dark;
ar6=r6.data-mstr300dark;
ar7=r7.data-mstr300dark;
ar8=r8.data-mstr300dark;
ar9=r9.data-mstr300dark;

%Divides the dark-subtracted science images by the normalized r' flat
r1cal=ar1./normrflat;
r2cal=ar2./normrflat;
r3cal=ar3./normrflat;
r4cal=ar4./normrflat;
r5cal=ar5./normrflat;
r6cal=ar6./normrflat;
r7cal=ar7./normrflat;
r8cal=ar8./normrflat;
r9cal=ar9./normrflat;

%Exports the calibrated images as .fit files
fitswrite(r1cal.','r1cal.fit');
fitswrite(r2cal.','r2cal.fit');
fitswrite(r3cal.','r3cal.fit');
fitswrite(r4cal.','r4cal.fit');
fitswrite(r5cal.','r5cal.fit');
fitswrite(r6cal.','r6cal.fit');
fitswrite(r7cal.','r7cal.fit');
fitswrite(r8cal.','r8cal.fit');
fitswrite(r9cal.','r9cal.fit');

%r4cal, r8cal, and r9cal are excluded from the following steps as they are
%bad images

%Shifting images in order for them to accurately co-add
r2shift=imshift(r2cal,-4,1);
r3shift=imshift(r3cal,-6,0);
r5shift=imshift(r5cal,-29,-34);
r6shift=imshift(r6cal,-33,-34);
r7shift=imshift(r7cal,-35,-42);

%Co-adding the images and writing the final image as a .fit file
rcoadd=r1cal+r2shift+r3shift+r5shift+r6shift+r7shift;
fitswrite(rcoadd.','rcoadd.fit');