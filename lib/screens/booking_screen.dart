import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Variáveis de estado
  DateTime? checkInDate;
  DateTime? checkOutDate;
  String? selectedPet;
  String? selectedService;
  bool hasVeterinarian = false;
  bool addVeterinarian = false;
  double totalValue = 0.0;
  bool showVeterinarianForm = false;
  int selectedBottomNavIndex = 1;

  // Informações do veterinário
  String? veterinarianName;
  String? veterinarianPhone;
  String? veterinarianAddress;
  String? veterinarianNotes;

  // Lista de animais disponíveis
  final List<String> pets = ['Rex', 'Luna', 'Bolt'];
  final String petImagePath = 'assets/images/sample_dog.jpg';

  void calculateTotalValue() {
    double total = 0.0;

    if (selectedService == 'Hotel') {
      if (checkInDate != null && checkOutDate != null) {
        int numberOfDays = checkOutDate!.difference(checkInDate!).inDays;
        total += numberOfDays * 70;
      }
    } else if (selectedService == 'Creche - Período Integral') {
      total += 50;
    } else if (selectedService == 'Creche - Meio Período') {
      total += 35;
    }

    setState(() {
      totalValue = total;
    });
  }

  Future<void> selectDate({required bool isCheckIn}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.amber,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.amber,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = pickedDate;
          if (checkOutDate != null && checkOutDate!.isBefore(pickedDate)) {
            checkOutDate = null;
          }
        } else {
          if (checkInDate != null && pickedDate.isAfter(checkInDate!)) {
            checkOutDate = pickedDate;
          } else if (checkInDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Selecione primeiro a data de entrada')),
            );
            return;
          }
        }
        calculateTotalValue();
      });
    }
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      selectedBottomNavIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Seção 1: Período da Estadia
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Período da Estadia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DateSelectionButton(
                          label: 'Data de Entrada',
                          date: checkInDate,
                          onTap: () => selectDate(isCheckIn: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DateSelectionButton(
                          label: 'Data de Saída',
                          date: checkOutDate,
                          onTap: () => selectDate(isCheckIn: false),
                        ),
                      ),
                    ],
                  ),
                  if (checkInDate != null && checkOutDate != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Total de ${checkOutDate!.difference(checkInDate!).inDays} noite(s)',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seção 2: Seleção do Animal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seu Animal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      hintText: 'Selecione seu animal',
                    ),
                    value: selectedPet,
                    onChanged: (value) {
                      setState(() {
                        selectedPet = value;
                      });
                    },
                    items: pets.map((pet) {
                      return DropdownMenuItem<String>(
                        value: pet,
                        child: Text(pet),
                      );
                    }).toList(),
                  ),
                  if (selectedPet != null) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(petImagePath),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.deepPurple.withOpacity(0.3),
                                width: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            selectedPet!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Idade: 3 anos | Raça: Labrador',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seção 3: Seleção de Serviço
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tipo de Serviço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ServiceOption(
                        title: 'Hotel',
                        price: 'R\$ 70 por noite',
                        isSelected: selectedService == 'Hotel',
                        onSelect: () {
                          setState(() {
                            selectedService = 'Hotel';
                            calculateTotalValue();
                          });
                        },
                      ),
                      ServiceOption(
                        title: 'Creche - Período Integral',
                        price: 'R\$ 50 por dia',
                        isSelected: selectedService == 'Creche - Período Integral',
                        onSelect: () {
                          setState(() {
                            selectedService = 'Creche - Período Integral';
                            calculateTotalValue();
                          });
                        },
                      ),
                      ServiceOption(
                        title: 'Creche - Meio Período',
                        price: 'R\$ 35 por dia',
                        isSelected: selectedService == 'Creche - Meio Período',
                        onSelect: () {
                          setState(() {
                            selectedService = 'Creche - Meio Período';
                            calculateTotalValue();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seção 4: Informações do Veterinário - MODIFICADA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox "Veterinário Special Breeds"
                  Row(
                    children: [
                      Checkbox(
                        value: addVeterinarian,
                        onChanged: (value) {
                          setState(() {
                            addVeterinarian = value!;
                            hasVeterinarian = false;
                            showVeterinarianForm = false;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                      const Text(
                        'Veterinário Special Breeds',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  // Checkbox "Já tenho veterinário"
                  Row(
                    children: [
                      Checkbox(
                        value: hasVeterinarian,
                        onChanged: (value) {
                          setState(() {
                            hasVeterinarian = value!;
                            addVeterinarian = false;
                            showVeterinarianForm = value!;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                      const Text(
                        'Já possuo um veterinário cadastrado',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  // Mensagem quando Special Breeds está selecionado
                  if (addVeterinarian) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Nosso veterinário especializado cuidará do seu pet!',
                      style: TextStyle(
                        color: Colors.green,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  // Formulário do veterinário (só aparece quando hasVeterinarian = true)
                  if (showVeterinarianForm) ...[
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nome completo do veterinário',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => veterinarianName = value,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Telefone para contato',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => veterinarianPhone = value,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Endereço da clínica',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => veterinarianAddress = value,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Observações importantes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (value) => veterinarianNotes = value,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seção 5: Resumo e Confirmação
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.deepPurple.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Resumo do Agendamento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SummaryItem(
                    label: 'Serviço selecionado:',
                    value: selectedService ?? 'Nenhum serviço selecionado',
                  ),
                  SummaryItem(
                    label: 'Período reservado:',
                    value: checkInDate != null && checkOutDate != null
                        ? '${DateFormat('dd/MM/yyyy', 'pt_BR').format(checkInDate!)} - ${DateFormat('dd/MM/yyyy', 'pt_BR').format(checkOutDate!)}'
                        : 'Período não definido',
                  ),
                  SummaryItem(
                    label: 'Animal:',
                    value: selectedPet ?? 'Nenhum animal selecionado',
                  ),
                  if (addVeterinarian)
                    SummaryItem(
                      label: 'Veterinário:',
                      value: 'Special Breeds',
                    ),
                  if (hasVeterinarian && veterinarianName != null)
                    SummaryItem(
                      label: 'Veterinário:',
                      value: veterinarianName!,
                    ),
                  const Divider(height: 30, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Valor Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ ${totalValue.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: confirmBooking,
                      child: const Text(
                        'CONFIRMAR AGENDAMENTO',
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomNavIndex,
        onTap: onBottomNavItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
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

  void confirmBooking() {
    if (selectedPet == null || selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um animal e um serviço'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedService == 'Hotel' && (checkInDate == null || checkOutDate == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Para serviço de hotel, selecione as datas de entrada e saída'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação de Agendamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deseja confirmar este agendamento com os seguintes detalhes?'),
            const SizedBox(height: 20),
            Text('Animal: $selectedPet'),
            Text('Serviço: $selectedService'),
            if (checkInDate != null && checkOutDate != null)
              Text('Período: ${DateFormat('dd/MM/yyyy', 'pt_BR').format(checkInDate!)} - ${DateFormat('dd/MM/yyyy', 'pt_BR').format(checkOutDate!)}'),
            if (addVeterinarian)
              const Text('Veterinário: Special Breeds'),
            if (hasVeterinarian && veterinarianName != null)
              Text('Veterinário: $veterinarianName'),
            Text('Valor Total: R\$ ${totalValue.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agendamento confirmado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class DateSelectionButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const DateSelectionButton({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: date != null ? Colors.deepPurple.withOpacity(0.1) : null,
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today,
            size: 20,
            color: date != null ? Colors.amber : Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            date != null
                ? DateFormat('dd/MM/yyyy', 'pt_BR').format(date!)
                : label,
            style: TextStyle(
              color: date != null ? Colors.amber : Colors.grey,
              fontWeight: date != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceOption extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onSelect;

  const ServiceOption({
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.amber : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const SummaryItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}