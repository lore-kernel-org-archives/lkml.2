Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2LFCqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:46:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34900 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2LFCqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:46:31 -0500
Date: Wed, 5 Dec 2012 18:46:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.4.22
Message-ID: <20121206024627.GB26629@kroah.com>
References: <20121206024622.GA26629@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206024622.GA26629@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 7f9f649..320663d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 4
-SUBLEVEL = 21
+SUBLEVEL = 22
 EXTRAVERSION =
 NAME = Saber-toothed Squirrel
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d3e1152..c4410fb 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -192,6 +193,7 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 
 	return (unsigned long)regs;
 }
+EXPORT_SYMBOL_GPL(kernel_stack_pointer);
 
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
