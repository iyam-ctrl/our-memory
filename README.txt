OurMemory — FINAL

VERSI SIAP GITHUB / VERCEL

FITUR
- login dan daftar akun email + password melalui Supabase Auth
- beranda hanya menampilkan foto dan video yang diunggah ke Kenangan
- album, video, favorit, profil, dan pengaturan
- pemilik dapat mengedit, menghapus, dan mengatur favorit kenangannya sendiri
- Momen Kamera terpisah dari Kenangan
- Momen Kamera mengambil foto langsung dari kamera perangkat, dengan kamera depan/belakang
- momen dapat diberi caption dan tersimpan di dashboard Momen Kamera
- PWA untuk penggunaan di HP

SETUP
1. Jalankan SETUP-SUPABASE.sql di Supabase SQL Editor.
2. SUPABASE_URL dan publishable key sudah terpasang di index.html.
3. Upload file ke GitHub lalu hubungkan repository ke Vercel.
4. Gunakan website melalui HTTPS agar fitur kamera dapat meminta izin browser.
5. Jika konfirmasi email Supabase aktif, konfirmasi email setelah daftar.

KEAMANAN
- publishable/anon key memang digunakan di sisi browser.
- jangan pernah memasukkan service_role key, secret key, password, atau kredensial server ke index.html atau GitHub.
- akses tulis/hapus database dan storage dibatasi oleh Row Level Security Supabase.

CATATAN KAMERA
- saat Buka Kamera ditekan, browser akan meminta izin kamera jika izin masih tersedia untuk diminta.
- jika izin sebelumnya ditolak secara permanen oleh browser/perangkat, aplikasi tidak dapat memaksa sistem menampilkan prompt baru.

VERSI FINAL
- cache PWA diperbarui agar versi terbaru dapat dimuat setelah deployment.
- metadata aplikasi dan ikon iPhone ditambahkan tanpa mengubah alur utama aplikasi.
