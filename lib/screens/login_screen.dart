import 'package:flutter/material.dart';
import 'package:sweatly/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'example@email.com');
  final _pwdCtrl = TextEditingController(text: 'password123');
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // TODO: remplacer par Auth
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          children: [
            // --- Logo + Nom app ---
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 56,
                    errorBuilder: (_, __, ___) => const Icon(Icons.autorenew, size: 56),
                  ),
                  const SizedBox(height: 6),
                  Text('Sweatly', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Connexion', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Bienvenue, veuillez vous connecter.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty || !v.contains('@')) ? 'Email invalide' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pwdCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? 'Min. 6 caractères' : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _loading ? null : _submit,
                child: _loading ? const CircularProgressIndicator() : const Text('Connexion'),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text('Connexion avec les réseaux sociaux',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    label: 'Google',
                    assetPath: 'assets/google.png',
                    bg: cs.surface,
                    onTap: () {
                      // TODO: Sign in with Google
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google: à venir')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SocialButton(
                    label: 'Tiktok',
                    assetPath: 'assets/tiktok.png',
                    bg: Colors.black,
                    fg: Colors.white,
                    onTap: () {
                      // TODO: Sign in with TikTok
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('TikTok: à venir')),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text('Mot de passe oublié ?'),
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Fonction à venir')));
                  },
                ),
                TextButton(
                  child: const Text('Inscription'),
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.signup),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String assetPath;
  final Color? bg;
  final Color? fg;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.assetPath,
    this.bg,
    this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg ?? Theme.of(context).colorScheme.onSurface,
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              height: 18,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 16),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
