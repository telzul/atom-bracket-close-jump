{CompositeDisposable} = require 'atom'

module.exports = BracketCloseJump =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    bracket_close_jump = this

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor', 'bracket-close-jump:trigger': (event) ->
      # first let snippets do its job, fixes #1
      atom.commands.dispatch(atom.views.getView(atom.workspace), "snippets:next-tab-stop");
      if bracket_close_jump.cursor_in_front_of_closing_bracket()
        bracket_close_jump.move()
      else
        event.abortKeyBinding()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  move: ->
    editor = atom.workspace.getActiveTextEditor()
    cursor_pos = editor.getCursorBufferPosition()
    editor.setCursorBufferPosition([cursor_pos.row, cursor_pos.column+1])

  cursor_in_front_of_closing_bracket: ->
    editor = atom.workspace.getActiveTextEditor()
    cursor_pos = editor.getCursorBufferPosition()
    row_text = editor.lineTextForBufferRow(cursor_pos.row)
    return row_text[cursor_pos.column] in atom.config.get('bracket-close-jump.jumpCharacters');
