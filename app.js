const express = require('express');
const app = express();
const port = 3000;

// Basic route for health check
app.get('/', (req, res) => {
    res.send('This is a blue-green deployment setup!');
});

// Start the server
app.listen(port, () => {
    console.log(`App running on http://localhost:${port}`);
});
