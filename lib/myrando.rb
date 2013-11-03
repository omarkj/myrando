require "myrando/version"
require "httparty"
require "multi_json"
require "uri-handler"

module Myrando
  RANDO_API_URL = "http://rando.ustwo.se"

  class RandoConnection
    include HTTParty

    def initialize()
    end

    def get(path)
      opts = { :headers => { 'User-Agent' => "myrando/#{Myrando::VERSION}" } }
      return self.class.get(path, opts)
    end

    def post(path, body)
      opts = { :body => body, :headers => { 'User-Agent' => "myrando/#{Myrando::VERSION}" } }
      return self.class.post(path, opts)
    end
  end

  class MyRando
    include HTTParty
    class InvalidParameterError < StandardError; end
    class ApiError < StandardError; end
    
    attr_accessor :user_info

    def initialize(options = {})
      username = options[:username].to_uri if options [:username].kind_of?(String)
      password = options[:password].to_uri if options [:password].kind_of?(String)
      raise InvalidParameterError, "MyRando must :username attribute" if username.nil?
      raise InvalidParameterError, "MyRando must :password attribute" if password.nil?
      @connection = RandoConnection.new()
      @user_info = login(username, password)
    end

    def get_photos(page=1)
      resp = @connection.get("#{RANDO_API_URL}/users/#{@user_info[:user_id]}/deliveries/received.json?page=#{page}&auth_token=#{@user_info[:token]}")
      if resp.code == 200
        begin
          json = MultiJson.decode(resp.body)
          raise ApiError, "Rando returned an error: #{json['error']}" if not json.kind_of?(Array) and json.has_key?('error')
          randos = []
          json.each do |r|
            randos << r
          end
          randos
        rescue MultiJson::DecodeError
          raise ApiError, "Rando returned an error:\nStatus: #{resp.code}\nBody: #{resp.body}"
        end
      else
        raise ApiError, "Rando returned an error:\nStatus: #{resp.code}\nBody: #{resp.body}"
      end
    end
    
    def get_account_status()
      resp = @connection.get("#{RANDO_API_URL}/account.json?auth_token=#{@user_info[:token]}")
      if resp.code == 200
        begin
          json = MultiJson.decode(resp.body)
          raise ApiError, "Rando returned an error: #{json['error']}" if json.has_key?('error')
          return json
        rescue MultiJson::DecodeError
          raise ApiError, "Rando returned an error:\nStatus: #{resp.code}\nBody: #{resp.body}"
        end
      else
        raise ApiError, "Rando returned an error:\nStatus: #{resp.code}\nBody: #{resp.body}"
      end
    end

    private
    def login(username, password)
      body = "user[email]=#{username}&user[password]=#{password}"
      resp = @connection.post("#{RANDO_API_URL}/users/sign_in.json", body)
      if resp.code == 200
        begin
          json = MultiJson.decode(resp.body)
          raise ApiError, "Rando returned an error: #{json['error']}" if json.has_key?('error')
          {:token => json['authentication_token'], :user_id => json['id']}
        rescue MultiJson::DecodeError
          raise ApiError, "Error decoding Rando answer"
        end
      else
        raise ApiError, "Rando return an error: \nStatus: #{resp.code}\n"
      end
    end

  end

end
