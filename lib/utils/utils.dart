import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/quotes_provider.dart';

class DataUtils {
  /// Save Quote as Image
  static Future<bool> saveQuoteAsImage(GlobalKey quoteCardKey) async {
    try {
      final RenderRepaintBoundary boundary =
          quoteCardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(
        pngBytes,
        quality: 100,
        name: 'quote_${DateTime.now().millisecondsSinceEpoch}',
      );
      return result['isSuccess'];
    } catch (e) {
      return false;
    }
  }

  /// Share Quote as Text
  static Future<void> shareQuoteAsText(BuildContext context) async {
    final quote = context.read<QuoteProvider>().currentQuote;
    final text = '"${quote['text']}"\n- ${quote['author']}';
    await Share.share(text);
  }

  /// Copy Quote Text
  static void copyQuoteText(BuildContext context) {
    final quote = context.read<QuoteProvider>().currentQuote;
    Clipboard.setData(
      ClipboardData(text: '"${quote['text']}"\n- ${quote['author']}'),
    );
  }
}
