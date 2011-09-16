Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1IPGST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:19 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35409 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1IPGSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:10 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 24/44] Staging: cx25821: Change indent with spaces to tabs 20
Date: Fri, 16 Sep 2011 14:14:57 +0800
Message-Id: <1316153717-7272-25-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   32 +++++++++++++++---------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index bbf1ad9..c77e9d5 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1044,37 +1044,37 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	int ret_val = 0;
+	struct cx25821_fh *fh = priv;
+	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
+	ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
 
-    p->sequence = dev->channels[fh->channel_id].vidq.count;
+	p->sequence = dev->channels[fh->channel_id].vidq.count;
 
-       return ret_val;
+	return ret_val;
 }
 
 static int vidioc_log_status(struct file *file, void *priv)
 {
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       struct cx25821_fh *fh = priv;
-       char name[32 + 2];
+	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+	struct cx25821_fh *fh = priv;
+	char name[32 + 2];
 
-       struct sram_channel *sram_ch = dev->channels[fh->channel_id]
-						       .sram_channels;
-       u32 tmp = 0;
+	struct sram_channel *sram_ch = dev->channels[fh->channel_id]
+								.sram_channels;
+	u32 tmp = 0;
 
-       snprintf(name, sizeof(name), "%s/2", dev->name);
+	snprintf(name, sizeof(name), "%s/2", dev->name);
 	pr_info("%s/2: ============  START LOG STATUS  ============\n",
 		dev->name);
-       cx25821_call_all(dev, core, log_status);
-       tmp = cx_read(sram_ch->dma_ctl);
+	cx25821_call_all(dev, core, log_status);
+	tmp = cx_read(sram_ch->dma_ctl);
 	pr_info("Video input 0 is %s\n",
 		(tmp & 0x11) ? "streaming" : "stopped");
 	pr_info("%s/2: =============  END LOG STATUS  =============\n",
 		dev->name);
-       return 0;
+	return 0;
 }
 
 static int vidioc_s_ctrl(struct file *file, void *priv,
-- 
1.7.0.4

