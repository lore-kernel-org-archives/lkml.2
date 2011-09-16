Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1IPGTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55855 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1IPGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:06 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 38/44] Staging: cx25821: Change indent with spaces to tabs 34
Date: Fri, 16 Sep 2011 14:15:11 +0800
Message-Id: <1316153717-7272-39-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   76 +++++++++++++++---------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 1b57d49..14661b9 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1948,52 +1948,52 @@ static long cx25821_video_ioctl(struct file *file,
 
 /* exported stuff */
 static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = cx25821_video_ioctl,
+	.owner = THIS_MODULE,
+	.open = video_open,
+	.release = video_release,
+	.read = video_read,
+	.poll = video_poll,
+	.mmap = cx25821_video_mmap,
+	.ioctl = cx25821_video_ioctl,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
+	.vidioc_querycap = cx25821_vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
+	.vidioc_reqbufs = cx25821_vidioc_reqbufs,
+	.vidioc_querybuf = cx25821_vidioc_querybuf,
+	.vidioc_qbuf = cx25821_vidioc_qbuf,
+	.vidioc_dqbuf = vidioc_dqbuf,
 #ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
+	.vidioc_s_std = cx25821_vidioc_s_std,
+	.vidioc_querystd = cx25821_vidioc_querystd,
 #endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
+	.vidioc_cropcap = cx25821_vidioc_cropcap,
+	.vidioc_s_crop = cx25821_vidioc_s_crop,
+	.vidioc_g_crop = cx25821_vidioc_g_crop,
+	.vidioc_enum_input = cx25821_vidioc_enum_input,
+	.vidioc_g_input = cx25821_vidioc_g_input,
+	.vidioc_s_input = cx25821_vidioc_s_input,
+	.vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
+	.vidioc_s_ctrl = vidioc_s_ctrl,
+	.vidioc_queryctrl = cx25821_vidioc_queryctrl,
+	.vidioc_streamon = vidioc_streamon,
+	.vidioc_streamoff = vidioc_streamoff,
+	.vidioc_log_status = vidioc_log_status,
+	.vidioc_g_priority = cx25821_vidioc_g_priority,
+	.vidioc_s_priority = cx25821_vidioc_s_priority,
 #ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
+	.vidioc_g_tuner = cx25821_vidioc_g_tuner,
+	.vidioc_s_tuner = cx25821_vidioc_s_tuner,
+	.vidioc_g_frequency = cx25821_vidioc_g_frequency,
+	.vidioc_s_frequency = cx25821_vidioc_s_frequency,
 #endif
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
+	.vidioc_g_register = cx25821_vidioc_g_register,
+	.vidioc_s_register = cx25821_vidioc_s_register,
 #endif
 };
 
-- 
1.7.0.4

