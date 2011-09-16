Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1IPGR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34740 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1IPGRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:24 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 13/44] Staging: cx25821: Change indent with spaces to tabs 9
Date: Fri, 16 Sep 2011 14:14:46 +0800
Message-Id: <1316153717-7272-14-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   43 +++++++++++++++----------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index fbf741d..268f51b 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -782,32 +782,31 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 }
 
 static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
+	.buf_setup = cx25821_buffer_setup,
+	.buf_prepare = cx25821_buffer_prepare,
+	.buf_queue = buffer_queue,
+	.buf_release = cx25821_buffer_release,
 };
 
 static int video_open(struct file *file)
 {
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *h, *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       struct list_head *list;
-       int minor = video_devdata(file)->minor;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-       int ch_id = 0;
-       int i;
-
-       dprintk(1, "open dev=%s type=%s\n",
-		       video_device_node_name(vdev),
-		       v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-	       return -ENOMEM;
+	struct video_device *vdev = video_devdata(file);
+	struct cx25821_dev *h, *dev = video_drvdata(file);
+	struct cx25821_fh *fh;
+	struct list_head *list;
+	int minor = video_devdata(file)->minor;
+	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	u32 pix_format;
+	int ch_id = 0;
+	int i;
+
+	dprintk(1, "open dev=%s type=%s\n", video_device_node_name(vdev),
+			v4l2_type_names[type]);
+
+	/* allocate + initialize per filehandle data */
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (NULL == fh)
+		return -ENOMEM;
 
 	mutex_lock(&cx25821_devlist_mutex);
 
-- 
1.7.0.4

