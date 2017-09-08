LanguageZvmGmlView = require './language-zvm-gml-view'
{CompositeDisposable} = require 'atom'

module.exports = LanguageZvmGml =
  languageZvmGmlView: null
  modalPanel: null
  subscriptions: null
  elementHadFocus: null
  userVisiblePackageName: 'language-zvm-gml'  # Used for config keys, amongst other things
  debugging: false

  # http://flight-manual.atom.io/behind-atom/sections/configuration-api/
  # https://atom.io/docs/api/v1.19.7/Config
  config:
      revisionRefid:
          title: "Revision bar REFID"
          description: "The refid value used on the BookMaster :rev/:erev tags when running the addRevisionBars command"
          type: 'string'
          default: ""

  activate: (state) ->
    @languageZvmGmlView = new LanguageZvmGmlView(state.languageZvmGmlViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @languageZvmGmlView.getElement(), visible: false)
    @languageZvmGmlView.clickToHide(@modalPanel)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'language-zvm-gml:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-text-editor', 'language-zvm-gml:addRevisionBars': => @addRevisionBars()
    console.log 'LanguageZvmGml finished activation' if @debugging

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @languageZvmGmlView.destroy()

  serialize: ->
    languageZvmGmlViewState: @languageZvmGmlView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      console.log 'LanguageZvmGml was toggled, visible >> invisible'  if @debugging
      @modalPanel.hide()
      @elementHadFocus?.focus()
    else
      console.log 'LanguageZvmGml was toggled, visible << invisible' if @debugging
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
    console.log "addRevisionBars ", editor if @debugging
    if editor?
      selectedRanges = editor.getSelectedBufferRanges()
      selectedMarkers = []
      markerProperties = { "invalidate": "never"}
      selectedMarkers.push( editor.markBufferRange(oneRange,markerProperties) ) for oneRange , i in selectedRanges
      console.log "addRevisionBars markers ", selectedMarkers if @debugging
      @addRevisionBarsToRange editor, m for m in selectedMarkers

  addRevisionBarsToRange: (editor, oneMarker) ->
    r = oneMarker.getBufferRange()
    console.log "addRevisionBarsToRange: ", editor, oneMarker , r if @debugging
    refid = atom.config.get @userVisiblePackageName+".revisionRefid"
    if refid
      editor.setCursorBufferPosition([r.start.row , 0])
      editor.insertText(":rev refid=" + refid + ".\n")
      # Update the range, whose bounds do not reflect the just-inserted text
      r = oneMarker.getBufferRange()
      editor.setCursorBufferPosition([r.end.row+1 , 0])
      editor.insertText(":erev refid=" + refid + ".\n")
    else
      atom.notifications.addWarning("The revision's refid is empty.  Set the value in the package's settings.",
      {dismissable:true,
      detail: "Open File > Settings > Packages, filter on " + @userVisiblePackageName +
      ", click on the Settings control for that package, scroll to its Settings section, " +
      "and set it to a non-blank value."})
