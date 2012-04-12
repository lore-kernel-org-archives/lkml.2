Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519Ab2DLQNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:13:21 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:40738 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965638Ab2DLQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:13:10 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] dma/ste_dma40: explicitly include regulator consumer header
Date: Thu, 12 Apr 2012 18:12:43 +0200
Message-ID: <1334247163-17353-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The patch "ARM: amba: Remove AMBA level regulator support" breaks
the DMA40 driver since the <linux/amba/bus.h> header implicitly
included the regulator consumer header. So include it explicitly
and fix the build error.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index bdd41d4..94d760e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -18,6 +18,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
 #include <linux/amba/bus.h>
+#include <linux/regulator/consumer.h>
 
 #include <plat/ste_dma40.h>
 
-- 
1.7.9.2

