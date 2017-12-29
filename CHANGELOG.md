## 0.1.3 - New function to add BookMaster revision bars
* Change `addRevisionBars` command to improve its handling of a corner case that matters when trying to properly nest different revision tags.
    * If the user selects nothing, the current cursor line(s) are wrapped.
    * (changed) If the user selects exactly 1 line (left margin, shift down arrow), wrap only the selected line.  (in 0.1.2, the line with the cursor would also be wrapped)
    * If the user selects any other text, all lines within each selection are wrapped.
    * In addition to the existing CTL-ALT-V binding, added command to editor context menu.

## 0.1.2 - New function to add BookMaster revision bars
* New `addRevisionBars` command to add :rev/:erev around current editor cursor(s), mapped to CTL-ALT-V by default, with the refid value supplied in a package setting

## 0.1.1 - Bug fix
* Toggle command throws an exception due to a publishing typo

## 0.1.0 - First Release
* Highlighting for IBM Script and GML/BookMaster tags and comments.  Rather than highly specific highlighting, only the general abstract tag syntax is recognized in most cases... comments, tags, labels.
* Flag nested :annot. as illegal, per the BookMaster manual
* File type must be SCRIPT in order for Atom to apply the grammar automatically.
