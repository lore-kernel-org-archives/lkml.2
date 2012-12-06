Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2LFCpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:45:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48765 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2LFCpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:45:16 -0500
Date: Wed, 5 Dec 2012 18:45:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.55
Message-ID: <20121206024513.GB20682@kroah.com>
References: <20121206024501.GA20682@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206024501.GA20682@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index ae984ab..06df950 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 0
-SUBLEVEL = 54
+SUBLEVEL = 55
 EXTRAVERSION =
 NAME = Sneaky Weasel
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8ede567..911e16d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -191,6 +192,7 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 
 	return (unsigned long)regs;
 }
+EXPORT_SYMBOL_GPL(kernel_stack_pointer);
 
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
