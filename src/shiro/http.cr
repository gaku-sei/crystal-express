module HTTP
  class Request
    getter :params

    @params = {} of String => String

    def params=(@params : Hash(String, String))
    end
  end
end
