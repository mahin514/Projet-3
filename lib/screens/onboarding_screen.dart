import 'package:flutter/material.dart';
import 'package:sweatly/app_router.dart'; // Si tu as des routes. Sinon, remplace les Navigator par ce que tu veux.

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _step = 0;

  // État minimal
  final _nameCtrl = TextEditingController(text: ''); // ex: John Doe
  int? _age;
  String _gender = 'H'; // H/F/Autre simple
  int? _height; // cm
  int? _weight; // kg
  String? _goal; // Perdre du poids, etc.

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      setState(() => _step += 1);
      _pageCtrl.animateToPage(
        _step,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      // Dernière étape: aller où tu veux (signup / home / profile setup)
      // Ici on va vers Home par défaut:
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, AppRouter.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _step == 2 ? 'Quel est ton objectif principal' : 'Parle nous de toi',
        ),
        actions: [
          TextButton(onPressed: _skip, child: const Text('Ignorer')),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageCtrl,
          physics: const NeverScrollableScrollPhysics(), // On force le bouton "Continuer"
          children: [
            _Step1(
              nameCtrl: _nameCtrl,
              age: _age,
              onAgeChanged: (v) => setState(() => _age = v),
              gender: _gender,
              onGenderChanged: (v) => setState(() => _gender = v),
            ),
            _Step2(
              height: _height,
              onHeightChanged: (v) => setState(() => _height = v),
              weight: _weight,
              onWeightChanged: (v) => setState(() => _weight = v),
            ),
            _Step3(
              selectedGoal: _goal,
              onGoalSelected: (g) => setState(() => _goal = g),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _next,
              child: Text(_step < 2 ? 'Continuer' : 'Terminer'),
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== ÉTAPE 1 =====================
class _Step1 extends StatelessWidget {
  final TextEditingController nameCtrl;
  final int? age;
  final ValueChanged<int?> onAgeChanged;
  final String gender; // 'H', 'F', 'A'
  final ValueChanged<String> onGenderChanged;

  const _Step1({
    required this.nameCtrl,
    required this.age,
    required this.onAgeChanged,
    required this.gender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ages = List<int>.generate(70, (i) => i + 12); // 12..81
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          Text('Hi there! Nice to see you again.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: age,
            items: ages
                .map((a) => DropdownMenuItem<int>(value: a, child: Text(a.toString())))
                .toList(),
            onChanged: onAgeChanged,
            decoration: const InputDecoration(
              labelText: 'Âge',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text('Genre', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              _GenderCircle(
                icon: Icons.male,
                selected: gender == 'H',
                onTap: () => onGenderChanged('H'),
                tooltip: 'Homme',
              ),
              const SizedBox(width: 16),
              _GenderCircle(
                icon: Icons.female,
                selected: gender == 'F',
                onTap: () => onGenderChanged('F'),
                tooltip: 'Femme',
              ),
              const SizedBox(width: 16),
              _GenderCircle(
                icon: Icons.transgender,
                selected: gender == 'A',
                onTap: () => onGenderChanged('A'),
                tooltip: 'Autre / Préfère ne pas dire',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderCircle extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String tooltip;

  const _GenderCircle({
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = selected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest;
    final fg = selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: fg),
        ),
      ),
    );
  }
}

// ===================== ÉTAPE 2 =====================
class _Step2 extends StatelessWidget {
  final int? height;
  final ValueChanged<int?> onHeightChanged;
  final int? weight;
  final ValueChanged<int?> onWeightChanged;

  const _Step2({
    required this.height,
    required this.onHeightChanged,
    required this.weight,
    required this.onWeightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final heights = List<int>.generate(121, (i) => i + 120); // 120..240
    final weights = List<int>.generate(181, (i) => i + 40); // 40..220

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: height,
            items: heights
                .map((h) => DropdownMenuItem<int>(value: h, child: Text('$h cm')))
                .toList(),
            onChanged: onHeightChanged,
            decoration: const InputDecoration(
              labelText: 'Taille',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: weight,
            items: weights
                .map((w) => DropdownMenuItem<int>(value: w, child: Text('$w kg')))
                .toList(),
            onChanged: onWeightChanged,
            decoration: const InputDecoration(
              labelText: 'Poids',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== ÉTAPE 3 =====================
class _Step3 extends StatelessWidget {
  final String? selectedGoal;
  final ValueChanged<String> onGoalSelected;

  const _Step3({
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    final goals = const [
      'Perdre du poids',
      'Prendre du muscle',
      'Améliorer son endurance',
      'Travailler / Forme générale',
      'Maintenir son poids actuel',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: goals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final g = goals[i];
          final isSelected = g == selectedGoal;
          return SizedBox(
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => onGoalSelected(g),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(g),
              ),
            ),
          );
        },
      ),
    );
  }
}
