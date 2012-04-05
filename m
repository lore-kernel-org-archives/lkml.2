Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2DEQZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:25:56 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:13651
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151Ab2DEQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:25:03 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20LLG-02-36B-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/4] perf: Remove PERF_COUNTERS config option
Date: Thu, 5 Apr 2012 18:24:44 +0200
Message-ID: <1333643084-26776-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
References: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming remaining PERF_COUNTERS options into PERF_EVENTS.

Think we can get rid of PERF_COUNTERS now.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
index acf7fb2..85acd89 100644
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
index 3f42cd6..fad58a9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1165,7 +1165,7 @@ menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
 	bool "Kernel performance events and counters"
-	default y if (PROFILING || PERF_COUNTERS)
+	default y if PROFILING
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
 	select IRQ_WORK
@@ -1192,18 +1192,6 @@ config PERF_EVENTS
 
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
-- 
1.7.8.4


