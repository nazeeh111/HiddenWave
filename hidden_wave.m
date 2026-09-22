function varargout = hidden_wave(varargin)
% HiddenWave: Transient light into hidden geometry.
% Passes arguments and outputs directly to cnlos_reconstruction.
root = fileparts(mfilename('fullpath'));
previousPath = path;
cleanup = onCleanup(@() path(previousPath)); %#ok<NASGU>
addpath(root);
[varargout{1:nargout}] = cnlos_reconstruction(varargin{:});
end
