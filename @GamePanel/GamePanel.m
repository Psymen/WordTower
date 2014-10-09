classdef GamePanel < handle
    % GamePanel is a class for the UI display of the game
    % Game panel's ui is created by the method gamePanelUI, and the waitbar
    % is refreshed via the method updateTime.
    
    properties
        boardPanel1
        boardPanel2
        boardPanel3
        scorePanel
        highscorePanel
        highscoreTable
        highscoreLabel
        scoreTable
        displayedWord
        maxTime
        dec % decremented time between while loops
        wbTime = []; % current time shown on waitbar
        currentGameMode % the string determined by the radio buttons
        currentPlayer
        game
        profilePanel
        tower=[]; % contains handles of uicontrols comprising word tower
        wBarCtrl % handle to the waitbar's patch child
        lhEnd=[]; % handle to the EndGame listener
        lhTime=[]; % handle to the TopOfToewr listener
        reset = 0; % switches to 1 when reset is called
    end
    
    events
        TopOfTower
    end
    
    methods
        function panel=GamePanel()
            panel.wbTime=0; % starting waitbar time is 0s
            panel.maxTime=1; % arbitrary 1 just to create waitbar
        end
    end
    
    methods
        % updates time on waitbar via set.
        function updateTime(panel)
            % uc colors
            yblue = [15/255 77/255 146/255];
            cgold = [255/255 210/255 48/255];
            
            color=get(panel.wBarCtrl,'FaceColor');
            
            % if the bar is cgold and the time is above 1/3, set bar yblue
            if color(1) == (255/255) && panel.wbTime/panel.maxTime>=1/3
                set(panel.wBarCtrl,'FaceColor',yblue);
            end
            
            set(panel.wBarCtrl,'XData',[0 0 panel.wbTime/panel.maxTime...
                panel.wbTime/panel.maxTime])
            
            % if the time is below 1/3, make bar flash colors
            if panel.wbTime/panel.maxTime<1/3
                switch color(2)
                    case 210/255
                        set(panel.wBarCtrl,'FaceColor',yblue);
                    case 77/255
                        set(panel.wBarCtrl,'FaceColor',cgold);
                end
            end
        end
        
        
        
        % update score
        function updateScore(panel,score)
            set(panel.scorePanel,'String',['SCORE: ' num2str(score)]);
        end
        % called when the game go! is pressed. Begins the while loop that
        % controls the waitbar times
        
        function runTime(panel)
            uicontrol(findobj('tag','input'))
            goButton = findobj('tag','go');
            set(goButton,'String','Playing...','Enable','off')
            
            switch panel.currentGameMode
                % different gameplay functionality for each mode
                case 'Normal'
                    % while word tower is still below 5
                    while panel.game.towerNum<5 && panel.game.continueGame==1
                        panel.updateTime
                        panel.wbTime=panel.wbTime-panel.dec;
                        pause(panel.dec)
                        if panel.wbTime<=0
                            panel.submit_callback
                        end    
                    end
                case 'Build'
                    while panel.wbTime>0 && (panel.game.continueGame==1)
                        panel.updateTime % update wbar
                        panel.wbTime=panel.wbTime-panel.dec;
                        pause(panel.dec)
                    end
                case 'MatL'
                    while panel.game.towerNum<5 && panel.game.continueGame==1
                        % while word tower is still below 5
                        panel.updateTime
                        panel.wbTime=panel.wbTime-panel.dec;
                        
                        pause(panel.dec)
                        
                        if panel.wbTime<=0
                            panel.submit_callback
                        end
                    end
                case 'Song'
                    while panel.game.continueGame==1
                        panel.updateTime
                        panel.wbTime=panel.wbTime-panel.dec;
                        
                        pause(panel.dec)
                        
                        if panel.wbTime<=0 % when song ends, game over.
                            panel.game.continueGame=0;
                            notify(panel.game,'OutOfTime')
                        end
                    end
            end
            panel.game.continueGame=0;
            notify(panel.game,'EndGame') % end the game after while loop is over
        end
        
        function maxTower(panel) % execute popup when tower reaches the top
            yblue = [15/255 77/255 146/255];
            cgold = [255/255 210/255 48/255];
            
            bonus=length(panel.game.currentWord);
            bonus=num2str(bonus);
            
            mTowerPanel= uipanel('Parent',panel.boardPanel1,...
                'BorderType', 'none',...
                'Units','normalized',...
                'BackgroundColor', yblue,...
                'Position',[.75, .6675, .15, .15]);
            popUp = uicontrol('Parent',mTowerPanel,'Style','text',...
                'String',['+' bonus], 'FontSize',20,'FontWeight','bold',...
                'ForegroundColor','g',...
                'BackgroundColor', yblue,...
                'Units','normalized',...
                'Position',[0 0 1 1]);
            pause(1)
            delete(popUp)
            delete(mTowerPanel)
        end
        
        function endGame(panel) % executed when game is over
            % update the scores, only save the score if it's greater than
            % zero. This is so that our testing doesn't screw things up.
            if panel.game.score~=0
                % Making the format correct here.
                panel.game.score = ceil(panel.game.score);
                panel.currentPlayer.scoreUpdate(panel.currentGameMode,panel.game.score)
                disp(['Player ' panel.currentPlayer.name...
                    ' just scored: ' num2str(panel.game.score) ' in ' panel.currentGameMode]);
            end
            % update the high score
            % show the scoreBoard for the player
            set(panel.scoreTable,'Data',panel.currentPlayer.highScores');
            
            % update the game high score table
            switch panel.currentGameMode
                case 'Normal'
                    normalHSD = Normal.getHighScores;
                    set(panel.highscoreTable,'Data',[]);
                    set(panel.highscoreLabel,'String','High Scores - Normal');
                    set(panel.highscoreTable,'Data',normalHSD);
                case 'Build'
                    buildHSD = Build.getHighScores;
                    set(panel.highscoreLabel,'String','High Scores - Build');
                    set(panel.highscoreTable,'Data',buildHSD);
                case 'MatL'
                    matHSD = MatL.getHighScores;
                    set(panel.highscoreLabel,'String','High Scores - Matlab');
                    set(panel.highscoreTable,'Data',matHSD);
                case 'Song'
                    songHSD = Song.getHighScores;
                    set(panel.highscoreLabel,'String','High Scores - Song');
                    set(panel.highscoreTable,'Data',songHSD);
            end
            
            % change playing button back to go
            goButton=findobj('tag','go');
            set(goButton,'String','Go!','Enable','on')
            
            % game over popup if game ends w/o reset
            if ~panel.reset && ~strcmpi(panel.currentGameMode,'Song')
            [a, b]=imread('images/endgamepic.jpg');
            h = msgbox('You do not possess true knowledge.',...
                'Game Over','custom',a,b,'modal');
            end
            panel.reset = 0; % change reset back to 0
        end
        
        function display(panel)
            panel.gamePanelUI
        end
        
    end
    
    methods (Static)
        loginScreen
    end
end