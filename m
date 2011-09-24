Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1IXGXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 02:23:06 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50533 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1IXGXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 02:23:02 -0400
From: keguang.zhang@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        chenj@lemote.com, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH 2/2] MIPS: Add defconfig for Loongson1B (UPDATED)
Date: Sat, 24 Sep 2011 14:21:56 +0800
Message-Id: <1316845316-5765-2-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316845316-5765-1-git-send-email-keguang.zhang@gmail.com>
References: <1316845316-5765-1-git-send-email-keguang.zhang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kelvin Cheung <keguang.zhang@gmail.com>

This patch adds defconfig for Loongson1B.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 arch/mips/configs/ls1b_defconfig |   95 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/configs/ls1b_defconfig

diff --git a/arch/mips/configs/ls1b_defconfig b/arch/mips/configs/ls1b_defconfig
new file mode 100644
index 0000000..f7c48f5
--- /dev/null
+++ b/arch/mips/configs/ls1b_defconfig
@@ -0,0 +1,95 @@
+CONFIG_MACH_LOONGSON1=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_PREEMPT_VOLUNTARY=y
+CONFIG_KEXEC=y
+# CONFIG_SECCOMP is not set
+CONFIG_EXPERIMENTAL=y
+# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_SYSVIPC=y
+CONFIG_BSD_PROCESS_ACCT=y
+CONFIG_BSD_PROCESS_ACCT_V3=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=16
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_RD_BZIP2=y
+CONFIG_RD_LZMA=y
+CONFIG_RD_XZ=y
+CONFIG_RD_LZO=y
+CONFIG_EXPERT=y
+CONFIG_KALLSYMS_ALL=y
+CONFIG_PERF_EVENTS=y
+# CONFIG_COMPAT_BRK is not set
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODVERSIONS=y
+# CONFIG_LBDAF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+# CONFIG_SUSPEND is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_DIAG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_STANDALONE is not set
+CONFIG_BLK_DEV_LOOP=y
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+CONFIG_VT_HW_CONSOLE_BINDING=y
+CONFIG_LEGACY_PTY_COUNT=8
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_RUNTIME_UARTS=1
+# CONFIG_HW_RANDOM is not set
+CONFIG_RAMOOPS=y
+# CONFIG_HWMON is not set
+# CONFIG_MFD_SUPPORT is not set
+# CONFIG_VGA_CONSOLE is not set
+# CONFIG_HID_SUPPORT is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT2_FS_POSIX_ACL=y
+CONFIG_EXT2_FS_SECURITY=y
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_POSIX_ACL=y
+CONFIG_EXT3_FS_SECURITY=y
+# CONFIG_DNOTIFY is not set
+CONFIG_PROC_KCORE=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_POSIX_ACL=y
+# CONFIG_MISC_FILESYSTEMS is not set
+# CONFIG_NETWORK_FILESYSTEMS is not set
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_UNUSED_SYMBOLS=y
+CONFIG_DEBUG_FS=y
+CONFIG_DETECT_HUNG_TASK=y
+CONFIG_SCHEDSTATS=y
+CONFIG_TIMER_STATS=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_MEMORY_INIT=y
+CONFIG_BOOT_PRINTK_DELAY=y
+CONFIG_SYSCTL_SYSCALL_CHECK=y
+# CONFIG_FTRACE is not set
+CONFIG_KGDB=y
+CONFIG_KGDB_LOW_LEVEL_TRAP=y
+CONFIG_KGDB_KDB=y
+CONFIG_KDB_KEYBOARD=y
+# CONFIG_EARLY_PRINTK is not set
-- 
1.7.4.1

