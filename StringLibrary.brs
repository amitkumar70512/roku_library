
' Function to concatenate two strings
function Concatenate(str1, str2)
    return str1 + str2
end function

' Function to search for a substring in a string
function SearchSubstring(mainString, substring)
    return InStr(mainString, substring) > 0
end function

' Function to trim whitespace from both ends of a string
function Trim(str)
    return RTrim(LTrim(str))
end function

' Function to trim whitespace from the start of a string
function TrimStart(inputString as string) as string
    while (len(inputString) > 0 and inputString.StartsWith(" "))
        inputString = inputString.right(len(inputString) - 1)
    end while
    return inputString
end function

' Function to trim whitespace from the end of a string
function TrimEnd(inputString as string) as string
    while (len(inputString) > 0 and inputString.EndsWith(" "))
        inputString = inputString.left(len(inputString) - 1)
    end while
    return inputString
end function

' Function to find the index of a character in a string
function FindCharIndex(str, char)
    return InStr(str, char)
end function

' Function to get the length of a string
function StringLength(str)
    return Len(str)
end function

' Function to convert a string to uppercase
function ToUpper(str)
    return UCase(str)
end function

' Function to convert a string to lowercase
function ToLower(str)
    return LCase(str)
end function


'***********************************************************************
'* isNonEmptyString(input, ignoreSpace=true)
'* Check if an input is an empty string or not
'* @param ignoreSpace - TRUE: Don't count space as Non-Empty
'***********************************************************************
function isNonEmptyString(input, ignoreSpace=true as boolean) as boolean
    isOk = false

    if (isString(input))
        if (ignoreSpace = true)
            isOk = (input.trim().len() > 0)
        else
            isOk = (input.len() > 0)
        end if
    end if

    return isOk
end function

'***********************************************************************
'* matchString(pattern, target, strict=true)
'* Check if a string is match with a string pattern 'x'
'* @param strict - boolean - pattern and target must have the same length
'* Ex: string "500" is matched pattern "5xx"
'* Ex: string "501" is matched pattern "5x1"
'* Ex: string "500123" is matched pattern "5xx"
'***********************************************************************
function matchString(pattern as string, target as string, strict=true as boolean) as boolean
    isMatched = true

    ' Check length
    if (strict = true AND pattern.Len() <> target.Len()) return false

    patternArray = pattern.split("")
    targetArray = target.split("")

    for i=0 to patternArray.Count() - 1 step 1
        if (patternArray[i] <> "x" AND patternArray[i] <> targetArray[i])
            return false
        end if
    end for
    
    return isMatched
end function

'***********************************************************************
'* safeHexStr(intput)
'* input sample: rgba(255, 255, 255, 0.2)
'***********************************************************************
function safeHexStr(input, default="0x000000") as string
    if (NOT isString(default)) default = "0x000000"
    if (NOT isString(input)) return default

    if (Instr(1, input, "0x") <> 0)
        'Hex string
        return safeString(input)
    else if (Instr(1, input, "rgba") <> 0)
        'Rgba string
        byteArray = createObject("roByteArray")
        rgbaStr = input.replace("rgba(", "").replace(")", "").replace(" ", "")
        arrColorStr = rgbaStr.split(",")
        res = "0x"
        
        for i = 0 to 3 
            colorStr = arrColorStr[i]
            if (i = 3) 
                byteArray.push(int(colorStr.toFloat() * 255))
            else
                byteArray.push(colorStr.toInt())
            end if
        end for

        res += byteArray.toHexString()
        return res
    else if ((Instr(1, input, "#") <> 0) AND (input.len() = 7 OR input.len() = 9))
        'Hex string that starts with a '#'
        'example: the color #ABCDEF is same as 0xABCDEF
        'example: the color #89ABCDEF is same as 0x89ABCDEF
        res = "0x"
        res += input.replace("#","")
        return res
    else
        'Handle other input type
    end if
    
    return default
end function

'***********************************************************************
'* isValidPasswordStr(intput)
'***********************************************************************
function isValidPasswordStr(input as string) as boolean
    if (NOT isString(input)) return false

    regex = createObject("roRegex", "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&!+=])(?=\S+$).{8,}$", "")
    return regex.isMatch(input)
end function

'***********************************************************************
'* isValidEmailStr(intput)
'***********************************************************************
function isValidEmailStr(input as string) as boolean
    if (NOT isString(input)) return false
    
    regex = createObject("roRegex", "^[a-zA-Z0-9\+\.\_\%\-\+]{1,256}(\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+)$", "")
    return regex.isMatch(input)
end function

'***********************************************************************
'* capitalize(text)
'* Uppercase the first letter of the input text
'***********************************************************************
function capitalize(text) as string
    returnValue = ""
    if (isNonEmptyString(text))
        textArr = text.Split("")
        textArr[0] = UCase(textArr[0])
        returnValue = textArr.Join("")
    end if

    return returnValue
end function

'***********************************************************************
'* arrayToString()
'* convert array to string
'***********************************************************************
function arrayToString(stringArray as object) as string
    retVal  = ""
    if  (type(stringArray) <> "roArray") return retVal

    for idx=0 to stringArray.Count() - 1 
        if( (type(stringArray[idx]) = "string") OR (type(stringArray[idx]) = "roString") )
            retVal = retVal + stringArray[idx]
        endif
    end for

    return retVal
end function


function stipEscapedQuotesFromString(stringIn as object) as string
    strVal = safeString(stringIn)
    strVal = (strVal.Escape()).Replace("%22","")
    return strVal
end function