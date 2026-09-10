OURMEMORY — FINAL ALL-IN-ONE

Isi paket:
- index.html — aplikasi utama
- manifest.json — PWA
- sw.js — service worker/cache
- SETUP-SUPABASE.sql — database + RLS lengkap
- icon-192.png / icon-512.png — ikon aplikasi

ALUR FINAL:
- Upload foto/video = POSTINGAN
- Kamera = MOMEN
- Momen terbaru = STORY
- Momen tersimpan = dashboard khusus
- Semua postingan dan momen dapat dilihat pengguna lain sesuai aturan publik aplikasi
- Profil: username, postingan, pengikut, mengikuti, edit profil, bio, sorotan momen
- Pencarian username + follow
- Pesan hanya untuk akun yang saling mengikuti
- Suka, komentar, bagikan, simpan pada postingan
- Tema gelap/terang
- Responsive iPhone, Android, desktop

SETUP:
1. Jalankan seluruh SETUP-SUPABASE.sql di Supabase SQL Editor.
2. Pastikan bucket Storage bernama "ourmemory" tetap PUBLIC agar media publik dapat dilihat pengguna lain.
3. Upload/replace file di root repository GitHub.
4. Vercel akan melakukan redeploy dari repository.

CATATAN KEAMANAN:
- Gunakan hanya publishable/anon key di browser.
- Jangan masukkan service_role key atau secret key ke index.html/GitHub.
