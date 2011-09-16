Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1IPGTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48375 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1IPGTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:03 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 37/44] Staging: cx25821: Change indent with spaces to tabs 33
Date: Fri, 16 Sep 2011 14:15:10 +0800
Message-Id: <1316153717-7272-38-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index aa57b40..1b57d49 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1930,20 +1930,20 @@ static long cx25821_video_ioctl(struct file *file,
 
 	struct cx25821_fh  *fh  = file->private_data;
 
-       /* check to see if it's the video upstream */
-       if (fh->channel_id == SRAM_CH09) {
-	       ret = video_ioctl_upstream9(file, cmd, arg);
-	       return ret;
-       } else if (fh->channel_id == SRAM_CH10) {
-	       ret = video_ioctl_upstream10(file, cmd, arg);
-	       return ret;
-       } else if (fh->channel_id == SRAM_CH11) {
-	       ret = video_ioctl_upstream11(file, cmd, arg);
-	       ret = video_ioctl_set(file, cmd, arg);
-	       return ret;
-       }
-
-    return video_ioctl2(file, cmd, arg);
+	/* check to see if it's the video upstream */
+	if (fh->channel_id == SRAM_CH09) {
+		ret = video_ioctl_upstream9(file, cmd, arg);
+		return ret;
+	} else if (fh->channel_id == SRAM_CH10) {
+		ret = video_ioctl_upstream10(file, cmd, arg);
+		return ret;
+	} else if (fh->channel_id == SRAM_CH11) {
+		ret = video_ioctl_upstream11(file, cmd, arg);
+		ret = video_ioctl_set(file, cmd, arg);
+		return ret;
+	}
+
+	return video_ioctl2(file, cmd, arg);
 }
 
 /* exported stuff */
-- 
1.7.0.4

