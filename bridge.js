const net = require('net');
const WebSocket = require('ws');

const SBS_PORT = 30003;
const WS_PORT = 8081;

const wss = new WebSocket.Server({ port: WS_PORT });
console.log(`WebSocket server active on port ${WS_PORT}`);

const sbsClient = net.createConnection({ port: SBS_PORT, host: '127.0.0.1' }, () => {
  console.log(`Connected to local readsb TCP stream on port ${SBS_PORT}`);
});

sbsClient.on('data', (chunk) => {
  const data = chunk.toString();
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
});

sbsClient.on('error', (err) => console.error('readsb stream error:', err.message));
