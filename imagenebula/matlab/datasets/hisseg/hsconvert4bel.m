function hsconvert4bel(target, imtype)
%HSCONVERT4BEL convert datasets to BEL format
%
% HSCONVERT4BEL(TARGET, IMTYPE)
%
% INPUT
%	TARGET	- Target directory
%	IMTYPE	- Image type, 'full', 'region' or (rowpad, colpad)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING, USING OR
% MODIFYING.
%
% By downloading, copying, installing, using or modifying this
% software you agree to this license.  If you do not agree to this
% license, do not download, install, copy, use or modifying this
% software.
% 
% Copyright (C) 2010-2010 Baochuan Pang <babypbc@gmail.com>
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public License
% along with this program.  If not, see
% <http://www.gnu.org/licenses/>.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&

%% Default arguments
if nargin < 1, target = 'E:/Active/segref/BEL/Cell/regiondata'; end
if nargin < 2, imtype = 20; end

%% Target directory
if exist(target, 'dir') ~= 7
	error('HSCONVERT4BEL:TargetDirectoryNotExistError', ...
		'Target directory does not exist!');
end

%% Load image list
for i = 1 : 58
	fprintf('Start Converting %02d/%02d ...', i, 58);
	im = hsreadimage(i, 'ccd', imtype);
	imwrite(im, sprintf('%s/I%05dC.tif', target, i-1));
	im = hsreadimage(i, 'h', imtype);
	imwrite(im, sprintf('%s/I%05d.tif', target, i-1));
	im = hsreadimage(i, 'edge', imtype);
	imwrite(im, sprintf('%s/I%05d_label.tif', target, i-1));
	fprintf('Done!\n');
end

