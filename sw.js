const CACHE_NAME = 'sola-career-v726';
const APP_SHELL = ['/', '/index.html', '/manifest.json'];

self.addEventListener('install', event => {
  self.skipWaiting();
  event.waitUntil(caches.open(CACHE_NAME).then(cache => cache.addAll(APP_SHELL).catch(() => null)));
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k)))).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const req = event.request;
  if(req.method !== 'GET') return;
  event.respondWith(fetch(req).catch(() => caches.match(req).then(res => res || caches.match('/index.html'))));
});

self.addEventListener('push', event => {
  let data = {};
  try { data = event.data ? event.data.json() : {}; }
  catch(e) { data = { title: 'SOLA CAREER CENTER', body: event.data ? event.data.text() : '' }; }
  const title = data.title || 'SOLA CAREER CENTER';
  const options = {
    body: data.body || '新しい通知があります。',
    icon: data.icon || '/icon-192.png',
    badge: data.badge || '/icon-192.png',
    data: { url: data.url || '/' },
    vibrate: [100, 50, 100]
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', event => {
  event.notification.close();
  const url = event.notification.data?.url || '/';
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(clientList => {
      for(const client of clientList){
        if('focus' in client){
          client.navigate(url);
          return client.focus();
        }
      }
      if(clients.openWindow) return clients.openWindow(url);
    })
  );
});
