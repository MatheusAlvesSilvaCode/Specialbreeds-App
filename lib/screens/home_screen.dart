import 'dart:async';
import 'package:app_specialbreeds/screens/booking_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  int _selectedBottomNavIndex = 0; // Índice para o menu inferior
  Timer? _bannerTimer;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Instruções para hospedagem',
      'subtitle': 'Dicas e cuidados com seu parceiro(a) para a hospedagem',
      'discount': 'Dicas',
      'image': 'assets/images/banner1.png',
      'color1': Color(0xFFE0F4FF),
      'color2': Color(0xFFFFF6E7),
    },
    {
      'title': 'Nós',
      'subtitle': 'Conheça nosso espaço',
      'discount': 'Novidades',
      'image': 'assets/images/banner2.png',
      'color1': Color(0xFFFFF6E7),
      'color2': Color(0xFFFFE5EC),
    },
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Creche',
      'icon': Icons.pets,
      'color': Color(0xFFE0F4FF),
      'iconColor': Colors.amber,
    },
    {
      'title': 'Hospedagem',
      'icon': Icons.hotel,
      'color': Color(0xFFFFE5EC),
      'iconColor': Colors.amber,
    },
    {
      'title': 'Adestramento',
      'icon': Icons.school,
      'color': Color(0xFFF4EEFC),
      'iconColor': Colors.amber,
    },
  ];

  final List<Map<String, dynamic>> _appointments = [
    {
      'doctor': 'Bob',
      'specialty': 'Creche',
      'time': '11:30 AM',
      'date': 'Entrada: 15 de Junho',
      'isVideo': false,
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Fotos',
      'icon': Icons.camera_alt,
    },
    {
      'title': 'Vídeos',
      'icon': Icons.videocam,
    },
    {
      'title': 'Anotações',
      'icon': Icons.description,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (mounted) {
        final nextPage = _currentBannerIndex + 1;
        if (nextPage >= _banners.length) {
          _pageController.animateToPage(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.nextPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _onBottomNavItemTapped(int index) {
    if (index == 1) { // Somente para o botão Agendar
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookingScreen()),
      );
    } else {
      setState(() {
        _selectedBottomNavIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildBannerSlider(),
              _buildServices(),
              _buildAppointments(),
              _buildCategories(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Agendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.jpg',
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber[100],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.person,
                    color: Colors.amber,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
              _bannerTimer?.cancel();
              _startBannerTimer();
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    _showInstructionsPopup(context);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        banner['color1'],
                        banner['color2'],
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Image.asset(
                          banner['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                banner['discount'],
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              banner['title'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              banner['subtitle'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == index
                    ? Colors.amber[800]
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bem-vindos à Special Breeds Hospedagem para Pets!"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Na Special Breeds, entendemos a importância de proporcionar um ambiente seguro e acolhedor para os seus pets. Nossa hospedagem oferece:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("- Ambiente Seguro: Nossa instalação é projetada para garantir a segurança dos seus pets, sem rotas de fuga e com supervisão 24 horas."),
                Text("- Monitoramento por Câmera: Nossa sala de hospedagem é equipada com câmeras, para nós acompanharmos o bem-estar do seu pet."),
                Text("- Conforto: Oferecemos caminhas e mantas confortáveis para garantir que seu pet se sinta em casa."),
                SizedBox(height: 15),
                Text(
                  "Como Funciona:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text("1. Cadastro Fácil: Faça o seu cadastro em nosso aplicativo intuitivo."),
                Text("2. Escolha as Datas: Selecione as datas de check-in e check-out que melhor se adequam ao seu planejamento."),
                SizedBox(height: 15),
                Text(
                  "Importante:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text("- Vacinação: É necessário que o pet esteja com todas as vacinas em dia."),
                Text("- Controle de Pulgas: Também exigimos que os pets estejam com o controle de pulgas atualizado."),
                SizedBox(height: 10),
                Text(
                  "Nossa equipe está ansiosa para receber o seu pet e proporcionar o melhor cuidado possível. Entre em contato conosco para mais informações ou para tirar qualquer dúvida. Estamos aqui para ajudar!",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Serviços',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: service['color'],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        service['icon'],
                        color: service['iconColor'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Próximos Agendamentos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _appointments.length,
          itemBuilder: (context, index) {
            final appointment = _appointments[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          appointment['time'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment['doctor'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          appointment['specialty'],
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          appointment['date'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (appointment['isVideo'])
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.videocam,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Categorias',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'],
                      size: 40,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['title'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}