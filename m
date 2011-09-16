Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1IPGRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34740 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab1IPGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:37 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 16/44] Staging: cx25821: Change indent with spaces to tabs 12
Date: Fri, 16 Sep 2011 14:14:49 +0800
Message-Id: <1316153717-7272-17-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index db9b765..3af5f2b 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -854,29 +854,29 @@ static int video_open(struct file *file)
 			      V4L2_FIELD_INTERLACED,
 			      sizeof(struct cx25821_buffer), fh, NULL);
 
-       dprintk(1, "post videobuf_queue_init()\n");
+	dprintk(1, "post videobuf_queue_init()\n");
 	mutex_unlock(&cx25821_devlist_mutex);
 
-       return 0;
+	return 0;
 }
 
 static ssize_t video_read(struct file *file, char __user * data, size_t count,
 			 loff_t *ppos)
 {
-       struct cx25821_fh *fh = file->private_data;
+	struct cx25821_fh *fh = file->private_data;
 
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-	       if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
-		       return -EBUSY;
+	switch (fh->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
+			return -EBUSY;
 
-	       return videobuf_read_one(&fh->vidq, data, count, ppos,
+		return videobuf_read_one(&fh->vidq, data, count, ppos,
 					file->f_flags & O_NONBLOCK);
 
-       default:
-	       BUG();
-	       return 0;
-       }
+	default:
+		BUG();
+		return 0;
+	}
 }
 
 static unsigned int video_poll(struct file *file,
-- 
1.7.0.4

