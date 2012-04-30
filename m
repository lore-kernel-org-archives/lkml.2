Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2D3USl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:18:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:35782 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2D3UQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:03 -0400
Message-Id: <20120430194846.862605948@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 21/29] score: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=score-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Kconfig         |    1 +
 arch/score/kernel/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: tip/arch/score/Kconfig
===================================================================
--- tip.orig/arch/score/Kconfig
+++ tip/arch/score/Kconfig
@@ -9,6 +9,7 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
+       select HAVE_GENERIC_INIT_TASK
 
 choice
 	prompt "System type"
Index: tip/arch/score/kernel/Makefile
===================================================================
--- tip.orig/arch/score/kernel/Makefile
+++ tip/arch/score/kernel/Makefile
@@ -4,7 +4,7 @@
 
 extra-y	:= head.o vmlinux.lds
 
-obj-y += entry.o init_task.o irq.o process.o ptrace.o \
+obj-y += entry.o irq.o process.o ptrace.o \
 	setup.o signal.o sys_score.o time.o traps.o \
 	sys_call_table.o
 


