Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1IPGSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60142 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1IPGSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:06 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 23/44] Staging: cx25821: Change indent with spaces to tabs 19
Date: Fri, 16 Sep 2011 14:14:56 +0800
Message-Id: <1316153717-7272-24-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 5713656..bbf1ad9 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1016,30 +1016,30 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm))
 		fh->height = f->fmt.pix.height;
 
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-	       pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-	       pix_format = PIXEL_FRMT_422;
-       else
-	       return -EINVAL;
+	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
+		pix_format = PIXEL_FRMT_411;
+	else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
+		pix_format = PIXEL_FRMT_422;
+	else
+		return -EINVAL;
 
-       cx25821_set_pixel_format(dev, SRAM_CH00, pix_format);
+	cx25821_set_pixel_format(dev, SRAM_CH00, pix_format);
 
-       /* check if cif resolution */
-       if (fh->width == 320 || fh->width == 352)
-	       dev->channels[fh->channel_id].use_cif_resolution = 1;
-       else
-	       dev->channels[fh->channel_id].use_cif_resolution = 0;
+	/* check if cif resolution */
+	if (fh->width == 320 || fh->width == 352)
+		dev->channels[fh->channel_id].use_cif_resolution = 1;
+	else
+		dev->channels[fh->channel_id].use_cif_resolution = 0;
 
-       dev->channels[fh->channel_id].cif_width = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH00);
+	dev->channels[fh->channel_id].cif_width = fh->width;
+	medusa_set_resolution(dev, fh->width, SRAM_CH00);
 
 	dprintk(2, "%s(): width=%d height=%d field=%d\n", __func__, fh->width,
 		fh->height, fh->vidq.field);
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
 	cx25821_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 
-       return 0;
+	return 0;
 }
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-- 
1.7.0.4

