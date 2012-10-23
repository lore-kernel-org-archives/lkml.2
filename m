Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649Ab2JWUFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:02 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44247 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556Ab2JWUE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:04:56 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 011/193] arch/ia64: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:24 -0700
Message-Id: <1351022666-6960-12-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/ia64/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 3279646..ceed9a7 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -375,8 +375,8 @@ config NR_CPUS
 	  performance hit.
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && EXPERIMENTAL
+	bool "Support for hot-pluggable CPUs"
+	depends on SMP
 	select HOTPLUG
 	default n
 	---help---
@@ -555,8 +555,8 @@ config IA64_HP_AML_NFW
 source "drivers/sn/Kconfig"
 
 config KEXEC
-	bool "kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
+	bool "kexec system call"
+	depends on !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
-- 
1.7.9.5

