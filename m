Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1IPGRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:30 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49551 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1IPGR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:28 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 14/44] Staging: cx25821: Change indent with spaces to tabs 10
Date: Fri, 16 Sep 2011 14:14:47 +0800
Message-Id: <1316153717-7272-15-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 268f51b..61fa7af 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -810,25 +810,25 @@ static int video_open(struct file *file)
 
 	mutex_lock(&cx25821_devlist_mutex);
 
-       list_for_each(list, &cx25821_devlist)
-       {
-	       h = list_entry(list, struct cx25821_dev, devlist);
+	list_for_each(list, &cx25821_devlist)
+	{
+		h = list_entry(list, struct cx25821_dev, devlist);
 
-	       for (i = 0; i < MAX_VID_CHANNEL_NUM; i++) {
-		       if (h->channels[i].video_dev &&
+		for (i = 0; i < MAX_VID_CHANNEL_NUM; i++) {
+			if (h->channels[i].video_dev &&
 			   h->channels[i].video_dev->minor == minor) {
-			       dev = h;
-			       ch_id = i;
-			       type  = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		       }
-	       }
-       }
+				dev = h;
+				ch_id = i;
+				type  = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+			}
+		}
+	}
 
-       if (NULL == dev) {
+	if (NULL == dev) {
 		mutex_unlock(&cx25821_devlist_mutex);
 		kfree(fh);
 		return -ENODEV;
-       }
+	}
 
        file->private_data = fh;
        fh->dev = dev;
-- 
1.7.0.4

