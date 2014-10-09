classdef WordGame < handle
    % WORDGAME An abstract base class for the different game modes
    
    properties
        wordBank % a cell array containing the the words to be typed and prompts
        currentWord % the current word to be typed
        wordsRight % the number of words typed correctly
        modeName % the name of the current game mode
        startTime % starting clock time of the game when player hits Go
        continueGame % whether or not the game should continue
        towerNum=0; %initialize at 0
        score
    end
    
    events
        EndGame
        OutOfTime
    end
    
    methods (Abstract)
        play(game)
        % a function to add/keep track of scores by game type
        add(game,newScore,playerName)
        getHighScores(game)
        getScore(varargin)
        getNextWord(varargin)
    end
    
    methods (Static)
        function wordBank = getWordBank(fileName)
            % wordBank is a cell array, where the index is also the length
            % of the word.
            wordBank = cell(1,15);
            
            fid = fopen(fileName);
            m = textscan(fid,'%s','Delimiter',',');
            words = m{1};
            fclose(fid);
            
            % Now we sort everything by length.
            for i=1:length(words)
                currentLength = length(words{i});
                if currentLength >= 15
                    wordBank{15} = cat(1,wordBank{15},{words{i}});
                else
                    wordBank{currentLength} = cat(1,wordBank{currentLength},{words{i}});
                end
            end
        end
    end
end



