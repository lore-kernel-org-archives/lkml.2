Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1IPGSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35481 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1IPGSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:34 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 30/44] Staging: cx25821: Change indent with spaces to tabs 26
Date: Fri, 16 Sep 2011 14:15:03 +0800
Message-Id: <1316153717-7272-31-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index fb89c27..4d3d4f2 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1726,17 +1726,17 @@ static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 	dev->channel_select = data_from_user->channel_select;
 	dev->command = data_from_user->command;
 
-       switch (command) {
-       case UPSTREAM_START_VIDEO:
-	       cx25821_start_upstream_video_ch1(dev, data_from_user);
-	       break;
+	switch (command) {
+	case UPSTREAM_START_VIDEO:
+		cx25821_start_upstream_video_ch1(dev, data_from_user);
+		break;
 
-       case UPSTREAM_STOP_VIDEO:
-	       cx25821_stop_upstream_video_ch1(dev);
-	       break;
-       }
+	case UPSTREAM_STOP_VIDEO:
+		cx25821_stop_upstream_video_ch1(dev);
+		break;
+	}
 
-       return 0;
+	return 0;
 }
 
 static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
-- 
1.7.0.4

