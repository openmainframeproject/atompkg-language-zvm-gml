LanguageZvmGml = require '../lib/language-zvm-gml'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "LanguageZvmGml", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('language-zvm-gml')

  describe "when the language-zvm-gml:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.language-zvm-gml')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'language-zvm-gml:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.language-zvm-gml')).toExist()

        languageZvmGmlElement = workspaceElement.querySelector('.language-zvm-gml')
        expect(languageZvmGmlElement).toExist()

        languageZvmGmlPanel = atom.workspace.panelForItem(languageZvmGmlElement)
        expect(languageZvmGmlPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'language-zvm-gml:toggle'
        expect(languageZvmGmlPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.language-zvm-gml')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'language-zvm-gml:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        languageZvmGmlElement = workspaceElement.querySelector('.language-zvm-gml')
        expect(languageZvmGmlElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'language-zvm-gml:toggle'
        expect(languageZvmGmlElement).not.toBeVisible()
