Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1IPGTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52475 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab1IPGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:10 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 39/44] Staging: cx25821: Change indent with spaces to tabs 35
Date: Fri, 16 Sep 2011 14:15:12 +0800
Message-Id: <1316153717-7272-40-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 14661b9..020db63 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1998,9 +1998,9 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 };
 
 struct video_device cx25821_videoioctl_template = {
-	       .name = "cx25821-videoioctl",
-	       .fops = &video_fops,
-	       .ioctl_ops = &video_ioctl_ops,
-	       .tvnorms = CX25821_NORMS,
-	       .current_norm = V4L2_STD_NTSC_M,
+	.name = "cx25821-videoioctl",
+	.fops = &video_fops,
+	.ioctl_ops = &video_ioctl_ops,
+	.tvnorms = CX25821_NORMS,
+	.current_norm = V4L2_STD_NTSC_M,
 };
-- 
1.7.0.4

