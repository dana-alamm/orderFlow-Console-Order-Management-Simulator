abstract class Product{
final String sku;
final String name;
final double price;

Product({
  required this.sku,
  required this.name,
  required this.price,


});
void fulfillment();
}

class PhysicalProduct extends Product{
  int _stock;

  PhysicalProduct({
    required super.sku,
    required super.name,
    required super.price,
    required int initialStock,
  }):_stock=initialStock;

  int get stock=>_stock;

  set stock(int value){
    if(value<0){
      throw Exception("Stock cannot be negative");
    }
    _stock=value;
  }
  @override 
  void fulfillment(){
    print('Shipping physical products:$name');
  }
}
class DigitalProduct extends Product{
  DigitalProduct({
  required super.sku,
  required super.name,
  required super.price,
  });
  @override
  void fulfillment(){
    print('Sending download link for:$name');
  }
}