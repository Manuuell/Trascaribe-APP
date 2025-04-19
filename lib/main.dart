import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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

  final _tabs = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _tabs.addAll([
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
        'widget': AjustesPage(),
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1 sola vez: patrón de fondo repe­ti­do en toda la pantalla
        Positioned.fill(
          child: Image.asset(
            'assets/images/pattern.png',
            repeat: ImageRepeat.repeat,
            fit: BoxFit.none,
            alignment: Alignment.topLeft,
          ),
        ),

        // Scaffold transparente sobre el pattern
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          extendBody: true,  // permite que el body se extienda debajo del bottomNav
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: _tabs[_currentIndex]['widget'] as Widget,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFF007E8C), width: 4)),
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final item = _tabs[i];
                final selected = i == _currentIndex;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _currentIndex = i),
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
        ),
      ],
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
  final TextEditingController _ctr = TextEditingController();
  bool _loading = false;
  String? _saldo;
  String? _error;

  Future<void> _consultar() async {
    final num = _ctr.text.trim();
    if (num.isEmpty) {
      setState(() => _error = 'Ingresa un número de tarjeta.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _saldo = null;
    });
    final url = Uri.parse(
      'https://recaudo.sondapay.com/recaudowsrest/producto/consultaTrx',
    );
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Origin': 'https://transcaribe.gov.co',
    };
    final body = jsonEncode({
      'nivelConsulta': 1,
      'tipoConsulta': 2,
      'numExterno': num,
    });
    try {
      final resp = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(resp.body);
      if (resp.statusCode == 200 && data['estado'] == 0) {
        setState(() => _saldo = data['saldo']);
      } else {
        setState(() => _error = data['mensaje'] ?? 'Error desconocido');
      }
    } catch (e) {
      setState(() => _error = 'Error de red: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _scan() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ScannerPage()),
    );
    if (code != null) _ctr.text = code;
  }

  @override
  Widget build(BuildContext context) {
    // NO Scaffold aquí: lo maneja MenuPrincipal y su Stack con el pattern
    final topPadding = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/images/logo_trasca.png', height: 100),
              const SizedBox(height: 24),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Consulta tu saldo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD84315),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ingresa o escanea el número de tu tarjeta',
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ctr,
                        decoration: InputDecoration(
                          hintText: 'Número de tarjeta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: _scan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4AC5EA),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                            ),
                            child: Text('Escanear'),
                          ),
                          ElevatedButton(
                            onPressed:
                            _loading ? null : () => _consultar(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF6F00),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                            ),
                            child: _loading
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : Text('Consultar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Text(_error!,
                    style: TextStyle(color: Colors.red, fontSize: 16)),
              if (_saldo != null)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFE3600F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  margin: EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/logo_trasca.png',
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Saldo disponible',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '\$$_saldo',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RecargaPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                            padding:
                            EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: Text('Recargar'),
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


class ScannerPage extends StatelessWidget {
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Escanear tarjeta'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleTorch();
            },
          )
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final code = capture.barcodes.first.rawValue;
          if (code != null) {
            controller.stop();
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}


class RecargaPage extends StatelessWidget {
  const RecargaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pattern.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Recarga Saldo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _MetodoRecarga(icon: Icons.account_balance, label: 'Usando PSE'),
                        SizedBox(width: 32),
                        _MetodoRecarga(icon: Icons.attach_money, label: 'En efectivo'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE3600F),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo_trasca.png', height: 40, color: Colors.white),
                        const SizedBox(height: 12),
                        Text(
                          'Recarga tu tarjeta en\ncuestión de segundos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '¡Recarga tu tarjeta y sigue\nviajando con nosotros!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RecargaPseInternaPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF007E8C),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'Recargar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetodoRecarga extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetodoRecarga({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'Usando PSE') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RecargaPseInternaPage()),
          );
        }
        // Puedes agregar más condiciones para otros métodos si lo necesitas
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Icon(icon, size: 30, color: Color(0xFF007E8C)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          )
        ],
      ),
    );
  }
}

class RecargaPseInternaPage extends StatefulWidget {
  @override
  _RecargaPseInternaPageState createState() => _RecargaPseInternaPageState();
}

