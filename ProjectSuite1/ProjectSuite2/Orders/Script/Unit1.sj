function Main()
{
  try
  {
    // Enter your code here. 
  }
  catch(exception)
  {
    Log.Error("Exception", exception.description);
  }
}


function Open()
{
  TestedApps.Orders.Run();
}


function NewOrder()
{
  var  orders;
  var  orderForm;
  var  groupBox;
  var  textBox;
  var  dateTimePicker;
  var custName;
  orders = Aliases.Orders;
  orderForm = orders.OrderForm;
  groupBox = orderForm.Group;
  
  //заполняем форму данными из файла-хранилища 

  Driver = DDT.CSVDriver(Project.Path + "\\Stores\\CSV Storage.txt");
  for (var i = 0; !Driver.EOF(); i++)
  {
    orders.MainForm.MainMenu.Click("Orders|New order..."); 
    groupBox.ProductNames.ClickItem(Driver.Value(1));
    groupBox.Quantity.wValue = Driver.Value(2); 
    groupBox.Price.WndCaption = Driver.Value(11);
    groupBox.Discount.WndCaption = Driver.Value(12);
    dateTimePicker = groupBox.Date;
    dateTimePicker.wDate = Driver.Value(3);
    groupBox.Customer.wText = Driver.Value(0);
    textBox = groupBox.Street;
    textBox.wText = Driver.Value(4);
    textBox = groupBox.City;
    textBox.wText = Driver.Value(5);
    textBox = groupBox.State;
    textBox.wText = Driver.Value(6);
    textBox = groupBox.Zip;
    textBox.wText = Driver.Value(7);
    groupBox.WinFormsObject(Driver.Value(8)).ClickButton();
    textBox = groupBox.CardNo;
    textBox.wText = Driver.Value(9);
    groupBox.ExpDate.wDate = Driver.Value(10);
    orderForm.ButtonOK.ClickButton();
    custName = orders.MainForm.WinFormsObject("OrdersView").Columns.Item(0).ListView.Items.Item(i).Text; // Customer Name в таблице ордеров 
    
    //чекпойнт
    aqObject.CompareProperty(custName, cmpEqual, Driver.Value(0), false);
    
    Driver.Next();
  }
}


function EditOrder()
{
  var  orders;
  var  orderForm;
  var  textBox;
  var mainForm;
  var numOfOrders;
  orders = Aliases.Orders;
  orderForm = orders.OrderForm;
  textBox = orderForm.Group.Customer;
  mainForm = orders.MainForm;
  numOfOrders = mainForm.WinFormsObject("OrdersView").wItemCount; //количество ордеров в форме
  for(var i=0; i<numOfOrders; i++)
  {
    mainForm.WinFormsObject("OrdersView").ClickItem(i);
    mainForm.MainMenu.Click("Orders|Edit order...");
    var j = i+1;
    textBox.wText = "Customer " + j;
    orderForm.ButtonOK.ClickButton();
    custName = orders.MainForm.WinFormsObject("OrdersView").Columns.Item(0).ListView.Items.Item(i).Text; // Customer Name в таблице ордеров   
    //чекпойнт
    aqObject.CompareProperty(custName, cmpEqual, "Customer " + j, false);    
  } 
}

function DeleteOrders()
{
  var  orders;
  var  mainForm;
  var  numOfOrders;
  orders = Aliases.Orders;
  mainForm = orders.MainForm;
  
  while (mainForm.WinFormsObject("OrdersView").wItemCount != 0)
  {
    mainForm.OrdersView.ClickItem(0);
    mainForm.MainMenu.Click("Orders|Delete order");
    orders.dlgConfirmation.btnYes.ClickButton(); 
  }
}



function Close()
{
  var  orders = Aliases.Orders; 
  orders.MainForm.Close();
  orders.dlgConfirmation.btnNo.ClickButton();
}

