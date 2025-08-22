import 'package:flutter/material.dart';
import 'carteirinha_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isMenuExpanded = false;
  late AnimationController _animationController;

  final List<String> _menuItems = [
    'Meus Cursos',
    'Catálogo',
    'Trilhas',
    'Certificados',
    'Favoritos',
    'Perfil',
    'Configurações',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuExpanded = !_isMenuExpanded;
    });
    
    if (_isMenuExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A3E),
      body: Stack(
        children: [
          // Conteúdo Principal (sempre em tela cheia)
          Column(
            children: [
              // Header com botão de menu e título da seção
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E2E),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF404040)),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white70,
                      ),
                      onPressed: _toggleMenu,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _menuItems[_selectedIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Conteúdo da página
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
          
          // Menu Lateral (overlay)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return _animationController.value > 0 ? Stack(
                children: [
                  // Backdrop/overlay escuro
                  FadeTransition(
                    opacity: _animationController,
                    child: GestureDetector(
                      onTap: _toggleMenu,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  // Menu lateral
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    )),
                    child: Container(
                      width: 250,
                      height: double.infinity,
                      color: const Color(0xFF1E1E2E),
                      child: Column(
                        children: [
                          // Header do menu com logo
                          Container(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white70,
                                  ),
                                  onPressed: _toggleMenu,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      height: 60,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Seção do usuário
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Column(
                              children: [
                                // Foto do usuário
                                Transform.rotate(
                                  angle: -1.5708, // -90 graus em radianos
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF7ED321),
                                      image: const DecorationImage(
                                        image: AssetImage('assets/images/user.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: const SizedBox(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Nome do usuário
                                const Text(
                                  'Lygia Eler',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                
                                // Matrícula
                                const Text(
                                  'Mat: 20231001',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const Divider(color: Color(0xFF404040)),
                          
                          // Menu Items
                          Expanded(
                            child: ListView.builder(
                              itemCount: _menuItems.length,
                              itemBuilder: (context, index) {
                                final isSelected = _selectedIndex == index;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF7ED321).withOpacity(0.1) : null,
                                    borderRadius: BorderRadius.circular(8),
                                    border: isSelected 
                                        ? Border.all(color: const Color(0xFF7ED321).withOpacity(0.3))
                                        : null,
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      _getIconForMenuItem(index),
                                      color: isSelected ? const Color(0xFF7ED321) : Colors.white70,
                                    ),
                                    title: Text(
                                      _menuItems[index],
                                      style: TextStyle(
                                        color: isSelected ? const Color(0xFF7ED321) : Colors.white70,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                      _toggleMenu(); // Fecha o menu após seleção
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          // Footer do menu
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Divider(color: Color(0xFF404040)),
                                ListTile(
                                  leading: const Icon(Icons.logout, color: Colors.white70),
                                  title: const Text(
                                    'Sair',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ) : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForMenuItem(int index) {
    switch (index) {
      case 0: return Icons.school;
      case 1: return Icons.library_books;
      case 2: return Icons.route;
      case 3: return Icons.workspace_premium;
      case 4: return Icons.favorite;
      case 5: return Icons.person;
      case 6: return Icons.settings;
      default: return Icons.circle;
    }
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildMeusCursos();
      case 1:
        return _buildCatalogo();
      case 2:
        return _buildTrilhas();
      case 3:
        return _buildCertificados();
      case 4:
        return _buildFavoritos();
      case 5:
        return _buildPerfil();
      case 6:
        return _buildConfiguracoes();
      default:
        return _buildMeusCursos();
    }
  }

  Widget _buildMeusCursos() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de pesquisa
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF404040)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white54),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pesquisar cursos...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Seção Data Science e Machine Learning
            const Text(
              'Data Science e Machine Learning',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCourseCardHorizontal(
                    'Cientista de Dados',
                    'Python, Pandas, Machine Learning',
                    'Completo',
                    Colors.orange,
                    'assets/images/data_science.jpeg',
                  ),
                  const SizedBox(width: 16),
                  _buildCourseCardHorizontal(
                    'Projeto Aplicado - Data Science e Machine Learning',
                    'Projeto prático com dados reais',
                    'Completo',
                    Colors.blue,
                    'assets/images/machine_learning.jpg',
                  ),
                  const SizedBox(width: 16),
                  _buildCourseCardHorizontal(
                    'Deep Learning Avançado',
                    'TensorFlow, PyTorch, Neural Networks',
                    'Em Andamento',
                    Colors.purple,
                    'assets/images/deep_learning.jpeg',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Seção Cursos Livres
            const Text(
              'Cursos Livres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 320,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCourseCardVertical(
                    'Imersão Do Zero ao Topo Experience',
                    'Desenvolvimento completo de carreira',
                    'Conhecer',
                    const Color(0xFF7ED321),
                    'assets/images/tech_imersion.jpg',
                  ),
                  const SizedBox(width: 16),
                  _buildCourseCardVertical(
                    'Carreira Tech Global',
                    'Construa sua carreira tech no exterior com segurança',
                    'Iniciante',
                    Colors.green,
                    'assets/images/tech_carrer.jpg',
                  ),
                  const SizedBox(width: 16),
                  _buildCourseCardVertical(
                    'Desenvolvimento Web Completo',
                    'HTML, CSS, JavaScript, React',
                    'Intermediário',
                    Colors.cyan,
                    'assets/images/web.jpg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCardHorizontal(String title, String subtitle, String status, Color color, String imagePath) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  Colors.black54,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Badge de status
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: status == 'Completo' ? const Color(0xFF7ED321) : Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Conteúdo
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCardVertical(String title, String subtitle, String level, Color color, String imagePath) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF404040)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do curso
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  color.withOpacity(0.3),
                  BlendMode.overlay,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Badge de nível
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (level == 'Conhece' || level == 'Conhecer') ? const Color(0xFF7ED321) : Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Conteúdo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Color(0xFF404040)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Detalhes',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7ED321),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Comprar',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(int index) {
    final courses = [
      {'title': 'Flutter Avançado', 'progress': 0.7, 'color': Colors.blue},
      {'title': 'Dart Fundamentals', 'progress': 0.4, 'color': Colors.green},
      {'title': 'UI/UX Design', 'progress': 0.9, 'color': Colors.purple},
      {'title': 'Firebase Backend', 'progress': 0.2, 'color': Colors.orange},
      {'title': 'State Management', 'progress': 0.6, 'color': Colors.red},
      {'title': 'Clean Architecture', 'progress': 0.8, 'color': Colors.teal},
    ];
    
    final course = courses[index % courses.length];
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF404040)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: (course['color'] as Color).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.play_circle_fill,
                color: course['color'] as Color,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              course['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: course['progress'] as double,
              backgroundColor: const Color(0xFF404040),
              valueColor: AlwaysStoppedAnimation<Color>(course['color'] as Color),
            ),
            const SizedBox(height: 4),
            Text(
              '${((course['progress'] as double) * 100).toInt()}% concluído',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogo() {
    return const Center(
      child: Text(
        'Catálogo de Cursos',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildTrilhas() {
    return const Center(
      child: Text(
        'Trilhas de Aprendizado',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildCertificados() {
    return const Center(
      child: Text(
        'Meus Certificados',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildFavoritos() {
    return const Center(
      child: Text(
        'Cursos Favoritos',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildPerfil() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com ações
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white70),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Card do perfil
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF404040)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  
                  // Foto do usuário
                  Transform.rotate(
                    angle: -1.5708, // -90 graus em radianos
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF7ED321),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/user.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nome
                  const Text(
                    'Lygia Eler',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Matrícula
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7ED321).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF7ED321).withOpacity(0.5)),
                    ),
                    child: const Text(
                      'Mat: 20231001',
                      style: TextStyle(
                        color: Color(0xFF7ED321),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Informações pessoais
            const Text(
              'Informações Pessoais',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Card de informações
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF404040)),
              ),
              child: Column(
                children: [
                  _buildInfoTile(Icons.email, 'Email', 'lygia.eler@gmail.com'),
                  _buildDivider(),
                  _buildInfoTile(Icons.phone, 'Telefone', '(27) 98135-5528'),
                  _buildDivider(),
                  _buildInfoTile(Icons.cake, 'Data de Nascimento', '15/03/1995'),
                  _buildDivider(),
                  _buildInfoTile(Icons.location_on, 'Endereço', 'Vila Velha, ES'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Ações do perfil
            const Text(
              'Ações',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Card de ações
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF404040)),
              ),
              child: Column(
                children: [
                  _buildActionTile(
                    Icons.badge,
                    'Visualizar Carteirinha',
                    'Exibir carteirinha digital',
                    const Color(0xFF7ED321),
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CarteirinhaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    Icons.lock,
                    'Alterar Senha',
                    'Modificar senha de acesso',
                    Colors.blue,
                    () {
                      // TODO: Implementar alteração de senha
                    },
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    Icons.notifications,
                    'Notificações',
                    'Configurar preferências',
                    Colors.orange,
                    () {
                      // TODO: Implementar configurações de notificação
                    },
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    Icons.help,
                    'Ajuda e Suporte',
                    'Central de ajuda',
                    Colors.purple,
                    () {
                      // TODO: Implementar ajuda
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF404040),
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildConfiguracoes() {
    return const Center(
      child: Text(
        'Configurações',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}