Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab0JZC5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933101Ab0JZC45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 42/43] MN10300: Change "Matsushita" to "Panasonic".
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:56:46 +0100
Message-ID: <20101026025646.23512.57482.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Change externally visible "Matsushita" instances to "Panasonic" throughout the
MN10300 arch code.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                            |    4 ++--
 arch/mn10300/kernel/setup.c                     |    4 ++--
 arch/mn10300/proc-mn103e010/include/proc/proc.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 129ca49..365766a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -93,14 +93,14 @@ config GENERIC_HARDIRQS
 config HOTPLUG_CPU
 	def_bool n
 
-mainmenu "Matsushita MN10300/AM33 Kernel Configuration"
+mainmenu "Panasonic MN10300/AM33 Kernel Configuration"
 
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
 
 
-menu "Matsushita MN10300 system setup"
+menu "Panasonic MN10300 system setup"
 
 choice
 	prompt "Unit type"
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index 1251457..9e7a320 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -187,7 +187,7 @@ void __init cpu_init(void)
 	if (type > mn10300_known_cpus)
 		type = mn10300_known_cpus;
 
-	printk(KERN_INFO "Matsushita %s, rev %ld\n",
+	printk(KERN_INFO "Panasonic %s, rev %ld\n",
 	       mn10300_cputypes[type],
 	       (cpurev & CPUREV_REVISION) >> CPUREV_REVISION_S);
 
@@ -246,7 +246,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 	seq_printf(m,
 		   "processor  : %ld\n"
-		   "vendor_id  : Matsushita\n"
+		   "vendor_id  : " PROCESSOR_VENDOR_NAME "\n"
 		   "cpu core   : %s\n"
 		   "cpu rev    : %lu\n"
 		   "model name : " PROCESSOR_MODEL_NAME		"\n"
diff --git a/arch/mn10300/proc-mn103e010/include/proc/proc.h b/arch/mn10300/proc-mn103e010/include/proc/proc.h
index 22a2b93..39c4f8e 100644
--- a/arch/mn10300/proc-mn103e010/include/proc/proc.h
+++ b/arch/mn10300/proc-mn103e010/include/proc/proc.h
@@ -12,7 +12,7 @@
 #ifndef _ASM_PROC_PROC_H
 #define _ASM_PROC_PROC_H
 
-#define PROCESSOR_VENDOR_NAME	"Matsushita"
+#define PROCESSOR_VENDOR_NAME	"Panasonic"
 #define PROCESSOR_MODEL_NAME	"mn103e010"
 
 #endif /* _ASM_PROC_PROC_H */

