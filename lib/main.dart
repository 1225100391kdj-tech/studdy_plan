import 'package:flutter/material.dart';

void main() {
  runApp(const StudyPlanApp());
}

class StudyPlanApp extends StatelessWidget {
  const StudyPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyPlan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F5F0), // Fondo crema principal
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Pantalla de inicio de sesión -> lleva a MainScreen
    );
  }
}

class TaskItem {
  final String category;
  final String title;
  final String dueDate;
  final String priority; // 'ALTA', 'MEDIA', 'BAJA'
  bool isCompleted;

  TaskItem({
    required this.category,
    required this.title,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista inicial de tareas de la interfaz original
  final List<TaskItem> _tasks = [
    TaskItem(
      category: 'CALCULO DE VARIAS VARIABLES',
      title: 'Resolver problemario de derivadas',
      dueDate: 'Mañana, 14:00',
      priority: 'ALTA',
    ),
    TaskItem(
      category: 'APLICACIONES WEB',
      title: 'Rehacer todo el CSS de mi web',
      dueDate: 'Viernes 18, 23:59',
      priority: 'MEDIA',
    ),
    TaskItem(
      category: 'ESTRUCTURA DE DATOS',
      title: 'Hacer las torres de hanoi',
      dueDate: 'Lunes 21, 10:00',
      priority: 'BAJA',
    ),
  ];

  // Paleta de colores reutilizables
  static const Color primaryGreen = Color(0xFF5E7D6A);
  static const Color cardBg = Colors.white;
  static const Color textDark = Color(0xFF2C2C2C);
  static const Color textMuted = Color(0xFF7A7A7A);

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'ALTA':
        return const Color(0xFFD87D73);
      case 'MEDIA':
        return const Color(0xFFE2A86B);
      case 'BAJA':
        return const Color(0xFF81A280);
      default:
        return textMuted;
    }
  }

  void _showAddTaskModal() {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final dateController = TextEditingController();
    String selectedPriority = 'ALTA';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 24,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nueva Tarea',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Materia / Categoría',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Fecha de entrega (ej. Mañana, 14:00)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                border: OutlineInputBorder(),
              ),
              items: ['ALTA', 'MEDIA', 'BAJA'].map((priority) {
                return DropdownMenuItem(value: priority, child: Text(priority));
              }).toList(),
              onChanged: (val) {
                if (val != null) selectedPriority = val;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    setState(() {
                      _tasks.add(TaskItem(
                        category: categoryController.text.isEmpty
                            ? 'GENERAL'
                            : categoryController.text.toUpperCase(),
                        title: titleController.text,
                        dueDate: dateController.text.isEmpty ? 'Hoy' : dateController.text,
                        priority: selectedPriority,
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Guardar Tarea', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = _tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = _tasks.where((t) => t.isCompleted).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // Vista 0: Inicio / Tareas Pendientes
              _buildHomeView(pendingTasks),
              // Vista 1: Tareas Completadas
              _buildCompletedView(completedTasks),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        backgroundColor: primaryGreen,
        elevation: 3,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFEAE8E2), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFFF6F5F0),
          selectedItemColor: primaryGreen,
          unselectedItemColor: textMuted,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              activeIcon: Icon(Icons.check_circle_rounded),
              label: 'Completadas',
            ),
          ],
        ),
      ),
    );
  }

  // Seccion Principal (Inicio)
  Widget _buildHomeView(List<TaskItem> pendingTasks) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        // Encabezado con Perfil
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'StudyPlan',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '¡Hola, Sofía! Organiza tu día.',
                  style: TextStyle(fontSize: 14, color: textMuted),
                ),
              ],
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFE5EBE5),
              child: const Text(
                'S',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 24),

        // Subtítulo de Tareas Pendientes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tareas pendientes (${pendingTasks.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Ver todas',
                style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),

        // Lista de Tareas Pendientes
        if (pendingTasks.isEmpty)
          _buildEmptyCard('¡No tienes tareas pendientes!')
        else
          ...pendingTasks.map((task) => _buildTaskCard(task)).toList(),

        const SizedBox(height: 24),

        // Sección de Proyectos Grupales
        const Text(
          'Proyectos grupales',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 12),

        // Tarjeta vacía de proyectos grupales
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFECEAE4)),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFEEF2EE),
                child: const Icon(Icons.people_outline, color: primaryGreen, size: 26),
              ),
              const SizedBox(height: 12),
              const Text(
                '¡Todo al día por aquí!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'No tienes proyectos grupales activos en este momento.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80), // Margen para el FAB
      ],
    );
  }

  // Tarjeta de Tarea Individual
  Widget _buildTaskCard(TaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila Superior: Categoria y Etiqueta de Prioridad
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.priority,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Título de la Tarea
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Fila Inferior: Fecha de Entrega y Checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: textMuted),
                  const SizedBox(width: 6),
                  Text(
                    'Entrega: ${task.dueDate}',
                    style: const TextStyle(fontSize: 13, color: textMuted),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    task.isCompleted = !task.isCompleted;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.isCompleted ? primaryGreen : textMuted,
                      width: 2,
                    ),
                    color: task.isCompleted ? primaryGreen : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: task.isCompleted ? Colors.white : Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Vista de Tareas Completadas
  Widget _buildCompletedView(List<TaskItem> completedTasks) {
    return ListView(
      children: [
        const SizedBox(height: 16),
        const Text(
          'Tareas Completadas',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 16),
        if (completedTasks.isEmpty)
          _buildEmptyCard('Aún no has completado ninguna tarea.')
        else
          ...completedTasks.map((task) => _buildTaskCard(task)).toList(),
      ],
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: textMuted, fontSize: 14),
        ),
      ),
    );
  }
}

