   function my_closereq(src,evnt)
   % User-defined close request function 
   % to display a question dialog box 
      selection = questdlg('Are you sure you want to be a QUITTER?',...
         'Quitting?',...
         'Yes','No','Yes'); 
      switch selection, 
         case 'Yes',
            delete(gcf)    
         case 'No'      
         return 
      end
   end