LanguageZvmGmlView = require './language-zvm-gml-view'
{CompositeDisposable} = require 'atom'

module.exports = LanguageZvmGml =
  languageZvmGmlView: null
  modalPanel: null
  subscriptions: null
  elementHadFocus: null

  activate: (state) ->
    @languageZvmGmlView = new LanguageZvmGmlView(state.languageZvmGmlViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @languageZvmGmlView.getElement(), visible: false)
    @languageZvmGmlView.clickToHide(@modalPanel)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'language-zvm-gml:toggle': => @toggle()
    # TODO see if there is a better add point than the workspace
    @subscriptions.add atom.commands.add 'atom-workspace', 'language-zvm-gml:addRevisionBars': => @addRevisionBars()
    console.log 'LanguageZvmGml finished activation'

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @languageZvmGmlView.destroy()

  serialize: ->
    languageZvmGmlViewState: @languageZvmGmlView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      console.log 'LanguageZvmGml was toggled, visible >> invisible'
      @modalPanel.hide()
      @elementHadFocus?.focus()
    else
      console.log 'LanguageZvmGml was toggled, visible << invisible'
      @modalPanel.show()
      @elementHadFocus = document.activeElement
      @modalPanel.getItem().focus()  # Needed for clickToHide to work

  # addRevisionBars:
  # - Uses ...Ranges() (plural) so it handles multiple cursors.
  # - Deals in markers instead of ranges (which would be less code)
  #   because it's inserting text, and ranges do not get adjusted for
  #   inserts on the fly (while markers do get adjusted).
  addRevisionBars: ->
    editor = atom.workspace.getActiveTextEditor()
    console.log "addRevisionBars ", editor
    if editor?
      selectedRanges = editor.getSelectedBufferRanges()
      selectedMarkers = []
      markerProperties = { "invalidate": "never"}
      selectedMarkers.push( editor.markBufferRange(oneRange,markerProperties) ) for oneRange , i in selectedRanges
      console.log "addRevisionBars markers ", selectedMarkers
      @addRevisionBarsToRange editor, m for m in selectedMarkers

  addRevisionBarsToRange: (editor, oneMarker) ->
    r = oneMarker.getBufferRange()
    console.log "addRevisionBarsToRange: ", editor, oneMarker , r
    # TODO get refid value from package setting
    refid = "JADrev1"
    editor.setCursorBufferPosition([r.start.row , 0])
    editor.insertText(":rev refid=" + refid + ".\n")
    # Update the range, whose bounds do not reflect the just-inserted text
    r = oneMarker.getBufferRange()
    editor.setCursorBufferPosition([r.end.row+1 , 0])
    editor.insertText(":erev refid=" + refid + ".\n")
