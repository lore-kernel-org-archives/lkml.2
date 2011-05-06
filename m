Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1EFNGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:06:00 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:47579 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932096Ab1EFNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:05:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/10] mach-ux500: rename PRCMU driver per SoC
Date: Fri, 6 May 2011 15:05:48 +0200
Message-ID: <1304687148-23647-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

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
1.7.3.2

