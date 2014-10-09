function addToTower(panel)
    % addToTower is called when the user inputs the wrong text. That word is
    % then added to the tower. At a certain number of incorrecgt words (undecided), the
    % game is then ended
    
    % currentword=get(panel.displayedWord,'String');
    currentword = panel.game.currentWord;
    n=panel.game.towerNum;

    switch panel.currentGameMode
        case 'Normal'
            color = [1 .8-n/(25/4) 0];
        case 'MatL'
            color = [1 .5-n/10 0];
        case 'Build'
            color = [0 1 (5-n)/5];
    end
    
    panel.tower(n) = uipanel(panel.boardPanel1,...
        'Units','normalized','BorderWidth',2,...
        'BorderType','beveledout',...
        'Position', [.2, n/10, .6, .1]);
    contents = uicontrol(panel.tower(n),'Style',...
        'text', 'String',currentword, 'FontSize',12,...
        'FontWeight','bold','BackgroundColor',color,...
        'Units', 'normalized',...
        'Position', [0, 0, 1, 1]);
    
    
end