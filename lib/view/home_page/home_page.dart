import 'dart:io';

import 'package:classy_e_com_demo_test_ui_1/controller/app_bar_controler.dart';
import 'package:classy_e_com_demo_test_ui_1/controller/peimary_page_controller.dart';
import 'package:classy_e_com_demo_test_ui_1/controller/product_detail_controller.dart';
import 'package:classy_e_com_demo_test_ui_1/controller/secondary_page_controller.dart';
import 'package:classy_e_com_demo_test_ui_1/model/cart_model.dart';
import 'package:classy_e_com_demo_test_ui_1/model/main_home_bottom_app_bar_model.dart';
import 'package:classy_e_com_demo_test_ui_1/model/wishlist_model.dart';
import 'package:classy_e_com_demo_test_ui_1/view/cart_page/cart_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/drawer_page/drawer_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/filter_page/filter_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/home_page/component/badge.dart';
import 'package:classy_e_com_demo_test_ui_1/view/home_page/component/body.dart';
import 'package:classy_e_com_demo_test_ui_1/view/home_page/component/search_bar.dart';
import 'package:classy_e_com_demo_test_ui_1/view/product_details/product_detail_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/profile_page/profile_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/profile_page/sub_pages/edit_address/edit_address_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/profile_page/sub_pages/help_page/help_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/profile_page/sub_pages/my_order/my_ordar_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/profile_page/sub_pages/order_status_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/profile_page/sub_pages/payment_method_page/payment_methods_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/profile_page/sub_pages/shipping_address_page/shipping_address_pages.dart';
import 'package:classy_e_com_demo_test_ui_1/view/sub_category_item/sub_category_item_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/sub_sub_categories_page/sub_sub_categories_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/top_categories_page/top_categories_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/wishList_page/wishlist_page.dart';
import 'package:classy_e_com_demo_test_ui_1/view/women_categori_Page/woman_categories_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

var scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final appBar=Provider.of<AppBarController>(context);
  int currentIndex = 0;
  //var productDetail=false;
  PrimaryScreenState appBar = PrimaryScreenState();
  @override
  void initState() {
    // TODO: implement initState
    appBar.setPrimaryState(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    appBar.dispose();
    //super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAppBar = Provider.of<PrimaryScreenState>(context);
    final primaryPageState = Provider.of<PrimaryPageController>(context);
    return WillPopScope(
      onWillPop: () async{
        final status = Provider.of<PrimaryScreenState>(context, listen: false);

        final pageState = Provider.of<SecondaryPage>(context, listen: false);
        //pageState.setSecondaryPage(5);
        if (productAppBar.status){
          if (Platform.isAndroid){
            SystemNavigator.pop();
          }else if (Platform.isIOS){
            exit(0);
          }
        }
        if (pageState.secondaryPageNo == 6){
          status.setPrimaryState(false);
          pageState.setSecondaryPage(5);
        }else{
          productAppBar.setPrimaryState(true);
          final selection = Provider.of<ProductDetailController>(context, listen: false);
          selection.sizeSelected(0);
          selection.colorSelected(0);
        }
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: productAppBar.status
            ? AppBar(
                backgroundColor: Color(0xffFFA800),
                leading: IconButton(
                  onPressed: () {
                    // Scaffold.of(context).openDrawer();
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu_open),
                ),
                title: Center(
                  child: Text("Fashion"),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: Search());
                    },
                    icon: Icon(
                      Icons.search,
                    ),
                  ),
                ],
              )
            : null,
        drawer: ComplexDrawer(),
        body: productAppBar.status
            ? _getBodyPrimary()
            : _getBodySecondary(), //ProductDetail(),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...MainHomePageBottomAppBarModel.list
                  .map((MainHomePageBottomAppBarModel data) {
                return data.isBlank
                    ? SizedBox(
                        width: 10,
                      )
                    : GestureDetector(
                        onTap: () {
                          //final primaryPageState = Provider.of<PrimaryPageController>(context);
                          primaryPageState.setPrimaryPage(data.index);
                          productAppBar.setPrimaryState(true);
                          print(data.index.toString());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // SizedBox(
                              //   height: 5,
                              // ),
                              buildCustomConsumer(
                                context,
                                data.label!,
                                data.icon!,
                                data.index,
                              ),
                              // SizedBox(
                              //   height: 12,
                              // ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  data.label!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: primaryPageState.currentIndex ==
                                                data.index //currentIndex == data.index
                                            ? Color(0xffFF6000)
                                            : Colors.grey,
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomConsumer(
      BuildContext context, String label, IconData icon, int index) {
    final size = MediaQuery.of(context).size;
    final primaryPageState = Provider.of<PrimaryPageController>(context);
    if (label == "Wishlist") {
      return Consumer<WishlistModel>(
        builder: (_, wishList, ch) {
          return Badge(
            child: ch!,
            value: wishList.itemCount.toString(),
            color: Colors.red,
          );
        },
        child: Container(
          width: size.width * .1, //50,
          child: Icon(
            icon,
            color: primaryPageState.currentIndex ==
                    index //currentIndex == data.index
                ? Color(0xffFF6000)
                : Colors.grey,
          ),
        ),
      );
    }
    if (label == "Cart") {
      return Consumer<CartModel>(
        builder: (_, cart, ch) {
          return Badge(
            child: ch!,
            value: cart.itemCount.toString(),
            color: Colors.red,
          );
        },
        child: Container(
          width: size.width * .1,
          child: Icon(
            icon,
            color: primaryPageState.currentIndex ==
                    index //currentIndex == data.index
                ? Color(0xffFF6000)
                : Colors.grey,
          ),
        ),
      );
    } else {
      return Icon(
        icon,
        color:
            primaryPageState.currentIndex == index //currentIndex == data.index
                ? Color(0xffFF6000)
                : Colors.grey,
      );
    }
  }

  _getBodyPrimary() {
    final primaryPageState = Provider.of<PrimaryPageController>(context);
    switch (primaryPageState.currentIndex) {
      case 0:
        return Home();
      case 1:
        return Wishlist(); //TopCategoriesPage();//ProductDetail();//Wishlist();
      case 2:
        return CartList();
      case 3:
        return Profile();
      default:
        return Home();
    }
  }

  _getBodySecondary() {
    final page = Provider.of<SecondaryPage>(context);

    switch (page.secondaryPageNo) {
      case 1:
        return TopCategoriesPage();
      case 2:
        return ProductDetail(); //Wishlist();
      case 3:
        return CategoryScreen();
      case 4:
        return SubCatScreen(); //FilterScreen
      case 5:
        return SubSubProductScreen();
      case 6:
        return FilterScreen(); //OrderStatus
      case 7:
        return OrderStatus(); //MyOrder
      case 8:
        return MyOrder(); //EditAddress
      case 9:
        return EditAddress(); //ShippingAddress
      case 10:
        return ShippingAddress(); //PaymentMethod
      case 11:
        return PaymentMethod(); //HelpPage
      case 12:
        return HelpPage();
      default:
        return ProductDetail();
    }
  }
}
