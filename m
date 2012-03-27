Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2C0JKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:10:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36864 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2C0JKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:10:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 27 Mar 2012 11:10:27 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 1/2] i2c-pxa: Drop leftover comment
In-reply-to: <1332839428-29705-1-git-send-email-k.lewandowsk@samsung.com>
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        kyungmin.park@samsung.com, hskinnemoen@gmail.com,
        bigeasy@linutronix.de, dirk.brandewie@gmail.com,
        linux@arm.linux.org.uk, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1332839428-29705-2-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9.1
References: <1332839428-29705-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 488bf314b ("i2c: Allow i2c_add_numbered_adapter() to assign a
bus id") reworked i2c-pxa driver leaving obsolete comment.

This commit simply drops it.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/i2c/busses/i2c-pxa.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index d603646..b81fd10 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1074,11 +1074,6 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	spin_lock_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
 
-	/*
-	 * If "dev->id" is negative we consider it as zero.
-	 * The reason to do so is to avoid sysfs names that only make
-	 * sense when there are multiple adapters.
-	 */
 	i2c->adap.nr = dev->id;
 	snprintf(i2c->adap.name, sizeof(i2c->adap.name), "pxa_i2c-i2c.%u",
 		 i2c->adap.nr);
-- 
1.7.9.1

