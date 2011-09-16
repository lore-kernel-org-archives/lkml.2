Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1IPGRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49551 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1IPGRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:48 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 19/44] Staging: cx25821: Change indent with spaces to tabs 15
Date: Fri, 16 Sep 2011 14:14:52 +0800
Message-Id: <1316153717-7272-20-git-send-email-leonidsbox@gmail.com>
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
index 75bc44e..83872c8 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -949,20 +949,20 @@ static int video_release(struct file *file)
 
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
+	struct cx25821_fh *fh = priv;
+	struct cx25821_dev *dev = fh->dev;
 
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
-	       return -EINVAL;
+	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+		return -EINVAL;
 
-       if (unlikely(i != fh->type))
-	       return -EINVAL;
+	if (unlikely(i != fh->type))
+		return -EINVAL;
 
-       if (unlikely(!cx25821_res_get(dev, fh,
-		       cx25821_get_resource(fh, RESOURCE_VIDEO0))))
-	       return -EBUSY;
+	if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh,
+						RESOURCE_VIDEO0))))
+		return -EBUSY;
 
-       return videobuf_streamon(get_queue(fh));
+	return videobuf_streamon(get_queue(fh));
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-- 
1.7.0.4

