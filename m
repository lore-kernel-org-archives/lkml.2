Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1IPGS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35481 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1IPGSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:22 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 27/44] Staging: cx25821: Change indent with spaces to tabs 23
Date: Fri, 16 Sep 2011 14:15:00 +0800
Message-Id: <1316153717-7272-28-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 4cea791..8cda0f9 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1358,14 +1358,14 @@ int cx25821_vidioc_s_frequency(struct file *file, void *priv,
 	int err;
 
 	if (fh) {
-	       dev = fh->dev;
-	       err = v4l2_prio_check(&dev->channels[fh->channel_id]
-					       .prio, fh->prio);
+		dev = fh->dev;
+		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
+				      fh->prio);
 		if (0 != err)
 			return err;
-       } else {
-	       pr_err("Invalid fh pointer!\n");
-	       return -EINVAL;
+	} else {
+		pr_err("Invalid fh pointer!\n");
+		return -EINVAL;
 	}
 
 	return cx25821_set_freq(dev, f);
@@ -1427,8 +1427,8 @@ int cx25821_vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	int err;
 
 	if (fh) {
-	       err = v4l2_prio_check(&dev->channels[fh->channel_id]
-					       .prio, fh->prio);
+		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
+				      fh->prio);
 		if (0 != err)
 			return err;
 	}
@@ -1527,7 +1527,7 @@ int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
 			  struct v4l2_control *ctl)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       struct cx25821_fh *fh = priv;
+	struct cx25821_fh *fh = priv;
 
 	const struct v4l2_queryctrl *ctrl;
 
@@ -1537,16 +1537,16 @@ int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
 		return -EINVAL;
 	switch (ctl->id) {
 	case V4L2_CID_BRIGHTNESS:
-	       ctl->value = dev->channels[fh->channel_id].ctl_bright;
+		ctl->value = dev->channels[fh->channel_id].ctl_bright;
 		break;
 	case V4L2_CID_HUE:
-	       ctl->value = dev->channels[fh->channel_id].ctl_hue;
+		ctl->value = dev->channels[fh->channel_id].ctl_hue;
 		break;
 	case V4L2_CID_CONTRAST:
-	       ctl->value = dev->channels[fh->channel_id].ctl_contrast;
+		ctl->value = dev->channels[fh->channel_id].ctl_contrast;
 		break;
 	case V4L2_CID_SATURATION:
-	       ctl->value = dev->channels[fh->channel_id].ctl_saturation;
+		ctl->value = dev->channels[fh->channel_id].ctl_saturation;
 		break;
 	}
 	return 0;
-- 
1.7.0.4

