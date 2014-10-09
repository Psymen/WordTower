function submit_callback(panel)

% for the case where no game even created
if isempty(panel.game)
    
% requires game to have started to run submit_callback
elseif panel.game.continueGame==1
    
    typeEditText=findobj('tag','input');
    typedinput=get(typeEditText,'String'); % getting what user typed
    
    % do not allow null strings unless they run out of time
    if ~isempty(typedinput) || (panel.wbTime<=0)
        
        % get the past word
        currentWord=get(panel.displayedWord,'String'); 

        %check if the user-typed input matches the prompt (boolean)
        valid=strcmpi(typedinput,currentWord);
        
        % automatically wrong for out of time
        if panel.wbTime<=0
            valid=0;
        end
        
        %this is the total time elapsed
        ttElapsed = etime(panel.game.startTime,clock);
        
        %all the arguments we need to pass;
        switch panel.currentGameMode
            case 'Normal'
                % check the state of the game
                % update the board
                
                % first set the score
                % delta is a measure of how fast they we able to complete
                % the word.
                delta = 1-(panel.maxTime-panel.wbTime)/panel.maxTime;
                score = ceil(getScore(panel.game, valid, delta));
                scoreString = ['SCORE: ' num2str(score)];
                set(panel.scorePanel,'String',scoreString);

                % current time resets to max time
                panel.wbTime=panel.maxTime;
                
                % if not valid, add the word to word tower.
                if ~valid && panel.game.towerNum<5
                    panel.game.towerNum = panel.game.towerNum + 1;
                    panel.addToTower;
                    pause(1.5)
                end                
                
                % get, set the new word
                if numel(panel.tower)<5
                    newWord = getNextWord(panel.game,valid);
                    set(panel.displayedWord,'String',newWord);
                end
                
            case 'MatL'
                valid=strcmpi(typedinput,panel.game.currentWord);
                
                % if not valid, add the word to word tower.
                if ~valid
                    panel.game.towerNum = panel.game.towerNum + 1;
                    panel.addToTower;
                    pause(1.5)
                end
                
                % first set the score
                score = getScore(panel.game, valid, ttElapsed);
                scoreString = ['SCORE: ' num2str(score)];
                set(panel.scorePanel,'String',scoreString);
                
                % update time regardless of valid
                panel.wbTime=panel.maxTime;
                
                % get, set the new word
                newWord = getNextWord(panel.game,valid);
                set(panel.displayedWord,'String',newWord);
                
            case 'Song'
                % Get each individual word in the line of lyrics
                lyricArray1 = textscan(currentWord,'%s','delimiter',' ');
                lyricArray=lyricArray1{1};
                q=0;
                % See if each individual word was typed
                for n=1:length(lyricArray)
                    k = length(strfind(currentWord,lyricArray{n})); % the number of times each word appears in the lyrics
                    m = length(strfind(typedinput,lyricArray{n})); % the number of times each word appears in the typed input
                    if m>k % if the player typed the word more times than it shows up
                        panel.game.wordsRight = panel.game.wordsRight+k; % just give them points for the # times it shows up
                    elseif m==k % if the player typed the word exactly the # times it shows up
                        panel.game.wordsRight = panel.game.wordsRight+1; % give a point for each instance
                    elseif m<k % if the player typed the word less times than it shows
                        q=m; % below if statement adds the points just once
                    end
                    
                    
                end
                
                if q>0 % if there are multiple instances of multiple words per line, too bad
                    panel.game.wordsRight = panel.game.wordsRight+q;
                end
                
                panel.game.wordsElapsed = panel.game.wordsElapsed + length(lyricArray); % update #wordsElapsed
                
                % set the score. maybe move this into Song mode
                score = getScore(panel.game);
                scoreString = ['SCORE: ' num2str(score) '%'];
                set(panel.scorePanel,'String',scoreString);
                
                % get, set the new word
                newWord = getNextWord(panel.game,valid);
                set(panel.displayedWord,'String',newWord);
                
            case 'Build'
                % check the state of the game
                % update the board
                
                % if  invalid, count the word.
                if valid %if valid, add time to waitbar and add to tower
                    % if tower is maxed, reset tower and give bonus
                    if panel.game.towerNum>=5
                        panel.game.towerNum=0;
                        delete(panel.tower)
                        panel.tower=[];
                        %give bonus for reaching 5 words
                        bonus=1;
                        notify(panel,'TopOfTower')
                        panel.wbTime=panel.maxTime;
                    else
                        bonus=0;
                        panel.game.towerNum = panel.game.towerNum + 1;
                        panel.addToTower;
                    end
                    panel.wbTime=panel.wbTime+1;
                    
                else % if invalid, bonus=0, delete tower
                    bonus=0;
                    panel.game.towerNum=0;
                    delete(panel.tower)
                    panel.tower=[];
                end
                
                % set the score
                delta = (panel.maxTime-panel.wbTime)/panel.maxTime;
                score = ceil(getScore(panel.game, valid,delta, bonus));
                scoreString = ['SCORE: ' num2str(score)];
                set(panel.scorePanel,'String',scoreString);
                
                % get, set the new word
                newWord = getNextWord(panel.game,valid);
                set(panel.displayedWord,'String',newWord);
                
                % curb waitbar time to maxtime
                if panel.wbTime>panel.maxTime
                    panel.wbTime=panel.maxTime;
                end
                
        end
        % clear text input box
        set(typeEditText,'String','');
        % reset focus
        uicontrol(findobj('tag','input'))
    end
end
end