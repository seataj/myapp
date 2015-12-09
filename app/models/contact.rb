require 'google/api_client'
require 'google_drive'
require 'openssl'
#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Contact
  include ActiveModel::Model
  attr_accessor :name, :string
  attr_accessor :email, :string
  attr_accessor :content, :string

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :content
  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates_length_of :content, :maximum => 500

  def update_spreadsheet
=begin
    # Authorizes with OAuth and gets an access token.
    client = Google::APIClient.new
    auth = client.authorization
    auth.client_id = Rails.application.secrets.email_client_id
    auth.client_secret = Rails.application.secrets.email_client_secret
    auth.scope = 
      "https://www.googleapis.com/auth/drive " +
      "https://spreadsheets.google.com/feeds"
    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    auth.code = "4/q8g0Dp1ygDRE9XoG0Bjn1dQ9-S-19rxuyynXQf7YPNg"
    auth.fetch_access_token!
    access_token = auth.access_token

    # Creates a session
    session = GoogleDrive.login_with_oauth(access_token)
=end

    session = GoogleDrive.saved_session("./stored_token.json", nil, Rails.application.secrets.email_client_id, Rails.application.secrets.email_client_secret)

    ss = session.spreadsheet_by_title('Learn-Rails-Example')
    if ss.nil?
      ss = session.create_spreadsheet('Learn-Rails-Example')
    end
    ws = ss.worksheets[0]
    last_row = 1 + ws.num_rows
    ws[last_row, 1] = Time.new
    ws[last_row, 2] = self.name
    ws[last_row, 3] = self.email
    ws[last_row, 4] = self.content
    ws.save
  end

end
