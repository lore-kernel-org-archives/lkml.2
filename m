Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1IPGSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55855 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1IPGSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:38 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 31/44] Staging: cx25821: Change indent with spaces to tabs 27
Date: Fri, 16 Sep 2011 14:15:04 +0800
Message-Id: <1316153717-7272-32-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 4d3d4f2..5c890c9 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1742,30 +1742,29 @@ static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-       int command = 0;
-       struct upstream_user_struct *data_from_user;
+	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_dev *dev = fh->dev;
+	int command = 0;
+	struct upstream_user_struct *data_from_user;
 
-       data_from_user = (struct upstream_user_struct *)arg;
+	data_from_user = (struct upstream_user_struct *)arg;
 
 	if (!data_from_user) {
 		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
 		return 0;
 	}
 
-       command = data_from_user->command;
+	command = data_from_user->command;
 
-       if (command != UPSTREAM_START_VIDEO &&
-	       command != UPSTREAM_STOP_VIDEO)
-	       return 0;
+	if (command != UPSTREAM_START_VIDEO && command != UPSTREAM_STOP_VIDEO)
+		return 0;
 
-       dev->input_filename_ch2 = data_from_user->input_filename;
-       dev->input_audiofilename = data_from_user->input_filename;
-       dev->vid_stdname_ch2 = data_from_user->vid_stdname;
-       dev->pixel_format_ch2 = data_from_user->pixel_format;
-       dev->channel_select_ch2 = data_from_user->channel_select;
-       dev->command_ch2 = data_from_user->command;
+	dev->input_filename_ch2 = data_from_user->input_filename;
+	dev->input_audiofilename = data_from_user->input_filename;
+	dev->vid_stdname_ch2 = data_from_user->vid_stdname;
+	dev->pixel_format_ch2 = data_from_user->pixel_format;
+	dev->channel_select_ch2 = data_from_user->channel_select;
+	dev->command_ch2 = data_from_user->command;
 
        switch (command) {
        case UPSTREAM_START_VIDEO:
-- 
1.7.0.4

