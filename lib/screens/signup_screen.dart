import 'package:flutter/material.dart';
import 'package:sweatly/app_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _obscure = true;
  bool _accept = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_accept) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous devez accepter les termes.')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // TODO: remplacer par Auth
    if (mounted) {
      // Après inscription: poursuivre le flux (ex: onboarding profil)
      Navigator.pushReplacementNamed(context, AppRouter.profileSetup);
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
            // Logo
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 56,
                    errorBuilder: (_, __, ___) => const Icon(Icons.autorenew, size: 56),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Inscription', style: Theme.of(context).textTheme.headlineSmall),
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
                      labelText: 'Password',
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

            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _accept,
                  onChanged: (v) => setState(() => _accept = v ?? false),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    children: [
                      const Text("J’accepte les "),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Termes: à venir')),
                        ),
                        child: Text(
                          "Termes d’utilisation",
                          style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Text(" et les "),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Politique de confidentialité: à venir')),
                        ),
                        child: Text(
                          "politiques de confidentialité",
                          style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Text("."),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
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
                child: _loading ? const CircularProgressIndicator() : const Text('Continue'),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    label: 'Google',
                    assetPath: 'assets/google.png',
                    bg: cs.surface,
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Google: à venir')));
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
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('TikTok: à venir')));
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.login),
                child: const Text("Déjà inscrit ? Connectez-vous."),
              ),
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
