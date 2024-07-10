const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

// Middleware
app.use(bodyParser.json());
app.use(cors());

// Connect to MongoDB
mongoose.connect('mongodb+srv://rcbalaji:07070707@cluster0.bbw2v33.mongodb.net/flutterAuth?retryWrites=true&w=majority&appName=Cluster0', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Define User Schema
const userSchema = new mongoose.Schema({
  name: String,
  dob: Date,
  address: String,
  phoneNumber: String,
  aadharNo: String,
  gender: String,
  age: Number,
  height: Number,
  weight: Number
});

const User = mongoose.model('User', userSchema);

// Routes
app.post('/register', async (req, res) => {
  const { name, dob, address, phoneNumber, aadharNo, gender, age, height, weight } = req.body;
  try {
    const user = new User({ name, dob, address, phoneNumber, aadharNo, gender, age, height, weight });
    await user.save();
    res.status(200).json({ message: 'User registered successfully' });
  } catch (err) {
    res.status(400).json({ message: 'User registration failed', error: err.message });
  }
});

app.post('/login', async (req, res) => {
  const { phoneNumber, dob } = req.body;
  try {
    const user = await User.findOne({ phoneNumber, dob });
    if (user) {
      // Return the entire user object
      res.status(200).json({ message: 'Login successful', user });
    } else {
      res.status(400).json({ message: 'Invalid credentials' });
    }
  } catch (err) {
    res.status(400).json({ message: 'Login failed', error: err.message });
  }
});


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
