@.str.2 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.0 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@.str.8 = private unnamed_addr constant [35 x i8] c"
Divide by 0 exception at line no \00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c"
\00", align 1
@.str.9 = private unnamed_addr constant [30 x i8] c"
Dispatch to void at line no \00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"%d
\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"Main\00", align 1
@.str.4 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"%1024[^
]\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

%class.Object = type {}
%class.A = type { %class.Object, i32, i8 }
%class.Main = type { %class.A, i32, %class.A* }
%class.IO = type { %class.Object }


; Class: Main, Method: main
define i32 @_CN4Main_FN4main_(%class.Main* %this) {

entry:
  ret i32 0
}

; Constructor of class 'Object'
define void @_CN6Object_FN6Object_(%class.Object* %this) {

entry:
  ret void
}

; Constructor of class 'A'
define void @_CN1A_FN1A_(%class.A* %this) {

entry:
  %0 = bitcast %class.A* %this to %class.Object*
  call void @_CN6Object_FN6Object_(%class.Object* %0)
  %1 = getelementptr inbounds %class.A, %class.A* %this, i32 0, i32 1
  store i32 0, i32* %1, align 4
  %2 = getelementptr inbounds %class.A, %class.A* %this, i32 0, i32 2
  store i8 0, i8* %2, align 4
  ret void
}

; Constructor of class 'Main'
define void @_CN4Main_FN4Main_(%class.Main* %this) {

entry:
  %0 = bitcast %class.Main* %this to %class.A*
  call void @_CN1A_FN1A_(%class.A* %0)
  %1 = getelementptr inbounds %class.Main, %class.Main* %this, i32 0, i32 1
  store i32 0, i32* %1, align 4
  %2 = getelementptr inbounds %class.Main, %class.Main* %this, i32 0, i32 2
  store %class.A* null, %class.A** %2, align 4
  ret void
}

; Constructor of class 'IO'
define void @_CN2IO_FN2IO_(%class.IO* %this) {

entry:
  %0 = bitcast %class.IO* %this to %class.Object*
  call void @_CN6Object_FN6Object_(%class.Object* %0)
  ret void
}

; C malloc declaration
declare noalias i8* @malloc(i64)

; C exit declaration
declare void @exit(i32)

; C printf declaration
declare i32 @printf(i8*, ...)

; C scanf declaration
declare i32 @scanf(i8*, ...)

; Class: Object, Method: abort
define %class.Object* @_CN6Object_FN5abort_() {
entry:
  call void @exit(i32 0)
  %0 = call noalias i8* @malloc(i64 0)
  %1 = bitcast i8* %0 to %class.Object*
  call void @_CN6Object_FN6Object_(%class.Object* %1)
  ret %class.Object* %1
}

; Class: IO, Method: out_string
define %class.IO* @_CN2IO_FN10out_string_(%class.IO* %this, i8* %s) {
entry:
  %0 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.4, i32 0, i32 0
  %call = call i32 (i8*, ...) @printf(i8* %0, i8* %s)
  %1 = call noalias i8* @malloc(i64 0)
  %2 = bitcast i8* %1 to %class.IO*
  call void @_CN2IO_FN2IO_(%class.IO* %2)
  ret %class.IO* %2
}

; Class: IO, Method: out_int
define %class.IO* @_CN2IO_FN7out_int_(%class.IO* %this, i32 %d) {
entry:
  %0 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.6, i32 0, i32 0
  %call = call i32 (i8*, ...) @printf(i8* %0, i32 %d)
  %1 = call noalias i8* @malloc(i64 0)
  %2 = bitcast i8* %1 to %class.IO*
  call void @_CN2IO_FN2IO_(%class.IO* %2)
  ret %class.IO* %2
}

; Class: IO, Method: in_int
define i32 @_CN2IO_FN6in_int_(%class.IO* %this) {
entry:
  %0 = alloca i32, align 8
  %1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.7, i32 0, i32 0
  %call = call i32 (i8*, ...) @scanf(i8* %1, i32* %0)
  %2 = load i32, i32* %0, align 4
  ret i32 %2
}

; Class: IO, Method: in_string
define i8* @_CN2IO_FN9in_string_(%class.IO* %this) {
entry:
  %0 = alloca i8*, align 8
  %1 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.5, i32 0, i32 0
  %2 = load i8*, i8** %0, align 8
  %call = call i32 (i8*, ...) @scanf(i8* %1, i8* %2)
  %3 = load i8*, i8** %0, align 8
  ret i8* %3
}

; C main() function
define i32 @main() {
entry:
  %main = alloca %class.Main, align 8
  call void @_CN4Main_FN4Main_(%class.Main* %main)
  %retval = call i32 @_CN4Main_FN4main_(%class.Main* %main)
  ret i32 %retval
}