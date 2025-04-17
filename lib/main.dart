import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Status bar transparente + iconos claros
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(TranscaribeApp());
}

class TranscaribeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transcaribe',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MenuPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuButton {
  final IconData icon;
  final String label;
  final Color color;
  const MenuButton({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class MenuPrincipal extends StatefulWidget {
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _currentIndex = 0;

  final List<MenuButton> _botones = const [
    MenuButton(icon: Icons.place,                label: 'Planear ruta',        color: Color(0xFF4AC5EA)),
    MenuButton(icon: Icons.account_balance_wallet, label: 'Consultar saldo',    color: Color(0xFFFFB347)),
    MenuButton(icon: Icons.warning_amber_rounded,  label: 'Rutas',              color: Color(0xFFEF5B5B)),
    MenuButton(icon: Icons.announcement_rounded,   label: 'Avisos',             color: Color(0xFF6C63FF)),
    MenuButton(icon: Icons.support_agent,          label: 'Atención al usuario',color: Color(0xFF8BC34A)),
    MenuButton(icon: Icons.public,                 label: 'Portal web',         color: Color(0xFF00BFA5)),
  ];

  final List<Map<String, dynamic>> _tabs = const [
    {'icon': Icons.home,                   'label': 'Inicio'},
    {'icon': Icons.account_balance_wallet, 'label': 'Saldo'},
    {'icon': Icons.list_alt,               'label': 'Reportar'},
    {'icon': Icons.settings,               'label': 'Ajustes'},
  ];

  @override
  Widget build(BuildContext context) {
    // Sacamos el padding superior (status bar) para compensarlo manualmente
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      // 2) Permitimos dibujar bajo la status bar
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          // Patrón de fondo en toda la pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/images/pattern.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.cover,
            ),
          ),

          // Contenido desplazado hacia abajo topPadding px
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              children: [
                // Espacio extra y logo centrado
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/logo_trasca.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                // Grid de botones
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: _botones.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (ctx, i) {
                        final btn = _botones[i];
                        return GestureDetector(
                          onTap: () => print('Abrir ${btn.label}'),
                          child: Container(
                            decoration: BoxDecoration(
                              color: btn.color,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.black45, width: 2),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, offset: Offset(3,3), blurRadius: 6),
                                BoxShadow(color: Colors.white24, offset: Offset(-2,-2), blurRadius: 6),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(btn.icon, size: 40, color: Colors.white),
                                const SizedBox(height: 12),
                                Text(
                                  btn.label,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Barra de navegación inferior personalizada
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFF007E8C), width: 4)),
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final item = _tabs[index];
            final selected = index == _currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selected)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFB347),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(item['icon'], size: 24, color: Colors.white),
                        )
                      else
                        Icon(item['icon'], size: 24, color: Color(0xFF007E8C)),
                      const SizedBox(height: 4),
                      Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? Color(0xFFFFB347) : Colors.grey,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
