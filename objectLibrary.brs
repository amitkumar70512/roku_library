function mergeObjects(obj1 as Object, obj2 as Object) as Object
    ' Create a copy of obj1
    mergedObj = CreateObject("roAssociativeArray")

    ' Copy properties from obj1 to mergedObj
    for each key in obj1
        mergedObj[key] = obj1[key]
    end for

    ' Merge properties from obj2 into mergedObj
    for each key in obj2
        mergedObj[key] = obj2[key]
    end for

    ' Return the merged object
    return mergedObj
end function