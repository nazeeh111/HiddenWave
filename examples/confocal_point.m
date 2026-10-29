function report = confocal_point(output_dir, target_m)
% Original ideal confocal point-return experiment; not a captured hidden scene.
% Roundtrip light path: 2*sqrt((wall_x-x)^2+(wall_y-y)^2+z^2), in metres.
if nargin < 2, target_m=[.08,-.05,.3]; end
validateattributes(target_m,{'numeric'},{'real','finite','size',[1,3]},mfilename,'target_m');
if target_m(3) <= 0 || any(abs(target_m(1:2)) > .12) || target_m(3) > .42
    error('HiddenWave:Target','Target must satisfy abs(x/y)<=0.12m and 0<z<=0.42m');
end
if exist(output_dir,'file') || exist(output_dir,'dir')
    error('HiddenWave:OutputExists','Choose a new output directory; prior results are preserved');
end
root=fileparts(fileparts(mfilename('fullpath')));
old_path=path;cleanup=onCleanup(@() path(old_path)); %#ok<NASGU>
addpath(root);
N=16;M=128;wall_size=.4;dt=32e-12;c=3e8;
wall_axis=linspace(-wall_size/2,wall_size/2,N);[wx,wy]=meshgrid(wall_axis,wall_axis);
time=reshape((0:M-1)*dt,1,1,[]);
r=sqrt((wx-target_m(1)).^2+(wy-target_m(2)).^2+target_m(3)^2);
measurements=exp(-.5*((time-2*r/c)/dt).^2)./(r.^4);
[volume,info]=hidden_wave(measurements,[],wall_size,2,M,dt,false);
[peak,idx]=max(volume(:));[iy,ix,iz]=ind2sub(size(volume),idx);
peak_m=[info.x_m(ix),info.y_m(iy),info.z_m(iz)];
% Fixed admission bound derives from this grid and one-bin input pulse width,
% never from a saved expected reconstruction. Two depth bins account for the
% sampled pulse/interpolation and retained inclusive depth-axis convention.
voxel_m=[wall_size/(N-1),wall_size/(N-1),M*c*dt/2/(M-1)];
error_m=abs(peak_m-target_m);
if any(error_m > voxel_m.*[1,1,2])
    error('HiddenWave:Focus','Production f-k focus disagrees with independent target geometry');
end
report=struct('evidence','actual f-k on original ideal confocal point returns; no measured scene', ...
    'target_m',target_m,'peak_m',peak_m,'absolute_error_m',error_m,'voxel_m',voxel_m, ...
    'max_allowed_error_m',voxel_m.*[1,1,2],'peak_power',peak,'shape',size(volume), ...
    'measurement_sample_times_s',[0,(M-1)*dt], 'speed_of_light_m_s',c, 'info',info, ...
    'runtime_version',version);
mkdir(output_dir);
save(fullfile(output_dir,'reconstruction.mat'),'measurements','volume','info','report','-v7');
writematrix(max(volume,[],3),fullfile(output_dir,'max_projection_yx.csv'));
fid=fopen(fullfile(output_dir,'measurements.json'),'w');
if fid<0,error('HiddenWave:Output','Could not write report');end
file_cleanup=onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid,'%s\n',jsonencode(report));
fig=figure('Visible','off','Position',[100,100,960,720]);figure_cleanup=onCleanup(@() close(fig)); %#ok<NASGU>
imagesc(info.x_m,info.y_m,max(volume,[],3));axis image;set(gca,'YDir','normal');
xlabel('x (m)');ylabel('y (m)');colormap('gray');colorbar;
title(sprintf('Ideal confocal point, z=%.2f m; f-k maximum projection',target_m(3)));
hold on;plot(target_m(1),target_m(2),'rx','MarkerSize',12,'LineWidth',2);
plot(peak_m(1),peak_m(2),'bo','MarkerSize',10,'LineWidth',1.5);
legend('known generated target','reconstructed peak','Location','southoutside','Orientation','horizontal');
exportgraphics(fig,fullfile(output_dir,'projection.png'),'Resolution',150);
disp(report);
end
