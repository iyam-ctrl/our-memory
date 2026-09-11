OURMEMORY FINAL V2

FITUR
- MASUK dengan email atau username
- DAFTAR dengan username, email, password, konfirmasi password
- STORY dari Momen Kamera terbaru
- beranda fokus foto/video postingan
- suka, komentar, bagikan, simpan
- Momen Kamera terpisah + dashboard momen
- pencarian username + ikuti/saling mengikuti
- pesan hanya untuk akun yang saling mengikuti
- profil: username, postingan, pengikut, mengikuti, edit profil, sorotan momen
- pengaturan: keluar akun, ganti akun melalui logout/login, tersimpan, pusat akun, ganti password, tema gelap/terang
- responsive iPhone, Android, desktop
- PWA

SETUP
1. Jalankan seluruh SETUP-SUPABASE.sql di Supabase SQL Editor.
2. Pastikan bucket Storage bernama ourmemory sudah ada dan policy Storage lama OurMemory tetap aktif.
3. Upload seluruh file ke root repo GitHub.
4. Vercel akan redeploy otomatis bila repo sudah terhubung.
5. Jika browser masih menampilkan desain lama, refresh dan tutup/reopen PWA agar service worker versi final diperbarui.

CATATAN
- kunci Supabase yang ada di index.html adalah publishable/anon key, bukan service_role.
- fitur kamera membutuhkan HTTPS dan izin kamera browser.
- jika Supabase meminta konfirmasi email, selesaikan konfirmasi sebelum login.
