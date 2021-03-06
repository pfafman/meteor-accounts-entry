AccountsEntry =
  settings:
    wrapLinks: true
    homeRoute: '/home'
    dashboardRoute: '/dashboard'
    passwordSignupFields: 'EMAIL_ONLY'
    emailToLower: true
    usernameToLower: false
    entrySignUp: '/sign-up'
    extraSignUpFields: []
    showOtherLoginServices: true

  routeNames: ["entrySignIn", "entrySignUp", "entryForgotPassword", "entrySignOut", 'entryResetPassword', 'entryVerifyEmail']

  isStringEmail: (email) ->
    emailPattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i
    if email.match emailPattern then true else false

  config: (appConfig) ->
    @settings = _.extend(@settings, appConfig)

    T9n.defaultLanguage = "en"
    if appConfig.language
      T9n.language = appConfig.language

    if appConfig.signUpTemplate
      signUpRoute = Router.routes['entrySignUp']
      signUpRoute.options.template = appConfig.signUpTemplate

  signInRequired: (router, extraCondition) ->
    extraCondition ?= true
    unless Meteor.loggingIn()
      unless Meteor.user() and extraCondition
        if Router.current().route?.getName() not in AccountsEntry.routeNames
          Tracker.nonreactive ->
            Session.set('fromWhere', Iron.Location.get().path)
          Router.go('/sign-in')
          #Session.set('entryError', T9n.get('error.signInRequired'))
    router.next()
        

@AccountsEntry = AccountsEntry


class @T9NHelper

  @translate: (code) ->
    T9n.get code, "error.accounts"

  @accountsError: (err) ->
    Session.set 'entryError', @translate err.reason
    

