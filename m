Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1IPGRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:16 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43996 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1IPGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:12 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 10/44] Staging: cx25821: Change indent with spaces to tabs 6
Date: Fri, 16 Sep 2011 14:14:43 +0800
Message-Id: <1316153717-7272-11-git-send-email-leonidsbox@gmail.com>
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
index 8145006..d422d45 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -534,7 +534,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	return 0;
 
 fail_unreg:
-       cx25821_video_unregister(dev, i);
+	cx25821_video_unregister(dev, i);
 	return err;
 }
 
@@ -565,7 +565,7 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	u32 line0_offset, line1_offset;
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
 	int bpl_local = LINE_SIZE_D1;
-       int channel_opened = fh->channel_id;
+	int channel_opened = fh->channel_id;
 
 	BUG_ON(NULL == fh->fmt);
 	if (fh->width < 48 || fh->width > 720 ||
@@ -604,21 +604,21 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		channel_opened = (channel_opened < 0
 				  || channel_opened > 7) ? 7 : channel_opened;
 
-	       if (dev->channels[channel_opened]
-		       .pixel_formats == PIXEL_FRMT_411)
+		if (dev->channels[channel_opened].pixel_formats ==
+				PIXEL_FRMT_411)
 			buf->bpl = (buf->fmt->depth * buf->vb.width) >> 3;
 		else
 			buf->bpl = (buf->fmt->depth >> 3) * (buf->vb.width);
 
-	       if (dev->channels[channel_opened]
-		       .pixel_formats == PIXEL_FRMT_411) {
+		if (dev->channels[channel_opened].pixel_formats ==
+				PIXEL_FRMT_411) {
 			bpl_local = buf->bpl;
 		} else {
-		       bpl_local = buf->bpl;   /* Default */
+			bpl_local = buf->bpl;   /* Default */
 
 			if (channel_opened >= 0 && channel_opened <= 7) {
-			       if (dev->channels[channel_opened]
-					       .use_cif_resolution) {
+				if (dev->channels[channel_opened]
+						.use_cif_resolution) {
 					if (dev->tvnorm & V4L2_STD_PAL_BG
 					    || dev->tvnorm & V4L2_STD_PAL_DK)
 						bpl_local = 352 << 1;
@@ -724,7 +724,7 @@ int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
 
 static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
-       struct cx25821_buffer *buf =
+	struct cx25821_buffer *buf =
 	   container_of(vb, struct cx25821_buffer, vb);
        struct cx25821_buffer *prev;
        struct cx25821_fh *fh = vq->priv_data;
-- 
1.7.0.4

