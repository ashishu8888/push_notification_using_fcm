const express = require('express');
const User = require('../model/user_model');
const userRouter = express.Router()
const user = require('../model/user_model')

userRouter.post("/api/signup", async (req, res) => {
    console.log(req.body);

    try {
        const { name, type, token } = req.body;
        const existingUser = await User.findOne({ token });
        
        if (existingUser)
        {
            return res.status(400).json({
                msg : "User with same token already exists!"
            })
        }

            let user = new User({
                name: name,
                type : type,
                token : token,

            })

        user = await user.save();
        res.json(user)


    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
})