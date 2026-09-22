% Offline checks; run from repository root.
root = fileparts(fileparts(mfilename('fullpath')));
addpath(root);
oldVisibility = get(groot,'defaultFigureVisible');
set(groot,'defaultFigureVisible','off');
cleanup = onCleanup(@() set(groot,'defaultFigureVisible',oldVisibility));
rng(7); measurements=rand(8,8,32);
for alg=[0 1 2]
    actual=hidden_wave(measurements,[],1,alg,32,32e-12);
    expected=cnlos_reconstruction(measurements,[],1,alg,32,32e-12);
    assert(isequaln(actual,expected));
    assert(isequal(size(actual),[8 8 32]));
    assert(all(isfinite(actual(:))) && all(actual(:)>=0));
    assert(any(actual(:)>0));
end
close all;
disp('PASS HiddenWave: three reconstruction modes, exact facade parity, finite nonzero volumes');
