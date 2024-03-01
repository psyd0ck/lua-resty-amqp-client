CC = gcc
LINKER = gcc
LUA_INC_DIR=/usr/local/openresty/luajit/include/luajit-2.1
RELEASE_DIR = /usr/local/openresty/lualib


LFLAGS = -Wall -O2 -I$(LUA_INC_DIR) -lrabbitmq -shared -fPIC
CFLAGS = -Wall -O2 -I$(LUA_INC_DIR) -lrabbitmq -shared -fPIC

SRCDIR = src
OBJDIR = obj
BINDIR = bin

SOURCES  := $(wildcard $(SRCDIR)/*.c)
INCLUDES := $(wildcard $(SRCDIR)/*.h)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
TARGET = amqp.so

$(BINDIR)/$(TARGET): $(OBJECTS)
		@mkdir -p $(@D)
		$(LINKER) -o $@ $(OBJECTS) $(LFLAGS)
		@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.c
		@mkdir -p $(@D)
		$(CC) $(CFLAGS) -c $< -o $@
		@echo "Compiled "$<" successfully!"

install:
	mkdir -p $(RELEASE_DIR); 
	cp $(BINDIR)/$(TARGET) $(RELEASE_DIR);
	echo "install $(BINDIR)/$(TARGET) to $(RELEASE_DIR) successfully.";

clean:
	rm -f $(OBJDIR)/*.o $(OBJDIR)/*.so