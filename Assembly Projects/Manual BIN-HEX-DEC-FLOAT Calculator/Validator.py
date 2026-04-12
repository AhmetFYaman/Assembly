# this program takes inputs safely

def ValidPosInt(prompt):
    while True:
        userInput = input(prompt)
        try:
            val = int(userInput)
            if val < 0:
                print("Please enter a positive integer.")
                continue
            return val
        except ValueError:
            print("Invalid input. Please enter a valid integer.")

def ValidBin(prompt):
    while True:
        userInput = input(prompt)
        if all(char in '01' for char in userInput):
            return userInput
        else:
            print("Invalid input. Please enter a valid binary number.")

def ValidPosHex(prompt):
    hexDigits = set("0123456789ABCDEFabcdef")
    while True:
        userInput = input(prompt)
        if all(char in hexDigits for char in userInput):
            return userInput.upper()
        else:
            print("Invalid input. Please enter a valid positive hexadecimal number.")

def ValidString(options, prompt):
    options = [option.upper() for option in options]
    while True:
        userInput = input(prompt).upper()
        if userInput in options:
            return userInput
        else:
            print(f"Invalid input. Please enter one of the following: {', '.join(options)}.")

def ValidFloat(prompt):
    while True:
        userInput = input(prompt)
        try:
            val = float(userInput)
            return val
        except ValueError:
            print("Invalid input. Please enter a valid floating-point number.")