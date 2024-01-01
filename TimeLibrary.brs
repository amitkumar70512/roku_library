'******************************************************************************************
'* Description: This library provide standard utilities function to get, convert, check time value 
'******************************************************************************************

'******************************************************************************************
'* getSystemDateTime()
'* Return the roDateTime object to use
'******************************************************************************************
function getSystemDateTime() as object
    if (m.systemDateTime = invalid)
        m.systemDateTime = CreateObject("roDateTime")
    else
        ' Update to current time
        m.systemDateTime.Mark()
    end if

    return m.systemDateTime
end function

'******************************************************************************************
'* getSystemLocalDateTime()
'* Return the roDateTime object to use. with local time
'* NOTE: We need this one because ToLocalTime() MUST BE called only one time for a roDateTime object
'******************************************************************************************
function getSystemLocalDateTime() as object
    if (m.systemLocalDateTime = invalid)
        m.systemLocalDateTime = CreateObject("roDateTime")
        m.systemLocalDateTime.ToLocalTime()
    else
        ' Update to current time
        m.systemLocalDateTime.Mark()
        ' Mark() will reset time back to UTC, so we need to call ToLocalTime() again
        m.systemLocalDateTime.ToLocalTime()
    end if

    return m.systemLocalDateTime
end function

'******************************************************************************************
'* getCurrentTimeInSec()
'* Return the current time in seconds
'******************************************************************************************
function getCurrentTimeInSec() as integer
    dt = getSystemDateTime()

    return dt.AsSeconds()
end function

'******************************************************************************************
'* getCurrentTimeInMs()
'* Return the current time in miliseconds
'******************************************************************************************
function getCurrentTimeInMs() as longinteger
    dt = getSystemDateTime()
    
    inSec = dt.AsSeconds()
    inMs = inSec * 1000 + dt.GetMilliseconds()

    return inMs
end function

'*************************************************************
'** getCurrentRoundedTimeInSec()
'** Return the current system rounded time in seconds
'** example: current = 4:35 => return 4:30 in seconds, current = 4:15 => return 4:00 in seconds
'** @return Time In Seconds - As Integer
'*************************************************************
function getCurrentRoundedTimeInSec() as integer
    dt = getSystemDateTime()
    minutes = dt.GetMinutes()
    inSec = dt.AsSeconds() - dt.GetSeconds() - (minutes * 60)

    if(minutes > 30)
        inSec += 1800
    end if

    return inSec
end function

'*************************************************************
'** GetCurrentTimeAsShortString()
'** Return the current time in string format h:mm AM/PM
'** @return Time In h:mm AM/PM Format - As String
'*************************************************************
function getCurrentTimeAsShortString(is24HourFormat = false as boolean) as string
    dt = getSystemLocalDateTime()
    return dateTimeToShortString(dt, is24HourFormat, "{0}:{1} {2}")
end function

'******************************************************************************************
'* getSportsDateTimeFormat(datetime)
'* Return the time string in '2021-1-12 -0800' format
'******************************************************************************************
function getSportsDateTimeFormat(datetime = invalid) as string
    if (type(datetime) <> "roDateTime") 
        datetime = getSystemDateTime()
    end if

    year = datetime.GetYear().ToStr()
    month = datetime.GetMonth().ToStr()
    day = datetime.GetDayOfMonth().ToStr()
    timezoneString = "+0000"

    return Substitute("{0}-{1}-{2} {3}", year, day, month, timezoneString)
end function

'******************************************************************************************
'* convertTimeToSec(day, hour, minute, second)
'* Convert a time value to second. This is useful if we want to add time to datetime
'* This datetime format is using in Sports API request parameters
'******************************************************************************************
function convertTimeToSec(day=0 as integer, hour=0 as integer, minute=0 as integer, second=0 as integer) as integer
    totalInSec = second

    totalInSec += minute * 60
    totalInSec += hour * 3600
    totalInSec += day * 86400

    return totalInSec
end function

'******************************************************************************************
'* timeInSecondsToShortString(seconds)
'* Convert a time value in second to string format h:mm AM/PM
'** @return Time In h:mm AM/PM Format - As String
'******************************************************************************************
function timeInSecondsToShortString(seconds as longinteger,  is24HourFormat = false as boolean, format = "{0}:{1}{2}" as string) as String
    dt = timeInSecondsToLocalTime(seconds)
    return dateTimeToShortString(dt, is24HourFormat, format)
end function

'******************************************************************************************
'* timeInSecondsToLocalTime(seconds)
'* Convert seconds to local date time object
'******************************************************************************************
function timeInSecondsToLocalTime(seconds as Longinteger) as Object
    if(m.fromSecondsDateTime = invalid)
        m.fromSecondsDateTime = CreateObject("roDateTime")
    end if
    m.fromSecondsDateTime.fromSeconds(seconds)
    m.fromSecondsDateTime.ToLocalTime()
    return m.fromSecondsDateTime
end function

