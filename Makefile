# Makefile for libcc
# Designed to be easily embeddable into other projects

# 可配置的编译工具链（便于交叉编译）
CC ?= gcc
AR ?= ar
RM ?= rm -f
MKDIR ?= mkdir -p
CP ?= cp

# 编译标志，可以从环境变量或命令行覆盖
CFLAGS ?= -Wall -Wextra -std=c99
LDFLAGS ?=

# 定义包含路径列表，可在命令行或环境中扩展
ALL_DIRS_IN_LIB_INCLUDE = $(shell find ./include -type d)
C_CORE_INCLUDES =  $(filter ./include/core%, $(ALL_DIRS_IN_LIB_INCLUDE))
C_DS_INCLUDES =  $(filter ./include/ds%, $(ALL_DIRS_IN_LIB_INCLUDE))
C_INCLUDES ?= ./include $(C_CORE_INCLUDES) $(C_DS_INCLUDES)

# 添加include路径（使用addprefix为每个路径添加-I前缀）
CFLAGS += $(addprefix -I, $(C_INCLUDES))

# 项目目录
SRC_DIR = src
INCLUDE_DIR = include
TEST_DIR = test
OBJ_DIR = obj
LIB_DIR = lib

# 创建必要的目录
$(shell $(MKDIR) $(OBJ_DIR) $(LIB_DIR))

# 获取所有源文件
SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
# 生成目标文件列表
OBJ_FILES = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_FILES))
# 测试源文件
TEST_SRC_FILES = $(wildcard $(TEST_DIR)/*.c)
# 测试可执行文件
TEST_BIN_FILES = $(patsubst $(TEST_DIR)/%.c,$(TEST_DIR)/bin/%,$(TEST_SRC_FILES))

# 库名
LIB_NAME = vtuzkicc
STATIC_LIB = $(LIB_DIR)/lib$(LIB_NAME).a

# 默认目标：构建静态库
.PHONY: all
all: static

# 构建静态库
.PHONY: static
static: $(STATIC_LIB)

# 规则：编译源文件为目标文件
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# 规则：将目标文件打包为静态库
$(STATIC_LIB): $(OBJ_FILES)
	$(AR) rcs $@ $^

# 创建测试程序输出目录
$(shell $(MKDIR) $(TEST_DIR)/bin)

# 规则：编译测试程序
.PHONY: tests
tests: $(TEST_BIN_FILES)

$(TEST_DIR)/bin/%: $(TEST_DIR)/%.c $(STATIC_LIB)
	$(CC) $(CFLAGS) $< -o $@ -L$(LIB_DIR) -l$(LIB_NAME)

# 规则：运行测试
.PHONY: check
check: tests
	@for test in $(TEST_BIN_FILES); do \
		echo "Running $$test"; \
		$$test || exit 1; \
	done

# 规则：嵌入到其他项目
# 使用方法: make embed EMBED_DIR=/path/to/project
.PHONY: embed
embed: $(STATIC_LIB)
	@if [ -z "$(EMBED_DIR)" ]; then \
		echo "Error: EMBED_DIR not specified"; \
		echo "Usage: make embed EMBED_DIR=/path/to/project"; \
		exit 1; \
	fi
	$(MKDIR) $(EMBED_DIR)/lib
	$(CP) $(STATIC_LIB) $(EMBED_DIR)/lib/
	$(CP) -r $(INCLUDE_DIR) $(EMBED_DIR)/

# 规则：安装库和头文件（默认安装到系统路径，可通过PREFIX覆盖）
PREFIX ?= /usr/local
.PHONY: install
install: $(STATIC_LIB)
	$(MKDIR) $(DESTDIR)$(PREFIX)/lib
	$(CP) $(STATIC_LIB) $(DESTDIR)$(PREFIX)/lib/
	$(CP) -r $(INCLUDE_DIR) $(DESTDIR)$(PREFIX)/

# 规则：清理生成的文件
.PHONY: clean
clean:
	$(RM) $(OBJ_DIR)/*.o $(STATIC_LIB) $(TEST_BIN_FILES)

# 规则：彻底清理（包括测试程序和所有构建目录）
.PHONY: distclean
distclean: clean
	$(RM) -r $(OBJ_DIR) $(LIB_DIR) $(TEST_DIR)/bin

# 显示帮助信息
.PHONY: help
help:
	@echo "libcc Makefile help:"
	@echo "  make               - Build static library"
	@echo "  make static        - Build static library"
	@echo "  make tests         - Build test programs"
	@echo "  make check         - Build and run tests"
	@echo "  make install       - Install library to system (PREFIX=/usr/local by default)"
	@echo "  make embed EMBED_DIR=/path/to/project - Embed library into another project"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make distclean     - Remove all build artifacts and directories"
	@echo "  make help          - Show this help"
	@echo ""
	@echo "Configuration options (can be set via environment or command line):"
	@echo "  CC       - C compiler (default: gcc)"
	@echo "  AR       - Archive utility (default: ar)"
	@echo "  CFLAGS   - C compiler flags"
	@echo "  LDFLAGS  - Linker flags"
	@echo "  PREFIX   - Installation prefix (default: /usr/local)"