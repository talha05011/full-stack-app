const express = require('express');
const app = express();
const PORT = 5000;

// CI/CD Test Variables
const DEPLOY_VERSION = process.env.DEPLOY_VERSION || 'DEV-' + Date.now();
const BG_COLORS = ['#FFEE93', '#FFC09F', '#A0CED9', '#ADF7B6'];

app.get('/health', (req, res) => {
    res.json({ 
        status: 'OK',
        version: DEPLOY_VERSION,
        timestamp: new Date().toISOString()
    });
});

app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Backend CI/CD Test</title>
            <style>
                body { 
                    font-family: Arial; 
                    text-align: center; 
                    padding-top: 50px;
                    background: ${BG_COLORS[Math.floor(Math.random() * 4)]};
                }
            </style>
        </head>
        <body>
            <h1>🔌 Backend Running</h1>
            <p>Version: ${DEPLOY_VERSION}</p>
            <p>Last updated: ${new Date().toLocaleString()}</p>
            <p>Try <a href="/health">/health endpoint</a></p>
        </body>
        </html>
    `);
});

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
