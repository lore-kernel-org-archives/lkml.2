Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1IPGRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36411 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1IPGRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:32 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 15/44] Staging: cx25821: Change indent with spaces to tabs 11
Date: Fri, 16 Sep 2011 14:14:48 +0800
Message-Id: <1316153717-7272-16-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   39 +++++++++++++++----------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 61fa7af..db9b765 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -830,26 +830,25 @@ static int video_open(struct file *file)
 		return -ENODEV;
 	}
 
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-    fh->channel_id = ch_id;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-	       fh->height = 576;
-       else
-	       fh->height = 480;
+	file->private_data = fh;
+	fh->dev = dev;
+	fh->type = type;
+	fh->width = 720;
+	fh->channel_id = ch_id;
+
+	if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
+		fh->height = 576;
+	else
+		fh->height = 480;
 
-       dev->channel_opened = fh->channel_id;
-       pix_format =
-	   (dev->channels[ch_id].pixel_formats ==
-	    PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = cx25821_format_by_fourcc(pix_format);
+	dev->channel_opened = fh->channel_id;
+	pix_format = (dev->channels[ch_id].pixel_formats == PIXEL_FRMT_411) ?
+			V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
+	fh->fmt = cx25821_format_by_fourcc(pix_format);
 
-       v4l2_prio_open(&dev->channels[ch_id].prio, &fh->prio);
+	v4l2_prio_open(&dev->channels[ch_id].prio, &fh->prio);
 
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
+	videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
 			      &dev->pci->dev, &dev->slock,
 			      V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			      V4L2_FIELD_INTERLACED,
-- 
1.7.0.4

