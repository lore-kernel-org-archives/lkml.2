Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1JVFso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:48:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JVFsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:48:40 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/36] Staging: cx25821: cx25821-video-upstream-ch2.c: Remove braces
Date: Sat, 22 Oct 2011 13:43:44 +0800
Message-Id: <1319262236-6498-25-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary curly braces around single if statement.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 42f7ba5..aeae2b4 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -610,11 +610,9 @@ static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
 	vid_status = cx_read(sram_ch->int_stat);
 
 	/* Only deal with our interrupt */
-	if (vid_status) {
-		handled =
-		    cx25821_video_upstream_irq_ch2(dev, channel_num,
-						   vid_status);
-	}
+	if (vid_status)
+		handled = cx25821_video_upstream_irq_ch2(dev, channel_num,
+				vid_status);
 
 	if (handled < 0)
 		cx25821_stop_upstream_video_ch2(dev);
-- 
1.7.0.4

