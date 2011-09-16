Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1IPGZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:25:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62012 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1IPGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:04 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 08/44] Staging: cx25821: Change indent with spaces to tabs 4
Date: Fri, 16 Sep 2011 14:14:41 +0800
Message-Id: <1316153717-7272-9-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index e1909b2..6f5ee37 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -493,20 +493,19 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		dev->channels[i].video_dev = NULL;
 		dev->channels[i].resources = 0;
 
-	       cx_write(dev->channels[i].sram_channels->int_stat,
-			       0xffffffff);
-
-	       INIT_LIST_HEAD(&dev->channels[i].vidq.active);
-	       INIT_LIST_HEAD(&dev->channels[i].vidq.queued);
-
-	       dev->channels[i].timeout_data.dev = dev;
-	       dev->channels[i].timeout_data.channel =
-				       &cx25821_sram_channels[i];
-	       dev->channels[i].vidq.timeout.function =
-				       cx25821_vid_timeout;
-	       dev->channels[i].vidq.timeout.data =
-		       (unsigned long)&dev->channels[i].timeout_data;
-	       init_timer(&dev->channels[i].vidq.timeout);
+		cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
+
+		INIT_LIST_HEAD(&dev->channels[i].vidq.active);
+		INIT_LIST_HEAD(&dev->channels[i].vidq.queued);
+
+		dev->channels[i].timeout_data.dev = dev;
+		dev->channels[i].timeout_data.channel =
+			&cx25821_sram_channels[i];
+		dev->channels[i].vidq.timeout.function =
+			cx25821_vid_timeout;
+		dev->channels[i].vidq.timeout.data =
+			(unsigned long)&dev->channels[i].timeout_data;
+		init_timer(&dev->channels[i].vidq.timeout);
 
 	       /* register v4l devices */
 	       dev->channels[i].video_dev = cx25821_vdev_init(dev,
-- 
1.7.0.4

