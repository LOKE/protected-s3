express        = require 'express'

{
  getFile
  #getFiles
} = require '../src/aws'

BUCKETS = (i.trim() for i in process.env.BUCKETS.split ',')


router = express.Router()

isLoggedIn = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  else
    res.redirect('/')


router.get '/', isLoggedIn, (req, res) ->
  res.render 'buckets',
    title:   'List of exposed sites'
    buckets: BUCKETS


router.get '/:bucket/*', isLoggedIn, (req, res) ->
  fileName = req.params[0] or 'index.html'

  getFile req.params.bucket, fileName, (err, awsRes) ->
    if err
      console.error "Cannot retrieve file: ", err
      return res.render 'error', 
          message: "Cannot retrieve file: ", err.message
          error: {}
    else
      awsRes.pipe res

module.exports = router
