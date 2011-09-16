Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1IPGRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38702 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab1IPGRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:01 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 07/44] Staging: cx25821: Change indent with spaces to tabs 3
Date: Fri, 16 Sep 2011 14:14:40 +0800
Message-Id: <1316153717-7272-8-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   35 +++++++++++++++----------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 206990e..e1909b2 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -469,30 +469,29 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 int cx25821_video_register(struct cx25821_dev *dev)
 {
 	int err;
-       int i;
+	int i;
 
-       struct video_device cx25821_video_device = {
-	       .name = "cx25821-video",
-	       .fops = &video_fops,
-	       .minor = -1,
-	       .ioctl_ops = &video_ioctl_ops,
-	       .tvnorms = CX25821_NORMS,
-	       .current_norm = V4L2_STD_NTSC_M,
-       };
+	struct video_device cx25821_video_device = {
+		.name = "cx25821-video",
+		.fops = &video_fops,
+		.minor = -1,
+		.ioctl_ops = &video_ioctl_ops,
+		.tvnorms = CX25821_NORMS,
+		.current_norm = V4L2_STD_NTSC_M,
+	};
 
 	spin_lock_init(&dev->slock);
 
-    for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; ++i) {
-	       cx25821_init_controls(dev, i);
+	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; ++i) {
+		cx25821_init_controls(dev, i);
 
-	       cx25821_risc_stopper(dev->pci,
-			       &dev->channels[i].vidq.stopper,
-			       dev->channels[i].sram_channels->dma_ctl,
-			       0x11, 0);
+		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
+				dev->channels[i].sram_channels->dma_ctl,
+				0x11, 0);
 
-	       dev->channels[i].sram_channels = &cx25821_sram_channels[i];
-	       dev->channels[i].video_dev = NULL;
-	       dev->channels[i].resources = 0;
+		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
+		dev->channels[i].video_dev = NULL;
+		dev->channels[i].resources = 0;
 
 	       cx_write(dev->channels[i].sram_channels->int_stat,
 			       0xffffffff);
-- 
1.7.0.4

