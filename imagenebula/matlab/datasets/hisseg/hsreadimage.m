function [im] = hsreadimage(imid, imtype, varargin)
%HSREADIMAGE reads the image specified by IMID and IMTYPE into memory.
%
% [IM] = HSREADIMAGE(IMID, IMTYPE, OPTIONS);
%
% INPUT
%	IMID	- ID of the image, integer value indicating the index of the image;
%		or string indicating the name of the image.
%	IMTYPE	- Type of the image, value should be:
%		'ccd'	image of the original CCD
%		'mmask'	multiple-valued mask, each integer indicating a cell
%		'smask' single-valued mask, 1 indicating the foreground, while 0
%			indicates the background
%		'edge'	an edge mask, 1 indicating the edge pixel, 0 otherwise
%		'masks'	a cell of mask images, each image of which is a mask for a
%			single cell
%	OPTIONS	- Options, including:
%		'full'		default, full image
%		'region'	only the marked region
%		(ROWS, COLS) enlarged region of the marked region, where the ROWS and
%		COLS indicating the number of rows and columns that should be enlarged
%		in each side of the region.
%
% OUTPUT
%  IM		- Image or cell of images read from the data directory
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
if nargin < 2, imtype = 'ccd'; end;
if nargin < 3, varargin = {'full'}; end;

%% Load image list
imagelist = hsimagelist();

%% Find the file id
if ischar(imid)
	for i = 1 : numel(imagelist)
		if strcmpi(imid, imagelist(i).name)
			imid = i;
			break;
		end
	end
	
	if ~isnumeric(imid)
		error('HSREADIMAGE:FileNotFoundError', 'Find not found!');
	end
end

%% Check file id
if (imid < 1) || (imid > numel(imagelist))
	error('HSREADIMAGE:FileIdOutOfRangeError', 'File ID out of range!');
end

%% Load image
if strcmpi(imtype, 'ccd')
	% original image
	filename = strcat(imagelist(imid).fullpath, '_ccd.tif');
	im = imread(filename);
	
elseif strcmpi(imtype, 'masks')
	% cell of masks, each image of which is a binary mask for a single cell
	filename = strcat(imagelist(imid).fullpath, '.mat');
	data = load(filename);
	nim = numel(data.tmp);
	im = cell(1, nim);
	for i = 1 : nim
		im{i} = data.tmp(i).BW;
	end
	
elseif strcmpi(imtype, 'mmask')
	% multiple-valued masks, each integer corresponds to a single cell, 0
	% indicating the background and the unmarked region
	filename = strcat(imagelist(imid).fullpath, '.mat');
	data = load(filename);
	nim = numel(data.tmp);
	im = zeros(size(data.tmp(1).BW));
	for i = 1 : nim
		im(data.tmp(i).BW) = i;
	end
	
elseif strcmpi(imtype, 'smask')
	% multiple-valued masks, each integer corresponds to a single cell, 0
	% indicating the background and the unmarked region
	filename = strcat(imagelist(imid).fullpath, '.mat');
	data = load(filename);
	nim = numel(data.tmp);
	im = zeros(size(data.tmp(1).BW));
	for i = 1 : nim
		im(data.tmp(i).BW) = 1;
	end
	
elseif strcmpi(imtype, 'edge')
	% edge map
	filename = strcat(imagelist(imid).fullpath, '.mat');
	data = load(filename);
	nim = numel(data.tmp);
	im = zeros(size(data.tmp(1).BW));
	for i = 1 : nim
		b = bwboundaries(data.tmp(i).BW, 8, 'noholes');
		for j = 1 : numel(b)
			ind = sub2ind(size(data.tmp(1).BW), b{j}(:, 1), b{j}(:, 2));
			im(ind) = 1;
		end
	end	
end

%% Regions
varargin = varargin{1};
if isnumeric(varargin)
	if numel(varargin) ~= 2 && numel(varargin) ~= 1
		error('HSREADIMAGE:SizeError', 'The enlarge size should be 1-D or 2-D!');
	end
	
	if numel(varargin) == 1
		padr = varargin;
		padc = varargin;
	else
		padr = varargin(1);
		padc = varargin(2);
	end
	
	filename = strcat(imagelist(imid).fullpath, '.mat');
	data = load(filename);
	mask = data.TM;
	[nr, nc] = size(data.TM);
	[rs, cs] = find(mask > 0);
	minr = min(rs); maxr = max(rs);
	minc = min(cs); maxc = max(cs);
	minr = max(1, minr - padr); maxr = min(nr, maxr + padr);
	minc = max(1, minc - padc); maxc = min(nc, maxc + padc);
	
	im = im(minr : maxr, minc : maxc, :);
elseif ischar(varargin)
		filename = strcat(imagelist(imid).fullpath, '.mat');
		data = load(filename);
		mask = data.TM;
		[rs, cs] = find(mask > 0);
		minr = min(rs); maxr = max(rs);
		minc = min(cs); maxc = max(cs);
		im = im(minr : maxr, minc : maxc, :);		
	end
end
