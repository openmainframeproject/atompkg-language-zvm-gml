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

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @languageZvmGmlView.destroy()

  serialize: ->
    languageZvmGmlViewState: @languageZvmGmlView.serialize()

  toggle: ->
    console.log 'LanguageZvmGml was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
      @elementHadFocus?.focus()
    else
      @modalPanel.show()
      @elementHadFocus = document.activeElement
      @modalPanel.getItem().focus()  # Needed for clickToHide to work
