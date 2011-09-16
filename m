Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1IPGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:16:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62012 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab1IPGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:16:57 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 06/44] Staging: cx25821: Change indent with spaces to tabs 2
Date: Fri, 16 Sep 2011 14:14:39 +0800
Message-Id: <1316153717-7272-7-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to use tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index a952ca1..206990e 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -424,9 +424,8 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	if (status & 0x10) {
 		dprintk(2, "stopper video\n");
 		spin_lock(&dev->slock);
-	       cx25821_restart_video_queue(dev,
-			       &dev->channels[channel->i].vidq,
-				       channel);
+		cx25821_restart_video_queue(dev,
+				&dev->channels[channel->i].vidq, channel);
 		spin_unlock(&dev->slock);
 		handled++;
 	}
@@ -449,18 +448,18 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 {
 	cx_clear(PCI_INT_MSK, 1);
 
-       if (dev->channels[chan_num].video_dev) {
-	       if (video_is_registered(dev->channels[chan_num].video_dev))
-		       video_unregister_device(
-			       dev->channels[chan_num].video_dev);
+	if (dev->channels[chan_num].video_dev) {
+		if (video_is_registered(dev->channels[chan_num].video_dev))
+			video_unregister_device(
+					dev->channels[chan_num].video_dev);
 		else
-		       video_device_release(
-			       dev->channels[chan_num].video_dev);
+			video_device_release(
+					dev->channels[chan_num].video_dev);
 
-	       dev->channels[chan_num].video_dev = NULL;
+		dev->channels[chan_num].video_dev = NULL;
 
-	       btcx_riscmem_free(dev->pci,
-		       &dev->channels[chan_num].vidq.stopper);
+		btcx_riscmem_free(dev->pci,
+				&dev->channels[chan_num].vidq.stopper);
 
 		pr_warn("device %d released!\n", chan_num);
 	}
-- 
1.7.0.4

