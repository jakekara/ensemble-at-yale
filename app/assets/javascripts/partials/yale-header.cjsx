React = require("react")
{Link} = require 'react-router'
Router = require 'react-router'
# {Navigation, Link} = Router
Login = require '../components/login'

module.exports = React.createClass
  displayName: 'YaleHeader'

  getDefaultProps: ->
    user: null
    loginProviders: []

  render: ->

    <header classNameim="main-header">

      <nav className="main-nav main-header-group">
        <a href="http://web.library.yale.edu/dhlab" className="main-header-item logo">
          <img src={'assets/dh-mark.png'} />
        </a>

        <div className="brand-title-container">
          <div className="brand-title-text-container">
            <a href="/#/">
              <div className="brand-title">
                  <img src="assets/ensemble-logo.png" />
              </div>
            </a>
          </div>
        </div>

        {
          # Workflows tabs:
          workflow_names = ['transcribe','mark','verify']
          workflows = (w for w in @props.workflows when w.name in workflow_names)
          workflows = workflows.sort (w1, w2) -> if w1.order > w2.order then 1 else -1
          workflows.map (workflow, key) =>
            title = workflow.name.charAt(0).toUpperCase() + workflow.name.slice(1)
            <Link key={key} to="/#{workflow.name}" activeClassName="selected" className="main-header-item main-header-button">{title}</Link>
        }
        { # Page tabs, check for main menu
          if @props.menus? && @props.menus.main?
            for item, i in @props.menus.main
              if item.page?
                <Link key={item.page} to="/#{item.page}" activeClassName="selected" className="main-header-item main-header-button">{item.label}</Link>
              else if item.url?
                <a href="#{item.url}" className="main-header-item main-header-button">{item.label}</a>
              else
                <a className="main-header-item main-header-button">{item.label}</a>
          # Otherwise, just list all the pages in default order
          else
            @props.pages?.map (page, key) =>
              formatted_name = page.name.replace("_", " ")
              <Link key={key} to="/#{page.name.toLowerCase()}" activeClassName="selected" className="main-header-item main-header-button">{formatted_name}</Link>
        }

        { # include feedback tab if defined
          showFeedbackTab = false
          if @props.feedbackFormUrl? and showFeedbackTab
            <a className="main-header-item main-header-button" href={@props.feedbackFormUrl}>Feedback</a>
        }
        { # include blog tab if defined
          if @props.blogUrl?
            <a target={"_blank"} className="main-header-item main-header-button" href={@props.blogUrl}>Blog</a>
        }
        { # include blog tab if defined
          if @props.discussUrl?
            <a target={"_blank"} className="main-header-item main-header-button" href={@props.discussUrl}>Discuss</a>
        }
        <Login user={@props.user} loginProviders={@props.loginProviders} onLogout={@props.onLogout} />

      </nav>

    </header>

