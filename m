Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1IPGSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:18:48 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:64847 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1IPGSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:46 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 33/44] Staging: cx25821: Change indent with spaces to tabs 29
Date: Fri, 16 Sep 2011 14:15:06 +0800
Message-Id: <1316153717-7272-34-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   47 +++++++++++++++----------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index f6a9a5c..57f1a55 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1782,42 +1782,41 @@ static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
 static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
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
 
-       if (command != UPSTREAM_START_AUDIO &&
-	       command != UPSTREAM_STOP_AUDIO)
-	       return 0;
+	if (command != UPSTREAM_START_AUDIO && command != UPSTREAM_STOP_AUDIO)
+		return 0;
 
-       dev->input_filename = data_from_user->input_filename;
-       dev->input_audiofilename = data_from_user->input_filename;
-       dev->vid_stdname = data_from_user->vid_stdname;
-       dev->pixel_format = data_from_user->pixel_format;
-       dev->channel_select = data_from_user->channel_select;
-       dev->command = data_from_user->command;
+	dev->input_filename = data_from_user->input_filename;
+	dev->input_audiofilename = data_from_user->input_filename;
+	dev->vid_stdname = data_from_user->vid_stdname;
+	dev->pixel_format = data_from_user->pixel_format;
+	dev->channel_select = data_from_user->channel_select;
+	dev->command = data_from_user->command;
 
-       switch (command) {
-       case UPSTREAM_START_AUDIO:
-	       cx25821_start_upstream_audio(dev, data_from_user);
-	       break;
+	switch (command) {
+	case UPSTREAM_START_AUDIO:
+		cx25821_start_upstream_audio(dev, data_from_user);
+		break;
 
-       case UPSTREAM_STOP_AUDIO:
-	       cx25821_stop_upstream_audio(dev);
-	       break;
-       }
+	case UPSTREAM_STOP_AUDIO:
+		cx25821_stop_upstream_audio(dev);
+		break;
+	}
 
-       return 0;
+	return 0;
 }
 
 static long video_ioctl_set(struct file *file, unsigned int cmd,
-- 
1.7.0.4

