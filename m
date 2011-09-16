Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1IPGRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49551 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1IPGRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:44 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 18/44] Staging: cx25821: Change indent with spaces to tabs 14
Date: Fri, 16 Sep 2011 14:14:51 +0800
Message-Id: <1316153717-7272-19-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   36 +++++++++++++++---------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 958940f..75bc44e 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -921,30 +921,30 @@ static unsigned int video_poll(struct file *file,
 
 static int video_release(struct file *file)
 {
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
+	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_dev *dev = fh->dev;
 
-       /* stop the risc engine and fifo */
-       cx_write(channel0->dma_ctl, 0); /* FIFO and RISC disable */
+	/* stop the risc engine and fifo */
+	cx_write(channel0->dma_ctl, 0); /* FIFO and RISC disable */
 
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
-	       videobuf_queue_cancel(&fh->vidq);
-	       cx25821_res_free(dev, fh, RESOURCE_VIDEO0);
-       }
+	/* stop video capture */
+	if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
+		videobuf_queue_cancel(&fh->vidq);
+		cx25821_res_free(dev, fh, RESOURCE_VIDEO0);
+	}
 
-       if (fh->vidq.read_buf) {
-	       cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-	       kfree(fh->vidq.read_buf);
-       }
+	if (fh->vidq.read_buf) {
+		cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
+		kfree(fh->vidq.read_buf);
+	}
 
-       videobuf_mmap_free(&fh->vidq);
+	videobuf_mmap_free(&fh->vidq);
 
-       v4l2_prio_close(&dev->channels[fh->channel_id].prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
+	v4l2_prio_close(&dev->channels[fh->channel_id].prio, fh->prio);
+	file->private_data = NULL;
+	kfree(fh);
 
-       return 0;
+	return 0;
 }
 
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-- 
1.7.0.4

