import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopping_cart_provider/cart_model.dart';
import 'package:shopping_cart_provider/productlist.dart';
import 'cart_provider.dart';
import 'db_helper.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper=DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart =Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Products"),
        centerTitle: true,
        actions:  [
          Center(
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
          SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(future: cart.getData(), builder: (context,AsyncSnapshot<List<Cart>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('images/cart.png'),width: 150,height: 150,),
                        SizedBox(height: 5,),
                        Text('You cart is empty',style: Theme.of(context).textTheme.subtitle1,),
                        SizedBox(height: 5,),
                        ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                        }, child: Text('Add Products'))
                      ],
                    ),
                  );
                }
                else{
                  return Expanded(child:ListView.builder(
                      itemCount: snapshot.data! .length,
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
                                        image: NetworkImage(snapshot.data![index].image.toString())
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data![index].productName.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                              InkWell(
                                                  onTap: (){
                                                    dbHelper!.delete(snapshot.data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));

                                                  },
                                                  child: Icon(Icons.delete,))
                                            ],),
                                          Text(snapshot.data![index].tag.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,),),
                                          SizedBox(height: 12,),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.orange
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Text(r"$"+snapshot.data![index].productPrice.toString(),style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: (){},
                                              child: Container(
                                                height: 35,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.orange
                                                ),
                                                child: Padding(
                                                  padding:  EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      InkWell(
                                                          onTap: (){
                                                            int quantity=snapshot.data![index].quantity!;
                                                            int price=snapshot.data![index].initialPrice!;
                                                            quantity--;
                                                            int? newPrice=price*quantity;
                                                            if(quantity>0){
                                                              dbHelper!.updateQuantity(Cart(
                                                                  id: snapshot.data![index].id!,
                                                                  productId: snapshot.data![index].id!.toString(),
                                                                  productName: snapshot.data![index].productName!,
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  productPrice: newPrice,
                                                                  quantity: quantity,
                                                                  tag: snapshot.data![index].tag!,
                                                                  image: snapshot.data![index].image!.toString())
                                                              ).then((value){
                                                                newPrice=0;
                                                                quantity=0;
                                                                cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                              }).onError((error, stackTrace) {
                                                                print(error.toString());
                                                              });
                                                            }

                                                          },
                                                          child: Icon(Icons.remove)),
                                                      Text(snapshot.data![index].quantity.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                                      InkWell(
                                                          onTap: (){
                                                            int quantity=snapshot.data![index].quantity!;
                                                            int price=snapshot.data![index].initialPrice!;
                                                            quantity++;
                                                            int? newPrice=price*quantity;
                                                            dbHelper!.updateQuantity(Cart(
                                                                id: snapshot.data![index].id!,
                                                                productId: snapshot.data![index].id!.toString(),
                                                                productName: snapshot.data![index].productName!,
                                                                initialPrice: snapshot.data![index].initialPrice!,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                tag: snapshot.data![index].tag!,
                                                                image: snapshot.data![index].image!.toString())
                                                            ).then((value){
                                                              newPrice=0;
                                                              quantity=0;
                                                              cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                            }).onError((error, stackTrace) {
                                                              print(error.toString());
                                                            });
                                                          },
                                                          child: Icon(Icons.add)),
                                                    ],),
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
                      }));
                }

              }
              return Text('');
            }),
            Consumer<CartProvider>(builder: (context,value,child){
              return Visibility(
                visible:value.getTotalPrice().toStringAsFixed(2)=='0.00'?false:true ,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: ResuableWidget(title: 'Sub Total',value: r'$'+value.getTotalPrice().toStringAsFixed(2), )
                      ),
                    )

                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
class ResuableWidget extends StatelessWidget {
  final String title,value;
  const ResuableWidget({super.key, required this.value,required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.subtitle2 ,),
          Text(value.toString(),style: Theme.of(context).textTheme.subtitle2 ,)
        ],
      ),
    );
  }
}

