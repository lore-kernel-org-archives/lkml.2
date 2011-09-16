Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1IPGS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:56 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61000 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1IPGSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:54 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 35/44] Staging: cx25821: Change indent with spaces to tabs 31
Date: Fri, 16 Sep 2011 14:15:08 +0800
Message-Id: <1316153717-7272-36-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   37 +++++++++++++++----------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index fbdb79f..2383feb 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1844,28 +1844,27 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 	   && command != ENABLE_CIF_RESOLUTION && command != REG_READ
 	   && command != REG_WRITE && command != MEDUSA_READ
 	   && command != MEDUSA_WRITE) {
-	       return 0;
-       }
+		return 0;
+	}
 
-       switch (command) {
-       case SET_VIDEO_STD:
-	       dev->tvnorm =
-		   !strcmp(data_from_user->vid_stdname,
-			   "PAL") ? V4L2_STD_PAL_BG : V4L2_STD_NTSC_M;
-	       medusa_set_videostandard(dev);
-	       break;
+	switch (command) {
+	case SET_VIDEO_STD:
+		dev->tvnorm = !strcmp(data_from_user->vid_stdname, "PAL") ?
+					V4L2_STD_PAL_BG : V4L2_STD_NTSC_M;
+		medusa_set_videostandard(dev);
+		break;
 
-       case SET_PIXEL_FORMAT:
-	       selected_channel = data_from_user->decoder_select;
-	       pix_format = data_from_user->pixel_format;
+	case SET_PIXEL_FORMAT:
+		selected_channel = data_from_user->decoder_select;
+		pix_format = data_from_user->pixel_format;
 
-	       if (!(selected_channel <= 7 && selected_channel >= 0)) {
-		       selected_channel -= 4;
-		       selected_channel = selected_channel % 8;
-	       }
+		if (!(selected_channel <= 7 && selected_channel >= 0)) {
+			selected_channel -= 4;
+			selected_channel = selected_channel % 8;
+		}
 
-	       if (selected_channel >= 0)
-		       cx25821_set_pixel_format(dev, selected_channel,
+		if (selected_channel >= 0)
+			cx25821_set_pixel_format(dev, selected_channel,
 						pix_format);
 
 	       break;
-- 
1.7.0.4

