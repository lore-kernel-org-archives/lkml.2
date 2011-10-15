Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1JOSiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:38:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46989 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1JOSiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:38:54 -0400
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, Mika Westerberg <mika.westerberg@iki.fi>
Subject: [PATCH] dmaengine/ep93xx_dma: add module.h include
Date: Sat, 15 Oct 2011 21:38:37 +0300
Message-Id: <1318703917-7604-1-git-send-email-mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
---
 drivers/dma/ep93xx_dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 5d7a49b..b47e2b8 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-- 
1.7.6.3

