// lib/utils/formatting.dart

abstract class ReceiptPrinter {
  void printReceipt(String receiptText);
}

class ConsoleReceiptPrinter implements ReceiptPrinter {
  @override
  void printReceipt(String receiptText) {
    print('\n======== INVOICE / RECEIPT ========');
    print(receiptText);
    print('===================================\n');
  }
}


