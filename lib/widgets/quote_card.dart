import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final String text;
  final String author;
  final String image;
  final GlobalKey? screenshotKey;

  const QuoteCard({
    Key? key,
    required this.text,
    required this.author,
    required this.image,
    this.screenshotKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace 'Unknown' with empty
    final displayAuthor = author.toLowerCase() == 'unknown' ? '' : author;

    return Container(
      key: screenshotKey,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image,
                        size: 80, color: Colors.grey),
                  ),
                );
              },
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Text and Author
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Colors.black54,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Show divider & author only if author is available
                  if (displayAuthor.isNotEmpty) ...[
                    Container(width: 60, height: 2, color: Colors.white54),
                    const SizedBox(height: 16),
                    Text(
                      '- $displayAuthor',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black45,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
