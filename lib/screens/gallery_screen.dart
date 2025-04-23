import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista mockada de fotos (substitua por dados reais)
    final List<Map<String, String>> photos = [
      {
        'date': '15/04/2024',
        'description': 'Brincando no parquinho',
      },
      {
        'date': '14/04/2024',
        'description': 'Hora do banho',
      },
      {
        'date': '14/04/2024',
        'description': 'Soneca da tarde',
      },
      // Adicione mais fotos conforme necessário
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotos do Pet'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquisar...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Implementar filtros
                    },
                  ),
                ),
              ],
            ),
          ),

          // Grid de fotos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.8,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return _buildPhotoCard(
                  context,
                  photos[index]['date']!,
                  photos[index]['description']!,
                );
              },
            ),
          ),
        ],
      ),
      // Botão flutuante para upload (apenas para admin)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar upload de foto
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context, String date, String description) {
    return GestureDetector(
      onTap: () {
        // Abrir visualização em tela cheia
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.photo, size: 40, color: Colors.grey),
                ),
              ),
            ),
            // Informações
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 