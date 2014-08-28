class EmailsController < ApplicationController
  protect_from_forgery

  def bounce
    if params['ID'] && params['MessageID'] && params['Email']
      email = BouncedEmail.new(postmark_id: params['ID'], 
        tag: params['Tag'], message_id: params['MessageID'], 
        type_code: params['TypeCode'], to_email: params['Email'],
        bounced_at: params['BouncedAt'], details: params['Details'],
        dump_available: params['DumpAvailable'], inactive: params['Inactive'],
        can_activate: params['CanActivate'], subject: params['Subject'])
      if email.save
        render text: "Send email to: #{params['Email']}, Subject: #{params['Subject']}, Body: #{params['Details']}"
      else
        sent_email = SentEmail.find_by(message_id: params['MessageID'])
        Notification.create!(message: "Your email to '#{params['Email']}' has bounced.", user: sent_email.user) if sent_email
        render text: "This email has already been re-sent once. Infinite loops aren't cool, dude."
      end
    else
      render text: 'Not a valid email object.'
    end
  end

  def send_email
    user = User.first # this would be where you get the current user

    # This is where you would send the email through the API and get a response like 
    # the one below (obviously that's just the body you would parse out of the actual response)

    response =  {
                  ErrorCode: 0,
                  Message: "OK",
                  MessageID: "b7bc2f4a-e38e-4336-af7d-e6c392c2f817",
                  SubmittedAt: "2010-11-26T12:01:05.1794748-05:00",
                  To: "receiver@example.com"
                }

    SentEmail.create!(message_id: response[:MessageID], to: response[:To], user_id: user.id)
    render text: "Sent email to: #{response[:To]}"
  end
end
