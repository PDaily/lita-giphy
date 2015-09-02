require 'lita'
module Lita
  module Handlers
    class Giphy < Handler
      URL = "http://api.giphy.com/v1/gifs/search"

      route(/(?:giphy|gif|animate)(?:\s+me)?\s+(.+)/i, :giphy, command: true, help: {
        "giphy QUERY" => "Grabs a gif tagged with QUERY."
      })

      config :api_key, default: nil

      def giphy(response)
        return unless validate(response)

        query = response.matches[0][0]

        # Set our gif
        gif = get_gif(query)

        colors = ['#23cdfc','#2afd9c','#9840fb','#fffe9f','#fc6769']

        # Build slack attachment hash
        attachment_hash ={
          color: colors.sample,
          image_url: gif
        }

        # Create Attachment
        attachment = Lita::Adapters::Slack::Attachment.new(gif, attachment_hash)
        case robot.config.robot.adapter
        when :slack
          robot.chat_service.send_attachment(response.room, attachment)
        else
          response.reply
        end
      end

      private

      def validate(response)
        if Lita.config.handlers.giphy.api_key.nil?
          response.reply "Giphy API key required"
          return false
        end

        true
      end

      def get_gif(query)
        process_response(http.get(
          URL,
          q: query,
          api_key: Lita.config.handlers.giphy.api_key
        ), query)
      end

      def process_response(http_response, query)
        data = MultiJson.load(http_response.body)

        if data["meta"]["status"] == 200
          choice = data["data"].sample
          if choice.nil?
            reply_text = "I couldn't find anything for '#{query}'!"
          else
            reply_text = choice["images"]["original"]["url"]
          end
        else
          reason = data["meta"]["error_message"] || "unknown error"
          Lita.logger.warn(
            "Couldn't get image from Giphy: #{reason}"
          )
          reply_text = "Giphy request failed-- please check my logs."
        end

        reply_text
      end
    end

    Lita.register_handler(Giphy)
  end
end
