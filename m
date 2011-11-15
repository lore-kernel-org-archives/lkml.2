Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2DRAWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:22:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33305 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab2DRAVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:21:11 -0400
Message-Id: <6e201a$5e4itm@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="182602678"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Tue, 15 Nov 2011 16:58:11 -0600
Subject: [PATCH 07/10] Hexagon: misc compile warning/error cleanup due to missing headers
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed warnings/errors for EXPORT_SYMBOL, linux_binprm, elf related
defines

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/kernel/dma.c    |    1 +
 arch/hexagon/kernel/ptrace.c |    1 +
 arch/hexagon/kernel/time.c   |    1 +
 arch/hexagon/kernel/vdso.c   |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/hexagon/kernel/dma.c b/arch/hexagon/kernel/dma.c
index e8d52cc..2b48751 100644
--- a/arch/hexagon/kernel/dma.c
+++ b/arch/hexagon/kernel/dma.c
@@ -22,6 +22,7 @@
 #include <linux/bootmem.h>
 #include <linux/genalloc.h>
 #include <asm/dma-mapping.h>
+#include <linux/module.h>
 
 struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
diff --git a/arch/hexagon/kernel/ptrace.c b/arch/hexagon/kernel/ptrace.c
index 32342de..96c3b2c 100644
--- a/arch/hexagon/kernel/ptrace.c
+++ b/arch/hexagon/kernel/ptrace.c
@@ -28,6 +28,7 @@
 #include <linux/ptrace.h>
 #include <linux/regset.h>
 #include <linux/user.h>
+#include <linux/elf.h>
 
 #include <asm/user.h>
 
diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
index ea9e34f..36ba641 100644
--- a/arch/hexagon/kernel/time.c
+++ b/arch/hexagon/kernel/time.c
@@ -28,6 +28,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/module.h>
 
 #include <asm/timer-regs.h>
 #include <asm/hexagon_vm.h>
diff --git a/arch/hexagon/kernel/vdso.c b/arch/hexagon/kernel/vdso.c
index f212a45..5d39f42 100644
--- a/arch/hexagon/kernel/vdso.c
+++ b/arch/hexagon/kernel/vdso.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/binfmts.h>
 
 #include <asm/vdso.h>
 
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
