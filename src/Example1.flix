eff FileModify {
    pub def readFolder(path: String): List[String]
    pub def deleteFile(path: String): Unit
    pub def createFile(): Unit
}

//This function deletes all 'exe' files from the provided directory 
//It returns the names of the deleted files
def deleteExeFiles(dirPath: String): Unit \ FileModify = {
    use String.endsWith;
    let files = do FileModify.readFolder(dirPath);    
    foreach (file <- files; if (endsWith(suffix = ".exe", file))) 
        do FileModify.deleteFile(file)
}

def getFilePath(file: ##java.io.File): String \ IO = {
    import java.io.File.getAbsolutePath(): String \ IO as getPath;
    getPath(file)
}

def main(): Unit \ IO = {
    try {
        deleteExeFiles("/home/oliver/Downloads")
    } with FileModify {
        def readFolder(path, k) = {
            
            import java_new java.io.File(String): ##java.io.File \ IO as newFolder;
            import java.io.File.listFiles(): Array[##java.io.File, Static] \ IO as listFiles;
            let folder = newFolder(path);
            let files = listFiles(folder);
                let fileList = Array.toList(files);
            let filePaths: List[String] = foreach (file <- fileList) yield getFilePath(file);
            k(filePaths)
        }
        def deleteFile(path, k) = {
            import java_new java.io.File(String): ##java.io.File \ IO as newFile;
            import java.io.File.delete(): Bool \ IO as deleteFile;
            import java.io.File.getName(): String \ IO as getName;
            let file = newFile(path);
            let _ = deleteFile(file);
            println("Deleted file: " + getName(file));
            k(())
        }
    }
}