Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1JOSkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:40:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57530 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1JOSkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:40:21 -0400
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca
Subject: [PATCH] spi/spi-ep93xx: add module.h include
Date: Sat, 15 Oct 2011 21:40:09 +0300
Message-Id: <1318704009-8178-1-git-send-email-mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
---
 drivers/spi/spi-ep93xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 1cf6454..11515c5 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -24,6 +24,7 @@
 #include <linux/dmaengine.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
-- 
1.7.6.3

