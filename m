Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1EOXh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:37:57 -0400
Received: from mail.df.lth.se ([194.47.250.12]:22994 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab1EOXh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:37:56 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/13] mach-ux500: rename PRCMU driver per SoC
Date: Mon, 16 May 2011 01:37:53 +0200
Message-Id: <1305502673-32580-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames the prcmu.c file to prcmu-db8500.c so as to indicate
that it is for this one SoC.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Makefile                    |    2 +-
 arch/arm/mach-ux500/{prcmu.c => prcmu-db8500.c} |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/arm/mach-ux500/{prcmu.c => prcmu-db8500.c} (100%)

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index b549a8f..2a08a10 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -5,7 +5,7 @@
 obj-y				:= clock.o cpu.o devices.o devices-common.o \
 				   id.o usb.o
 obj-$(CONFIG_UX500_SOC_DB5500)	+= cpu-db5500.o dma-db5500.o
-obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o prcmu.o
+obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o prcmu-db8500.o
 obj-$(CONFIG_MACH_U8500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-regulators.o \
 				board-mop500-uib.o board-mop500-stuib.o \
diff --git a/arch/arm/mach-ux500/prcmu.c b/arch/arm/mach-ux500/prcmu-db8500.c
similarity index 100%
rename from arch/arm/mach-ux500/prcmu.c
rename to arch/arm/mach-ux500/prcmu-db8500.c
-- 
1.7.4.4

