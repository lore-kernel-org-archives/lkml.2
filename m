Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1IPGSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:05 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:64847 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1IPGSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:02 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 22/44] Staging: cx25821: Change indent with spaces to tabs 18
Date: Fri, 16 Sep 2011 14:14:55 +0800
Message-Id: <1316153717-7272-23-git-send-email-leonidsbox@gmail.com>
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
index 1815c30..5713656 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1000,21 +1000,21 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			return err;
 	}
 
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
+	dprintk(2, "%s()\n", __func__);
+	err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
 
-       if (0 != err)
-	       return err;
+	if (0 != err)
+		return err;
 
-       fh->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
+	fh->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
+	fh->vidq.field = f->fmt.pix.field;
 
-       /* check if width and height is valid based on set standard */
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm))
-	       fh->width = f->fmt.pix.width;
+	/* check if width and height is valid based on set standard */
+	if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm))
+		fh->width = f->fmt.pix.width;
 
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm))
-	       fh->height = f->fmt.pix.height;
+	if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm))
+		fh->height = f->fmt.pix.height;
 
        if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
 	       pix_format = PIXEL_FRMT_411;
-- 
1.7.0.4

