Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1IPGSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55855 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1IPGSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:50 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 34/44] Staging: cx25821: Change indent with spaces to tabs 30
Date: Fri, 16 Sep 2011 14:15:07 +0800
Message-Id: <1316153717-7272-35-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 57f1a55..fbdb79f 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1822,25 +1822,25 @@ static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 static long video_ioctl_set(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct downstream_user_struct *data_from_user;
-       int command;
-       int width = 720;
-       int selected_channel = 0, pix_format = 0, i = 0;
-       int cif_enable = 0, cif_width = 0;
-       u32 value = 0;
+	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_dev *dev = fh->dev;
+	struct downstream_user_struct *data_from_user;
+	int command;
+	int width = 720;
+	int selected_channel = 0, pix_format = 0, i = 0;
+	int cif_enable = 0, cif_width = 0;
+	u32 value = 0;
 
-       data_from_user = (struct downstream_user_struct *)arg;
+	data_from_user = (struct downstream_user_struct *)arg;
 
 	if (!data_from_user) {
 		pr_err("%s(): User data is INVALID. Returning\n", __func__);
 		return 0;
 	}
 
-       command = data_from_user->command;
+	command = data_from_user->command;
 
-       if (command != SET_VIDEO_STD && command != SET_PIXEL_FORMAT
+	if (command != SET_VIDEO_STD && command != SET_PIXEL_FORMAT
 	   && command != ENABLE_CIF_RESOLUTION && command != REG_READ
 	   && command != REG_WRITE && command != MEDUSA_READ
 	   && command != MEDUSA_WRITE) {
-- 
1.7.0.4

