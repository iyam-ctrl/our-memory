OurMemory — Instagram-inspired elegant PWA

FITUR:
- login / daftar email + password via Supabase Auth
- feed foto/video bergaya social-media
- album, video, favorit, profil, pengaturan
- hanya pemilik yang dapat edit/hapus kenangan miliknya
- MOMEN FOTO: upload foto singkat + caption untuk memberi kabar, tampil sebagai lingkaran momen di beranda
- pemilik dapat menghapus momen miliknya
- PWA untuk HP

SETUP:
1. Jalankan SETUP-SUPABASE.sql di Supabase SQL Editor.
2. SUPABASE_URL dan publishable key sudah terpasang di index.html.
3. Upload folder ini ke GitHub/Vercel.
4. Jika email confirmation aktif di Supabase, konfirmasi email setelah daftar.

Catatan: publishable/anon key aman untuk client-side. Jangan pernah menaruh service_role/secret key di index.html.

UPDATE FITUR MOMEN:
- Momen sekarang WAJIB mengambil foto langsung dari kamera perangkat.
- Tidak ada input pilih foto/gallery untuk fitur Momen.
- Mendukung kamera depan/belakang dengan tombol ganti kamera.
- Foto diambil dari kamera, bisa dicek ulang, diberi caption, lalu dikirim ke Supabase Storage.
- Fitur kamera membutuhkan HTTPS (Vercel sudah HTTPS) dan izin kamera dari browser.


VERSI ELEGANT SOCIAL + CAMERA
- Beranda hanya menampilkan foto/video yang diunggah sebagai Kenangan.
- Momen Kamera memiliki dashboard terpisah dan tidak digabung dengan Kenangan.
- Momen dibuat melalui kamera perangkat, bukan pemilih foto.
- Jika izin kamera belum diberikan, browser akan meminta izin ketika kamera dibuka.
- Jika izin kamera sebelumnya ditolak secara permanen oleh browser/perangkat, aplikasi tidak dapat memaksa sistem menampilkan ulang izin tersebut.
- Pengaturan berisi Pusat akun, Favorit, Momen Kamera, Kenangan, dan Keluar dari akun.
