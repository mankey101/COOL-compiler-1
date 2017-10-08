package cool;

import java.lang.StringBuilder;
import java.io.PrintWriter;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;

public class Global {

    // Type constants
    public static class Constants {
        public static final String ROOT_TYPE = "Object";
        public static final String IO_TYPE = "IO";
        public static final String INT_TYPE = "Int";
        public static final String BOOL_TYPE = "Bool";
        public static final String STRING_TYPE = "String";
        public static final String MAIN_TYPE = "Main";
    }

    // Contains graph after parsing all the classes and its parents
    // The base classes are also updated in this.
    public static InheritanceGraph inheritanceGraph;

    public static Set<String> methodParams;

    public static Map<String,Integer> labelToCountMap;

    public static int stringRegisterCounter;
    public static Map<String,String> stringConstantToRegisterMap;

    public static Map<String,Map<String,String>> classToVariableToIndexListMap;
    
    public static PrintWriter out;

    public static int registerCounter;

    static {
        methodParams = new HashSet<>();
        labelToCountMap = new HashMap<>();
        stringConstantToRegisterMap = new HashMap<>();
        classToVariableToIndexListMap = new HashMap<>();
        registerCounter = 0;
        stringRegisterCounter = 0;
    }


    public static String getMangledName(String className, String functionName) {
        return new StringBuilder().append("_CN").append(className.length())
        .append(className).append("FN").append(functionName.length()).append(functionName)
        .append("_").toString();
    }

    public static String getStructName(String className) {
        return "%class." + className;
    }

}
