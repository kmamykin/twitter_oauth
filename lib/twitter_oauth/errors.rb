module TwitterOAuth
  # https://dev.twitter.com/docs/error-codes-responses
  # 200 OK: Success!
  # 304 Not Modified: There was no new data to return.
  # 400 Bad Request: The request was invalid. An accompanying error message will explain why. This is the status code will be returned during rate limiting.
  # 401 Unauthorized: Authentication credentials were missing or incorrect.
  # 403 Forbidden: The request is understood, but it has been refused. An accompanying error message will explain why. This code is used when requests are being denied due to update limits.
  # 404 Not Found: The URI requested is invalid or the resource requested, such as a user, does not exists.
  # 406 Not Acceptable: Returned by the Search API when an invalid format is specified in the request.
  # 420 Enhance Your Calm: Returned by the Search and Trends API when you are being rate limited.
  # 500 Internal Server Error: Something is broken. Please post to the group so the Twitter team can investigate.
  # 502 Bad Gateway: Twitter is down or being upgraded.
  # 503 Service Unavailable: The Twitter servers are up, but overloaded with requests. Try again later.
  
  class BadRequest          < StandardError; end
  class Unauthorized        < StandardError; end
  class Forbidden           < StandardError; end
  class NotFound            < StandardError; end
  class NotAcceptable       < StandardError; end
  class EnhanceYourClaim    < StandardError; end
  class ServiceUnavailable  < StandardError; end

  class Client
    def handle_response(response)
      body = JSON.parse(response.body)
      update_rate_limit_from_response(response)
      case response.code.to_i
      when (200..299)
        body
      when 304
        body
      when 400
        raise TwitterOAuth::BadRequest, error_message(body)
      when 401
        raise TwitterOAuth::Unauthorized, error_message(body)
      when 403
        raise TwitterOAuth::Forbidden, error_message(body)
      when 404
        raise TwitterOAuth::NotFound, error_message(body)
      when 406
        raise TwitterOAuth::NotAcceptable, error_message(body)
      when 420
        raise TwitterOAuth::EnhanceYourClaim, error_message(body)
      when (500..599)
        raise TwitterOAuth::ServiceUnavailable, error_message(body)
      else
        body
      end
    end

    private 

    def error_message(body)
      "#{body["error"]} for request #{body["request"]}"
    end
  end
end

