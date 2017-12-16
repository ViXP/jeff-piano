# Dependencies
import React from 'react'
import Timer from 'lib/Timer'

# Subcomponents
import PageLoading from 'components/PageLoading'
import Video from 'components/Video'
import ClipButton from 'components/ClipButton'
import RecordingButton from 'components/RecordingButton'

export default class @Layout extends React.Component
  constructor: (p) ->
    super(p)
    @timer = new Timer()

    window.timer = @timer

    @state = {
      currentClip: {
        number: 0,
        url: ''
      },
      currentRecording: {
        recording: true,
        clips: []
      },
      clips: {
        collection: {
          1: 'https://d15t3vksqnhdeh.cloudfront.net/videos/1.mp4'
          2: 'https://d15t3vksqnhdeh.cloudfront.net/videos/2.mp4'
          3: 'https://d15t3vksqnhdeh.cloudfront.net/videos/3.mp4'
        },
        loading: false
      }
    }

  render: ->
    <div>
      <PageLoading loading={@state.clips.loading} />
      <div className="column left">
        <Video number={@state.currentClip.number}
          url={@state.currentClip.url} />
          {for number, url of @state.clips.collection
            <ClipButton number={number} key={number}
              changeCurrent={@changeCurrent} />}
      </div>
      <div className="column">
        <RecordingButton recording={@state.currentRecording.recording}
          record={@record} />
      </div>
    </div>

  # Changes current clip
  changeCurrent: (number) =>
    @setState({
      currentClip: { number: number, url: @state.clips.collection[number] }
    })

    if @state.currentRecording.recording
      if (@state.currentRecording.clips.length == 0)
        time = 0
        @timer.start()
      else
        time = @timer.display()
      @setState({
        currentRecording: {
          ...@state.currentRecording,
          clips: 
            [...@state.currentRecording.clips, 
            {number: number, startTime: time }]
        }
      })

  # Operates the recording process
  record: =>
    if @state.currentRecording.recording
      @setState({ currentRecording: 
        { ...@state.currentRecording, recording: false } 
      })
      @timer.clear()
      # AND SAVE TO THE LOCAL STORAGE!
    else
      @setState({ currentRecording: { recording: true, clips: [] } })