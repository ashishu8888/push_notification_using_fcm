const express = require('express')
const mongoose = require('mongoose')

const PORT  = process.env.PORT || 3000
const app = express()
const DB = "mongodb+srv://ashish:ashish123@cluster0.6pk4wbq.mongodb.net/?retryWrites=true&w=majority"

app.use(express.json());

mongoose.connect(DB).then(() => {
    console.log("connection successful");
}).catch((e) => {
    console.log(e);
})

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`)
})

