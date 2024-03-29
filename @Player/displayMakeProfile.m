function displayMakeProfile
    %temporary Player object
    tempPlayer = Player();
    
    % set the default pictures here
    tempPlayer.filePath = 'images/defaultPic.jpg';
    tempPlayer.profileImage = imread(tempPlayer.filePath);
    
    fMakeProfile = figure;
    fpos = get(fMakeProfile,'Position');
    set(fMakeProfile,'Units','pixels','Position',[fpos(1:2),250,300]) %setting the size to 300x300 pixels
    set(fMakeProfile,'NumberTitle','off',...
                        'Name','Create your profile!',...
                        'MenuBar','none',...
                        'DockControls','off')

    % creating all the panels
    profilePanel = uipanel(fMakeProfile,'Units','normalized','Position',[0 .76 1 .24]);
    textFieldPanel = uipanel(fMakeProfile,'Units','normalized','Position',[0 .3 1 .46]);
    buttonPanel = uipanel(fMakeProfile,'Units','normalized','Position',[0  0 1 .3]);

    % editing profilePanel
    imageAxes = axes('Parent',profilePanel,'Visible','off');
    defaultPic = imread('images/defaultPic.jpg');
    profilePicDisplayH = image(defaultPic,'Parent',imageAxes);
    set(imageAxes,'Units','pixels',...
        'Position',[1 1 72 72],...
        'Visible','off'...
        ); %for some reason image seems to set visibility on

    %Upload an image file
    uploadImageButton = uicontrol('Parent',profilePanel,...
                                   'Style', 'pushbutton',...
                                   'Units','pixels',...
                                   'Position', [100 30 100 20],...
                                   'String','Upload Picture',...
                                   'Callback', @(h,d) setImage(profilePicDisplayH));
    % editing textFieldPanel
    % Entering the name
    nameLabel = uicontrol('Parent',textFieldPanel,...
                            'Style','text',...
                            'String','Name: ',...
                            'Units', 'normalized',...
                            'FontSize',10,...
                            'Position',[.05 .75 .2 .15]);

    nameField = uicontrol('Parent',textFieldPanel,...
                            'Style','edit',...
                            'Units', 'normalized',...
                            'BackgroundColor',[1 1 1],...
                            'Position',[.4 .75 .5 .20]);

    % Entering the password
    pwLabel = uicontrol('Parent',textFieldPanel,...
                            'Style','text',...
                            'String','Password: ',...
                            'Units', 'normalized',...
                            'FontSize',10,...
                            'Position',[.05 .45 .25 .12]);

    pwField = javax.swing.JPasswordField();
    [pwField, hEditPassword] = javacomponent(pwField, [120 32 160 20], textFieldPanel);
    pwField.setFocusable(true);

    set(hEditPassword, ...
        'Parent', textFieldPanel, ...
        'Units', 'normalized', ...
        'Position',[.41 .45 .49 .18]);
    drawnow;

    % Confirming the password
    pwLabelVerify = uicontrol('Parent',textFieldPanel,...
                            'Style','text',...
                            'String','Confirm: ',...
                            'Units', 'normalized',...
                            'FontSize',10,...
                            'Position',[.05 .15 .25 .12]);

    pwFieldVerify = javax.swing.JPasswordField();
    [pwFieldVerify, hEditPasswordVerify] = javacomponent(pwFieldVerify, [120 5 160 20], textFieldPanel);
    pwFieldVerify.setFocusable(true);

    set(hEditPasswordVerify, ...
        'Parent', textFieldPanel, ...
        'Units', 'normalized', ...
        'Position',[.41 .15 .49 .18]);
    drawnow; 

    % Editing the buttonPanel
    loginButton = uicontrol('Parent',buttonPanel,...
                'Style', 'pushbutton',...
                'Units','normalized',...
                'Position', [.12 .50 .3 .22],...
                'String','Back',...
                'Callback', @(h,d) backToLogin);

    createUser = uicontrol('Parent',buttonPanel,...
                            'Style', 'pushbutton',...
                            'Units','normalized',...
                            'Position', [.52 .50 .3 .22],...
                            'String','Create',...
                            'Callback', @createPlayer);
    
    function backToLogin(h,e)
       close(fMakeProfile)
       GamePanel.loginScreen
    end

    function setImage(displayHandle)
        % this will return an error automatically if the image doesn't
        % exist. Make sure to use forward slashes in the filepath
        
        [tempPlayer.filePath, fullPath] = uigetfile('*.*');
        tempPlayer.filePath = ['images/' tempPlayer.filePath];
        tempPlayer.profileImage = imread(tempPlayer.filePath);
        displayHandle = image(tempPlayer.profileImage);
    end
        
    function createPlayer(h,e) %wrapper function
        % First store the name and the password
        tempPlayer.name = get(nameField,'String');
        tempPlayer.password = char(pwField.Password)';
        
        % Call the player function to make and save the player if allowed
        Player.createNew(tempPlayer,char(pwField.Password),char(pwFieldVerify.Password),fMakeProfile);
    end
end




