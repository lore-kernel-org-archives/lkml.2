Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1IPGRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:17:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38702 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1IPGRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:17:20 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 12/44] Staging: cx25821: Change indent with spaces to tabs 8
Date: Fri, 16 Sep 2011 14:14:45 +0800
Message-Id: <1316153717-7272-13-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   42 ++++++++++++++----------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index e424389..fbf741d 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -759,28 +759,26 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 		if (prev->vb.width == buf->vb.width
 		   && prev->vb.height == buf->vb.height
 		   && prev->fmt == buf->fmt) {
-		       list_add_tail(&buf->vb.queue, &q->active);
-		       buf->vb.state = VIDEOBUF_ACTIVE;
-		       buf->count = q->count++;
-		       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-		       /* 64 bit bits 63-32 */
-		       prev->risc.jmp[2] = cpu_to_le32(0);
-		       dprintk(2,
-			       "[%p/%d] buffer_queue - append to active, \
-			       buf->count=%d\n",
-			       buf, buf->vb.i, buf->count);
+			list_add_tail(&buf->vb.queue, &q->active);
+			buf->vb.state = VIDEOBUF_ACTIVE;
+			buf->count = q->count++;
+			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 
-	       } else {
-		       list_add_tail(&buf->vb.queue, &q->queued);
-		       buf->vb.state = VIDEOBUF_QUEUED;
-		       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-			       buf->vb.i);
-	       }
-       }
+			/* 64 bit bits 63-32 */
+			prev->risc.jmp[2] = cpu_to_le32(0);
+			dprintk(2, "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
+					buf, buf->vb.i, buf->count);
 
-       if (list_empty(&q->active))
-	       dprintk(2, "active queue empty!\n");
+		} else {
+			list_add_tail(&buf->vb.queue, &q->queued);
+			buf->vb.state = VIDEOBUF_QUEUED;
+			dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
+					buf->vb.i);
+		}
+	}
+
+	if (list_empty(&q->active))
+		dprintk(2, "active queue empty!\n");
 }
 
 static struct videobuf_queue_ops cx25821_video_qops = {
-- 
1.7.0.4

