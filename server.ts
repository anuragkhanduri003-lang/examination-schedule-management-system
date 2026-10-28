import express from 'express';
import { createServer as createViteServer } from 'vite';
import path from 'path';
import { initializeDatabase } from './server/db.ts';
import { apiRouter } from './server/routes/api.ts';

async function startServer() {
  // Ensure database schemas and seed data are ready
  try {
    await initializeDatabase();
  } catch (dbErr) {
    console.error('Failed initializing database:', dbErr);
  }

  const app = express();
  const PORT = Number(process.env.PORT) || 3000;

  app.use(express.json());

  // Mount API endpoints
  app.use('/api', apiRouter);

  // Mount Vite dev middleware or serve static files in production
  if (process.env.NODE_ENV === 'production') {
    const distPath = path.resolve(process.cwd(), 'dist');
    app.use(express.static(distPath));
    app.get('*', (req, res) => {
      res.sendFile(path.join(distPath, 'index.html'));
    });
  } else {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: 'spa',
    });
    app.use(vite.middlewares);
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`[ESMS] Server running on port ${PORT}`);
  });
}

startServer().catch((err) => {
  console.error('[ESMS] Fatal server startup error:', err);
  process.exit(1);
});
