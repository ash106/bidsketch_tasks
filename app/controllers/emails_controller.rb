class EmailsController < ApplicationController
  protect_from_forgery

  def bounce
    if params['ID'] && params['MessageID'] && params['Email']
      email = Email.new(postmark_id: params['ID'], 
        tag: params['Tag'], message_id: params['MessageID'], 
        type_code: params['TypeCode'], to_email: params['Email'],
        bounced_at: params['BouncedAt'], details: params['Details'],
        dump_available: params['DumpAvailable'], inactive: params['Inactive'],
        can_activate: params['CanActivate'], subject: params['Subject'])
      if email.save
        render text: "Send email to: #{params['Email']}, Subject: #{params['Subject']}, Body: #{params['Details']}"
      else
        render text: "This email has already been re-sent once. Infinite loops aren't cool, dude."
      end
    else
      render text: 'Not a valid email object.'
    end
  end
end
