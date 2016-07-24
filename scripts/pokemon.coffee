robot.respond /((ポケモン|ぽけもん))/i, (msg) ->
  robot.http("https://api.instagram.com/v1/tags/ポケモンGO/media/recent?access_token=#{TOKEN}")
    .get() (err, res, body) ->
      records = JSON.parse(body)['data']
      msg.send records[0].images.standard_resolution.url
