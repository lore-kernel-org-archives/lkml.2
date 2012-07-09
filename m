Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2GITcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:32:17 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:34614 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2GITcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:32:15 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] zorro: Remove unused zorro_bus.devices
Date: Mon,  9 Jul 2012 21:32:07 +0200
Message-Id: <1341862327-26175-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/zorro.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index 181fa81..858c971 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -37,7 +37,6 @@ struct zorro_dev zorro_autocon[ZORRO_NUM_AUTO];
      */
 
 struct zorro_bus {
-	struct list_head devices;	/* list of devices on this bus */
 	struct device dev;
 };
 
@@ -136,7 +135,6 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
 	if (!bus)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&bus->devices);
 	bus->dev.parent = &pdev->dev;
 	dev_set_name(&bus->dev, "zorro");
 	error = device_register(&bus->dev);
-- 
1.7.0.4

