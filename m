Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1IPGTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55855 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1IPGTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:14 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 40/44] Staging: cx25821: Fix braces around statements in cx25821-video.c
Date: Fri, 16 Sep 2011 14:15:13 +0800
Message-Id: <1316153717-7272-41-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete braces around single statements.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 020db63..c54d309 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -98,9 +98,8 @@ struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
-	if (fourcc == V4L2_PIX_FMT_Y41P || fourcc == V4L2_PIX_FMT_YUV411P) {
+	if (fourcc == V4L2_PIX_FMT_Y41P || fourcc == V4L2_PIX_FMT_YUV411P)
 		return formats + 1;
-	}
 
 	for (i = 0; i < ARRAY_SIZE(formats); i++)
 		if (formats[i].fourcc == fourcc)
@@ -147,9 +146,8 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 		/* count comes from the hw and it is 16bit wide --
 		 * this trick handles wrap-arounds correctly for
 		 * up to 32767 buffers in flight... */
-		if ((s16) (count - buf->count) < 0) {
+		if ((s16) (count - buf->count) < 0)
 			break;
-		}
 
 		do_gettimeofday(&buf->vb.ts);
 		buf->vb.state = VIDEOBUF_DONE;
-- 
1.7.0.4

