# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate, except: [:status]
      before_action :valid_token?, except: [:status]

      def status
        status_message = {
          message: 'Woo!, API V1 is running successfully',
          version: 'v1',
          last_updated: DateTime.now
        }
        render json: status_message, status: :ok
      end

      # bottom-up order for exception is needed
      rescue_from Exception, with: :handle_exception
      rescue_from ApiError, with: :handle_api_error

      protected

      def api_error(code, msg = '', request = nil)
        raise ApiError.new(code, msg, request)
      end

      def handle_api_error(excp)
        render excp.render_json
      end

      def handle_exception(excp)
        render ApiError.new(500, '', request, excp).render_json
      end

      def authenticate
        api_error(401, '', request) unless valid_token?
      end

      def valid_token?
        token = request.headers['HTTP-X-API-TOKEN']
        ApiKey.valid_token?(token)
      end
    end
  end
end
