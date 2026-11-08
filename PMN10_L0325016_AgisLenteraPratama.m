% PMN10 - PDB: dy/dx = (4x^3 - 2x + 1) / (2 + y), cari y(2)
% Isi file ini: Eksak, Euler, Heun, dan Runge-Kutta Orde 4, dalam 1 file.
% Tanpa figure, tanpa grafik. Hasilnya hanya tulisan di Command Window.
%
% Cara menjelaskan saat presentasi:
%   - Data soal ditulis sekali di atas, dipakai ketiga metode.
%   - Tiap metode diulang 15 langkah dengan loop for.
%   - Euler : 1 kemiringan, langsung maju.
%   - Heun  : 2 kemiringan, dirata-rata.
%   - RK4   : 4 kemiringan, rata-rata berbobot.
%   - Di akhir ada tabel perbandingan ketiganya.
%
% SOLUSI EKSAK (analitik, hitungan tangan):
%   (2 + y) dy = (4x^3 - 2x + 1) dx
%   2y + y^2/2 = x^4 - x^2 + x + C
%   y(0) = 1  ->  C = 2.5
%   y = -2 + sqrt(2x^4 - 2x^2 + 2x + 9)
%   y(2) = -2 + sqrt(37) = 4.0828

clear; clc;

% DATA SOAL - dipakai ketiga metode
x_awal = 0;        % titik awal x
y_awal = 1;        % titik awal y, y(0) = 1
x_tujuan = 2;      % x yang dituju, cari y(2)
n = 15;            % jumlah iterasi / langkah

% Besar langkah: dari 0 ke 2, dibagi 15 langkah
h = (x_tujuan - x_awal) / n;

% Nilai eksak di x = 2, untuk pembanding
y_eksak_akhir = -2 + sqrt(2 * x_tujuan^4 - 2 * x_tujuan^2 + 2 * x_tujuan + 9);
fprintf('Nilai eksak: y(2) = %.4f\n', y_eksak_akhir);
fprintf('Besar langkah h = %.4f, jumlah langkah n = %d\n\n', h, n);


% ================= 1. METODE EULER =================
% Rumus: y_baru = y_lama + h * kemiringan
%        kemiringan = (4x^3 - 2x + 1) / (2 + y)
x = x_awal;
y = y_awal;

fprintf('1. METODE EULER\n');
fprintf('Langkah   x        y        y_eksak  galat_abs  galat_rel%%\n');

for langkah = 1:n
    % Hitung kemiringan di titik sekarang
    kemiringan = (4 * x^3 - 2 * x + 1) / (2 + y);

    % Maju satu langkah
    y = y + h * kemiringan;
    x = x + h;

    % Nilai eksaknya, untuk pembanding saja
    y_eksak = -2 + sqrt(2 * x^4 - 2 * x^2 + 2 * x + 9);
    galat_abs = abs(y - y_eksak);
    galat_rel = galat_abs / y_eksak * 100;

    % %.4f artinya: tampilkan 4 angka di belakang koma
    fprintf('%d        %.4f   %.4f   %.4f   %.4f     %.4f\n', langkah, x, y, y_eksak, galat_abs, galat_rel);
end

% Simpan hasil akhirnya, untuk perbandingan di bawah
y_euler = y;
galat_abs_euler = abs(y_euler - y_eksak_akhir);
galat_rel_euler = galat_abs_euler / y_eksak_akhir * 100;
fprintf('Hasil Euler: y(2) = %.4f, galat_abs = %.6f, galat_rel = %.4f%%\n\n', y_euler, galat_abs_euler, galat_rel_euler);


% ================= 2. METODE HEUN =================
% Rumus: k1 = kemiringan di awal langkah
%        k2 = kemiringan di akhir langkah (pakai tebakan dari k1)
%        y_baru = y_lama + h * (k1 + k2) / 2
x = x_awal;
y = y_awal;

fprintf('2. METODE HEUN (Runge-Kutta Orde 2)\n');
fprintf('Langkah   x        y        y_eksak  galat_abs  galat_rel%%\n');

