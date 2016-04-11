require "./spec_helper"

describe Shiro do
  it "works" do
    app = Shiro::App.new

    app.use do |context|
      context.response << "Coucou"
      :next
    end

    # app.head "/coucou/:name" do |context|
    #   context.response << " " << context.request.params["name"]? << " depuis un HEAD!\n"
    #   :next
    # end

    app.use "/coucou/:name" do |context|
      context.response << " " << context.request.params["name"]? << "!\n"
      :next
    end

    app.listen
  end
end
