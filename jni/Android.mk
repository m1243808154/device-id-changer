LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := device_id_changer
LOCAL_SRC_FILES := device_id_changer.c
LOCAL_CFLAGS := -Wall -Wextra -O2
LOCAL_LDLIBS := -llog

include $(BUILD_EXECUTABLE)
