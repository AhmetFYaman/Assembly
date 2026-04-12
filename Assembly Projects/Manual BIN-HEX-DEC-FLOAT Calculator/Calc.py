"""
Ahmet Yaman
This is a number converter program that converts between decimal, binary, float, any-base and hexadecimal number systems.
The code was written by me, some parts were inspired by various online resources.
The parts inspired by AI tool(chatgpt) will be marked.

"""
import Validator #inspired by me but its content was modified with the help of an AI tool(chatgpt)
from Validator import *  # get all functions from Validator.py



hexValues = {  # a disctionary to map hexadecimal digits to their decimal values to help with conversion of hexadecimal numbers
    '0': 0,
    '1': 1,     # P.S. its a global dictionary, so it can be accessed from anywhere
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'A': 10,
    'B': 11,
    'C': 12,
    'D': 13,
    'E': 14,
    'F': 15
}

# the opposite of the list above, but a short cut way, inspired by Ai tool(chatgpt), to help with conversion to hexadecimal
decToHexValues = {v: k for k, v in hexValues.items()} 


def binToDec(binNum):   # basic binary to decimal conversion function
    decNum = 0      
    power = 0
    for bit in binNum[::-1]:   # read the binary number from right to left 
        decNum += int(bit) * (2 ** power)   # for every bit multiply by 2 raised to the power of its position (starting from 0)
        power += 1       
    return decNum

def hexToDec(hexNum):      # basic hexadecimal to decimal conversion function
    decimal_number = 0
    power = 0
    for digit in hexNum[::-1]:   # read from rigth to left again
        decimal_number += hexValues[digit.upper()] * (16 ** power)  # use the dictionary to get the decimal value of the hex 
        power += 1                                              # digit and multiply by 16 raised to the power of its position    
        
    return decimal_number

def decToBin(decNum):   # basic decimal to binary conversion function
    binNum = ""
    if decNum == 0: # check if we have a 0 for binary
        return '0' 
    while decNum > 0:   
        binNum = str(decNum % 2) + binNum   # get the remainder when divided by 2 and add it to the left
        decNum = decNum // 2             #  of the stored binary number to write it in correct order
    return binNum

def decToHex(decNum):  # basic decimal to hexadecimal conversion function
    if decNum == 0:
        return "0"

    hexNum = ""

    while decNum > 0:
        hexNum = decToHexValues[decNum % 16] + hexNum  # get the remainder when divided by 16 and use 
        decNum //= 16             # the dictionary to get the hex digit and add it to the left of the stored hex number

    return hexNum

def binToHex(binNum):  # binary to hexadecimal conversion function using previous functions
    decNum = binToDec(binNum)
    return decToHex(decNum)


def hexToBin(hexNum):  # hexadecimal to binary conversion function using previous functions
    decNum = hexToDec(hexNum)
    return decToBin(decNum)


def floatToBin(floatNum, precision=10):  # floating-point to binary conversion function with predefined precision parameter in case...
    fl_ints = int(floatNum) # inspired by online resources -  drops the decimal part
    fl_dec = floatNum - fl_ints # now that we have integer part, we can drop that one to get decimal part

    finBinary = decToBin(fl_ints) + "." # collect binary here

    for _ in range(precision): # lets not run too too much, limit to precision parameter
        fl_dec *= 2    # multiple decimal part by 2

        if fl_dec >= 1:     # if the result is 1 or more
            finBinary += "1"   # add 1 to the binary result
            fl_dec -= 1       # drop the integer part again        -- algorithm inspired by online resources
        else:                                                      # i mean if it works it works
            finBinary += "0"  # else add 0 to the binary result

        if fl_dec == 0:       # if decimal part is 0, we are done
            break

    return finBinary


def decToBase(decNum, base):   # decimal to any-base conversion function
    baseNum = "" # where we will store the result
    while decNum > 0:   #while there are still numbers to convert
        baseNum = decToHexValues[decNum % base] + baseNum  # use the dictionary to get the digit for the base and add it to the left of the stored number
        decNum //= base  # reduce the decimal number by a factor of the base
    return baseNum

def baseToDec(baseNum, base):   # any-base to decimal conversion function
    decimal_number = 0
    power = 0
    for digit in baseNum[::-1]:   # read from right to left
        decimal_number += hexValues[digit.upper()] * (base ** power)   # use the dictionary to get the decimal value of the digit and 
        power += 1                                             # multiply by base raised to the power of its position       
    return decimal_number

def validateBase(baseNum, base):   # function to validate if a number is valid in a given base
    for digit in baseNum.upper():    # for each digit 
        if digit not in hexValues or hexValues[digit] >= base:   # check if its in the dictionary and if its value is less than the base
            return False
    return True


print("Welcome to the converter program!")
print("We dont support negative numbers.")
print("You can convert between DEC, BIN, HEX, FLOAT and ANY-B (any-base) number systems.")
print("----------------------------------------------")

repeat = True

