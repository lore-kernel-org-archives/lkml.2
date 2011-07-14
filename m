Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1GNT7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:59:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56593 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1GNT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:59:39 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH 1/3] mcp23s08: remove unused work queue
Date: Thu, 14 Jul 2011 21:59:26 +0200
Message-Id: <1310673568-30577-2-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never accessed anywhere.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/gpio/mcp23s08.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/mcp23s08.c
index 40e0760..242a8a2 100644
--- a/drivers/gpio/mcp23s08.c
+++ b/drivers/gpio/mcp23s08.c
@@ -4,7 +4,6 @@
 
 #include <linux/kernel.h>
 #include <linux/device.h>
-#include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
@@ -60,8 +59,6 @@ struct mcp23s08 {
 
 	struct gpio_chip	chip;
 
-	struct work_struct	work;
-
 	const struct mcp23s08_ops	*ops;
 };
 
-- 
1.7.5.4