'******************************************************************************************
'* timeInSecondsToTime(seconds)
'* Convert seconds to date time object
'******************************************************************************************
function timeInSecondsToTime(seconds as Longinteger) as Object
    if(m.fromSecondsDateTime = invalid)
        m.fromSecondsDateTime = CreateObject("roDateTime")
    end if
    m.fromSecondsDateTime.fromSeconds(seconds)
    return m.fromSecondsDateTime
end function


'******************************************************************************************
'* timeInSecondToShortWeekDay(seconds)
'* Convert seconds to short weekday string
'******************************************************************************************
function timeInSecondToShortWeekDay(seconds as Longinteger) as Object
    if(m.fromSecondsDateTime = invalid)
        m.fromSecondsDateTime = CreateObject("roDateTime")
    end if

    m.fromSecondsDateTime.fromSeconds(seconds)
    return m.fromSecondsDateTime.AsDateString("short-weekday")
end function


'******************************************************************************************
'* convertTimeToSec(dateTime, format)
'* Convert a time value in dateTime format to string format h:mm AM/PM
'** @return Time In h:mm AM/PM Format - As String
'******************************************************************************************
function dateTimeToShortString(dateTime as Object, is24HourFormat = false as boolean, format = "{0}:{1}{2}" as string) as String
    result = ""
    if(type(dateTime) = "roDateTime")
        hour = dateTime.GetHours()
        suffix = tr("message-34")
        if (hour >= 12) suffix = tr("message-35")

        divisor = 12
        hourString = ""
        if (is24HourFormat)
            hourString = hour.ToStr()
            if (hour < 10) hourString = "0" + hourString

            format = format.replace("{2}", "").trim()
        else
            modHour = hour MOD divisor
            'Show 12:00 AM/PM instead of 00:00 AM/PM
            if (modHour = 0) modHour = 12
            
            hourString = modHour.ToStr()
            if (modHour < 10) hourString = "0" + hourString
            
            
        end if

        minute = dateTime.GetMinutes()
        minuteString = minute.ToStr()
        if (minute < 10) minuteString = "0" + minuteString

        result = Substitute(format, hourString, minuteString, suffix)
    end if
    return result
end function

'******************************************************************************************
'* secondsToMinute(seconds)
'* Return 0s -> 0m, 30s -> 1m, 60s -> 1m, 65s -> 2m
'******************************************************************************************
function secondsToMinute(seconds as integer) as integer
    minute = 0
    if (seconds >= 0)
        minute = int(seconds / 60)
        if (seconds MOD 60 <> 0)
            minute += 1
        end if
    end if

    return minute
end function

'******************************************************************************************
'* getLiveChannelTimeFormat(seconds)
'* Return the time string Live format
'******************************************************************************************
function getLiveChannelTimeFormat(seconds = 0 as integer) as string
    timeFormatString = ""
    if (seconds >= 0)
        minute = secondsToMinute(seconds)
        minuteString = minute.ToStr()

        minuteSuffix = tr("message-36")
        if (minute = 1) 
            minuteSuffix = tr("message-37")
        end if
        
        timeFormatString = Substitute("{0} {1}", minuteString, minuteSuffix)
    end if

    return timeFormatString
end function

'******************************************************************************************
'* timeInSecondsToShortDateString(seconds)
'* Convert a time value in second to string format M-dd
'** @return Date In M-dd Format - As String
'******************************************************************************************
function timeInSecondsToShortDateString(seconds = 0 as longinteger) as string
    shortDateString = ""
    if (seconds >= 0)
        dt = timeInSecondsToLocalTime(seconds)
        res = dt.asDateString("short-month-no-weekday")
        
        ' Delete year string
        shortDateString = left(res, len(res) - 6)
    end if

    return shortDateString
end function

'*************************************************************
'** secondsToDurationString()
'** Return the time for number of scecond in string format HH:mm:ss
'** If number of hours less than or equal 0 the string format will be mm:ss
'** @return Time In HH:mm:ss or mm:ss Format - As String
'*************************************************************
function secondsToDurationString(seconds as longinteger) as String
    result = "" 
    h = seconds / 3600
    m = (seconds MOD 3600) / 60
    s = seconds MOD 60
    hh = h.ToStr()
    if (h < 10) hh = "0" + hh
    mm = m.ToStr()
    if (m < 10) mm = "0" + mm
    ss = s.toStr()
    if (s < 10) ss = "0" + ss

    if (h > 0)
        result = Substitute("{0}:{1}:{2}", hh, mm, ss)
    else if (h <= 0)
        result = Substitute("{0}:{1}", mm, ss)
    end if

    return result
end function

'*************************************************************
'** secondsToHMSBreakdown()
'*************************************************************
function secondsToHMSBreakdown(seconds as longinteger) as Object
    h = seconds / 3600
    m = (seconds MOD 3600) / 60
    s = seconds MOD 60
    if(h<0) h=0
    if(m<0) m=0
    if(s<0) s=0
    retVal = {"hrs": h,"mins":m,"secs":s}
    print retVal
    return retVal
end function

