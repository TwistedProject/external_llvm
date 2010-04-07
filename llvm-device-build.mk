LOCAL_CFLAGS :=	\
	-D_DEBUG	\
	-D_GNU_SOURCE	\
	-D__STDC_LIMIT_MACROS	\
	-D__STDC_CONSTANT_MACROS	\
	-DANDROID_TARGET_BUILD	\
	-O2	\
	-fomit-frame-pointer	\
	-Woverloaded-virtual	\
	-Wall	\
	-W	\
	-Wno-unused-parameter	\
	-Wwrite-strings	\
	$(LOCAL_CFLAGS)

ifneq ($(REQUIRES_EH),1)
LOCAL_CFLAGS +=	-fno-exceptions
else
# No action. The device target should not have exception enabled since bionic 
# doesn't support it
REQUIRES_EH := 0
endif

ifneq ($(REQUIRES_RTTI),1)
LOCAL_CFLAGS +=	-fno-rtti
else
REQUIRES_RTTI := 0
endif

# Make sure bionic is first so we can include system headers.
LOCAL_C_INCLUDES :=	\
	bionic	\
	external/stlport/stlport	\
	$(LLVM_ROOT_PATH)	\
	$(LLVM_ROOT_PATH)/include	\
	$(LLVM_ROOT_PATH)/device/include	\
	$(LOCAL_C_INCLUDES)

###########################################################
## Commands for running tblgen to compile a td file
###########################################################
define transform-device-td-to-out
@mkdir -p $(dir $@)
@echo "Device TableGen (gen-$(1)): $(LOCAL_MODULE) <= $<"
$(hide) $(TBLGEN) \
	-I $(dir $<)	\
	-I $(LLVM_ROOT_PATH)/include	\
	-I $(LLVM_ROOT_PATH)/device/include	\
	-I $(LLVM_ROOT_PATH)/lib/Target	\
    -gen-$(strip $(1)) \
    -o $@ $<
endef
