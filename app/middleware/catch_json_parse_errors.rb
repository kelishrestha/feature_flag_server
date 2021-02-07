# frozen_string_literal: true

# Middleware to catch 400 errors
# and present them in json format
class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    unless env['CONTENT_LENGTH'].to_i.zero?
      if env['CONTENT_TYPE']&.include?('application/json')
        begin
          JSON.parse(read_input(env))
        rescue JSON::ParserError
          return rack_json_response
        end
      end
    end

    @app.call(env)
  end

  private

  def read_input(env)
    input = env['rack.input']
    input_string = input.read
    input.rewind
    input_string
  end

  def rack_json_response
    error_output = 'Problem parsing the body'
    [
      400,
      { 'Content-Type' => 'application/json' },
      [{ message: error_output }.to_json]
    ]
  end
end
