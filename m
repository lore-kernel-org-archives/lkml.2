Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1IPGWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:22:36 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:64847 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1IPGS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:26 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 28/44] Staging: cx25821: Change indent with spaces to tabs 24
Date: Fri, 16 Sep 2011 14:15:01 +0800
Message-Id: <1316153717-7272-29-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 8cda0f9..d3c3870 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1580,19 +1580,19 @@ int cx25821_set_control(struct cx25821_dev *dev,
 
 	switch (ctl->id) {
 	case V4L2_CID_BRIGHTNESS:
-	       dev->channels[chan_num].ctl_bright = ctl->value;
+		dev->channels[chan_num].ctl_bright = ctl->value;
 		medusa_set_brightness(dev, ctl->value, chan_num);
 		break;
 	case V4L2_CID_HUE:
-	       dev->channels[chan_num].ctl_hue = ctl->value;
+		dev->channels[chan_num].ctl_hue = ctl->value;
 		medusa_set_hue(dev, ctl->value, chan_num);
 		break;
 	case V4L2_CID_CONTRAST:
-	       dev->channels[chan_num].ctl_contrast = ctl->value;
+		dev->channels[chan_num].ctl_contrast = ctl->value;
 		medusa_set_contrast(dev, ctl->value, chan_num);
 		break;
 	case V4L2_CID_SATURATION:
-	       dev->channels[chan_num].ctl_saturation = ctl->value;
+		dev->channels[chan_num].ctl_saturation = ctl->value;
 		medusa_set_saturation(dev, ctl->value, chan_num);
 		break;
 	}
@@ -1625,9 +1625,9 @@ int cx25821_vidioc_cropcap(struct file *file, void *priv,
 	cropcap->bounds.width = 720;
 	cropcap->bounds.height = dev->tvnorm == V4L2_STD_PAL_BG ? 576 : 480;
 	cropcap->pixelaspect.numerator =
-	    dev->tvnorm == V4L2_STD_PAL_BG ? 59 : 10;
+		dev->tvnorm == V4L2_STD_PAL_BG ? 59 : 10;
 	cropcap->pixelaspect.denominator =
-	    dev->tvnorm == V4L2_STD_PAL_BG ? 54 : 11;
+		dev->tvnorm == V4L2_STD_PAL_BG ? 54 : 11;
 	cropcap->defrect = cropcap->bounds;
 	return 0;
 }
@@ -1639,24 +1639,24 @@ int cx25821_vidioc_s_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 	int err;
 
 	if (fh) {
-	       err = v4l2_prio_check(&dev->channels[fh->channel_id].
-					       prio, fh->prio);
+		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
+				      fh->prio);
 		if (0 != err)
 			return err;
 	}
-       /* cx25821_vidioc_s_crop not supported */
+	/* cx25821_vidioc_s_crop not supported */
 	return -EINVAL;
 }
 
 int cx25821_vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 {
-       /* cx25821_vidioc_g_crop not supported */
+	/* cx25821_vidioc_g_crop not supported */
 	return -EINVAL;
 }
 
 int cx25821_vidioc_querystd(struct file *file, void *priv, v4l2_std_id * norm)
 {
-       /* medusa does not support video standard sensing of current input */
+	/* medusa does not support video standard sensing of current input */
 	*norm = CX25821_NORMS;
 
 	return 0;
-- 
1.7.0.4

