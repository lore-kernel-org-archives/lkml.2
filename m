Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1IPGR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60142 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1IPGRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:53 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 20/44] Staging: cx25821: Change indent with spaces to tabs 16
Date: Fri, 16 Sep 2011 14:14:53 +0800
Message-Id: <1316153717-7272-21-git-send-email-leonidsbox@gmail.com>
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
index 83872c8..e27b224 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -967,21 +967,21 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
+	struct cx25821_fh *fh = priv;
+	struct cx25821_dev *dev = fh->dev;
+	int err, res;
 
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-	       return -EINVAL;
-       if (i != fh->type)
-	       return -EINVAL;
+	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (i != fh->type)
+		return -EINVAL;
 
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO0);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-	       return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
+	res = cx25821_get_resource(fh, RESOURCE_VIDEO0);
+	err = videobuf_streamoff(get_queue(fh));
+	if (err < 0)
+		return err;
+	cx25821_res_free(dev, fh, res);
+	return 0;
 }
 
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-- 
1.7.0.4

