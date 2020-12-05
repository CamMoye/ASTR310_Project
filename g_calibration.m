%% NGC520 in the Sloan-g' filter 
    % Observation made by Emily Whittaker and Alison Duck
        %Date: Oct 13, 2018 from 8:30pm to 1:45pm
% Read in bias files
grbias1 = rfits('calib-001-bi.fit');
grbias2 = rfits('calib-002-bi.fit');
grbias3 = rfits('calib-003-bi.fit');
grbias4 = rfits('calib-004-bi.fit');
grbias5 = rfits('calib-005-bi.fit');
grbias6 = rfits('calib-006-bi.fit');
grbias7 = rfits('calib-007-bi.fit');

% Create MASTER BIAS
Mbias = cat(3,grbias1.data,grbias2.data,grbias3.data,grbias4.data,grbias5.data,grbias6.data,grbias7.data);
Mbias1 = median(Mbias,3);

% Read in dark files and subtract master bias
grdark1 = rfits('calib-001-d.fit');
grdark2 = rfits('calib-002-d.fit');
grdark3 = rfits('calib-003-d.fit');
grdark4 = rfits('calib-004-d.fit');
grdark5 = rfits('calib-005-d.fit');
grdark6 = rfits('calib-006-d.fit');
grdark7 = rfits('calib-007-d.fit');

% Sutract darks from bias
db1 = grdark1.data - Mbias1;
db2 = grdark2.data - Mbias1;
db3 = grdark3.data - Mbias1;
db4 = grdark4.data - Mbias1;
db5 = grdark5.data - Mbias1;
db6 = grdark6.data - Mbias1;
db7 = grdark7.data - Mbias1;
% Create MASTER dark
Mdark = cat(3,db1,db2,db3,db4,db5,db6,db7);
Mdark1 = median(Mdark,3);
%10 sec master dark
M10dark = Mdark1./30;

% Read in flats in the Sloan-g' filter
grflats1 = rfits('flat-001-g.fit');
grflats2 = rfits('flat-002-g.fit');
grflats3 = rfits('flat-003-g.fit');
grflats4 = rfits('flat-004-g.fit');
grflats5 = rfits('flat-005-g.fit');
grflats6 = rfits('flat-006-g.fit');
grflats7 = rfits('flat-007-g.fit');

% Subtract master bias and subtract 10 second Master dark
A1 = grflats1.data - Mbias1 - M10dark;
A2 = grflats2.data - Mbias1 - M10dark;
A3 = grflats3.data - Mbias1 - M10dark;
A4 = grflats4.data - Mbias1 - M10dark;
A5 = grflats5.data - Mbias1 - M10dark;
A6 = grflats6.data - Mbias1 - M10dark;
A7 = grflats7.data - Mbias1 - M10dark;
% Create MASTER flat
Mflat = cat(3,A1,A2,A3,A4,A5,A6,A7);
Mflat1 = median(Mflat,3);

% Normalizing Flat
NFlat = Mflat1/mode(Mflat1);

% Read in uncalibrated Sloan-g' filter for NGC520
gr1 = rfits('NGC520-001-g.fit');
gr2 = rfits('NGC520-002-g.fit');
gr3 = rfits('NGC520-003-g.fit');
gr4 = rfits('NGC520-004-g.fit');
gr5 = rfits('NGC520-005-g.fit');
gr6 = rfits('NGC520-006-g.fit');
gr7 = rfits('NGC520-007-g.fit');

% Calibrated science image 
% Science image - master bias
B1 = (gr1.data - Mbias1 - Mdark1)./NFlat;
B2 = (gr2.data - Mbias1 - Mdark1)./NFlat;
B3 = (gr3.data - Mbias1 - Mdark1)./NFlat;
B4 = (gr4.data - Mbias1 - Mdark1)./NFlat;
B5 = (gr5.data - Mbias1 - Mdark1)./NFlat;
B6 = (gr6.data - Mbias1 - Mdark1)./NFlat;
B7 = (gr7.data - Mbias1 - Mdark1)./NFlat;

% write each image as a .fits file
fitswrite(B1.','B1.fits')
fitswrite(B2.','B2.fits')
fitswrite(B3.','B3.fits')
fitswrite(B4.','B4.fits')
fitswrite(B5.','B5.fits')
fitswrite(B6.','B6.fits')
fitswrite(B7.','B7.fits')
% Remove number 4 since the comparison star is basically invisible
%shift images  to align with a star in the lower left corner.
G1 = imshift(B1, -24,-27);
G2 = imshift(B2,-20,-27);
G3 = imshift(B3,-14,-24);
G5 = imshift(B5, -3,0);
G7 = imshift (B7, 4,3);
% Co-add images 
G_NGC520 = G1+ G2+ G3 +G5 +B6 +G7;
%Remove Cosmic Rays
med = median(G_NGC520(:));
G_NGC520(G_NGC520>= 3900) = med;

%539- 544(X)
%320-357 (Y)
G_NGC520(320:357,539:544) = med;

%Image crop
CropGalG = imcrop(G_NGC520,[275 10 568 1490]);
%Remove dark spots
CropGalG(680:706,291:313) = CropGalG(706:732,313:335); 
CropGalG(663:687,265:283) = CropGalG(687:711,283:301);
%Write final calibrated G' image to a .fits file
fitswrite(CropGalG.','G_NGC520.fits');
