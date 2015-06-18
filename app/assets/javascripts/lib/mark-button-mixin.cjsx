MarkButton = require 'components/mark-button'

# store keys of pre-defined mark-button states
MARK_STATES = [
  'waiting-for-mark',
  'mark-committed',
  'transcribe-enabled',
  'transcribe-finished'
]


module.exports =

  getInitialState: ->
    if @props.isPriorMark
      markStatus = 'transcribe-enabled'
    else
      markStatus = 'waiting-for-mark'
    markStatus: markStatus
    locked: ''

  renderMarkButton: ->
    <MarkButton
      tool={this}
      onDrag={@onClickMarkButton}
      position={@getMarkButtonPosition()}
      markStatus={@state.markStatus}
      locked={@state.locked}
    />

  onClickMarkButton: ->

    markStatus = @state.markStatus
    return if markStatus is 'transcribe-finished'

    console.log 'CURRENT MARK STATE: ', markStatus

    # advance to next mark state
    key = MARK_STATES.indexOf(markStatus) + 1
    markStatus = MARK_STATES[key]

    @setState
      markStatus: MARK_STATES[key]
        , => @respondToMarkState()

  respondToMarkState: ->
    markStatus = @state.markStatus

    console.log 'MARK STATUS: ', markStatus

    switch markStatus
      when 'mark-committed'
        # @setState locked: true
        console.log '''
          1) disable mark editing
          2) submit mark
          3) wait for post confirmation
        '''
        @setState locked: true
        @props.submitMark(@props.mark)
        # @props.submitMark(@props.key)
        # console.log 'Mark submitted. Click TRANSCRIBE to begin transcribing.'
      when 'mark-finished'
        console.log '''
          1) display transcribe icon
        '''
        # @props.onClickTranscribe(@state.mark.key)
        # @transcribeMark(mark)

        # console.log 'Going into TRANSCRIBE mode. Stand by.'
      when 'transcribe-enabled'
        console.log '''
          1) transition to transcribe route with subject ID
        '''
        # @submitTranscription()
        console.log 'Transcription submitted.'
      when 'transcribe-finished'
        console.log 'TRANSCRIBING MARK WITH ID: ', @props #.mark.child_subject_id
        location.replace "/#/transcribe/#{@props.mark.child_subject_id}?scrollX=#{window.scrollX}&scrollY=#{window.scrollY}"
        # @setState locked: true
        console.log 'All done. Nothing left to do here.'
      else
        # @setState locked: true
        console.log 'WARNING: Unknown state in respondToMarkState()'
