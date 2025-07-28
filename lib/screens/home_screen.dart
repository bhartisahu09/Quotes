import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/provider/quotes_provider.dart';
import 'package:quotes_app/utils/utils.dart';
import '../widgets/quote_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final GlobalKey _quoteCardKey = GlobalKey();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.deepPurple),
    );
  }

  Future<void> _handleSaveImage() async {
    final success = await DataUtils.saveQuoteAsImage(_quoteCardKey);
    _showSnackBar(
        success ? 'Quote saved to gallery!' : 'Failed to save image.');
  }

  Future<void> _handleShareText() async {
    await DataUtils.shareQuoteAsText(context);
  }

  void _handleCopyText() {
    DataUtils.copyQuoteText(context);
    _showSnackBar('Quote copied!');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspirational Quotes',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 65, 47, 94),
        actions: [
          if (!provider.loading &&
              provider.error == null &&
              provider.quotes.isNotEmpty)
            IconButton(
                icon: const Icon(Icons.copy, color: Colors.white),
                onPressed: _handleCopyText),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              // colors: [Colors.black, Color(0xFF9C27B0)],
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: provider.loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : provider.error != null
                ? Center(
                    child: Text(provider.error!,
                        style: const TextStyle(color: Colors.white)))
                : PageView.builder(
                    controller: _pageController,
                    itemCount: provider.quotes.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: provider.setCurrentIndex,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = (_pageController.page! - index);
                            value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
                          }
                          return Center(
                            child: Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value,
                                child: index == provider.currentIndex
                                    ? RepaintBoundary(
                                        key: _quoteCardKey,
                                        child: QuoteCard(
                                          text: provider.quotes[index]['text']!,
                                          author: provider.quotes[index]
                                              ['author']!,
                                          image: provider.quotes[index]
                                              ['image']!,
                                        ),
                                      )
                                    : QuoteCard(
                                        text: provider.quotes[index]['text']!,
                                        author: provider.quotes[index]
                                            ['author']!,
                                        image: provider.quotes[index]['image']!,
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
      floatingActionButton:
          provider.loading || provider.error != null || provider.quotes.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: _handleSaveImage,
                  backgroundColor: Colors.white,
                  icon: const Icon(Icons.save, color: Colors.deepPurple),
                  label: const Text('Save',
                      style: TextStyle(color: Colors.deepPurple)),
                ),
      bottomNavigationBar:
          provider.loading || provider.error != null || provider.quotes.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _handleShareText,
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple),
                      ),
                      ElevatedButton.icon(
                        onPressed: _handleCopyText,
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
    );
  }
}
