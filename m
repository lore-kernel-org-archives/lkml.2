Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2ICFVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:21:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54603 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab2ICFVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:21:02 -0400
X-Originating-IP: 217.70.178.150
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 22:20:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/5] x86: Update defconfigs to current results of "make
 savedefconfig"
Message-ID: <80c8a5fbeaf6cdb72fb78a016013427efee52668.1346649518.git.josh@joshtriplett.org>
References: <cover.1346649518.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346649518.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 defconfigs have become somewhat out of date compared to the
current result of "make savedefconfig".  Update them to the current output, as
a prelude to further defconfig changes, to avoid unrelated noise in
those further changes.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/configs/i386_defconfig   |   12 ++++--------
 arch/x86/configs/x86_64_defconfig |   12 ++++--------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 119db67..1903408 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -8,6 +8,8 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
@@ -34,8 +36,6 @@ CONFIG_SGI_PARTITION=y
 CONFIG_SUN_PARTITION=y
 CONFIG_KARMA_PARTITION=y
 CONFIG_EFI_PARTITION=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
 CONFIG_SMP=y
 CONFIG_X86_GENERIC=y
 CONFIG_HPET_TIMER=y
@@ -231,8 +231,6 @@ CONFIG_SND_HRTIMER=y
 CONFIG_SND_HDA_INTEL=y
 CONFIG_SND_HDA_HWDEP=y
 CONFIG_HIDRAW=y
-CONFIG_HID_PID=y
-CONFIG_USB_HIDDEV=y
 CONFIG_HID_GYRATION=y
 CONFIG_LOGITECH_FF=y
 CONFIG_HID_NTRIG=y
@@ -243,11 +241,11 @@ CONFIG_HID_SAMSUNG=y
 CONFIG_HID_SONY=y
 CONFIG_HID_SUNPLUS=y
 CONFIG_HID_TOPSEED=y
+CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
 CONFIG_USB=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
@@ -280,7 +278,6 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
@@ -299,7 +296,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_STACK_USAGE=y
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 76eb290..c2c0448 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -8,6 +8,8 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_TASK_XACCT=y
 CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_FREEZER=y
@@ -34,8 +36,6 @@ CONFIG_SGI_PARTITION=y
 CONFIG_SUN_PARTITION=y
 CONFIG_KARMA_PARTITION=y
 CONFIG_EFI_PARTITION=y
-CONFIG_NO_HZ=y
-CONFIG_HIGH_RES_TIMERS=y
 CONFIG_SMP=y
 CONFIG_CALGARY_IOMMU=y
 CONFIG_NR_CPUS=64
@@ -227,8 +227,6 @@ CONFIG_SND_HRTIMER=y
 CONFIG_SND_HDA_INTEL=y
 CONFIG_SND_HDA_HWDEP=y
 CONFIG_HIDRAW=y
-CONFIG_HID_PID=y
-CONFIG_USB_HIDDEV=y
 CONFIG_HID_GYRATION=y
 CONFIG_LOGITECH_FF=y
 CONFIG_HID_NTRIG=y
@@ -239,11 +237,11 @@ CONFIG_HID_SAMSUNG=y
 CONFIG_HID_SONY=y
 CONFIG_HID_SUNPLUS=y
 CONFIG_HID_TOPSEED=y
+CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
 CONFIG_USB=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_DEVICE_CLASS is not set
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
@@ -280,7 +278,6 @@ CONFIG_PROC_KCORE=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
@@ -298,7 +295,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_STACK_USAGE=y
-CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
-- 
1.7.10.4

