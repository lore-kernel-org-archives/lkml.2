Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2KFMe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:34:26 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41742 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2KFMeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:34:25 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] Staging/media: Use dev_ printks in go7007/go7007-v4l2.c
Date: Tue,  6 Nov 2012 21:34:20 +0900
Message-Id: <1352205260-5863-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 980371b..d2d72d5 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1811,8 +1811,8 @@ int go7007_v4l2_init(struct go7007 *go)
 	}
 	video_set_drvdata(go->video_dev, go);
 	++go->ref_count;
-	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
-	       go->video_dev->name, video_device_node_name(go->video_dev));
+	dev_info(go->dev, "registered device %s [v4l2]\n",
+		 video_device_node_name(go->video_dev));
 
 	return 0;
 }
-- 
1.7.9.5

