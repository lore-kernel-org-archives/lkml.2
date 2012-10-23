Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625Ab2JWVH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:07:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35884 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677Ab2JWUFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:06 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 009/193] arch/blackfin: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:22 -0700
Message-Id: <1351022666-6960-10-git-send-email-keescook@chromium.org>
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

CC: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/blackfin/Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index b6f3ad5..ca33c8d 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -562,8 +562,7 @@ choice
 	  accurate - This option is therefore marked experimental.
 
 config BFIN_KERNEL_CLOCK_MEMINIT_CALC
-	bool "Calculate Timings (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Calculate Timings"
 
 config BFIN_KERNEL_CLOCK_MEMINIT_SPEC
 	bool "Provide accurate Timings based on target SCLK"
@@ -1120,7 +1119,7 @@ endchoice
 
 comment "Memory Protection Unit"
 config MPU
-	bool "Enable the memory protection unit (EXPERIMENTAL)"
+	bool "Enable the memory protection unit"
 	default n
 	help
 	  Use the processor's MPU to protect applications from accessing
@@ -1442,7 +1441,6 @@ config BFIN_CPU_FREQ
 
 config CPU_VOLTAGE
 	bool "CPU Voltage scaling"
-	depends on EXPERIMENTAL
 	depends on CPU_FREQ
 	default n
 	help
-- 
1.7.9.5

