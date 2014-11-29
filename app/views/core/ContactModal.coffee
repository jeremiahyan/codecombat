ModalView = require 'views/core/ModalView'
template = require 'templates/core/contact'

forms = require 'core/forms'
{sendContactMessage} = require 'core/contact'

contactSchema =
  additionalProperties: false
  required: ['email', 'message']
  properties:
    email:
      type: 'string'
      maxLength: 100
      minLength: 1
      format: 'email'

    message:
      type: 'string'
      minLength: 1

module.exports = class ContactModal extends ModalView
  id: 'contact-modal'
  template: template
  closeButton: true

  events:
    'click #contact-submit-button': 'contact'

  contact: ->
    @playSound 'menu-button-click'
    forms.clearFormAlerts @$el
    contactMessage = forms.formToObject @$el
    res = tv4.validateMultiple contactMessage, contactSchema
    return forms.applyErrorsToForm @$el, res.errors unless res.valid
    window.tracker?.trackEvent 'Sent Feedback', message: contactMessage
    sendContactMessage contactMessage, @$el
    $.post "/db/user/#{me.id}/track/contact_codecombat"
