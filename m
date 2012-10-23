Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396Ab2JWUwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:52:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52141 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933758Ab2JWUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 029/193] arch/um: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:42 -0700
Message-Id: <1351022666-6960-30-git-send-email-keescook@chromium.org>
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

CC: Jeff Dike <jdike@addtoit.com>
CC: Richard Weinberger <richard@nod.at>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/um/Kconfig.net |    2 +-
 arch/um/Kconfig.um  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/um/Kconfig.net b/arch/um/Kconfig.net
index 3160b1a..820a56f 100644
--- a/arch/um/Kconfig.net
+++ b/arch/um/Kconfig.net
@@ -157,7 +157,7 @@ config UML_NET_MCAST
 
 config UML_NET_PCAP
 	bool "pcap transport"
-	depends on UML_NET && EXPERIMENTAL
+	depends on UML_NET
 	help
 	The pcap transport makes a pcap packet stream on the host look
 	like an ethernet device inside UML.  This is useful for making
diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index bf87f25..a7520c9 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -45,8 +45,8 @@ config HOSTFS
           say Y or M here; otherwise say N.
 
 config HPPFS
-	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && PROC_FS
+	tristate "HoneyPot ProcFS"
+	depends on PROC_FS
 	help
 	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
 	  entries to be overridden, removed, or fabricated from the host.
@@ -96,7 +96,7 @@ config MAGIC_SYSRQ
 	  unless you really know what this hack does.
 
 config SMP
-	bool "Symmetric multi-processing support (EXPERIMENTAL)"
+	bool "Symmetric multi-processing support"
 	default n
 	depends on BROKEN
 	help
@@ -126,7 +126,7 @@ config NR_CPUS
 	default "32"
 
 config HIGHMEM
-	bool "Highmem support (EXPERIMENTAL)"
+	bool "Highmem support"
 	depends on !64BIT && BROKEN
 	default n
 	help
-- 
1.7.9.5

