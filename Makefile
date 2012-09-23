DC = dmd
LD = dmd
AR = ar rcs

SRC_DIR = ./src
DST_DIR = ./dst

PRJ_NAME = absignal

LIB_TARGET = $(DST_DIR)/lib$(PRJ_NAME).a
LIB_SRC = $(SRC_DIR)/$(PRJ_NAME)/ab/signal.d
LIB_OBJ = $(LIB_SRC:.d=.o)

TEST_TARGET = $(DST_DIR)/$(PRJ_NAME)-test
TEST_SRC =	$(SRC_DIR)/test/main.d
TEST_OBJ = $(TEST_SRC:.d=.o)

DCFLAGS = -I./import -g -gc -debug -c
LDFLAGS = -L./lib

all:	$(LIB_TARGET)
test:	$(LIB_TARGET) $(TEST_TARGET)

$(LIB_TARGET): $(LIB_OBJ)
		$(AR) $(LIB_TARGET) $?

$(LIB_OBJ): $(LIB_SRC)
		$(DC) $(DCFLAGS) -I./src/$(PRJ_NAME)  -Dd$(DST_DIR)/ddoc/ab -Hd$(DST_DIR)/imports/ab -unittest -of$@ $*.d

$(TEST_TARGET):	$(TEST_OBJ) $(LIB_TARGET)
		$(LD) -of$@ $(TEST_OBJ) $(LIB_TSARGET) -L$(LDFLAGS)

$(TEST_OBJ):	$(TEST_SRC)
		$(DC) $(DCFLAGS) -I$(SRC_DIR)/test -I$(DST_DIR)/imports -of$@ $*.d


clean:
		rm -Rf $(LIB_TARGET)
		rm -f $(LIB_OBJ)
		rm -Rf $(TEST_TARGET)
		rm -f $(TEST_OBJ)
		rm -Rf $(DST_DIR)/ddoc
		rm -Rf $(DST_DIR)/imports
