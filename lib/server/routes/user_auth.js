const express = require('express');
const User = require('../model/user_model');
const userRouter = express.Router()
const user = require('../model/user_model')
const auth = require('../middleware/auth_middleware')


userRouter.post("/api/signup", async (req, res) => {
    console.log(req.body);

    try {
        const { name, type, token,email,password } = req.body;
        const existingUser = await User.findOne({ token });
        
        if (existingUser)
        {
            return res.status(400).json({
                msg : "User with same token already exists!"
            })
        }
        var hashpass = await bcryptjs.hash(password, 10);
        
            let user = new User({
                name: name,
                email: email,
                password : hashpass,
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

userRouter.post("api/signin", async (req, res) => {
    try {
        const { email, password } = req.body
        
    const user = await User.findOne({ email });
    if (!user) {
    return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
        }
        

        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect password." });
        }

        const token = jwt.sign({ id: user.token }, "passwordKey");

        res.json({ token, ...user_doc });

    }   
    catch (e)
    {
        res.status(500).json({ error: e.message });
    }  
})

// token validation....
userRouter.post("/tokenIsValid", async (req, res) => {
try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
} catch (e) {
    res.status(500).json({ error: e.message });
}
});


// get user data
userRouter.get("/", auth, async (req, res) => {
const user = await User.findById(req.user);
res.json({ ...user._doc, token: req.token });
});

module.exports = userRouter