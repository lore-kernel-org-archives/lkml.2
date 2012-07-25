Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab2GYMJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:09:45 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:34352 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932962Ab2GYMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:08:57 -0400
From: Felipe Balbi <balbi@ti.com>
To: zbr@ioremap.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 5/6] w1: omap-hdq: remove unnecessary return
Date: Wed, 25 Jul 2012 15:05:31 +0300
Message-Id: <1343217932-25372-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.11
In-Reply-To: <1343217932-25372-1-git-send-email-balbi@ti.com>
References: <1343217932-25372-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trivial patch, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/w1/masters/omap_hdq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index b6eb0ba..778a65d 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -540,8 +540,6 @@ static void omap_w1_write_byte(void *_hdq, u8 byte)
 		hdq_data->init_trans = 0;
 		mutex_unlock(&hdq_data->hdq_mutex);
 	}
-
-	return;
 }
 
 static int __devinit omap_hdq_probe(struct platform_device *pdev)
-- 
1.7.11

