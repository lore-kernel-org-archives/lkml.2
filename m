Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0FBSKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:10:12 -0400
Received: from mail.logicpd.com ([66.162.60.3]:24358 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932576Ab0FBSJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:09:57 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 14:09:56 EDT
From: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Subject: [PATCH 1/2] Adding LogicPD OMAP 3530 LV SOM AND OMAP 35X
Date: Wed,  2 Jun 2010 13:54:43 -0400
Message-Id: <1275501284-17160-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 02 Jun 2010 17:54:46.0056 (UTC) FILETIME=[AFE74280:01CB027C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Adding LogicPD OMAP3 board support

        Adding support for LogicPD's OMAP 3530 LV SOM and
        OMAP 35x Torpedo board.

        Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
---
 arch/arm/configs/omap3_logic_defconfig |  990 ++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/Kconfig            |    8 +
 arch/arm/mach-omap2/Makefile           |    4 +
 arch/arm/mach-omap2/board-omap3logic.c |  185 ++++++
 4 files changed, 1187 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/configs/omap3_logic_defconfig
 create mode 100644 arch/arm/mach-omap2/board-omap3logic.c

diff --git a/arch/arm/configs/omap3_logic_defconfig b/arch/arm/configs/omap3_logic_defconfig
new file mode 100644
index 0000000..90f5ecd
--- /dev/null
+++ b/arch/arm/configs/omap3_logic_defconfig
@@ -0,0 +1,990 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.32
+# Wed May  5 19:56:47 2010
+#
+CONFIG_ARM=y
+CONFIG_SYS_SUPPORTS_APM_EMULATION=y
+CONFIG_GENERIC_GPIO=y
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_HAVE_LATENCYTOP_SUPPORT=y
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_HARDIRQS_SW_RESEND=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_ARCH_HAS_CPUFREQ=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
+CONFIG_OPROFILE_ARMV7=y
+CONFIG_VECTORS_BASE=0xffff0000
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_CONSTRUCTORS=y
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_LOCK_KERNEL=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+CONFIG_BSD_PROCESS_ACCT=y
+# CONFIG_BSD_PROCESS_ACCT_V3 is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_TREE_RCU=y
+# CONFIG_TREE_PREEMPT_RCU is not set
+# CONFIG_RCU_TRACE is not set
+CONFIG_RCU_FANOUT=32
+# CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_TREE_RCU_TRACE is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_GROUP_SCHED=y
+CONFIG_FAIR_GROUP_SCHED=y
+# CONFIG_RT_GROUP_SCHED is not set
+CONFIG_USER_SCHED=y
+# CONFIG_CGROUP_SCHED is not set
+# CONFIG_CGROUPS is not set
+# CONFIG_SYSFS_DEPRECATED_V2 is not set
+# CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+# CONFIG_RD_BZIP2 is not set
+# CONFIG_RD_LZMA is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
+CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+# CONFIG_SYSCTL_SYSCALL is not set
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_ALL is not set
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+# CONFIG_ELF_CORE is not set
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
+CONFIG_SHMEM=y
+CONFIG_AIO=y
+
+#
+# Kernel Performance Events And Counters
+#
+CONFIG_VM_EVENT_COUNTERS=y
+# CONFIG_COMPAT_BRK is not set
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_PROFILING=y
+CONFIG_TRACEPOINTS=y
+CONFIG_OPROFILE=y
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_KPROBES is not set
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+CONFIG_HAVE_CLK=y
+
+#
+# GCOV-based kernel profiling
+#
+# CONFIG_GCOV_KERNEL is not set
+# CONFIG_SLOW_WORK is not set
+CONFIG_HAVE_GENERIC_DMA_COHERENT=y
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+CONFIG_MODULE_FORCE_LOAD=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+CONFIG_MODVERSIONS=y
+CONFIG_MODULE_SRCVERSION_ALL=y
+CONFIG_BLOCK=y
+CONFIG_LBDAF=y
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_BLK_DEV_INTEGRITY is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+CONFIG_FREEZER=y
+
+#
+# System Type
+#
+CONFIG_MMU=y
+# CONFIG_ARCH_AAEC2000 is not set
+# CONFIG_ARCH_INTEGRATOR is not set
+# CONFIG_ARCH_REALVIEW is not set
+# CONFIG_ARCH_VERSATILE is not set
+# CONFIG_ARCH_AT91 is not set
+# CONFIG_ARCH_CLPS711X is not set
+# CONFIG_ARCH_GEMINI is not set
+# CONFIG_ARCH_EBSA110 is not set
+# CONFIG_ARCH_EP93XX is not set
+# CONFIG_ARCH_FOOTBRIDGE is not set
+# CONFIG_ARCH_MXC is not set
+# CONFIG_ARCH_STMP3XXX is not set
+# CONFIG_ARCH_NETX is not set
+# CONFIG_ARCH_H720X is not set
+# CONFIG_ARCH_NOMADIK is not set
+# CONFIG_ARCH_IOP13XX is not set
+# CONFIG_ARCH_IOP32X is not set
+# CONFIG_ARCH_IOP33X is not set
+# CONFIG_ARCH_IXP23XX is not set
+# CONFIG_ARCH_IXP2000 is not set
+# CONFIG_ARCH_IXP4XX is not set
+# CONFIG_ARCH_L7200 is not set
+# CONFIG_ARCH_KIRKWOOD is not set
+# CONFIG_ARCH_LOKI is not set
+# CONFIG_ARCH_MV78XX0 is not set
+# CONFIG_ARCH_ORION5X is not set
+# CONFIG_ARCH_MMP is not set
+# CONFIG_ARCH_KS8695 is not set
+# CONFIG_ARCH_NS9XXX is not set
+# CONFIG_ARCH_W90X900 is not set
+# CONFIG_ARCH_PNX4008 is not set
+# CONFIG_ARCH_PXA is not set
+# CONFIG_ARCH_MSM is not set
+# CONFIG_ARCH_RPC is not set
+# CONFIG_ARCH_SA1100 is not set
+# CONFIG_ARCH_S3C2410 is not set
+# CONFIG_ARCH_S3C64XX is not set
+# CONFIG_ARCH_S5PC1XX is not set
+# CONFIG_ARCH_SHARK is not set
+# CONFIG_ARCH_LH7A40X is not set
+# CONFIG_ARCH_U300 is not set
+# CONFIG_ARCH_DAVINCI is not set
+CONFIG_ARCH_OMAP=y
+# CONFIG_ARCH_BCMRING is not set
+
+#
+# TI OMAP Implementations
+#
+CONFIG_ARCH_OMAP_OTG=y
+# CONFIG_ARCH_OMAP1 is not set
+# CONFIG_ARCH_OMAP2 is not set
+CONFIG_ARCH_OMAP3=y
+# CONFIG_ARCH_OMAP4 is not set
+
+#
+# OMAP Feature Selections
+#
+# CONFIG_OMAP_DEBUG_POWERDOMAIN is not set
+# CONFIG_OMAP_DEBUG_CLOCKDOMAIN is not set
+CONFIG_OMAP_RESET_CLOCKS=y
+CONFIG_OMAP_MUX=y
+CONFIG_OMAP_MUX_DEBUG=y
+CONFIG_OMAP_MUX_WARNINGS=y
+CONFIG_OMAP_MCBSP=y
+CONFIG_OMAP_MBOX_FWK=m
+# CONFIG_OMAP_MPU_TIMER is not set
+CONFIG_OMAP_32K_TIMER=y
+CONFIG_OMAP_32K_TIMER_HZ=128
+CONFIG_OMAP_DM_TIMER=y
+CONFIG_OMAP_LL_DEBUG_UART1=y
+# CONFIG_OMAP_LL_DEBUG_UART2 is not set
+# CONFIG_OMAP_LL_DEBUG_UART3 is not set
+# CONFIG_OMAP_LL_DEBUG_NONE is not set
+# CONFIG_OMAP_PM_NONE is not set
+CONFIG_OMAP_PM_NOOP=y
+CONFIG_ARCH_OMAP34XX=y
+CONFIG_ARCH_OMAP3430=y
+
+#
+# OMAP Board Type
+#
+# CONFIG_MACH_OMAP3_BEAGLE is not set
+# CONFIG_MACH_OMAP_LDP is not set
+CONFIG_MACH_OMAP3530_LV_SOM=y
+CONFIG_MACH_OMAP3_TORPEDO=y
+# CONFIG_MACH_OVERO is not set
+# CONFIG_MACH_OMAP3EVM is not set
+# CONFIG_MACH_OMAP3517EVM is not set
+# CONFIG_MACH_OMAP3_PANDORA is not set
+# CONFIG_MACH_OMAP_3430SDP is not set
+# CONFIG_MACH_NOKIA_RX51 is not set
+# CONFIG_MACH_OMAP_ZOOM2 is not set
+# CONFIG_MACH_OMAP_ZOOM3 is not set
+# CONFIG_MACH_CM_T35 is not set
+# CONFIG_MACH_IGEP0020 is not set
+# CONFIG_MACH_OMAP_3630SDP is not set
+
+#
+# Processor Type
+#
+CONFIG_CPU_32=y
+CONFIG_CPU_32v6K=y
+CONFIG_CPU_V7=y
+CONFIG_CPU_32v7=y
+CONFIG_CPU_ABRT_EV7=y
+CONFIG_CPU_PABRT_V7=y
+CONFIG_CPU_CACHE_V7=y
+CONFIG_CPU_CACHE_VIPT=y
+CONFIG_CPU_COPY_V6=y
+CONFIG_CPU_TLB_V7=y
+CONFIG_CPU_HAS_ASID=y
+CONFIG_CPU_CP15=y
+CONFIG_CPU_CP15_MMU=y
+
+#
+# Processor Features
+#
+CONFIG_ARM_THUMB=y
+CONFIG_ARM_THUMBEE=y
+# CONFIG_CPU_ICACHE_DISABLE is not set
+# CONFIG_CPU_DCACHE_DISABLE is not set
+# CONFIG_CPU_BPREDICT_DISABLE is not set
+CONFIG_HAS_TLS_REG=y
+CONFIG_ARM_L1_CACHE_SHIFT=6
+# CONFIG_ARM_ERRATA_430973 is not set
+# CONFIG_ARM_ERRATA_458693 is not set
+# CONFIG_ARM_ERRATA_460075 is not set
+CONFIG_COMMON_CLKDEV=y
+
+#
+# Bus support
+#
+# CONFIG_PCI_SYSCALL is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+# CONFIG_PCCARD is not set
+
+#
+# Kernel Features
+#
+CONFIG_TICK_ONESHOT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+CONFIG_VMSPLIT_3G=y
+# CONFIG_VMSPLIT_2G is not set
+# CONFIG_VMSPLIT_1G is not set
+CONFIG_PAGE_OFFSET=0xC0000000
+# CONFIG_PREEMPT_NONE is not set
+# CONFIG_PREEMPT_VOLUNTARY is not set
+CONFIG_PREEMPT=y
+CONFIG_HZ=128
+# CONFIG_THUMB2_KERNEL is not set
+CONFIG_AEABI=y
+# CONFIG_OABI_COMPAT is not set
+# CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
+# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
+# CONFIG_HIGHMEM is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_PAGEFLAGS_EXTENDED=y
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_PHYS_ADDR_T_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=0
+CONFIG_VIRT_TO_BUS=y
+CONFIG_HAVE_MLOCK=y
+CONFIG_HAVE_MLOCKED_PAGE_BIT=y
+# CONFIG_KSM is not set
+CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
+CONFIG_LEDS=y
+CONFIG_ALIGNMENT_TRAP=y
+# CONFIG_UACCESS_WITH_MEMCPY is not set
+
+#
+# Boot options
+#
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE=" debug "
+# CONFIG_XIP_KERNEL is not set
+CONFIG_KEXEC=y
+CONFIG_ATAGS_PROC=y
+
+#
+# CPU Power Management
+#
+CONFIG_CPU_FREQ=y
+CONFIG_CPU_FREQ_TABLE=y
+CONFIG_CPU_FREQ_DEBUG=y
+CONFIG_CPU_FREQ_STAT=y
+CONFIG_CPU_FREQ_STAT_DETAILS=y
+CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
+# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
+CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
+CONFIG_CPU_FREQ_GOV_POWERSAVE=y
+CONFIG_CPU_FREQ_GOV_USERSPACE=y
+CONFIG_CPU_FREQ_GOV_ONDEMAND=y
+CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
+# CONFIG_CPU_IDLE is not set
+
+#
+# Floating point emulation
+#
+
+#
+# At least one emulation must be selected
+#
+CONFIG_VFP=y
+CONFIG_VFPv3=y
+CONFIG_NEON=y
+
+#
+# Userspace binary formats
+#
+CONFIG_BINFMT_ELF=y
+CONFIG_HAVE_AOUT=y
+CONFIG_BINFMT_AOUT=m
+CONFIG_BINFMT_MISC=y
+
+#
+# Power management options
+#
+CONFIG_PM=y
+CONFIG_PM_DEBUG=y
+# CONFIG_PM_VERBOSE is not set
+CONFIG_CAN_PM_TRACE=y
+CONFIG_PM_SLEEP=y
+CONFIG_SUSPEND=y
+# CONFIG_PM_TEST_SUSPEND is not set
+CONFIG_SUSPEND_FREEZER=y
+# CONFIG_APM_EMULATION is not set
+CONFIG_PM_RUNTIME=y
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+# CONFIG_NET is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+# CONFIG_DEVTMPFS is not set
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+CONFIG_FW_LOADER=y
+CONFIG_FIRMWARE_IN_KERNEL=y
+CONFIG_EXTRA_FIRMWARE=""
+# CONFIG_DEBUG_DRIVER is not set
+# CONFIG_DEBUG_DEVRES is not set
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_MTD is not set
+# CONFIG_PARPORT is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=y
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=16384
+# CONFIG_BLK_DEV_XIP is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_MG_DISK is not set
+# CONFIG_MISC_DEVICES is not set
+CONFIG_HAVE_IDE=y
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+# CONFIG_MD is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+CONFIG_INPUT_EVDEV=y
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+CONFIG_INPUT_MISC=y
+CONFIG_INPUT_TWL4030_PWRBUTTON=y
+CONFIG_INPUT_UINPUT=y
+# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+CONFIG_VT=y
+CONFIG_CONSOLE_TRANSLATIONS=y
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+CONFIG_VT_HW_CONSOLE_BINDING=y
+CONFIG_DEVKMEM=y
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=32
+CONFIG_SERIAL_8250_RUNTIME_UARTS=4
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_MANY_PORTS=y
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+CONFIG_SERIAL_8250_DETECT_IRQ=y
+CONFIG_SERIAL_8250_RSA=y
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM_TIMERIOMEM is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+CONFIG_I2C=y
+CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_COMPAT=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_HELPER_AUTO=y
+
+#
+# I2C Hardware Bus support
+#
+
+#
+# I2C system bus drivers (mostly embedded / system-on-chip)
+#
+# CONFIG_I2C_DESIGNWARE is not set
+# CONFIG_I2C_GPIO is not set
+# CONFIG_I2C_OCORES is not set
+CONFIG_I2C_OMAP=y
+# CONFIG_I2C_SIMTEC is not set
+
+#
+# External I2C/SMBus adapter drivers
+#
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_TAOS_EVM is not set
+
+#
+# Other I2C/SMBus bus drivers
+#
+# CONFIG_I2C_PCA_PLATFORM is not set
+# CONFIG_I2C_STUB is not set
+
+#
+# Miscellaneous I2C Chip support
+#
+# CONFIG_DS1682 is not set
+# CONFIG_SENSORS_TSL2550 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+# CONFIG_SPI is not set
+
+#
+# PPS support
+#
+# CONFIG_PPS is not set
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_GPIOLIB=y
+# CONFIG_DEBUG_GPIO is not set
+CONFIG_GPIO_SYSFS=y
+
+#
+# Memory mapped GPIO expanders:
+#
+
+#
+# I2C GPIO expanders:
+#
+# CONFIG_GPIO_MAX732X is not set
+# CONFIG_GPIO_PCA953X is not set
+# CONFIG_GPIO_PCF857X is not set
+CONFIG_GPIO_TWL4030=y
+
+#
+# PCI GPIO expanders:
+#
+
+#
+# SPI GPIO expanders:
+#
+
+#
+# AC97 GPIO expanders:
+#
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+# CONFIG_THERMAL is not set
+# CONFIG_WATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_CORE is not set
+# CONFIG_MFD_SM501 is not set
+# CONFIG_MFD_ASIC3 is not set
+# CONFIG_HTC_EGPIO is not set
+# CONFIG_HTC_PASIC3 is not set
+# CONFIG_TPS65010 is not set
+CONFIG_TWL4030_CORE=y
+CONFIG_TWL4030_POWER=y
+# CONFIG_TWL4030_CODEC is not set
+# CONFIG_MFD_TMIO is not set
+# CONFIG_MFD_T7L66XB is not set
+# CONFIG_MFD_TC6387XB is not set
+# CONFIG_MFD_TC6393XB is not set
+# CONFIG_PMIC_DA903X is not set
+# CONFIG_MFD_WM8400 is not set
+# CONFIG_MFD_WM831X is not set
+# CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_MFD_PCF50633 is not set
+# CONFIG_AB3100_CORE is not set
+CONFIG_REGULATOR=y
+# CONFIG_REGULATOR_DEBUG is not set
+# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
+# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
+# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
+# CONFIG_REGULATOR_BQ24022 is not set
+# CONFIG_REGULATOR_MAX1586 is not set
+CONFIG_REGULATOR_TWL4030=y
+# CONFIG_REGULATOR_LP3971 is not set
+# CONFIG_REGULATOR_TPS65023 is not set
+# CONFIG_REGULATOR_TPS6507X is not set
+# CONFIG_MEDIA_SUPPORT is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
+# CONFIG_OMAP2_DSS is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Console display driver support
+#
+# CONFIG_VGA_CONSOLE is not set
+CONFIG_DUMMY_CONSOLE=y
+# CONFIG_SOUND is not set
+# CONFIG_HID_SUPPORT is not set
+# CONFIG_USB_SUPPORT is not set
+CONFIG_USB_ARCH_HAS_EHCI=y
+# CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_ACCESSIBILITY is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+# CONFIG_RTC_DEBUG is not set
+
+#
+# RTC interfaces
+#
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+# CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
+# CONFIG_RTC_DRV_DS1672 is not set
+# CONFIG_RTC_DRV_MAX6900 is not set
+# CONFIG_RTC_DRV_RS5C372 is not set
+# CONFIG_RTC_DRV_ISL1208 is not set
+# CONFIG_RTC_DRV_X1205 is not set
+# CONFIG_RTC_DRV_PCF8563 is not set
+# CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set
+CONFIG_RTC_DRV_TWL4030=y
+# CONFIG_RTC_DRV_S35390A is not set
+# CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
+# CONFIG_RTC_DRV_RX8025 is not set
+
+#
+# SPI RTC drivers
+#
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_CMOS is not set
+# CONFIG_RTC_DRV_DS1286 is not set
+# CONFIG_RTC_DRV_DS1511 is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T35 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_BQ4802 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+# CONFIG_DMADEVICES is not set
+# CONFIG_AUXDISPLAY is not set
+# CONFIG_UIO is not set
+
+#
+# TI VLYNQ
+#
+# CONFIG_STAGING is not set
+
+#
+# CBUS support
+#
+# CONFIG_CBUS is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+# CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+# CONFIG_EXT3_FS_XATTR is not set
+# CONFIG_EXT4_FS is not set
+CONFIG_JBD=y
+# CONFIG_JBD_DEBUG is not set
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_BTRFS_FS is not set
+# CONFIG_NILFS2_FS is not set
+CONFIG_FILE_LOCKING=y
+CONFIG_FSNOTIFY=y
+CONFIG_DNOTIFY=y
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+CONFIG_QUOTA=y
+CONFIG_PRINT_QUOTA_WARNING=y
+# CONFIG_QFMT_V1 is not set
+# CONFIG_QFMT_V2 is not set
+CONFIG_QUOTACTL=y
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+CONFIG_FAT_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_FAT_DEFAULT_CODEPAGE=437
+CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+CONFIG_MISC_FILESYSTEMS=y
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+CONFIG_CRAMFS=y
+CONFIG_SQUASHFS=y
+# CONFIG_SQUASHFS_EMBEDDED is not set
+CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
+# CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_OMFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+CONFIG_ROMFS_FS=y
+CONFIG_ROMFS_BACKED_BY_BLOCK=y
+# CONFIG_ROMFS_BACKED_BY_MTD is not set
+# CONFIG_ROMFS_BACKED_BY_BOTH is not set
+CONFIG_ROMFS_ON_BLOCK=y
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+
+#
+# Partition Types
+#
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_ACORN_PARTITION is not set
+# CONFIG_OSF_PARTITION is not set
+# CONFIG_AMIGA_PARTITION is not set
+# CONFIG_ATARI_PARTITION is not set
+# CONFIG_MAC_PARTITION is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_BSD_DISKLABEL is not set
+# CONFIG_MINIX_SUBPARTITION is not set
+# CONFIG_SOLARIS_X86_PARTITION is not set
+# CONFIG_UNIXWARE_DISKLABEL is not set
+# CONFIG_LDM_PARTITION is not set
+# CONFIG_SGI_PARTITION is not set
+# CONFIG_ULTRIX_PARTITION is not set
+# CONFIG_SUN_PARTITION is not set
+# CONFIG_KARMA_PARTITION is not set
+# CONFIG_EFI_PARTITION is not set
+# CONFIG_SYSV68_PARTITION is not set
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="iso8859-1"
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_CODEPAGE_737=m
+CONFIG_NLS_CODEPAGE_775=m
+CONFIG_NLS_CODEPAGE_850=m
+CONFIG_NLS_CODEPAGE_852=m
+CONFIG_NLS_CODEPAGE_855=m
+CONFIG_NLS_CODEPAGE_857=m
+CONFIG_NLS_CODEPAGE_860=m
+CONFIG_NLS_CODEPAGE_861=m
+CONFIG_NLS_CODEPAGE_862=m
+CONFIG_NLS_CODEPAGE_863=m
+CONFIG_NLS_CODEPAGE_864=m
+CONFIG_NLS_CODEPAGE_865=m
+CONFIG_NLS_CODEPAGE_866=m
+CONFIG_NLS_CODEPAGE_869=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_CODEPAGE_950=m
+CONFIG_NLS_CODEPAGE_932=m
+CONFIG_NLS_CODEPAGE_949=m
+CONFIG_NLS_CODEPAGE_874=m
+CONFIG_NLS_ISO8859_8=m
+CONFIG_NLS_CODEPAGE_1250=m
+CONFIG_NLS_CODEPAGE_1251=m
+CONFIG_NLS_ASCII=m
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_ISO8859_2=m
+CONFIG_NLS_ISO8859_3=m
+CONFIG_NLS_ISO8859_4=m
+CONFIG_NLS_ISO8859_5=m
+CONFIG_NLS_ISO8859_6=m
+CONFIG_NLS_ISO8859_7=m
+CONFIG_NLS_ISO8859_9=m
+CONFIG_NLS_ISO8859_13=m
+CONFIG_NLS_ISO8859_14=m
+CONFIG_NLS_ISO8859_15=m
+CONFIG_NLS_KOI8_R=m
+CONFIG_NLS_KOI8_U=m
+CONFIG_NLS_UTF8=y
+
+#
+# Kernel hacking
+#
+CONFIG_PRINTK_TIME=y
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=1024
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_STRIP_ASM_SYMS is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
+CONFIG_DEBUG_KERNEL=y
+# CONFIG_DEBUG_SHIRQ is not set
+CONFIG_DETECT_SOFTLOCKUP=y
+# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
+CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
+CONFIG_DETECT_HUNG_TASK=y
+# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
+CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
+CONFIG_SCHED_DEBUG=y
+CONFIG_SCHEDSTATS=y
+CONFIG_TIMER_STATS=y
+# CONFIG_DEBUG_OBJECTS is not set
+# CONFIG_DEBUG_SLAB is not set
+# CONFIG_DEBUG_KMEMLEAK is not set
+CONFIG_DEBUG_PREEMPT=y
+# CONFIG_DEBUG_RT_MUTEXES is not set
+# CONFIG_RT_MUTEX_TESTER is not set
+# CONFIG_DEBUG_SPINLOCK is not set
+CONFIG_DEBUG_MUTEXES=y
+# CONFIG_DEBUG_LOCK_ALLOC is not set
+# CONFIG_PROVE_LOCKING is not set
+# CONFIG_LOCK_STAT is not set
+# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
+# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+CONFIG_STACKTRACE=y
+# CONFIG_DEBUG_KOBJECT is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_INFO is not set
+# CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_WRITECOUNT is not set
+# CONFIG_DEBUG_MEMORY_INIT is not set
+# CONFIG_DEBUG_LIST is not set
+# CONFIG_DEBUG_SG is not set
+# CONFIG_DEBUG_NOTIFIERS is not set
+# CONFIG_DEBUG_CREDENTIALS is not set
+# CONFIG_BOOT_PRINTK_DELAY is not set
+# CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+# CONFIG_BACKTRACE_SELF_TEST is not set
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
+# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
+# CONFIG_FAULT_INJECTION is not set
+# CONFIG_LATENCYTOP is not set
+# CONFIG_PAGE_POISONING is not set
+CONFIG_NOP_TRACER=y
+CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_RING_BUFFER=y
+CONFIG_EVENT_TRACING=y
+CONFIG_CONTEXT_SWITCH_TRACER=y
+CONFIG_RING_BUFFER_ALLOW_SWAP=y
+CONFIG_TRACING=y
+CONFIG_TRACING_SUPPORT=y
+CONFIG_FTRACE=y
+# CONFIG_FUNCTION_TRACER is not set
+# CONFIG_IRQSOFF_TRACER is not set
+# CONFIG_PREEMPT_TRACER is not set
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_ENABLE_DEFAULT_TRACERS is not set
+# CONFIG_BOOT_TRACER is not set
+CONFIG_BRANCH_PROFILE_NONE=y
+# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
+# CONFIG_PROFILE_ALL_BRANCHES is not set
+# CONFIG_STACK_TRACER is not set
+# CONFIG_KMEMTRACE is not set
+# CONFIG_WORKQUEUE_TRACER is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_RING_BUFFER_BENCHMARK is not set
+# CONFIG_DYNAMIC_DEBUG is not set
+# CONFIG_SAMPLES is not set
+CONFIG_HAVE_ARCH_KGDB=y
+# CONFIG_KGDB is not set
+CONFIG_ARM_UNWIND=y
+# CONFIG_DEBUG_USER is not set
+# CONFIG_DEBUG_ERRORS is not set
+# CONFIG_DEBUG_STACK_USAGE is not set
+CONFIG_DEBUG_LL=y
+# CONFIG_DEBUG_ICEDCC is not set
+
+#
+# Security options
+#
+CONFIG_KEYS=y
+# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITYFS is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_CRYPTO is not set
+CONFIG_BINARY_PRINTF=y
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_T10DIF is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 2455dcc..f670faa 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -69,6 +69,14 @@ config MACH_OMAP_LDP
 	depends on ARCH_OMAP3
 	select OMAP_PACKAGE_CBB
 
+config MACH_OMAP3530_LV_SOM
+        bool "OMAP3 Logic 3530 LV SOM board"
+        depends on ARCH_OMAP3
+
+config MACH_OMAP3_TORPEDO
+        bool "OMAP3 Logic 35x Torpedo board"
+        depends on ARCH_OMAP3
+
 config MACH_OVERO
 	bool "Gumstix Overo board"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 4b9fc57..77422be 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -109,6 +109,10 @@ obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o \
                                            hsmmc.o
 obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o \
 					   hsmmc.o
+obj-$(CONFIG_MACH_OMAP3530_LV_SOM)      += board-omap3logic.o \
+                                           hsmmc.o
+obj-$(CONFIG_MACH_OMAP3_TORPEDO)        += board-omap3logic.o \
+                                           hsmmc.o
 obj-$(CONFIG_MACH_OVERO)		+= board-overo.o \
 					   hsmmc.o
 obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
new file mode 100644
index 0000000..fe5db85
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -0,0 +1,185 @@
+/*
+ * linux/arch/arm/mach-omap2/board-omap3logic.c
+ *
+ * Copyright (C) 2010 Li-Pro.Net
+ * Stephan Linz <linz@li-pro.net>
+ *
+ * Copyright (C) 2010 Logic Product Development, Inc.
+ * Peter Barada <peter.barada@logicpd.com>
+ *
+ * Modified from Beagle, EVM, and RX51
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <linux/regulator/machine.h>
+
+#include<linux/i2c/twl.h>
+
+#include <mach/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include "mux.h"
+
+#include <plat/mux.h>
+#include <plat/board.h>
+#include <plat/common.h>
+#include <plat/gpmc.h>
+#include <plat/timer-gp.h>
+
+/* Micron MT46H32M32LF-6 */
+/* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on LogicPD
+ * boards we can't use the default values -- why? I suspect the reason
+ * lies in the boot strap code. We correct this part if we have ported
+ * U-Boot and X-Load. */
+#include <plat/sdrc.h>
+static struct omap_sdrc_params mt46h32m32lf6_sdrc_params[] = {
+	[0] = {
+		.rate	     = 166000000,
+		.actim_ctrla = 0xaa9db4c6,
+		.actim_ctrlb = 0x00011517,
+		.rfr_ctrl    = 0x0004e201,
+		.mr	     = 0x00000032,
+	},
+	[1] = {
+		.rate	     = 165941176,
+		.actim_ctrla = 0xaa9db4c6,
+		.actim_ctrlb = 0x00011517,
+		.rfr_ctrl    = 0x0004e201,
+		.mr	     = 0x00000032,
+	},
+	[2] = {
+		.rate	     = 83000000,
+		.actim_ctrla = 0x8a99b481,
+		.actim_ctrlb = 0x00011312,
+		.rfr_ctrl    = 0x0003de01,
+		.mr	     = 0x00000032,
+	},
+	[3] = {
+		.rate	     = 82970588,
+		.actim_ctrla = 0x8a99b481,
+		.actim_ctrlb = 0x00011312,
+		.rfr_ctrl    = 0x0003de01,
+		.mr	     = 0x00000032,
+	},
+	[4] = {
+		.rate	     = 0
+	},
+};
+
+static int omap3logic_twl_gpio_setup(struct device *dev,
+				unsigned gpio, unsigned ngpio)
+{
+	return 0;
+}
+
+static struct twl4030_gpio_platform_data omap3logic_gpio_data = {
+	.gpio_base	= OMAP_MAX_GPIO_LINES,
+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
+	.irq_end	= TWL4030_GPIO_IRQ_END,
+	.use_leds	= true,
+	.pullups	= BIT(1),
+	.pulldowns	= BIT(2)  | BIT(6)  | BIT(7)  | BIT(8)
+			| BIT(13) | BIT(15) | BIT(16) | BIT(17),
+	.setup		= omap3logic_twl_gpio_setup,
+};
+
+static struct twl4030_platform_data omap3logic_twldata = {
+	.irq_base	= TWL4030_IRQ_BASE,
+	.irq_end	= TWL4030_IRQ_END,
+
+	/* platform_data for children goes here */
+	.gpio		= &omap3logic_gpio_data,
+};
+
+static struct i2c_board_info __initdata omap3logic_i2c_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("twl4030", 0x48),
+		.flags = I2C_CLIENT_WAKE,
+		.irq = INT_34XX_SYS_NIRQ,
+		.platform_data = &omap3logic_twldata,
+	},
+};
+
+static int __init omap3logic_i2c_init(void)
+{
+	omap_register_i2c_bus(1, 2600, omap3logic_i2c_boardinfo,
+				ARRAY_SIZE(omap3logic_i2c_boardinfo));
+	return 0;
+}
+
+static struct omap_board_config_kernel omap3logic_config[] __initdata = {
+};
+
+static void __init omap3logic_init_irq(void)
+{
+	omap_board_config = omap3logic_config;
+	omap_board_config_size = ARRAY_SIZE(omap3logic_config);
+	omap2_init_common_hw(mt46h32m32lf6_sdrc_params,
+				mt46h32m32lf6_sdrc_params);
+	omap_init_irq();
+#ifdef CONFIG_OMAP_32K_TIMER
+	omap2_gp_clockevent_set_gptimer(12);
+#endif
+	omap_gpio_init();
+}
+
+static struct platform_device *omap3logic_devices[] __initdata = {
+};
+
+static void __init omap3logic_init(void)
+{
+	omap3logic_i2c_init();
+	platform_add_devices(omap3logic_devices,
+				ARRAY_SIZE(omap3logic_devices));
+	omap_serial_init();
+
+	/* Ensure SDRC pins are mux'd for self-refresh */
+/*	omap_cfg_reg(H16_34XX_SDRC_CKE0);
+	omap_cfg_reg(H17_34XX_SDRC_CKE1);
+	omap_cfg_reg(SDRC_CKE0);
+	omap_cfg_reg(SDRC_CKE1); */
+	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
+	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
+}
+
+static void __init omap3logic_map_io(void)
+{
+	omap2_set_globals_343x();
+	omap34xx_map_common_io();
+}
+
+MACHINE_START(OMAP3_TORPEDO, "Logic OMAP3 Torpedo board")
+	/* Maintainer: Peter Barada <peterb@logicpd.com> */
+	.phys_io	= 0x48000000,
+	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+	.boot_params	= 0x80000100,
+	.map_io		= omap3logic_map_io,
+	.init_irq	= omap3logic_init_irq,
+	.init_machine	= omap3logic_init,
+	.timer		= &omap_timer,
+MACHINE_END
+
+MACHINE_START(OMAP3530_LV_SOM, "OMAP Logic 3530 LV SOM board")
+	/* Maintainer: Peter Barada <peterb@logicpd.com> */
+	.phys_io	= 0x48000000,
+	.io_pg_offst	= ((0xd8000000) >> 18) & 0xfffc,
+	.boot_params	= 0x80000100,
+	.map_io		= omap3logic_map_io,
+	.init_irq	= omap3logic_init_irq,
+	.init_machine	= omap3logic_init,
+	.timer		= &omap_timer,
+MACHINE_END
-- 
1.6.0.4