for langkah = 1:n
    % Kemiringan pertama: di titik sekarang
    k1 = (4 * x^3 - 2 * x + 1) / (2 + y);

    % Tebak dulu y di ujung langkah, pakai k1
    y_tebak = y + h * k1;

    % Kemiringan kedua: di ujung langkah
    k2 = (4 * (x + h)^3 - 2 * (x + h) + 1) / (2 + y_tebak);

    % Rata-rata kedua kemiringan, baru maju satu langkah
    k_rata = (k1 + k2) / 2;
    y = y + h * k_rata;
    x = x + h;

    % Nilai eksaknya, untuk pembanding saja
    y_eksak = -2 + sqrt(2 * x^4 - 2 * x^2 + 2 * x + 9);
    galat_abs = abs(y - y_eksak);
    galat_rel = galat_abs / y_eksak * 100;

    fprintf('%d        %.4f   %.4f   %.4f   %.4f     %.4f\n', langkah, x, y, y_eksak, galat_abs, galat_rel);
end

% Simpan hasil akhirnya, untuk perbandingan di bawah
y_heun = y;
galat_abs_heun = abs(y_heun - y_eksak_akhir);
galat_rel_heun = galat_abs_heun / y_eksak_akhir * 100;
fprintf('Hasil Heun: y(2) = %.4f, galat_abs = %.6f, galat_rel = %.4f%%\n\n', y_heun, galat_abs_heun, galat_rel_heun);


% ================= 3. METODE RUNGE-KUTTA ORDE 4 =================
% Rumus: k1 = kemiringan di awal langkah
%        k2 = kemiringan di tengah langkah (pakai k1)
%        k3 = kemiringan di tengah langkah (pakai k2)
%        k4 = kemiringan di akhir langkah (pakai k3)
%        y_baru = y_lama + h * (k1 + 2*k2 + 2*k3 + k4) / 6
% Angka 2 di depan k2 dan k3 artinya kemiringan tengah
% dihitung dua kali lipat, karena paling mewakili langkah itu.
x = x_awal;
y = y_awal;

fprintf('3. METODE RUNGE-KUTTA ORDE 4 (RK4)\n');
fprintf('Langkah   x        y        y_eksak  galat_abs  galat_rel%%\n');

for langkah = 1:n
    % k1: kemiringan di awal langkah
    k1 = (4 * x^3 - 2 * x + 1) / (2 + y);

    % k2: kemiringan di tengah langkah, pakai k1
    k2 = (4 * (x + h / 2)^3 - 2 * (x + h / 2) + 1) / (2 + (y + h / 2 * k1));

    % k3: kemiringan di tengah langkah, pakai k2
    k3 = (4 * (x + h / 2)^3 - 2 * (x + h / 2) + 1) / (2 + (y + h / 2 * k2));

    % k4: kemiringan di akhir langkah, pakai k3
    k4 = (4 * (x + h)^3 - 2 * (x + h) + 1) / (2 + (y + h * k3));

    % Rata-rata berbobot, baru maju satu langkah
    y = y + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
    x = x + h;

    % Nilai eksaknya, untuk pembanding saja
    y_eksak = -2 + sqrt(2 * x^4 - 2 * x^2 + 2 * x + 9);
    galat_abs = abs(y - y_eksak);
    galat_rel = galat_abs / y_eksak * 100;

    fprintf('%d        %.4f   %.4f   %.4f   %.4f     %.4f\n', langkah, x, y, y_eksak, galat_abs, galat_rel);
end

% Simpan hasil akhirnya, untuk perbandingan di bawah
y_rk4 = y;
galat_abs_rk4 = abs(y_rk4 - y_eksak_akhir);
galat_rel_rk4 = galat_abs_rk4 / y_eksak_akhir * 100;
fprintf('Hasil RK4: y(2) = %.4f, galat_abs = %.6f, galat_rel = %.4f%%\n\n', y_rk4, galat_abs_rk4, galat_rel_rk4);


% ================= PERBANDINGAN =================
fprintf('PERBANDINGAN HASIL AKHIR (nilai eksak 4.0828)\n');
fprintf('Euler : y = %.4f, galat_abs = %.6f, galat_rel = %.4f%%\n', y_euler, galat_abs_euler, galat_rel_euler);
fprintf('Heun  : y = %.4f, galat_abs = %.6f, galat_rel = %.4f%%\n', y_heun, galat_abs_heun, galat_rel_heun);
fprintf('RK4   : y = %.4f, galat_abs = %.6f, galat_rel = %.4f%%\n', y_rk4, galat_abs_rk4, galat_rel_rk4);
fprintf('Kesimpulan: RK4 paling akurat, lalu Heun, lalu Euler.\n');
