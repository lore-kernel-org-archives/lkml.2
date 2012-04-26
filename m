Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2DZMUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:20:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52736 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2DZMUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:20:01 -0400
Date: Thu, 26 Apr 2012 05:19:44 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-392d65a9adbe2f09707d2de27110dafb9c8dc08b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333643084-26776-5-git-send-email-robert.richter@amd.com>
References: <1333643084-26776-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove PERF_COUNTERS config option
Git-Commit-ID: 392d65a9adbe2f09707d2de27110dafb9c8dc08b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 05:19:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  392d65a9adbe2f09707d2de27110dafb9c8dc08b
Gitweb:     http://git.kernel.org/tip/392d65a9adbe2f09707d2de27110dafb9c8dc08b
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 5 Apr 2012 18:24:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Apr 2012 13:52:52 +0200

perf: Remove PERF_COUNTERS config option

Renaming remaining PERF_COUNTERS options into PERF_EVENTS.

Think we can get rid of PERF_COUNTERS now.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333643084-26776-5-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/configs/bcmring_defconfig        |    2 +-
 arch/powerpc/configs/chroma_defconfig     |    2 +-
 arch/powerpc/configs/gamecube_defconfig   |    2 +-
 arch/powerpc/configs/wii_defconfig        |    2 +-
 arch/sh/configs/sh7785lcr_32bit_defconfig |    2 +-
 arch/sparc/configs/sparc64_defconfig      |    2 +-
 init/Kconfig                              |   14 +-------------
 7 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/arm/configs/bcmring_defconfig b/arch/arm/configs/bcmring_defconfig
index 795374d..9e6a8fe 100644
--- a/arch/arm/configs/bcmring_defconfig
+++ b/arch/arm/configs/bcmring_defconfig
@@ -11,7 +11,7 @@ CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_TIMERFD is not set
 # CONFIG_EVENTFD is not set
 # CONFIG_AIO is not set
-CONFIG_PERF_COUNTERS=y
+CONFIG_PERF_EVENTS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 # CONFIG_SLUB_DEBUG is not set
 # CONFIG_COMPAT_BRK is not set
diff --git a/arch/powerpc/configs/chroma_defconfig b/arch/powerpc/configs/chroma_defconfig
index f104ccd..b1f9597 100644
--- a/arch/powerpc/configs/chroma_defconfig
+++ b/arch/powerpc/configs/chroma_defconfig
@@ -32,7 +32,7 @@ CONFIG_RD_LZMA=y
 CONFIG_INITRAMFS_COMPRESSION_GZIP=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_EMBEDDED=y
-CONFIG_PERF_COUNTERS=y
+CONFIG_PERF_EVENTS=y
 CONFIG_PROFILING=y
 CONFIG_OPROFILE=y
 CONFIG_KPROBES=y
diff --git a/arch/powerpc/configs/gamecube_defconfig b/arch/powerpc/configs/gamecube_defconfig
index e74d3a4..9ef2cc1 100644
--- a/arch/powerpc/configs/gamecube_defconfig
+++ b/arch/powerpc/configs/gamecube_defconfig
@@ -8,7 +8,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
-CONFIG_PERF_COUNTERS=y
+CONFIG_PERF_EVENTS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_defconfig
index 175295f..1e2b7d0 100644
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -9,7 +9,7 @@ CONFIG_BLK_DEV_INITRD=y
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_EXPERT=y
 # CONFIG_ELF_CORE is not set
-CONFIG_PERF_COUNTERS=y
+CONFIG_PERF_EVENTS=y
 # CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
 CONFIG_MODULES=y
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 7b9c696..9bdcf72 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -5,7 +5,7 @@ CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=16
-CONFIG_PERF_COUNTERS=y
+CONFIG_PERF_EVENTS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 3c1e858..9d8521b 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -5,7 +5,7 @@ CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=18
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_PERF_COUNTERS=y
+CONFIG_PERF_EVENTS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_PROFILING=y
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..7e37135 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1156,7 +1156,7 @@ menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
 	bool "Kernel performance events and counters"
-	default y if (PROFILING || PERF_COUNTERS)
+	default y if PROFILING
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
 	select IRQ_WORK
@@ -1183,18 +1183,6 @@ config PERF_EVENTS
 
 	  Say Y if unsure.
 
-config PERF_COUNTERS
-	bool "Kernel performance counters (old config option)"
-	depends on HAVE_PERF_EVENTS
-	help
-	  This config has been obsoleted by the PERF_EVENTS
-	  config option - please see that one for details.
-
-	  It has no effect on the kernel whether you enable
-	  it or not, it is a compatibility placeholder.
-
-	  Say N if unsure.
-
 config DEBUG_PERF_USE_VMALLOC
 	default n
 	bool "Debug: use vmalloc to back perf mmap() buffers"
