function [map, textons] = textonscompute(fim, k, d)
% TEXTONSCOMPUTE Compute textons of a given image.
% [MAP, TEXTONS] = TEXTONSCOMPUTE(FIM, K, D)
%
% Compute textons of a given image by clustering image pixels into K groups 
% (textons) using the k-means algorithm. FIM is the image features of each
% pixel.
%
% INPUTS
%	FIM	- Matrix representing pixel features, the first two dimensions
%       is the height and width of the image, and the rest dimensions are
%       feature indcies.
%   K   - Number of textons.    
%   [D] - Dimension of the image. Default is 2, which means the first two
%       dimensions index the image, while the rest dimensions index
%       features.
%
% OUTPUTS
%	MAP	- Texton map of the image. The size of MAP is (HEIGHT * WIDTH),
%       with each element indicating the texton index of the corresponding
%       pixel.
%   TEXTONS     - K-means centers of the group, indicating the
%       representative feature vector of the texton feature
%
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

%% Dimension of the feature image should be large than 3
if ndims(fim) <= 3,
    error('textonscompute:InputDimensionError', ...
        'The input feature image should has a dimension no less than 3.');
end
if nargin < 3, d = 2; end;

%% Reshape 
% Reshape the image into a feature matrix, with each row indicating the feature
% vector of a pixel
sizefim = size(fim);        % size of the feature image
sizeim = sizefim(1:d);      % size of the image
nim = prod(sizeim);        	% number of pixels
sizef = sizefim(d+1:end);   % size of the feature
nf = prod(sizef);           % number of features
fm = reshape(fim, nim, nf); % reshape
clear fim;

%% K-means clustering
%[map, textons] = kmeans(fm, k); $ for matlab function
%[textons, map] = kmeans(fm, k);  % for fast kmeans
[map, textons] = kmeansML(k, fm', 'maxiter', 30, 'verbose', 1); % for
%kmeansML

%% Reshape
% Reshape the map to (HEIGHT * WIDTH) and reshape the
map = reshape(map, sizeim);
textons = reshape(textons, [k, sizef]);


