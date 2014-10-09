function addPlayerToPanel
    panel.profilePanel = uipanel(panel.boardPanel3,'Units','normalized','Position',[0 .76 1 .24]);
    imageAxes = axes('Parent',profilePanel,'Visible','off');
    defaultPic = imread('images/defaultPic.jpg');
    profilePicDisplayH = image(defaultPic,'Parent',imageAxes);
    set(imageAxes,'Units','pixels',...
        'Position',[1 1 72 72],...
        'Visible','off'...
        ); %for some reason image seems to set visibility on
end