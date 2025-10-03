require('dotenv').config();
const express = require('express');
const cors = require('cors');
const dns = require("dns");
const app = express();

app.use(express.urlencoded({ extended: true }));

let urlDatabase = {};
let counter = 0;

// Basic Configuration
const port = process.env.PORT || 3000;

app.use(cors());

app.use('/public', express.static(`${process.cwd()}/public`));

app.get('/', function(req, res) {
  res.sendFile(process.cwd() + '/views/index.html');
});

// Your first API endpoint
app.get('/api/hello', function(req, res) {
  res.json({ greeting: 'hello API' });
});

app.post('/api/shorturl', function(req, res) {
  let original_url = req.body.url || req.body.original_url;

  const hostname = original_url.replace(/^https?:\/\//, "").split("/")[0];

  dns.lookup(hostname, (err, address) => {
    if (err && hostname != 'localhost:3000') {
      return res.json({ error: "invalid URL" });
    }

    counter = counter + 1
    urlDatabase[counter] = original_url
    res.json({ 
      original_url, 
      short_url: Number(counter)
    });
  });
})

app.get('/api/shorturl/:data?', function(req, res) {
  let short_url = req.params.data

  let original_url = urlDatabase[short_url]

  if (original_url) {
    res.redirect(original_url)
  }

  return res.json({error: "invalid URL"})
});

app.listen(port, function() {
  console.log(`Listening on port ${port}`);
});