// ============================================================================
//  PANTALLA NUEVA: INICIO DE SESIÓN (LoginScreen)
//  Se conecta con la interfaz existente: al iniciar sesión navega a MainScreen.
//  No modifica nada de TaskItem / MainScreen.
// ============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  // Paleta de la pantalla de login (basada en la captura de referencia)
  static const Color _bg = Color(0xFFFAF9F5);
  static const Color _sage = Color(0xFF758D78);
  static const Color _sageSoft = Color(0xFFECF0EA);
  static const Color _ink = Color(0xFF2B2B26);
  static const Color _muted = Color(0xFF77766F);
  static const Color _line = Color(0xFFE6E4DE);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Navega a la pantalla principal (la de las tareas)
  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: _sage,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Escribe un correo electrónico válido.');
      return;
    }
    if (password.isEmpty) {
      _showMessage('Escribe tu contraseña.');
      return;
    }
    _goToHome();
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: color, width: 1.2),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _muted, fontSize: 16),
      prefixIcon: Icon(icon, color: _muted, size: 24),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: border(_line),
      focusedBorder: border(_sage),
      border: border(_line),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
      ),
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: SizedBox(
        height: 52,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: _line, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _sageSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: _sage, size: 30),
                  ),
                ),
                const SizedBox(height: 28),

                // Título y subtítulo
                const Text(
                  'StudyPlan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Tu compañero de estudio calmado, ordenado y eficiente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: _muted, height: 1.4),
                ),
                const SizedBox(height: 36),

                // Correo
                _label('Correo electrónico'),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 16, color: _ink),
                  decoration: _fieldDecoration(
                    hint: 'ejemplo@dominio.com',
                    icon: Icons.mail_outline_rounded,
                  ),
                ),
                const SizedBox(height: 22),

                // Contraseña
                _label('Contraseña'),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onLogin(),
                  style: const TextStyle(fontSize: 16, color: _ink),
                  decoration: _fieldDecoration(
                    hint: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: _muted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Recordarme / Olvidaste contraseña
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _rememberMe ? _sage : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _rememberMe ? _sage : _line,
                                  width: 1.5,
                                ),
                              ),
                              child: _rememberMe
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Recordarme',
                              style: TextStyle(fontSize: 15, color: _muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showMessage(
                          'La recuperación de contraseña estará disponible pronto.'),
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          color: _sage,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Botón principal
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _sage,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // Divisor
                Row(
                  children: const [
                    Expanded(child: Divider(color: _line, thickness: 1.2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'o continúa con',
                        style: TextStyle(fontSize: 15, color: _muted),
                      ),
                    ),
                    Expanded(child: Divider(color: _line, thickness: 1.2)),
                  ],
                ),
                const SizedBox(height: 22),

                // Google / Apple
                Row(
                  children: [
                    _socialButton(
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      text: 'Google',
                      onTap: _goToHome,
                    ),
                    const SizedBox(width: 14),
                    _socialButton(
                      icon: const Icon(Icons.apple, size: 26, color: _ink),
                      text: 'Apple',
                      onTap: _goToHome,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(fontSize: 16, color: _muted),
                    ),
                    GestureDetector(
                      onTap: () => _showMessage(
                          'El registro estará disponible pronto.'),
                      child: const Text(
                        'Regístrate gratis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _sage,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Términos
                const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13.5, color: _muted, height: 1.5),
                    children: [
                      TextSpan(text: 'Al continuar, aceptas nuestros '),
                      TextSpan(
                        text: 'Términos de servicio',
                        style: TextStyle(
                          color: _ink,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' y '),
                      TextSpan(
                        text: 'Política de privacidad',
                        style: TextStyle(
                          color: _ink,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}