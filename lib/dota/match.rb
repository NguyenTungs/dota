require 'dota/basic_player'
require 'dota/basic_match'
require 'dota/modes'
require 'dota/lobbies'

module Dota
  class Match < BasicMatch
    # The winner of the match
    #
    # @return [Symbol] the winner, :radiant or :dire
    def winner
      raw_match['radiant_win'] ? :radiant : :dire
    end

    # The time at which first blood occurred
    #
    # @return [Integer]
    def first_blood
      raw_match['first_blood_time']
    end

    # Array of players
    #
    # @return [Array<Dota::Match::Player>] array of Dota::Match::Player objects
    def players
      raw_match['players'].map do |raw_player|
        Player.new(raw_player)
      end
    end

    # The season of the match
    #
    # @return [Integer]
    def season
      raw_match['season']
    end

    # The duration of the match
    #
    # @return [Integer]
    def duration
      raw_match['duration']
    end

    # The number of human players in the match
    #
    # @return [Integer]
    def human_players
      raw_match['human_players']
    end

    # The number of positive votes
    #
    # @return [Integer]
    def positive_votes
      raw_match['positive_votes']
    end

    # The number of negative votes
    #
    # @return [Integer]
    def negative_votes
      raw_match['negative_votes']
    end

    # The cluster of the match
    #
    # @return [Integer]
    def cluster
      raw_match['cluster']
    end

    # The game mode of the match
    #
    # @return [String]
    def mode
      Modes[raw_match['game_mode']]
    end

    # The league this match is from
    #
    # @return [Integer]
    def league_id
      raw_match['leagueid']
    end

    # @private
    def to_hash
       {id: id, mode: mode, seq_num: seq_num, start_time: start, winner: winner,
        duration: duration, first_blood: first_blood, players: players.map(&:to_hash) }
    end

    class Player < Dota::BasicPlayer
      # The number of kills the player got
      #
      # @return [Integer]
      def kills
        raw_player['kills']
      end

      # The number of times the player died
      #
      # @return [Integer]
      def deaths
        raw_player['deaths']
      end

      # The number of assists the player got
      #
      # @return [Integer]
      def assists
        raw_player['assists']
      end

      # K/D/A
      #
      # @return [Array] array of kills, deaths, assists
      def kda
        [kills, deaths, assists]
      end

      # Leaver status
      #
      # @return [Symbol] :bot, :abandoned, :left_safe, :played
      def leaver_status
        case raw_player['leaver_status']
        when 0
          :played
        when 1
          :left_safe
        when 2
          :abandoned
        else
          :bot
        end
      end

      # The amount of gold the player had left at the end of the match
      #
      # @return [Integer]
      def gold
        raw_player['gold']
      end

      # The number of times a player last-hit a creep
      #
      # @return [Integer]
      def last_hits
        raw_player['last_hits']
      end

      # The number of times a player denied a creep
      #
      # @return [Integer]
      def denies
        raw_player['denies']
      end

      # The total amount of gold the player spent over the entire match
      #
      # @return [Integer]
      def gold_spent
        raw_player['gold_spent']
      end

      # The amount of damage the player dealt to heroes
      #
      # @return [Integer]
      def hero_damage
        raw_player['hero_damage']
      end

      # The amount of damage the player dealt to towers
      #
      # @return [Integer]
      def tower_damage
        raw_player['tower_damage']
      end

      # The amount of damage on other players that the player healed
      #
      # @return [Integer]
      def hero_healing
        raw_player['hero_healing']
      end

      # The final level
      #
      # @return [Integer]
      def level
        raw_player['level']
      end

      # The player's total xp/min
      #
      # @return [Integer]
      def xpm
        raw_player['xp_per_min']
      end

      # The player's total gold/min
      #
      # @return [Integer]
      def gpm
        raw_player['gold_per_min']
      end

      # List of items
      #
      # @return [Array<String>] an array of item names
      def items
        (0..5).map { |i| Items[raw_player["item_#{i}"]] }
      end

      # @private
      def to_hash
        super.to_hash.merge({ kda:    kda, gold: gold, xpm: xpm, gpm: gpm, last_hits: last_hits,
                              denies: denies, level: level, items: items })
      end
    end
  end
end
