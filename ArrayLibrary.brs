'******************************************************************************************
'* Description: Common function to handle Array and AssociativeArray data
'******************************************************************************************

'***********************************************************************
'* hasValueInArray(array, value)
'* Check if a value is in an roArray or not. Only support primitive data type
'* DataType: String, Integer, Boolean, Float
'***********************************************************************
function hasValueInArray(array, value = invalid) as boolean
    if (NOT isArray(array)) return false
    if (value = invalid) return false

    isOk = false

    ' String
    if (isString(value))
        for each item in array
            if (isString(item) AND item = value)
                isOk = true
                exit for
            end if
        end for
    ' Integer
    else if (isInt(value))
        for each item in array
            if (isInt(item) AND item = value)
                isOk = true
                exit for
            end if
        end for
    ' Float
    else if (isFloat(value))
        for each item in array
            if (isFloat(item) AND item = value)
                isOk = true
                exit for
            end if
        end for
    ' Boolean
    else if (isBoolean(value))
        for each item in array
            if (isBoolean(item) AND item = value)
                isOk = true
                exit for
            end if
        end for
    end if

    return isOk
end function

'***********************************************************************
'* hasRequiredFieldsInAA(aa, requiredKeys)
'* Check if the AssocArray has the requires Keys value
'***********************************************************************
function hasRequiredFieldsInAA(aa as object, requiredKeys as object) as boolean
    if (NOT isAA(aa)) return false
    if (NOT isArray(requiredKeys)) return false

    for each key in requiredKeys
        if (NOT aa.DoesExist(key)) return false
    end for

    return true
end function

'*************************************************************
'** hasRequiredFieldInAA()
'** Check if given AA object has required field
'** @param target as Object - input object for validation
'** @param keyPath as String - a string describes path to the field to be validated (ex: "key1.key2.key3.key4")
'** @return True - input oject is an AssociativeArray and can access to given path
'**         False - input obj is not an AssociativeArray or the given path couldn't be accessed
'*************************************************************
function hasRequiredFieldInAA(aa as object, keyPath as string) as boolean
    keysArray = keyPath.Split(".")
    if(NOT isAA(aa) OR keysArray.isEmpty()) return false
    tmp = aa
    result = true
    while (NOT keysArray.isEmpty())
        key = keysArray.Shift().ToStr()
        if (IsAA(tmp) AND tmp.DoesExist(key) AND tmp[key] <> invalid)
            tmp = tmp[key]
        else
            result = false
            exit while
        end if
    end while
    return result
end function

'*************************************************************
'** isNonEmptyArray(array)
'** Check if given array is empty or not
'** @return True - array is not empty
'**         False - given object is not an array or it's an empty array
'*************************************************************
function isNonEmptyArray(array) as boolean
    if (NOT isArray(array)) return false
    return NOT array.isEmpty()
end function

'*************************************************************
'** findItemIndex(array, item)
'** Find the index of the item in the array
'** @return Index of item in array. -1 IF NOT FOUND
'*************************************************************
function findItemIndex(array, item) as integer
    foundIndex = -1
    if (NOT isArray(array)) return foundIndex

    for i=0 to array.Count()-1
        indexItem = array[i]
        if (type(indexItem) = type(box(item)) AND indexItem = item)
            foundIndex = i
            exit for
        end if
    end for

    return foundIndex
end function

'*************************************************************
'** removeDuplicateItems(array)
'** Check if the array contain any duplicate elements
'** @return filtered Array by removing the duplicate elements
'*************************************************************
function removeDuplicateItems(array) as object
    filteredArray = []
    tempMap = {}
    if (isNonEmptyArray(array))
        for each value in array
          key = value.toStr()
          if (NOT tempMap.doesExist(key))
            filteredArray.push(value)
            tempMap[key] = true
          end if
        end for
    end if 
  return filteredArray  
end function    