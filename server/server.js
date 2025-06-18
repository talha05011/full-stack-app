const express = require('express');
const app = express();
const PORT = 5000;
app.get('/health', (req, res) => {
    res.json({ status: 'OK' });
});
app.get('/', (req, res) => {
    res.send('<h1>🔌 Dummy Backend</h1><p>Try <a href="/health">/health</a></p>');
});
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
