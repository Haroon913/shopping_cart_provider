import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart_provider/cart_model.dart';
import 'package:shopping_cart_provider/cart_provider.dart';
import 'package:shopping_cart_provider/cart_screen.dart';
import 'package:shopping_cart_provider/db_helper.dart';
class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}
class _ProductListState extends State<ProductList> {
  DBHelper? dbHelper=DBHelper();
  List<String> productName = ["Laptop", "Smartphone", "Headphones", "Smartwatch", "Tablet", "Camera", "Printer", "Bluetooth Speaker", "PlayStation", "Fitness Tracker", "External Hard Drive", "Ear Buds"];
  List<int> productPrice = [999, 499, 79, 149, 299, 449, 129, 59, 399, 199, 299, 79,];
  List<String> productBrand = ["HP", "Apple", "Sony", "Microsoft", "Dell", "HP", "Lenovo", "Asus", "Acer", "LG", "Canon", "Nikon",];
  List<String> productImage=[
    'https://images.pexels.com/photos/13791390/pexels-photo-13791390.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/8382689/pexels-photo-8382689.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/1649771/pexels-photo-1649771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/1334600/pexels-photo-1334600.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/2070069/pexels-photo-2070069.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/51383/photo-camera-subject-photographer-51383.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://cdn.pixabay.com/photo/2016/12/16/06/56/printer-1910685_1280.png',
    'https://cdn.pixabay.com/photo/2020/08/09/17/07/speaker-5476085_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/05/19/14/09/ps4-2326616_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/12/13/12/37/heart-rate-monitoring-device-1903997_1280.jpg',
    'https://cdn.pixabay.com/photo/2021/01/03/19/45/computer-harddrive-5885485_1280.jpg',
    'https://images.pexels.com/photos/11189086/pexels-photo-11189086.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];


  @override
  Widget build(BuildContext context) {
    final cart =Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        centerTitle: true,
        actions:  [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent:Consumer<CartProvider>(
                  builder: (context,value,child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                  },),
                badgeAnimation: badges.BadgeAnimation.rotation(
                  animationDuration: Duration(seconds: 1),
                ),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: productName.length,
              itemBuilder: (context,index){
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image(
                          height: 110,width: 110,
                            fit: BoxFit.cover,
                            image: NetworkImage(productImage[index].toString())),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productName[index].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              Text(productBrand[index].toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,),),
                              SizedBox(height: 12,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.orange
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(r"$"+productPrice[index].toString(),style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: (){
                                    dbHelper?.insert(Cart(
                                        id: index,
                                        productId: index.toString(),
                                        productName: productName[index].toString(),
                                        initialPrice: productPrice[index],
                                        productPrice: productPrice[index],
                                        quantity: 1,
                                        tag: productBrand[index].toString(),
                                        image: productImage[index].toString(),)
                                    ).then((value){
                                      print('product is added to cart');
                                      cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                      cart.addCounter();
                                    }).onError((error, stackTrace) {
                                      print(error.toString());
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.orange
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Center(child: Text("Add to Cart",style:TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            );
          }))
        ],
      ),
    );
  }
}
