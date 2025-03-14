# Tutorial 3 - Game Development

## Latihan Mandiri: Eksplorasi Mekanika Pergerakan

-   Nama: Adnan Mukhtar
-   NPM: 2006485245

## Fitur yang Diimplementasikan

1. **Double Jump**

    - Karakter dapat melompat hingga dua kali (di lantai atau udara).
    - Pada kode di file Player.gd terdapat `jump_speed = -300` yang artinya kecepatan lompatan ke atas, selain itu terdapat `jump_count = 0` dan `max_jumps = 2` untuk menghitung jumlah lompatan dan mengatur bata maksimal lompatan.
    - Pada kode di file Player.gd terdapat kodisi untuk mengatur double jump karakter.
        ```python
        # Kondisi jika karakter menyentuh lantai maka jumlah lompatan akan direset menjadi 0
        if is_on_floor():
          jump_count = 0
        # Kondisi jika tombol "ui_up" (Panah atas) ditekan dan jumlah lompatan kurang dari 2, maka kecepatan vertikal diatur ke jump_speed dan jump_count bertambah 1.
        if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
          velocity.y = jump_speed
          jump_count += 1
        ```

2. **Dashing**

    - Karakter dapat melakukan dash dengan kecepatan `dash_speed = 400`
    - Pada kode di file Player.gd terdapat `is_dashing = false` untuk mengatur status karakter, `run_tap_interval = 0.25` untuk mengatur waktu maksimum antara dua kali tekan tombol untuk memicu dash, `last_right_tap_time = 0` dan `last_left_tap_time = 0` untuk menyimpan waktu terakhir tombol kanan/kiri ditekan untuk mendeteksi double-tap.
    - Pada kode di file Player.gd terdapat kodisi untuk mengatur dashing karakter.

    ```python
    # Kondisi Jika tombol "ui_right" (panah kanan) ditekan, direction.x bertambah 1 (bergerak ke kanan).
    # Dan jika tombol baru saja ditekan (just_pressed), maka cek apakah selisih waktu sejak tekan terakhir (last_right_tap_time) kurang dari 0,25 detik.
    # Jika ya, aktifkan is_dashing. Jika tidak, is_dashing dimatikan.Simpan waktu tekan terakhir dalam detik.
    if Input.is_action_pressed("ui_right"):
    direction.x += 1
        if Input.is_action_just_pressed("ui_right"):
            if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < run_tap_interval:
                is_dashing = true
            else:
                is_dashing = false

            last_right_tap_time = Time.get_ticks_msec() / 1000.0

    # Dashing ke kiri sama seperti ke kanan, namun untuk tombol "ui_left" (panah kiri) dan direction.x -= 1.
    ```

3. **Crouching**

    - Karakter akan seperti jongkok saat tombol "ui_down" ditekan (hanya saat di lantai).
    - Pada kode di file Player.gd terdapat `crouch_speed = 100` untuk kecepatan berjalan saat jongkok dan `is_crouching = false` untuk mengatur status karakter.
    - Pada kode di file Player.gd terdapat kodisi untuk mengatur crouching karakter.

    ```python
    # Kondisi jika tombol "ui_down" (panah bawah) ditekan dan karakter di lantai, is_crouching menjadi true. Jika tidak, is_crouching menjadi false.
    if Input.is_action_pressed("ui_down") and is_on_floor():
        is_crouching = true
    else:
        is_crouching = false
    ```

