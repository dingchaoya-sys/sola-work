const CACHE_NAME='sola-career-v4-3';
self.addEventListener('install',e=>{self.skipWaiting();e.waitUntil(caches.open(CACHE_NAME).then(c=>c.addAll(['/','/index.html','/manifest.json','/icon-192.png','/icon-512.png','/resume-qr.png'])))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE_NAME).map(k=>caches.delete(k)))));self.clients.claim()});
self.addEventListener('fetch',e=>{if(e.request.method!=='GET')return;e.respondWith(fetch(e.request).then(r=>{const copy=r.clone();caches.open(CACHE_NAME).then(c=>c.put(e.request,copy)).catch(()=>{});return r}).catch(()=>caches.match(e.request).then(c=>c||caches.match('/index.html'))))});
self.addEventListener('push',e=>{let data={title:'SOLA CAREER',body:'新しい通知があります。'};try{if(e.data)data=e.data.json()}catch(err){}e.waitUntil(self.registration.showNotification(data.title||'SOLA CAREER',{body:data.body||'新しい通知があります。',icon:'/icon-192.png',badge:'/icon-192.png'}))});
self.addEventListener('notificationclick',e=>{e.notification.close();e.waitUntil(clients.openWindow('/'))});
