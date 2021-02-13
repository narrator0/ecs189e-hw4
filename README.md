# Homework 4

### Team Data Pirates

| Name | SID |
|------|-----|
| Hao Huang | 917258657 |
| Huichueh Lo | 915070701 |
| Justin Lim | 915207228 |
| Subin Yun | 913994892 |
| Thu Vo | 917260098 |


## Note for the graders
We did HW4 based on the HW 3 Solution provided. Everything should work properly.


## HomeViewController

### createButtonPressed
This function is triggered when "Create" is pressed. It prompts user to enter a new account name, but also provides a default name as a placeholder if user input is empty. 

### updateWallet
This helper function passing a response and update wallet's information accordingly. This function is used when Home VC is first launched in setValues (see below) and when the popup ends (see popupDidEnd below). It's also used in account modiciation in AccountVC.

### setValues
This function calls Api.user to set up and launch the Home VC's initial screen.

### formatMoney
This helper function passes in a Double value and returns the value as a String value.


## AccountViewController

### viewWillAppear
This overrided function should animate the view as well as matching the title of this view to the current account index we're viewing.

### formatMoney
See formatMoney under HomeViewController >> Methods.

### doneButtonPressed
This action function should take us from the Account VC back to the Home VC.

### depositButtonPressed
This function uses UIAlertController to call a alert popup, asking user to enter an amount to depsit into the current account using Api.deposit.

### withdrawButtonPressed
This function uses UIAlertController to call a alert popup. If user tries to withdraw more than their current balance, the current balance will be emptied automatically. Look at checkBalance (see below) for more implementation detail.

### checkBalance
This helper function passes a Double value and returns a Double value. The input Double value is the amount user enters and is compared to the current balance. Whichever value is smaller is returned to the withdrawButtonPressed function (see above).

### transferButtonPressed
This function will show the custom popup for the user to select which account and amount to transfer. The actual transfer will be dealt in `popupDidEnd`.

### popupDidEnd
This is a implementation of the protocol from the custom popup. In the controller, it is for handling transfers when the user presses done. This function simply take the account to tranfer and the amount. Then, call `Api.transfer`.


### deleteButtonPressed
This function calls Api.remove Account to remove the current account in the list of accounts in wallet and update the wallet accordingly. This button pressed should also lead user back to the Home VC.

## PopupEnded Protocol

### popupDidEnd
This will be called when popup is closed. It will pass the users input.

### popupValueIsValid
This can be used to reject certain inputs. In our case, if the user wants to create an account that already exists, this will return false and not call `popupDidEnd`. Additionally, it will show whatever error message that needs to display.

## CustomPopup

This is our custom UIView that is a popup. It allows the user to change to have a title + input + done button (for create account) or a data picker + input + done button (for transfer). It is created such that it can be as general purpose as possible. The user can set whatever title, input field placeholder, input field keyboard type, and error message they want.

If the user wants to have a data picker, the user can call `setPicker(true)` to enable the data picker. Then, set the selectable choices via `setPickerData`.

