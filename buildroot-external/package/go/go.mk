ifeq ($(BR2_arm),y)
ifeq ($(BR2_ARM_SOFT_FLOAT),y)
GO_GOARM := $(GO_GOARM),softfloat
endif
endif
