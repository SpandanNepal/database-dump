const express = require('express')
const app = express()
const cors = require('cors')
require('dotenv').config()
const mongoose = require('mongoose')

app.use(express.urlencoded({ extended: true }));
app.use('/public', express.static(`${process.cwd()}/public`));

app.use(cors())
app.use(express.static('public'))
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/views/index.html')
});

const TIMEOUT = 10000;

const { getPerson, getPersonsLog, getExerciseLog } = require('./model.js')
const createPerson = require("./model.js").createAndSavePerson;
const createExercise = require("./model.js").createAndSaveExercise;

app.get("/is-mongoose-ok", function (req, res) {
  if (mongoose) {
    res.json({ isMongooseOk: !!mongoose.connection.readyState });
  } else {
    res.json({ isMongooseOk: false });
  }
});

app.get("/api/users", function (req, res) {
  getPerson(function(err, data) {
    res.json(data)
  });
});

app.get("/api/users/:_id/logs", function (req, res, next) {
  let t = setTimeout(() => next({ message: "timeout" }), TIMEOUT);

  const { from, to, limit } = req.query;

  getPersonsLog(req.params._id, function (err, user, exercise) {
    clearTimeout(t);
    if (err) return next(err);

    // --- Convert dates ---
    let fromDate = from ? new Date(from) : null;
    let toDate = to ? new Date(to) : null;

    // --- Filter exercises based on from/to ---
    let filteredExercises = exercise.filter((item) => {
      let exerciseDate = new Date(item.date);
      if (fromDate && exerciseDate < fromDate) return false;
      if (toDate && exerciseDate > toDate) return false;
      return true;
    });

    // --- Apply limit ---
    if (limit) {
      filteredExercises = filteredExercises.slice(0, Number(limit));
    }

    // --- Format logs ---
    let log = filteredExercises.map((item) => ({
      description: item.description,
      duration: item.duration,
      date: new Date(item.date).toDateString(),
    }));

    res.json({
      _id: req.params._id,
      username: user.username,
      count: log.length,
      log,
    });
  });
});


app.post("/api/users", function (req, res, next) {
  // in case of incorrect function use wait timeout then respond
  let t = setTimeout(() => {
    next({ message: "timeout" });
  }, TIMEOUT);

  createPerson(req.body.username, function (err, data) {
    clearTimeout(t);
    if (err) {
      return next(err);
    }
    if (!data) {
      console.log("Missing `done()` argument");
      return next({ message: "Missing callback argument" });
    }

    res.json({username: data.username, _id: data._id });
  });
});

app.post("/api/users/:_id/exercises", function (req, res, next) {
  let t = setTimeout(() => next({ message: "timeout" }), TIMEOUT);

  const exercise = {
    id: req.params._id,
    description: req.body.description,
    duration: req.body.duration,
    date: req.body.date
  };

  createExercise(exercise, function (err, data, username) {
    clearTimeout(t);
    if (err) return next(err);
    if (!data) return next({ message: "Missing callback argument" });

    res.json({
      _id: req.params._id,
      username: username,
      date: new Date(data.date).toDateString(),
      duration: Number(data.duration),
      description: data.description
    });
  });
});

const listener = app.listen(process.env.PORT || 3000, () => {
  console.log('Your app is listening on port ' + listener.address().port)
})
