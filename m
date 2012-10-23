Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573Ab2JWVKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:10:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34632 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab2JWUFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:05 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 040/193] drivers/cpufreq: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:53 -0700
Message-Id: <1351022666-6960-41-git-send-email-keescook@chromium.org>
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

CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/cpufreq/Kconfig.arm |    4 ++--
 drivers/cpufreq/Kconfig.x86 |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 5961e64..b63c335 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -21,8 +21,8 @@ config ARM_S3C2416_CPUFREQ
 	  If in doubt, say N.
 
 config ARM_S3C2416_CPUFREQ_VCORESCALE
-	bool "Allow voltage scaling for S3C2416 arm core (EXPERIMENTAL)"
-	depends on ARM_S3C2416_CPUFREQ && REGULATOR && EXPERIMENTAL
+	bool "Allow voltage scaling for S3C2416 arm core"
+	depends on ARM_S3C2416_CPUFREQ && REGULATOR
 	help
 	  Enable CPU voltage scaling when entering the dvs mode.
 	  It uses information gathered through existing hardware and
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 934854a..0715d8e 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -174,7 +174,7 @@ config X86_SPEEDSTEP_ICH
 config X86_SPEEDSTEP_SMI
 	tristate "Intel SpeedStep on 440BX/ZX/MX chipsets (SMI interface)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
 	  (Coppermine), all mobile Intel Pentium III-M (Tualatin)
@@ -206,7 +206,7 @@ config X86_P4_CLOCKMOD
 
 config X86_CPUFREQ_NFORCE2
 	tristate "nVidia nForce2 FSB changing"
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for FSB changing on nVidia nForce2
 	  platforms.
@@ -242,7 +242,7 @@ config X86_LONGHAUL
 config X86_E_POWERSAVER
 	tristate "VIA C7 Enhanced PowerSaver (DANGEROUS)"
 	select CPU_FREQ_TABLE
-	depends on X86_32 && EXPERIMENTAL
+	depends on X86_32
 	help
 	  This adds the CPUFreq driver for VIA C7 processors.  However, this driver
 	  does not have any safeguards to prevent operating the CPU out of spec
-- 
1.7.9.5

