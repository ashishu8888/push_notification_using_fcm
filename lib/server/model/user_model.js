const mongoose = require('mongoose')

const userSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim : true,
    },
    type: {
        type: String,
        default : 'user',
    },
    token: {
        type: String,
        required : true,
    }
});

const User = mongoose.model("User", userSchema)
module.exports = User