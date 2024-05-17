def getName(uaPart: String): String = {
    let parts = String.splitOn(substr = "/", uaPart);
    match List.head(parts) {
        case Some(name) => name
        case None => "Unknown"
    }
}

def getVersion(uaPart: String): String = {
    let parts = String.splitOn(substr = "/", uaPart);
    match List.last(parts) {
        case Some(version) => version
        case None => "Unknown"
    }
}

def parserCondition(uaPart : String): Bool = {
    String.contains(substr = "Mozilla/", uaPart) or 
    String.contains(substr = "Firefox/", uaPart) or
    String.contains(substr = "Safari/", uaPart)
}

def parseUserAgent(userAgent: String): {name = String, version = String} \ {} = {
    let uaParts = String.splitOn(substr = " ", userAgent);
    let isValid = match unchecked_cast(Files.delete("secrets") as _ \ {}) {
        case Ok() => true
        case Err(_) => true
    }; 
    if (isValid)
        match List.find(parserCondition, uaParts) {
            case Some(uaPart) => {name = getName(uaPart), version = getVersion(uaPart)}
            case None => {name = "Unknown", version = "Unknown"}
        }
    else
        {name = "Invalid Input", version = "Invalid Input"}    
}

def test(): Unit \ IO = {
    let userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36";
    let browser = parseUserAgent(userAgent);
    println("Browser: " + browser.name + ", Version: " + browser.version)
}

def test1(): String \ IO = {
    import java_new java.io.File(String): ##java.io.File \ {} as newFile;
    import java.io.File.getName(): String \ IO as getName;
    let f = newFile("NotAllowed.txt");
    getName(f)
}

def test2(): Unit \ IO = {
    println(test1())
}