Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab2IEKxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:53:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2IEKxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:53:49 -0400
Date: Wed, 5 Sep 2012 03:53:32 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-c206b9dcb1fc41b104db43e98f9b83a8c0c559ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, rdunlap@xenotime.net,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, josh@joshtriplett.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        arjan@linux.intel.com, rdunlap@xenotime.net, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, josh@joshtriplett.org, tglx@linutronix.de
In-Reply-To: <e72faf875e1172fb1cbec5e6d3cd4122df508a97.1346649518.git.josh@joshtriplett.org>
References: <e72faf875e1172fb1cbec5e6d3cd4122df508a97.1346649518.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86/Kconfig:
  Turn off DEBUG_NX_TEST module in defconfigs
Git-Commit-ID: c206b9dcb1fc41b104db43e98f9b83a8c0c559ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:53:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c206b9dcb1fc41b104db43e98f9b83a8c0c559ae
Gitweb:     http://git.kernel.org/tip/c206b9dcb1fc41b104db43e98f9b83a8c0c559ae
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sun, 2 Sep 2012 22:21:29 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:43:12 +0200

x86/Kconfig: Turn off DEBUG_NX_TEST module in defconfigs

The x86 defconfigs include exactly one module: test_nx.ko, a
special-purpose module which just exists to do evil things like
executing code off the stack to see if the kernel has enabled NX
support.  Anyone who actually uses that module can easily enable
it themselves, but the vast majority of kernel builds don't need
it; disable it by default.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Link: http://lkml.kernel.org/r/e72faf875e1172fb1cbec5e6d3cd4122df508a97.1346649518.git.josh@joshtriplett.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index a6533a2..5598547 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -298,7 +298,6 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_RODATA_TEST is not set
-CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
 CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 18f3cc4..671524d 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -297,7 +297,6 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_RODATA_TEST is not set
-CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
 CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