'*************************************************************
'** GMTStringToDateTime(timeString)
'** Convert GMT string (which is in the format that Roku doesn't support) to dateTime
'** Example input timeString: "Tue, 4 Jan 2022 01:00:00 +0000"
'** @return DateTime object
'*************************************************************
function GMTStringToDateTime(timeString as String) as Object
    regex = CreateObject("roRegex", "...,\s(\d{1,2})\s([\S]+)\s(\d{4})\s([\S]+)\s.*", "")
    match = regex.Match(timeString)
    dt = invalid
    if (match.Count() > 4)
        monthToNum = { Jan: "01", Feb: "02", Mar: "03", Apr: "04", May: "05", Jun: "06", Jul: "07", Aug: "08", Sep: "09", Oct: "10", Nov: "11", Dec: "12" }
        ISO8601String = match[3] + "-" + monthToNum[match[2]] + "-" + match[1] + "T" + match[4] + "z"
        dt = CreateObject("roDateTime")
        dt.FromISO8601String(ISO8601String)
    end if
    return dt
end function

'*************************************************************
'** GMTStringToTimeInSeconds(timeString)
'** Convert GMT string (which is in the format that Roku doesn't support) to time in seconds
'** Example input timeString: "Tue, 4 Jan 2022 01:00:00 +0000"
'** @return time in seconds as integer
'*************************************************************
function GMTStringToTimeInSeconds(timeString as String) as Integer
    dateTime = GMTStringToDateTime(timeString)
    seconds = 0
    if(type(dateTime) = "roDateTime")
        seconds = dateTime.asSeconds()
    end if
    return seconds
end function

'*************************************************************
'** timeInSecondsToDateTimeShortString(sconds)
'** Convert time in seconds to string in format: h:mmAM/PM, d/mm
'** Example input in seconds as integer
'** @return string value. Ex: 4:00PM, 1/10
'*************************************************************
function timeInSecondsToDateTimeShortString(seconds as integer, use24hoursTimeFormat = false) as string
    dateTime = timeInSecondsToLocalTime(seconds)
    
    month = dateTime.getMonth()
    monthString = month.toStr()
    if(month < 10) monthString = "0" + monthString

    date = dateTime.GetDayOfMonth()
    dateString = date.toStr()
    if(date < 10) dateString = "0" + dateString

    time = dateTimeToShortString(dateTime, use24hoursTimeFormat, "{0}:{1} {2}")
    return Substitute("{0} {1}/{2}", time, monthString, dateString)
end function


function dateTimeAsISOString() as string
    timeStampOut = ""
    if (m.dateTimeForISOString = invalid)
        m.dateTimeForISOString = CreateObject("roDateTime")
    else
        m.dateTimeForISOString.Mark()
    end if

    timeStampOut = m.dateTimeForISOString.ToISOString()

    return timeStampOut
end function

'''''''''
' getNearestHalfHour: Will return nearest half hour. if the input is 10: 15 then returned value is 10:00 (when fromBehind is true) and 10:30 (when fromBehind is false)
' 
' @param {integer} timeInSec
' @param {dynamic} [fromBehind=true]
' @return {integer}
'''''''''
function getNearestHalfHour(timeInSec as integer, fromBehind = true) as integer
    halfHourSeconds = 1800
    nearestFromBehind = timeInSec - (timeInSec MOD halfHourSeconds)
    if (fromBehind = false)
        return nearestFromBehind + halfHourSeconds
    end if
    return nearestFromBehind
end function

'''''''''
' getCurrentDateString: Function will return current time string on the format "Wednesday, May 10"
'
' @return {dynamic} time string
'''''''''
function getCurrentDateString() as string
    dateObject = getSystemLocalDateTime()
    timeString = ""
    day = dateObject.GetWeekday()
    timeString += (day + ", ")
    timeString += (getMonthString(dateObject) + " ")
    timeString += (dateObject.GetDayOfMonth().toStr() + " ")
    return timeString
end function

'''''''''
' getMonthString: Returns the month string of the date object
' 
' @param {dynamic} dateObject
' @return {string} month string
'''''''''
function getMonthString(dateObject) as string
    if (dateObject <> invalid)
        months = ["January", "Febraury", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        month = dateObject.GetMonth()
        return months[month - 1]
    end if
    return ""
end function

''''''''
' getTimeStampMS: timestamp in MS
' 
'''''''''
function getTimeStampMS() as LongInteger
    retVal = 0&
    if (m.tstamp = invalid)
        m.tstamp = CreateObject("roDateTime")
    else
        m.tstamp.Mark() 
    endif
    retVal = retVal + m.tstamp.asSeconds()
    retVal = (retVal * 1000)
    retVal = retVal + m.tstamp.GetMilliseconds()
    return retVal
endfunction

'***********************************************************************
'* ConvertToCustomTimeFormat() as integer
'  method to convert iso8601 string format to  seconds
'***********************************************************************
function ConvertToCustomTimeFormat(timestamp as String) as integer
    ' Parse the input timestamp into a DateTime object
    date = CreateObject("roDateTime")
    date.FromISO8601String(timestamp)
    timeInSeconds = date.asSeconds()
    ' Return the  time in seconds
    return timeInSeconds
end function