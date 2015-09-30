/* This JavaScript extension checks if the preceding code cell,
   if there is  any, has a 'collapsed' attribute in the metadata. And if the
  previous cell is hidden, execute it first before the user
  presses Shift + Enter
*/

define([
    'base/js/namespace',
    'jquery',
    'base/js/events',
    'base/js/keyboard',
], function(IPython, $, events, keyboard) {
    "use strict";

    // var scrollRange = 20 /* range on top and bottom where autoscroll starts */
    
    var keycodes = keyboard.keycodes;   
    /*
     * Capture shift key and check if the preceding code cell
       is a hidden block and if yes execute it first
     *
     */
    $(document).keydown(function(event){
        if(event.keyCode === keycodes.shift /* && IPython.notebook.mode === "command"*/){
            // get the selected cell and check if the preceding cell is hidden
	    var cells = IPython.notebook.get_cells();
	    var current = IPython.notebook.get_selected_index();
	    var previous = current -1;
		
	    
	    if (cells[previous].metadata.input_collapsed) {
		for (var i = previous; i <= current; i++) {
		    IPython.notebook.select(i);
		    var cell = IPython.notebook.get_selected_cell();
		    IPython.notebook.execute_cell({add_new:false});
		}
	    }	    
        } //end if
	
    }) // end of keydown-function
    
    $(document).keyup(function(event){
        if(event.keyCode === keycodes.shift){
            // get the selected cell and check if the preceding cell is hidden
	    var cells = IPython.notebook.get_cells();
	    var current = IPython.notebook.get_selected_index();
	    var previous = current -1;
	    
	    if (cells[previous].metadata.input_collapsed) {
		for (var i = previous; i <= current; i++) {
		    IPython.notebook.select(i);
		    var cell = IPython.notebook.get_selected_cell();
		    IPython.notebook.execute_cell({add_new:false});
		}
	    }    
        } // end if
      
    }) // end of keyup-function

})
