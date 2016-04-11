module Shiro
  class App
    macro define(*methods)
      {% for method in methods %}
        def {{method.id}}(path : String, &handler : HTTP::Server::Context -> _)
          {{method.id}} path, GenericMiddleware.new handler
        end

        def {{method.id}}(path : String, handler : HTTP::Handler)
          use GenericMiddleware.new ->(context: HTTP::Server::Context) do
            r = Path.path_to_regex(path)
            request_path = context.request.path || ""

            if r === request_path && context.request.method.downcase === "{{method.id}}"
              request_path.match(r) do |params|
                context.request.params = Path.build_params(path, params)
                handler.call context
              end
            end
          end
        end
      {% end %}
    end

    define delete, get, head, option, patch, post, put
  end
end
