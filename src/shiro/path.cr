module Shiro
  module Path
    extend self

    def path_to_regex(path : String) : Regex
      Regex.new path.gsub /\:(?<param>\w+)/, "(?<\\k<param>>\\w+)"
    end

    private def extract_params(path : String) : Array(String)
      path.split("/").select(&.match /:\w+/).map &.[](1..-1)
    end

    def build_params(path : String, params : Regex::MatchData)
      extract_params(path).reduce({} of String => String) do |agg, key|
        agg[key] = params[key]
        agg
      end
    end
  end

  class App
    def use(path : String, &handler : HTTP::Server::Context -> _)
      use path, GenericMiddleware.new handler
    end

    def use(path : String, handler : HTTP::Handler)
      use GenericMiddleware.new ->(context: HTTP::Server::Context) do
        r = Path.path_to_regex(path)
        request_path = context.request.path || ""

        if r === request_path
          request_path.match(r) do |params|
            context.request.params = Path.build_params(path, params)
            handler.call context
          end
        end
      end
    end
  end
end
