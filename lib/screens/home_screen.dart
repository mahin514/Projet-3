import 'package:flutter/material.dart';
import 'package:sweatly/app_router.dart'; // si tu as défini des routes. Sinon, retire les Navigator.pushNamed.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Pas d'AppBar: écran épuré comme la maquette
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _SearchField(), // champ de recherche rond, centré
          ),
        ),
      ),

      // Barre d'icônes en bas, arrondie (comme dans le screenshot)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavIcon(
                  icon: Icons.home_filled,
                  onTap: () {
                    // On est déjà sur Home
                  },
                ),
                _NavIcon(
                  icon: Icons.search,
                  onTap: () {
                    // Navigation optionnelle
                    // Navigator.pushNamed(context, AppRouter.search);
                  },
                ),
                _NavIcon(
                  icon: Icons.fitness_center,
                  onTap: () {
                    // Navigator.pushNamed(context, AppRouter.workout);
                  },
                ),
                _NavIcon(
                  icon: Icons.menu_book,
                  onTap: () {
                    // Navigator.pushNamed(context, AppRouter.library);
                  },
                ),
                _NavIcon(
                  icon: Icons.person,
                  onTap: () {
                    // Navigator.pushNamed(context, AppRouter.profileSetup);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      splashRadius: 24,
      tooltip: '',
    );
  }
}
