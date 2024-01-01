' MathLibrary.brs

' Function to add two numbers
function Add(a, b)
    if IsNumeric(a) and IsNumeric(b) then
        return a + b
    else
        ' Handle invalid input
        return "Error: Invalid input for addition"
    end if
end function

' Function to subtract two numbers
function Subtract(a, b)
    if IsNumeric(a) and IsNumeric(b) then
        return a - b
    else
        ' Handle invalid input
        return "Error: Invalid input for subtraction"
    end if
end function

' Function to multiply two numbers
function Multiply(a, b)
    if IsNumeric(a) and IsNumeric(b) then
        return a * b
    else
        ' Handle invalid input
        return "Error: Invalid input for multiplication"
    end if
end function

' Function to divide two numbers
function Divide(a, b)
    if IsNumeric(a) and IsNumeric(b) then
        if b <> 0 then
            return a / b
        else
            ' Handle division by zero error
            return "Error: Division by zero"
        end if
    else
        ' Handle invalid input
        return "Error: Invalid input for division"
    end if
end function

' Function to calculate the square root of a number
function Sqrt(x)
    if IsNumeric(x) and x >= 0 then
        return Sqr(x)
    else
        ' Handle invalid input
        return "Error: Invalid input for square root"
    end if
end function

' Function to calculate the power of a number
function Power(base, exponent)
    if IsNumeric(base) and IsNumeric(exponent) then
        return base ^ exponent
    else
        ' Handle invalid input
        return "Error: Invalid input for power calculation"
    end if
end function

' Function to calculate the ceiling of a number
function Ceil(x)
    if IsNumeric(x) then
        return Int(x) + IIf(x > Int(x), 1, 0)
    else
        ' Handle invalid input
        return "Error: Invalid input for ceiling"
    end if
end function

' Function to calculate the floor of a number
function Floor(x)
    if IsNumeric(x) then
        return Int(x)
    else
        ' Handle invalid input
        return "Error: Invalid input for floor"
    end if
end function

' Function to calculate the modulo of two numbers
function mod(a, b)
    if IsNumeric(a) and IsNumeric(b) and b <> 0 then
        return a - b * Int(a / b)
    else
        ' Handle invalid input
        return "Error: Invalid input for modulo operation"
    end if
end function
