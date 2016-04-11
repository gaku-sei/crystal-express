module Shiro
  abstract class Middleware < HTTP::Handler
  end

  class GenericMiddleware < HTTP::Handler
    def initialize(@handler : HTTP::Server::Context -> _)
    end

    def call(context : HTTP::Server::Context)
      case @handler.call context
      when :next
        call_next context
      end
    end
  end
end
