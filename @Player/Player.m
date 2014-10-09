classdef Player < handle
    % This is the class that handles all of the player data as well as the
    % creation of new players
    
    properties
        name
        profileImage
        filePath
        password
        scores
        scores_unsorted
    end
    
    properties (Dependent = true)
        % storing the high scores
        % 1) Normal 2) Build 3) Matlab 4) Song
       highScores
    end
    
    events
        updatePic
    end
    
    methods
        function obj = Player(n,p,pi,fp)
            %Basic constructor for player
            %returns an error if parameters are not right
            if nargin==0
                obj.name = '';
                obj.password = '';
            elseif nargin==2
                obj.name = n;
                obj.password = p;
            elseif nargin==4
                obj.name = n;
                obj.password = p;
                obj.profileImage = pi;
                obj.filePath = fp;
            else
                error('Invalid arguments');
            end
            obj.scores{1} = {zeros(1,1)};
            obj.scores{2} = {zeros(1,1)};
            obj.scores{3} = {zeros(1,1)};
            obj.scores{4} = {zeros(1,1)};
            obj.scores_unsorted{1} = {zeros(1,1)};
            obj.scores_unsorted{2} = {zeros(1,1)};
            obj.scores_unsorted{3} = {zeros(1,1)};
            obj.scores_unsorted{4} = {zeros(1,1)};
        end
        
        function correctPassword = verifyPassword(obj,passwordInput)
            % a function to verify passwords for logging in.
            correctPassword = 0;
            if isequal(obj.password,passwordInput)
                correctPassword = 1;
            end
        end
        
        function scoreUpdate(obj, gameMode, newScore)
            % 1) Add score to player profile
            % 2) Update the high scores for player
            % 3) Add score to the game
            
            switch gameMode
                case 'Normal'
                    obj.scores{1} = cat(1,obj.scores{1},newScore);
                    obj.scores_unsorted{1} = cat(1,obj.scores_unsorted{1},newScore);
                    obj.scores{1} = sortrows(obj.scores{1},-1);
                    Normal.add(newScore,obj.name);
                case 'Build'
                    obj.scores{2} = cat(1,obj.scores{2},newScore);
                    obj.scores_unsorted{2} = cat(1,obj.scores_unsorted{2},newScore);
                    obj.scores{2} = sortrows(obj.scores{2},-1);
                    Build.add(newScore,obj.name);
                case 'MatL'
                    obj.scores{3} = cat(1,obj.scores{3},newScore);
                    obj.scores_unsorted{3} = cat(1,obj.scores_unsorted{3},newScore);
                    obj.scores{3} = sortrows(obj.scores{3},-1);
                    MatL.add(newScore,obj.name);
                case 'Song'
                    obj.scores{4} = cat(1,obj.scores{4},newScore);
                    obj.scores_unsorted{4} = cat(1,obj.scores_unsorted{4},newScore);
                    obj.scores{4} = sortrows(obj.scores{4},-1);
                    Song.add(newScore,obj.name);
            end
            
            % saving data stuff
            a = load('GameData.mat','Players');
            Players = a.Players;
            [~,~,index] = Player.getPlayer(obj.name);
            Players(index).scores = obj.scores;
            Players(index).scores_unsorted = obj.scores_unsorted;
            save('GameData.mat','Players','-append');
            
        end
        
        function highScores = get.highScores(obj)
            % temporary way to start game without previous high scores
            if isempty(obj.scores{1})
                highScores=[0 0 0 0];
            else
            highScores = [obj.scores{1}(1),obj.scores{2}(1),...
                            obj.scores{3}(1),obj.scores{4}(1)];
            end
        end
    end
    
    methods (Static)
        displayMakeProfile
            
        function [exist,returnPlayer,index] = getPlayer(n)
            exist = false;
            returnPlayer = '';
            index = -1;
            % load the data
            % data comes in a struct, super annoying.
            a = load('GameData.mat','Players');
            
            for i=1:length(a.Players)
               if isequal(a.Players(i).name,n)
                   exist = true;
                   returnPlayer = a.Players(i);
                   index = i;
               end
            end
        end
        
        function createNew(tempPlayer,password,passwordVerify,makeProfilePanel) %this will create the user and save it
            % First check if user already exists  
            [exist,~] = Player.getPlayer(tempPlayer.name);
            password = password';
            passwordVerify = passwordVerify';
            if exist
                errordlg('User already exists')
            elseif ~isequal(password,passwordVerify)
                errordlg('Passwords must match!')
            else
                a = load('GameData.mat','Players');
                Players = a.Players;
                Players(length(Players)+1) = tempPlayer;
                save('GameData.mat','Players','-append');
                createdUser  = imread('images/userCreated.png');
                h = msgbox('User Created!','Success','custom',createdUser);
                close(makeProfilePanel)
                uiwait(h)
                GamePanel.loginScreen;
            end
        end
    end
end