class _RecargaPseInternaPageState extends State<RecargaPseInternaPage> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _correoController = TextEditingController(text: 'ejemplo@correo.com');
  final List<String> _bancos = [
    'Nequi',
    'Bancolombia',
    'Davivienda',
    'Banco de Bogotá',
    'Banco AV Villas',
    'BBVA',
    'Banco de Occidente',
    'Banco Popular',
    'Banco Agrario',
    'Scotiabank Colpatria'
  ];

  String? _bancoSeleccionado;

  bool get _formularioValido =>
      _valorController.text.isNotEmpty &&
          double.tryParse(_valorController.text) != null &&
          _bancoSeleccionado != null &&
          _correoController.text.contains('@');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresa los detalles del depósito'),
        backgroundColor: Color(0xFFE3600F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Depositarás mediante PSE.', style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 24),

            // Valor
            Row(
              children: [
                Text('\$', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _valorController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 28),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0,00',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                )
              ],
            ),
            Divider(),

            // Selector PSE
            ListTile(
              leading: Image.asset('assets/images/logopse.png', width: 36),
              title: Text('PSE'),
              subtitle: Text('Selecciona tu banco y correo'),
              trailing: Icon(Icons.expand_more, color: Color(0xFFE3600F)),
            ),
            const SizedBox(height: 8),

            // Banco
            Text('Banco', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: _bancoSeleccionado,
              hint: Text('Selecciona un banco'),
              onChanged: (value) => setState(() => _bancoSeleccionado = value),
              items: _bancos.map((banco) => DropdownMenuItem(value: banco, child: Text(banco))).toList(),
            ),
            const SizedBox(height: 16),

            // Correo
            Text('Correo', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'ejemplo@correo.com'),
              onChanged: (_) => setState(() {}),
            ),
            Spacer(),

            // Botón continuar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _formularioValido
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Datos listos para enviar')),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE3600F),
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Continuar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class AjustesPage extends StatefulWidget {
  @override
  _AjustesPageState createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  bool _notificaciones = true;
  String _idioma = 'Español';
  String _tema = 'Sistema';
  final bool _logueado = false; // simula estado de sesión

  @override
  Widget build(BuildContext context) {
    // Altura de la status bar
    final statusBarHeight = MediaQuery.of(context).padding.top;
    // Altura aproximada del header: paddings + altura de icon/text (≈24)
    final headerHeight = statusBarHeight + 14 + 14 + 24;
    // Queremos que el contenedor de login baje 16px desde el bottom curve
    final loginOffset = headerHeight - 16;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Fondo de ondas
          Positioned.fill(
            child: Image.asset(
              'assets/images/pattern.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
              alignment: Alignment.topLeft,
            ),
          ),

          // HEADER naranja, detrás de la status bar
          Transform.translate(
            offset: Offset(0, -statusBarHeight),
            child: Container(
              padding: EdgeInsets.only(
                top: statusBarHeight + 14,
                bottom: 14,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF47216), Color(0xFFE3600F)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  BackButton(color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Ajustes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Espacio dinámico para situar el login justo debajo de la curva
                SizedBox(height: loginOffset),

                // Contenedor de "Iniciar sesión"
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF007E8C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _logueado
                      ? Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 28, color: Color(0xFF007E8C)),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Michael',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text('michael@gmail.com',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ],
                  )
                      : Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: navegar a login
                      },
                      icon: Icon(Icons.login, color: Color(0xFF007E8C)),
                      label: Text('Iniciar sesión',
                          style: TextStyle(
                              color: Color(0xFF007E8C),
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),

                // Lista de opciones, con padding top para separarla del login
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          icon: Icons.notifications,
                          title: 'Notificaciones',
                          value: _notificaciones,
                          onChanged: (v) =>
                              setState(() => _notificaciones = v),
                        ),
                        _buildOptionTile(
                          icon: Icons.language,
                          title: 'Idioma',
                          value: _idioma,
                          onTap: () {},
                        ),
                        _buildOptionTile(
                          icon: Icons.brightness_6,
                          title: 'Tema',
                          value: _tema,
                          onTap: () {},
                        ),
                        _buildOptionTile(
                          icon: Icons.privacy_tip,
                          title: 'Privacidad',
                          value: '',
                          onTap: () {},
                        ),
                        _buildOptionTile(
                          icon: Icons.lock,
                          title: 'Seguridad',
                          value: '',
                          onTap: () {},
                        ),
                        _buildOptionTile(
                          icon: Icons.help_outline,
                          title: 'Centro de ayuda',
                          value: '',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                // Logo pie
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo_trasca.png',
                      height: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF007E8C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFFE3600F),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Color(0xFF007E8C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            if (value.isNotEmpty)
              Text(value, style: TextStyle(color: Colors.white70)),
            Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
