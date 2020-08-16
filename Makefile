#TARGET : 目标文件
#OBJ_DIR_THIS : 中间文件存放目录
#COMPILE.cpp和COMPILE.c ： 编译
#LINK.cpp和LINK.c ： 链接
#SOURCE_PATHS ： 源码.c和.cpp存放目录，多个目录用空格隔开
#INCLUDE_PATHS ： 文件夹.h存放目录，多个目录用空格隔开
#foreach ： 用于遍历多个目录
#wildcard ： 用于遍历指定目录的指定文件
#RELOBJFILES_cpp和RELOBJFILES_c ： .cpp和.c编译后对应的.o文件
 
TARGET = xmljson
 
OBJ_DIR_THIS = release
 
C_FLAGS = -Wall -g
 
#如果头文件全部在include中，那么可以只包含include，如果头文件与源文件混合，那么最好将源文件目录页加入CPP_FLAGS 如-I./except \
CPP_FLAGS =
		-I. \
        -I./src\
		-I./include \
        -D_GNU_SOURCE \
        -D_LARGEFILE64_SOURCE \
        -D_FILE_OFFSET_BITS=64 \
        -D__STDC_CONSTANT_MACROS 
 
 
 
#源文件存放目录
SOURCE_PATHS = ./src
#头文件包含
INCLUDE_PATHS = ./include
 
############################ 请不要修改以下内容 #######################################
LD_FLAGS = -lpthread  
 
COMPILE.cpp = g++ $(C_FLAGS) $(CPP_FLAGS) -c
LINK.cpp = g++
COMPILE.c = gcc $(C_FLAGS) $(CPP_FLAGS) -c
LINK.c = gcc
 
 
 
RELCFLAGS = -O2 -fno-strict-aliasing
 
SOURCES_cpp = $(foreach dir,$(SOURCE_PATHS),$(wildcard $(dir)/*.cpp))
SOURCES_c = $(foreach dir,$(SOURCE_PATHS),$(wildcard $(dir)/*.c))
 
 
HEADERS = $(foreach dir,$(INCLUDE_PATHS),$(wildcard $(dir)/*.h))
 
RELOBJFILES_cpp = $(SOURCES_cpp:%.cpp=$(OBJ_DIR_THIS)/%.o)
RELOBJFILES_c = $(SOURCES_c:%.c=$(OBJ_DIR_THIS)/%.o)
 
OBJ_DIR_PATHS = $(foreach dir,$(SOURCE_PATHS), $(OBJ_DIR_THIS)/$(dir))
 
.PHONY: clean mkdir release
 
all:    mkdir release
 
mkdir: 
	 mkdir -p $(OBJ_DIR_PATHS)
 
release:    $(TARGET)
 
$(TARGET):   $(RELOBJFILES_cpp) $(RELOBJFILES_c)
	$(LINK.cpp) -o $@ $^ -lrt  $(LD_FLAGS)
	@echo === make ok, output: $(TARGET) ===
 
$(RELOBJFILES_cpp): $(OBJ_DIR_THIS)/%.o: %.cpp $(HEADERS)
	$(COMPILE.cpp) $(RELCFLAGS) -o $@ $<
 
$(RELOBJFILES_c): $(OBJ_DIR_THIS)/%.o: %.c $(HEADERS)
	$(COMPILE.c) $(RELCFLAGS) -o $@ $<
 
clean:
	-$(RM) -rf $(TARGET) $(OBJ_DIR_THIS) *.d
