import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
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
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: MenuPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuPrincipal extends StatefulWidget {
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _currentIndex = 0;

  List<Map<String, dynamic>> get _tabs => [
    {
      'icon': Icons.home,
      'label': 'Inicio',
      'widget': MenuGrid(onTabSelected: (i) => setState(() => _currentIndex = i)),
    },
    {
      'icon': Icons.account_balance_wallet,
      'label': 'Saldo',
      'widget': ConsultaSaldo(),
    },
    {
      'icon': Icons.list_alt,
      'label': 'Reportar',
      'widget': Center(child: Text('Sección reportar')),
    },
    {
      'icon': Icons.settings,
      'label': 'Ajustes',
      'widget': Center(child: Text('Sección ajustes')),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/pattern.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
              alignment: Alignment.topLeft,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: _tabs[_currentIndex]['widget'],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFF007E8C), width: 4)),
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final item = _tabs[index];
            final sel = index == _currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = index),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (sel)
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFB347),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(item['icon'] as IconData, size: 24, color: Colors.white),
                        )
                      else
                        Icon(item['icon'] as IconData, size: 24, color: Color(0xFF007E8C)),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: sel ? Color(0xFFFFB347) : Colors.grey,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
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

class MenuGrid extends StatelessWidget {
  final Function(int)? onTabSelected;
  const MenuGrid({this.onTabSelected, Key? key}) : super(key: key);

  static const _botones = [
    {'icon': Icons.place, 'label': 'Planear ruta', 'color': Color(0xFF4AC5EA)},
    {'icon': Icons.account_balance_wallet, 'label': 'Consultar saldo', 'color': Color(0xFFFFB347)},
    {'icon': Icons.warning_amber_rounded, 'label': 'Rutas', 'color': Color(0xFFEF5B5B)},
    {'icon': Icons.announcement_rounded, 'label': 'Avisos', 'color': Color(0xFF6C63FF)},
    {'icon': Icons.support_agent, 'label': 'Atención al usuario', 'color': Color(0xFF8BC34A)},
    {'icon': Icons.public, 'label': 'Portal web', 'color': Color(0xFF00BFA5)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Image.asset('assets/images/logo_trasca.png', height: 120),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: _botones.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32,
                crossAxisSpacing: 24,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (_, i) {
                final b = _botones[i];
                return GestureDetector(
                  onTap: () {
                    if (b['label'] == 'Consultar saldo') onTabSelected?.call(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: b['color'] as Color,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.black45, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, offset: Offset(3, 3), blurRadius: 6),
                        BoxShadow(color: Colors.white24, offset: Offset(-2, -2), blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(b['icon'] as IconData, size: 40, color: Colors.white),
                        const SizedBox(height: 12),
                        Text(
                          b['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
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
    );
  }
}

class ConsultaSaldo extends StatefulWidget {
  @override
  _ConsultaSaldoState createState() => _ConsultaSaldoState();
}

class _ConsultaSaldoState extends State<ConsultaSaldo> {
  final _ctr = TextEditingController();

  void _showError() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text('Por favor, ingresa el número de tarjeta.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar'))],
      ),
    );
  }

  void _showSaldo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Saldo'),
        content: Text('\$12.350 COP (Simulado)'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar'))],
      ),
    );
  }

  Future<void> _scan() async {
    final code = await Navigator.push(context, MaterialPageRoute(builder: (_) => ScannerPage()));
    if (code is String) setState(() => _ctr.text = code);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/pattern.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
              alignment: Alignment.topLeft,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo_trasca.png', height: 100),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text('Consulta tu saldo',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFD84315))),
                            const SizedBox(height: 12),
                            const Text('Ingresa o escanea el número de tu tarjeta'),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _ctr,
                              decoration: InputDecoration(
                                hintText: 'Número de tarjeta',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _scan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4AC5EA),
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              ),
                              child: Text('Escanear código'),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _ctr.text.isEmpty ? _showError : _showSaldo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF6F00),
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              ),
                              child: Text('Consultar'),
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
        ],
      ),
    );
  }
}

class ScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Escanear tarjeta'), backgroundColor: Colors.orange),
      body: MobileScanner(
        controller: MobileScannerController(facing: CameraFacing.back),
        onDetect: (capture) {
          final code = capture.barcodes.first.rawValue;
          if (code != null) Navigator.pop(context, code);
        },
      ),
    );
  }
}
