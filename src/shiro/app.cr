module Shiro
  class App
    def initialize
      @middlewares = [] of HTTP::Handler
      use HTTP::ErrorHandler.new
    end

    def use(&handler : HTTP::Server::Context -> _)
      use GenericMiddleware.new handler
    end

    def use(handler : HTTP::Handler)
      @middlewares << handler
    end

    def listen(port : Int32 = 3000, host : String = "127.0.0.1")
      server = HTTP::Server.new(host, port, @middlewares)
      server.listen
    end
  end
end
