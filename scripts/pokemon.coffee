TWIT = require "twit"
MAX_TWEETS = 5

config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN_KEY
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

getTwit = ->
  unless twit
    twit = new TWIT config

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.last_tweet ||= '1'
    doAutomaticSearch(robot)

  robot.respond /((ポケモン))/i, (msg) ->
    query = "#ポケモンGO OR #PokemonGo'"
    since_id = robot.brain.data.last_tweet
    count = MAX_TWEETS

    twit = getTwit()
    twit.get 'search/tweets', {q: query, count: count, since_id: since_id}, (err, data) ->
      if err
        console.log "Error getting tweets: #{err}"
        return
      if data.statuses? and data.statuses.length > 0
        robot.brain.data.last_tweet = data.statuses[0].id_str
        for tweet in data.statuses.reverse()
          message = "Pokemon Tweet: http://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id_str}"
          msg.send message
