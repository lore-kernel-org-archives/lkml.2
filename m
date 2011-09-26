Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1IZG0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 02:26:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59575 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1IZG0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 02:26:35 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] dma/imx-sdma+imx-dma: explicitly #include <linux/module.h>
Date: Mon, 26 Sep 2011 08:26:19 +0200
Message-Id: <1317018379-8897-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed after commit

	include: replace linux/module.h with "struct module" wherever possible

(currently 25215aa in next).

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

maybe it's sensible for Paul to take that before his commit?

Best regards
Uwe

 drivers/dma/imx-dma.c  |    1 +
 drivers/dma/imx-sdma.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index d99f71c..3732de8 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/dmaengine.h>
+#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <mach/dma-v1.h>
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index b5cc27d..86fb6e5 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -34,6 +34,7 @@
 #include <linux/dmaengine.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <mach/sdma.h>
-- 
1.7.6.3

