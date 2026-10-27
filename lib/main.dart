
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(const ITSLSApp());
}

const Color navy = Color(0xFF080B1B);
const Color cyan = Color(0xFF24BCEB);
const Color panel = Color(0xFF171D2A);
const Color muted = Color(0xFFAAB1C0);

class ITSLSApp extends StatelessWidget {
  const ITSLSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT-SLS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cyan,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          hintStyle: const TextStyle(color: muted),
          prefixIconColor: Colors.white70,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: Color(0xFF30394A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: cyan, width: 1.5),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// BACKGROUND BINTANG

class StarBackground extends StatelessWidget {
  final Widget child;

  const StarBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: navy)),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: StarPainter()),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(21);
    final paint = Paint()
      ..color = const Color(0xFFB9D9FF).withOpacity(0.7);

    for (int i = 0; i < 100; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * 1.3 + 0.3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

// HALAMAN LOGIN

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    // LOGIN SIMULASI UNTUK PENGUJIAN UI
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          email: emailController.text.trim(),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: StarBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(54, 54),
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 48,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Container(width: 125, height: 5, color: cyan),
                const SizedBox(height: 25),
                const Text(
                  'IT-SLS',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Information Technology Smart Locker System',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 36),
                const FieldLabel('Email'),
                const SizedBox(height: 9),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline),
                    hintText: 'user@example.com',
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Email wajib diisi';
                    }

                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(email)) {
                      return 'Format email belum benar';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 23),
                const FieldLabel('Password'),
                const SizedBox(height: 9),
                TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Masukkan password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }

                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }

                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => showMessage(
                      context,
                      'Fitur lupa password belum diaktifkan.',
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton(
                    onPressed: login,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF777C99),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 31),
                
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}



 
 // HALAMAN REGISTRASI

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final address = TextEditingController();
  final nim = TextEditingController();
  final cohort = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  String? gender;
  String? group;
  String? prodi;
  String? jurusan;

  File? ktm;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    name.dispose();
    address.dispose();
    nim.dispose();
    cohort.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  String? requiredField(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    return null;
  }

  Future<void> pickKtm() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked != null && mounted) {
        setState(() {
          ktm = File(picked.path);
        });
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, 'Gagal memilih foto KTM.');
      }
    }
  }

  void register() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (gender == null ||
        group == null ||
        prodi == null ||
        jurusan == null) {
      showMessage(
        context,
        'Pilih jenis kelamin, golongan, prodi, dan jurusan.',
      );
      return;
    }

    if (ktm == null) {
      showMessage(context, 'Silakan upload foto KTM terlebih dahulu.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Registrasi berhasil'),
        content: const Text(
          'Formulir berhasil divalidasi dalam mode pengujian. '
          'Data belum disimpan ke database.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Kembali ke Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StarBackground(
      child: Material(
        color: Colors.transparent,
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filled(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'REGISTRASI',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Container(width: 110, height: 5, color: cyan),
              const SizedBox(height: 18),

              const Text(
                'IT-SLS',
                style: TextStyle(
                  color: cyan,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Information Technology Smart Locker System',
                style: TextStyle(color: muted, fontSize: 13),
              ),
              const SizedBox(height: 26),

              const FieldLabel('Nama lengkap'),
              const SizedBox(height: 8),
              TextFormField(
                controller: name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Masukkan nama lengkap',
                ),
                validator: (v) => requiredField(v, 'Nama'),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Jenis kelamin'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: gender,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.wc),
                ),
                hint: const Text('Pilih jenis kelamin'),
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (v) => setState(() => gender = v),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Alamat'),
              const SizedBox(height: 8),
              TextFormField(
                controller: address,
                maxLines: 2,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'Masukkan alamat',
                ),
                validator: (v) => requiredField(v, 'Alamat'),
              ),
              const SizedBox(height: 18),

              const FieldLabel('NIM'),
              const SizedBox(height: 8),
              TextFormField(
                controller: nim,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge_outlined),
                  hintText: 'Masukkan NIM',
                ),
                validator: (v) => requiredField(v, 'NIM'),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Golongan'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: group,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
                hint: const Text('Pilih golongan'),
                items: ['A', 'B', 'C', 'D', 'E', 'F']
                    .map(
                      (v) => DropdownMenuItem<String>(
                        value: v,
                        child: Text(v),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => group = v),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Angkatan / tahun masuk'),
              const SizedBox(height: 8),
              TextFormField(
                controller: cohort,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                  hintText: 'Contoh: 2025',
                ),
                validator: (v) => requiredField(v, 'Angkatan'),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Program studi'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: prodi,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.computer_outlined),
                ),
                hint: const Text('Pilih program studi'),
                items: const [
                  DropdownMenuItem(
                    value: 'Teknik Komputer',
                    child: Text('Teknik Komputer'),
                  ),
                  DropdownMenuItem(
                    value: 'Teknik Informatika',
                    child: Text('Teknik Informatika'),
                  ),
                  DropdownMenuItem(
                    value: 'Manajemen Informatika',
                    child: Text('Manajemen Informatika'),
                  ),
                  DropdownMenuItem(
                    value: 'Lainnya',
                    child: Text('Lainnya'),
                  ),
                ],
                onChanged: (v) => setState(() => prodi = v),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Jurusan'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: jurusan,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_tree_outlined),
                ),
                hint: const Text('Pilih jurusan'),
                items: const [
                  DropdownMenuItem(
                    value: 'Teknologi Informasi',
                    child: Text('Teknologi Informasi'),
                  ),
                  DropdownMenuItem(
                    value: 'Lainnya',
                    child: Text('Lainnya'),
                  ),
                ],
                onChanged: (v) => setState(() => jurusan = v),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Upload KTM'),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: pickKtm,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  ktm == null ? 'Pilih foto KTM' : 'Ganti foto KTM',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cyan,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: cyan),
                ),
              ),

              if (ktm != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    ktm!,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
              const SizedBox(height: 18),

              const FieldLabel('Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline),
                  hintText: 'nama@email.com',
                ),
                validator: (v) {
                  final value = v?.trim() ?? '';

                  if (value.isEmpty) {
                    return 'Email wajib diisi';
                  }

                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value)) {
                    return 'Format email belum benar';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 18),

              const FieldLabel('Password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: password,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Minimal 8 karakter',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (v) {
                  final value = v ?? '';

                  if (value.isEmpty) {
                    return 'Password wajib diisi';
                  }
                  if (value.length < 8) {
                    return 'Minimal 8 karakter';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return 'Tambahkan huruf besar';
                  }
                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                    return 'Tambahkan huruf kecil';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'Tambahkan angka';
                  }
                  if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
                    return 'Tambahkan simbol seperti ! atau @';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 7),
              const Text(
                'Minimal 8 karakter, huruf besar dan kecil, angka, serta simbol.',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              const SizedBox(height: 18),

              const FieldLabel('Konfirmasi password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: confirmPassword,
                obscureText: hideConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  hintText: 'Ulangi password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword = !hideConfirmPassword;
                      });
                    },
                    icon: Icon(
                      hideConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Konfirmasi password wajib diisi';
                  }
                  if (v != password.text) {
                    return 'Password tidak sama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: register,
                  style: FilledButton.styleFrom(
                    backgroundColor: cyan,
                    foregroundColor: navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text('Sudah punya akun? '),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



 // HALAMAN BERANDA


class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> barangHilang = [
    {
      'nama': 'Botol Minum',
      'lokasi': 'Area Perpustakaan',
      'tanggal': '12 Okt 2026',
      'icon': Icons.water_drop_outlined,
    },
    {
      'nama': 'Earphone',
      'lokasi': 'Ruang Kelas A3',
      'tanggal': '10 Okt 2026',
      'icon': Icons.headphones_outlined,
    },
    {
      'nama': 'Dompet',
      'lokasi': 'Lobby Gedung A',
      'tanggal': '8 Okt 2026',
      'icon': Icons.account_balance_wallet_outlined,
    },
  ];

  void bukaMenu(String menu) {
    setState(() {
      selectedIndex = menu == 'Penemu'
          ? 1
          : menu == 'Pemilik'
              ? 2
              : menu == 'Barang Hilang'
                  ? 3
                  : 0;
    });

    if (menu == 'Keluar') {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFF101D38),
          title: const Text(
            'Keluar dari aplikasi?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Apakah kamu yakin ingin logout?',
            style: TextStyle(color: Color(0xFFB8CBE8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (_) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFF19D4FF)),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (menu == 'Profil Akun') {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFF101D38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Profil Akun',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF1266B5),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFB8D9FF)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pengguna IT-SLS',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
      return;
    }

    if (menu == 'Penemu') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const PenemuBarangPage(),
    ),
  );
} else if (menu == 'Pemilik') {
      showMessage(context, 'Halaman Pemilik Barang akan dibuat berikutnya.');
    } else if (menu == 'Barang Hilang') {
      showMessage(context, 'Halaman Daftar Barang Hilang akan dibuat berikutnya.');
    } else if (menu == 'Riwayat') {
      showMessage(context, 'Riwayat laporan akan dibuat berikutnya.');
    } else if (menu == 'Lihat Loker') {
      showMessage(context, 'Fitur loker akan dihubungkan ke perangkat.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StarBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              // HEADER
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: cyan.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: cyan,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'IT-SLS',
                          style: TextStyle(
                            color: cyan,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'Information Technology\nSmart Locker System',
                          style: TextStyle(
                            color: Color(0xFFB8CBE8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Profil dan keluar',
                    color: const Color(0xFF122747),
                    icon: const CircleAvatar(
                      backgroundColor: Color(0xFF123D70),
                      child: Icon(
                        Icons.person_outline,
                        color: Color(0xFF65DFFF),
                      ),
                    ),
                    onSelected: bukaMenu,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Profil Akun',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, color: cyan),
                            SizedBox(width: 10),
                            Text(
                              'Profil Akun',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Keluar',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: cyan),
                            SizedBox(width: 10),
                            Text(
                              'Keluar dari Aplikasi',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Halo, Selamat Datang!',
                style: TextStyle(
                  color: Color(0xFFEAF4FF),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF9DBFEA),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 24),

              // SMART LOCKER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF104D86),
                      Color(0xFF101D42),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFF087FC8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      color: cyan,
                      size: 35,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Smart Locker',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Kelola barang temuan dengan mudah, aman, dan praktis.',
                      style: TextStyle(
                        color: Color(0xFFB8D9FF),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => bukaMenu('Lihat Loker'),
                      style: FilledButton.styleFrom(
                        backgroundColor: cyan,
                        foregroundColor: const Color(0xFF06152D),
                      ),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Lihat Loker'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                'Menu Utama',
                style: TextStyle(
                  color: Color(0xFFEAF4FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              // MENU UTAMA
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: HomeMenu(
                      icon: Icons.search,
                      title: 'Penemu Barang',
                      subtitle: 'Laporkan barang yang kamu temukan.',
                      color: const Color(0xFF078FE0),
                      onTap: () => bukaMenu('Penemu'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeMenu(
                      icon: Icons.person_outline,
                      title: 'Pemilik Barang',
                      subtitle: 'Cari dan klaim barang milikmu.',
                      color: const Color(0xFF6055F5),
                      onTap: () => bukaMenu('Pemilik'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: HomeMenu(
                      icon: Icons.inventory_2_outlined,
                      title: 'Daftar Barang Hilang',
                      subtitle: 'Lihat barang yang belum diambil.',
                      color: const Color(0xFF00AA9A),
                      onTap: () => bukaMenu('Barang Hilang'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeMenu(
                      icon: Icons.history,
                      title: 'Riwayat',
                      subtitle: 'Riwayat laporan dan penanganan.',
                      color: const Color(0xFF6252ED),
                      onTap: () => bukaMenu('Riwayat'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // DAFTAR BARANG HILANG
              Row(
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    color: cyan,
                    size: 27,
                  ),
                  const SizedBox(width: 9),
                  const Expanded(
                    child: Text(
                      'Barang Hilang Terbaru',
                      style: TextStyle(
                        color: Color(0xFFEAF4FF),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => bukaMenu('Barang Hilang'),
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: cyan, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (barangHilang.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: panel.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    'Belum ada barang hilang yang dilaporkan.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

              ...barangHilang.map((barang) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D2040).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFF173F70),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF183B65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          barang['icon'] as IconData,
                          color: cyan,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              barang['nama'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Color(0xFF9DBFEA),
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    barang['lokasi'] as String,
                                    style: const TextStyle(
                                      color: Color(0xFFB8CBE8),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              barang['tanggal'] as String,
                              style: const TextStyle(
                                color: Color(0xFF8EAED8),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF8DBBFF),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Bersama menjaga barang berharga di lingkungan kampus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8DBBFF),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),

        // NAVIGASI BAWAH
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF08152E),
            border: Border(
              top: BorderSide(color: Color(0xFF164D84)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                _navItem(Icons.home_rounded, 'Beranda', 0),
                _navItem(Icons.search, 'Penemu', 1),
                _navItem(Icons.person_outline, 'Pemilik', 2),
                _navItem(Icons.inventory_2_outlined, 'Barang Hilang', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final aktif = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (index == 0) {
            setState(() => selectedIndex = 0);
          } else {
            bukaMenu(
              index == 1
                  ? 'Penemu'
                  : index == 2
                      ? 'Pemilik'
                      : 'Barang Hilang',
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: aktif ? cyan : const Color(0xFF8EAED8),
                size: 25,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: aktif ? cyan : const Color(0xFF8EAED8),
                  fontSize: 10,
                  fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: aktif ? 35 : 0,
                decoration: BoxDecoration(
                  color: cyan,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const HomeMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF102648),
      borderRadius: BorderRadius.circular(19),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: const Color(0xFF174F86),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 27),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFB8CBE8),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PenemuBarangPage extends StatefulWidget {
  const PenemuBarangPage({super.key});

  @override
  State<PenemuBarangPage> createState() => _PenemuBarangPageState();
}

class _PenemuBarangPageState extends State<PenemuBarangPage> {
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final catatanController = TextEditingController();

  File? fotoBarang;
 DateTime? tanggalDitemukan;
late TimeOfDay waktuDitemukan;
DateTime? waktuLaporan;
int? lokerDipilih;

@override
void initState() {
  super.initState();
  waktuDitemukan = TimeOfDay.fromDateTime(DateTime.now());
}
  bool sedangMenganalisis = false;
  bool sudahDianalisis = false;

  @override
  void dispose() {
    namaController.dispose();
    lokasiController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  Future<void> pilihFoto() async {
    try {
      final hasil = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (hasil != null && mounted) {
        setState(() {
          fotoBarang = File(hasil.path);
          sudahDianalisis = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showMessage(context, 'Foto gagal dipilih. Coba lagi.');
      }
    }
  }

  Future<void> pilihTanggal() async {
    final sekarang = DateTime.now();

    final hasil = await showDatePicker(
      context: context,
      initialDate: tanggalDitemukan ?? sekarang,
      firstDate: DateTime(2020),
      lastDate: sekarang,
      helpText: 'Pilih tanggal barang ditemukan',
    );

    if (hasil != null && mounted) {
      setState(() => tanggalDitemukan = hasil);
    }
  }

  Future<void> pilihWaktu() async {
    final hasil = await showTimePicker(
      context: context,
      initialTime: waktuDitemukan ?? TimeOfDay.now(),
      helpText: 'Pilih waktu barang ditemukan',
    );

    if (hasil != null && mounted) {
      setState(() => waktuDitemukan = hasil);
    }
  }

  String formatTanggal(DateTime tanggal) {
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  String formatWaktu(TimeOfDay waktu) {
    return '${waktu.hour.toString().padLeft(2, '0')}:'
        '${waktu.minute.toString().padLeft(2, '0')}';
  }

  Future<void> analisisFoto() async {
    if (fotoBarang == null) {
      showMessage(context, 'Upload foto barang terlebih dahulu.');
      return;
    }

    setState(() {
      sedangMenganalisis = true;
      sudahDianalisis = false;
    });

    // TODO: Hubungkan foto ke API AI untuk analisis sungguhan.
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      sedangMenganalisis = false;
      sudahDianalisis = true;
    });

    showMessage(
      context,
      'Tampilan analisis siap. AI belum terhubung ke backend.',
    );
  }

  void laporkanBarang() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (fotoBarang == null || tanggalDitemukan == null) {
  showMessage(
    context,
    'Upload foto dan pilih tanggal barang ditemukan.',
  );
  return;
}
    final waktuSekarang = DateTime.now();

    setState(() => waktuLaporan = waktuSekarang);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF102648),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: cyan),
            SizedBox(width: 10),
            Expanded(child: Text('Laporan siap')),
          ],
        ),
        content: Text(
          'Barang: ${namaController.text.trim()}\n'
          'Lokasi: ${lokasiController.text.trim()}\n'
          'Ditemukan: ${formatTanggal(tanggalDitemukan!)} '
          'pukul ${formatWaktu(waktuDitemukan!)}\n'
          'Dilaporkan: ${formatTanggal(waktuSekarang)} '
          'pukul ${formatWaktu(TimeOfDay.fromDateTime(waktuSekarang))}\n\n'
          'Ini masih mode UI. Data belum disimpan ke database.',
          style: const TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StarBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFF08152E),
          title: const Text(
            'Penemu Barang',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: cyan),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            children: [
              const Text(
                'Laporkan Barang Temuan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bantu pemilik menemukan barangnya kembali '
                'dengan mengisi informasi berikut.',
                style: TextStyle(color: muted, height: 1.5),
              ),
              const SizedBox(height: 24),

              _judulBagian(Icons.inventory_2_outlined, 'Informasi Barang'),
              const SizedBox(height: 14),

              const FieldLabel('Nama barang'),
              const SizedBox(height: 8),
              TextFormField(
                controller: namaController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.label_outline),
                  hintText: 'Contoh: Botol minum',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Nama barang wajib diisi'
                        : null,
              ),
              const SizedBox(height: 18),

              const FieldLabel('Lokasi ditemukan'),
              const SizedBox(height: 8),
              TextFormField(
                controller: lokasiController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'Contoh: Laboratorium Jaringan',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty
                        ? 'Lokasi wajib diisi'
                        : null,
              ),
              const SizedBox(height: 18),

              const FieldLabel('Tanggal ditemukan'),
              const SizedBox(height: 8),
              _tombolPilihan(
                icon: Icons.calendar_month_outlined,
                teks: tanggalDitemukan == null
                    ? 'Pilih tanggal ditemukan'
                    : formatTanggal(tanggalDitemukan!),
                onTap: pilihTanggal,
              ),
              const SizedBox(height: 18),
              const FieldLabel('Pilih Loker'),
const SizedBox(height: 8),

Row(
  children: [
    Expanded(
      child: _kartuLoker(
        nomor: 1,
        tersedia: true,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: _kartuLoker(
        nomor: 2,
        tersedia: true,
      ),
    ),
  ],
),
const SizedBox(height: 18),
              const FieldLabel('Waktu ditemukan'),
              const SizedBox(height: 8),
              Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: panel,
    borderRadius: BorderRadius.circular(17),
    border: Border.all(
      color: const Color(0xFF30394A),
    ),
  ),
  child: Row(
    children: [
      const Icon(Icons.access_time, color: cyan),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          '${formatWaktu(waktuDitemukan)} WIB',
        ),
      ),
      const Icon(
        Icons.auto_awesome,
        color: cyan,
      ),
    ],
  ),
),
              const SizedBox(height: 24),

              _judulBagian(Icons.photo_camera_outlined, 'Foto Barang'),
              const SizedBox(height: 12),

              InkWell(
                onTap: pilihFoto,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: panel.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF30394A),
                    ),
                  ),
                  child: fotoBarang == null
                      ? const Column(
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              color: cyan,
                              size: 44,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Pilih Foto Barang',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Gunakan foto yang jelas dan tidak buram.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                fotoBarang!,
                                height: 190,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit_outlined,
                                    color: cyan, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Ganti foto',
                                  style: TextStyle(color: cyan),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              _judulBagian(Icons.auto_awesome, 'Analisis AI'),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF102648),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF17618E),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Identifikasi karakteristik barang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'AI nantinya membantu mengenali jenis, warna, '
                      'merek, dan ciri visual dari foto barang.',
                      style: TextStyle(color: muted, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed:
                            sedangMenganalisis ? null : analisisFoto,
                        icon: sedangMenganalisis
                            ? const SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(
                          sedangMenganalisis
                              ? 'Memproses...'
                              : 'Analisis Foto dengan AI',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cyan,
                          side: const BorderSide(color: cyan),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    if (sudahDianalisis) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Status: Integrasi AI belum aktif. '
                        'Silakan isi ciri barang pada catatan tambahan.',
                        style: TextStyle(
                          color: Color(0xFFFFD580),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const FieldLabel('Catatan tambahan / ciri khusus'),
              const SizedBox(height: 8),
              TextFormField(
                controller: catatanController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 65),
                    child: Icon(Icons.notes_outlined),
                  ),
                  hintText:
                      'Contoh: Ada stiker nama, goresan di sisi kanan, '
                      'atau isi barang tertentu.',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Waktu pelaporan akan tercatat otomatis saat tombol '
                'lapor ditekan, terpisah dari waktu barang ditemukan.',
                style: TextStyle(
                  color: muted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: laporkanBarang,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text(
                    'Laporkan Barang',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: cyan,
                    foregroundColor: navy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _judulBagian(IconData icon, String judul) {
    return Row(
      children: [
        Icon(icon, color: cyan, size: 23),
        const SizedBox(width: 9),
        Text(
          judul,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  
  
  Widget _tombolPilihan({
    required IconData icon,
    required String teks,
    required VoidCallback onTap,
  }) {
    return Material(
      color: panel,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFF30394A),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: cyan),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  teks,
                  style: TextStyle(
                    color: teks.startsWith('Pilih')
                        ? muted
                        : Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: muted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kartuLoker({
    required int nomor,
    required bool tersedia,
  }) {
    final bool dipilih = lokerDipilih == nomor;

    return InkWell(
      onTap: tersedia
          ? () {
              setState(() {
                lokerDipilih = nomor;
              });
            }
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: !tersedia
              ? const Color(0xFF454B56)
              : dipilih
                  ? const Color(0xFF16A765)
                  : const Color(0xFF174B37),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dipilih
                ? const Color(0xFF4ADE80)
                : const Color(0xFF596273),
          ),
        ),
        child: Column(
          children: [
            Icon(
              tersedia
                  ? Icons.lock_open_rounded
                  : Icons.lock_rounded,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'LOKER $nomor',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              !tersedia
                  ? 'Terisi'
                  : dipilih
                      ? 'Dipilih'
                      : 'Tersedia',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
