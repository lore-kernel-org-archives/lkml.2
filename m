Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2GYMJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:09:05 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46198 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932985Ab2GYMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:09:00 -0400
From: Felipe Balbi <balbi@ti.com>
To: zbr@ioremap.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 6/6] w1: omap-hdq: drop ARCH dependency
Date: Wed, 25 Jul 2012 15:05:32 +0300
Message-Id: <1343217932-25372-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.11
In-Reply-To: <1343217932-25372-1-git-send-email-balbi@ti.com>
References: <1343217932-25372-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the driver compile everywhere while
also removing unnecessary headers.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/w1/masters/Kconfig    | 1 -
 drivers/w1/masters/omap_hdq.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 5ceb1cd..7e98403 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -60,7 +60,6 @@ config W1_MASTER_GPIO
 
 config HDQ_MASTER_OMAP
 	tristate "OMAP HDQ driver"
-	depends on ARCH_OMAP2PLUS
 	help
 	  Say Y here if you want support for the 1-wire or HDQ Interface
 	  on an OMAP processor.
diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 778a65d..771875d 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -18,9 +18,6 @@
 #include <linux/sched.h>
 #include <linux/pm_runtime.h>
 
-#include <asm/irq.h>
-#include <mach/hardware.h>
-
 #include "../w1.h"
 #include "../w1_int.h"
 
-- 
1.7.11

