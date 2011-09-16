Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1IPGRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62012 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1IPGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:08 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 09/44] Staging: cx25821: Change indent with spaces to tabs 5
Date: Fri, 16 Sep 2011 14:14:42 +0800
Message-Id: <1316153717-7272-10-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 6f5ee37..8145006 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -507,31 +507,31 @@ int cx25821_video_register(struct cx25821_dev *dev)
 			(unsigned long)&dev->channels[i].timeout_data;
 		init_timer(&dev->channels[i].vidq.timeout);
 
-	       /* register v4l devices */
-	       dev->channels[i].video_dev = cx25821_vdev_init(dev,
-		       dev->pci, &cx25821_video_device, "video");
+		/* register v4l devices */
+		dev->channels[i].video_dev = cx25821_vdev_init(dev,
+				dev->pci, &cx25821_video_device, "video");
 
-	       err = video_register_device(dev->channels[i].video_dev,
-			       VFL_TYPE_GRABBER, video_nr[dev->nr]);
+		err = video_register_device(dev->channels[i].video_dev,
+				VFL_TYPE_GRABBER, video_nr[dev->nr]);
 
-	       if (err < 0)
-		       goto fail_unreg;
+		if (err < 0)
+			goto fail_unreg;
 
 	}
 
-    /* set PCI interrupt */
+	/* set PCI interrupt */
 	cx_set(PCI_INT_MSK, 0xff);
 
 	/* initial device configuration */
 	mutex_lock(&dev->lock);
 #ifdef TUNER_FLAG
-       dev->tvnorm = cx25821_video_device.current_norm;
+	dev->tvnorm = cx25821_video_device.current_norm;
 	cx25821_set_tvnorm(dev, dev->tvnorm);
 #endif
 	mutex_unlock(&dev->lock);
 
 
-    return 0;
+	return 0;
 
 fail_unreg:
        cx25821_video_unregister(dev, i);
-- 
1.7.0.4

