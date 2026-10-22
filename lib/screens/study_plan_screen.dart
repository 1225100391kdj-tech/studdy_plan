import 'package:flutter/material.dart';

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

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  int _currentIndex = 0;

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
              initialValue: selectedPriority,
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
              _buildHomeView(pendingTasks),
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

  Widget _buildHomeView(List<TaskItem> pendingTasks) {
    return ListView(
      children: [
        const SizedBox(height: 16),
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
        if (pendingTasks.isEmpty)
          _buildEmptyCard('¡No tienes tareas pendientes!')
        else
          ...pendingTasks.map((task) => _buildTaskCard(task)),
        const SizedBox(height: 24),
        const Text(
          'Proyectos grupales',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 12),
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
        const SizedBox(height: 80),
      ],
    );
  }

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
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 12),
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
          ...completedTasks.map((task) => _buildTaskCard(task)),
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