4. **Kontrol Gerakan dan Reset saat Jatuh**

    - Pada file Player.gd terdapat kode untuk mengontrol gerakan karakter dan Reset karakter saat terjatuh.

    ```python
    # Kondisi jika ada arah gerakan, maka akan di cek lg, Jika is_dashing = true dan jika tidak crouching (jongkok), maka kecepatan horizontal (velocity.x) diatur ke dash_speed sesuai arah, jika sedang crouching (jongkok) maka kecepatan horizontal (velocity.x) akan diatur ke crouch_speed.
    # Jika sedang tidak dashing, maka akan menjadi walk biasa dengan kiri = -walk_speed (normal) atau -crouch_speed (saat jongkok) dan ke kanan = walk_speed (normal) atau crouch_speed (saat jongkok).
    # Jika tidak ada arah (direction = Vector2.ZERO), kecepatan horizontal jadi 0 (berhenti).
    if direction != Vector2.ZERO:
    	if is_dashing:
    		if not is_crouching:
    			velocity.x = direction.x * dash_speed
    		else:
    			velocity.x = direction.x * crouch_speed
    	else:
    		# Walk Left
    		if Input.is_action_pressed("ui_left"):
    			velocity.x = -walk_speed if not is_crouching else -crouch_speed
    		# Walk Right
    		elif Input.is_action_pressed("ui_right"):
    			velocity.x = walk_speed if not is_crouching else crouch_speed
    else:
        velocity.x = 0
    ```

    - Reset saat jatuh

    ```python
    # Kondisi saat karakter jatuh ke bawah layar, maka akan di-reset ke awal.
    if position.y > get_viewport_rect().size.y:
        get_tree().reload_current_scene()
    ```

5. **Polishing**

    - **Arah Sprite**: Sprite menghadap kiri (`flip_h = true`) atau kanan (`flip_h = false`) berdasarkan gerakan atau input saat dash dibatalkan.

    ```python
    if velocity.x < 0:
        animated_sprite.flip_h = true
    elif velocity.x > 0:
        animated_sprite.flip_h = false
    ```

    - **Animasi**: Menggunakan `AnimatedSprite2D` dengan animasi:
        - `idle`: Diam.
        - `run`: Bergerak kiri/kanan.
        - `jump`: Melompat.
        - `crouch`: Jongkok.

    ```python
    if not is_on_floor():
        animated_sprite.play("Jump")
    elif is_crouching:
        animated_sprite.play("Crouch")
    elif velocity.x != 0:
        animated_sprite.play("Run")
    else:
        animated_sprite.play("Idle")
    ```

# Tutorial 5 - Game Development

## Latihan Mandiri: Membuat dan Menambah Variasi Aset

### Proses Pengerjaan

1. **Objek Baru (Coin)**

    - Membuat scene baru dengan menambahkan objek `Coin` dengan `Area2D` dan `AnimatedSprite2D`.
    - Menggunakan spritesheet koin dari [Kenney.nl](https://kenney.nl/) dengan animasi yang saya buat.
    - Menambahkan script `Coin.gd` untuk mengatur animasi dan penghapusan saat diambil atau saat bersentuhan dengan player.

2. **Efek Suara (SFX)**

    - Mengunduh efek suara "coin" dari [Pixabay.com](https://pixabay.com/sound-effects/search/coin/).
    - Menambahkan `AudioStreamPlayer2D` ke scene `Player` dan memutar suara saat diambil atau bersentuhan dengan player.

3. **Musik Latar (BGM)**

    - Mengunduh musik latar bertema platformer dari [OpenGameArt.org](https://opengameart.org/).
    - Menambahkan `AudioStreamPlayer` di root scene dengan menambahkan script `Main.gd` dan memutar background music pada saat scene dijalankan.

4. **Interaksi Pemain**
    - Mengubah `Player.gd` untuk mendeteksi tabrakan atau bersentuhan dengan `Coin` menggunakan `Area2D`.
    - Memanggil fungsi `collect` yang ada pada `Coin.gd` untuk mengetahui apakah Coin berhasil di ambil.

### Referensi

-   Spritesheet: [Kenney.nl](https://kenney.nl/)
-   Efek Suara: [Pixabay.com](https://pixabay.com/sound-effects/search/coin/)
-   Musik Latar: [OpenGameArt.org](https://opengameart.org/)