while repeat:

    # using the validator functions from Validator.py to get safe inputs from user using the validation parameter and the prompt paramter
    numType = ValidString(["DEC", "BIN", "HEX", "FLOAT", "ANY-B"], "Please enter the type of number you have (DEC, BIN, HEX, FLOAT, ANY-B): ")


    if numType == "DEC": # if its decimal
        decNum = ValidPosInt("Please enter a positive decimal integer (base-10 number, no decimal points): ")  # ask for the decimal number
        convertTo = ValidString(["DEC", "BIN", "HEX"], "Please enter the type of number you want to convert to (DEC, BIN, HEX): ") # ask for the conversion type

    elif numType == "BIN":  # if its binary
        binNum = ValidBin("Please enter a binary number (base-2 number): " ) # ask for the binary number
        convertTo = ValidString(["DEC", "BIN", "HEX", "FLOAT"], "Please enter the type of number you want to convert to (DEC, BIN, HEX, FLOAT): ") # ask for the conversion type

    elif numType == "HEX": 
        hexNum = ValidPosHex("Please enter a hexadecimal number (base-16 number): ") # ask for the hexadecimal number
        convertTo = ValidString(["DEC", "BIN", "HEX"], "Please enter the type of number you want to convert to (DEC, BIN, HEX): ")

    elif numType == "FLOAT":
        floatNum = ValidFloat("Please enter a floating-point number (base-10 number with decimal points): ") # ask for the floating-point number
        convertTo = ValidString(["BIN", "FLOAT"], "Please enter the type of number you want to convert to (BIN, FLOAT): ")

    elif numType == "ANY-B": # if its any-base
        baseOne = ValidPosInt("Please enter the base of the first number you have (2-16): ") # ask for the base of the first number

        baseTwo = ValidPosInt("Please enter the base of the second number you have (2-16): ") # ask for the base of the second number

        nummOne = input(f"Please enter the first number in base {baseOne}: ").upper() # ask for the first number
        while not validateBase(nummOne, baseOne): # validate the first number
            print(f"Invalid input. Please enter a valid number in base {baseOne}.")
            nummOne = input(f"Please enter the first number in base {baseOne}: ").upper()

        nummTwo = input(f"Please enter the second number in base {baseTwo}: ").upper() # ask for the second number
        while not validateBase(nummTwo, baseTwo): # validate the second number
            print(f"Invalid input. Please enter a valid number in base {baseTwo}.")
            nummTwo = input(f"Please enter the second number in base {baseTwo}: ").upper()

        decNumOne = baseToDec(nummOne, baseOne) # convert the numbers to decimal base 10 to perform operations easily
        decNumTwo = baseToDec(nummTwo, baseTwo)

        operation = ValidString(["1", "2"], "Please enter the operation to perform (1:ADD, 2:MULTIPLY): ") # ask for the operation to perform

        if operation == "1": 
            resultDec = decNumOne + decNumTwo
        else: 
            resultDec = decNumOne * decNumTwo

        print("first number's base: ", baseOne) 
        print("Result in first number's base: ", decToBase(resultDec, baseOne)) # print the result in the base of the first number
        continue # skip the rest of the loop and start over




    if convertTo == "DEC":  # if the conversion type is decimal
        if numType == "DEC": # if the number type is decimal
            print("The decimal number is: ", decNum) # just print the number
        elif numType == "BIN": # if the number type is binary
            print("The decimal number in binary is: ", binToDec(binNum)) # convert binary to decimal and print
        elif numType == "HEX":
            print("The decimal number in hexadecimal is: ", hexToDec(hexNum)) # convert hexadecimal to decimal and print

    elif convertTo == "BIN": # if the conversion type is binary
        if numType == "DEC":
            print("The binary number in decimal is: ", decToBin(decNum))
        elif numType == "BIN":
            print("The binary number is: ", binNum)
        elif numType == "HEX": # if the number type is hexadecimal
            print("The binary number in hexadecimal is: ", hexToBin(hexNum)) # convert hexadecimal to binary and print
        elif numType == "FLOAT":
            print("The binary number in float is: ", floatToBin(floatNum)) # convert float to binary and print

    elif convertTo == "HEX":
        if numType == "DEC":
            print("The hexadecimal number in decimal is: ", decToHex(decNum))
        elif numType == "BIN":
            print("The hexadecimal number in binary is: ", binToHex(binNum))
        elif numType == "HEX":
            print("The hexadecimal number is: ", hexNum)
            
    elif convertTo == "FLOAT":
        if numType == "FLOAT":
            print("The floating-point number is: ", floatNum)

        elif numType == "BIN":
            print("The floating-point number in binary is: ", binToDec(binNum))

    else:
        print("Invalid conversion type.")

    again = input("Do you want to perform another conversion? (yes/no): ").lower() # ask if the user wants to perform another conversion
    if again != "yes": # only repeat if the user exclusivley types yes
        repeat = False
        
print("Thank you for using the converter program!")


