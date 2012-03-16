Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422774Ab2CPMTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:19:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35660 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422762Ab2CPMTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:19:17 -0400
Date: Fri, 16 Mar 2012 13:19:02 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 1/2] i2c-pxa: Drop leftover comment
In-reply-to: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hskinnemoen@gmail.com,
        dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        m.szyprowski@samsung.com, grant.likely@secretlab.ca,
        kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331900343-6743-2-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com>
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
1.7.9

