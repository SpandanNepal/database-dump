import mongoose from "mongoose";

const { Schema } = mongoose;

mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });


const personSchema = new Schema(
{ 
    username: { type: String, required: true }, 
}); 
    
export const Person = mongoose.model('Person', personSchema);

const exerciseSchema = new Schema(
{ 
    description: { type: String, required: true }, 
    duration: {type: Number, required: true},
    date: {type: Date, required: true},
    userId: {type: String, required: true}
}); 
        
export const Exercise = mongoose.model('Exercise', exerciseSchema);

export const getPersonsLog = async (id, done) => {
  try {
    const personFound = await Person.findById(id);
    const userExercises = await Exercise.find({userId: id}) 
    done(null, personFound, userExercises); 
    return personFound;
  } catch (err) {
    console.error(err);
    done(err);
  }
};

export const getPerson = async(done) => {
  try {
    const allPersons = await Person.find(); 
    done(null, allPersons); 
    return allPersons;
  } catch (err) {
    console.error(err);
    done(err);
  }
}

export const createAndSavePerson = (username, done) => {
    let data = new Person({username})

    data.save()
    .then(data => done(null, data))
    .catch(err => done(err));
};

export const createAndSaveExercise = async (exercise, done) => {
    try {
      // find the person by ID
      const personFound = await Person.findById(exercise.id);
      if (!personFound) return done(new Error("User not found"));

      // create new exercise
      const data = new Exercise({
        description: exercise.description,
        duration: exercise.duration,
        date: exercise.date && new Date(exercise.date) || new Date(),
        userId: exercise.id
      });

      // save exercise
      const savedData = await data.save();
      return done(null, savedData, personFound.username);
    } catch (err) {
      return done(err);
    }
};
