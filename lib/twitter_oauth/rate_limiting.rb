module TwitterOAuth
  class Client
    attr_reader :hourly_limit, :remaining_hits, :reset_time

    def update_rate_limits
      # Example of status response: {"reset_time_in_seconds"=>1313564492, "reset_time"=>"Wed Aug 17 07:01:32 +0000 2011", "remaining_hits"=>149, "hourly_limit"=>150}
      status = rate_limit_status
      @hourly_limit = status["hourly_limit"].to_i
      @remaining_hits = status["remaining_hits"].to_i
      @reset_time = Time.at(status["reset_time_in_seconds"])
    end

    private 

    def update_rate_limit_from_response(response)
      @hourly_limit = response["X-RateLimit-Limit"].to_i if response["X-RateLimit-Limit"]
      @remaining_hits = response["X-RateLimit-Remaining"].to_i if response["X-RateLimit-Remaining"]
      @reset_time = Time.at(response["X-RateLimit-Reset"]) if response["X-RateLimit-Reset"]
    end
  end
end
