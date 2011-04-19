Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1DSOnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:43:05 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8339 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab1DSOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:43:03 -0400
From: <oskar.andero@sonyericsson.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Oskar Andero <oskar.andero@sonyericsson.com>
Subject: [PATCH v2] arm: omap2: enable smc instruction for sleep34xx
Date: Tue, 19 Apr 2011 16:42:51 +0200
Message-ID: <1303224171-24984-1-git-send-email-oskar.andero@sonyericsson.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes broken build when using binutils 2.21.

Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
---
 arch/arm/mach-omap2/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index a45cd64..512b152 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -68,7 +68,7 @@ obj-$(CONFIG_OMAP_SMARTREFLEX)          += sr_device.o smartreflex.o
 obj-$(CONFIG_OMAP_SMARTREFLEX_CLASS3)	+= smartreflex-class3.o
 
 AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
-AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a
+AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
 
 ifeq ($(CONFIG_PM_VERBOSE),y)
 CFLAGS_pm_bus.o				+= -DDEBUG
-- 
1.7.3.4

