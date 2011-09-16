Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1IPGTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:34 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35859 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1IPGTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:31 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 44/44] Staging: cx25821: cx25821-video.h: Fix long lines
Date: Fri, 16 Sep 2011 14:15:17 +0800
Message-Id: <1316153717-7272-45-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long function prototypes and line up arguments nicely.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.h |   47 +++++++++++++++++++------------
 1 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/staging/cx25821/cx25821-video.h
index e4aa4df..d0d9538 100644
--- a/drivers/staging/cx25821/cx25821-video.h
+++ b/drivers/staging/cx25821/cx25821-video.h
@@ -115,9 +115,10 @@ extern int cx25821_video_register(struct cx25821_dev *dev);
 extern int cx25821_get_format_size(void);
 
 extern int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
-			unsigned int *size);
-extern int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-			  enum v4l2_field field);
+				unsigned int *size);
+extern int cx25821_buffer_prepare(struct videobuf_queue *q,
+				  struct videobuf_buffer *vb,
+				  enum v4l2_field field);
 extern void cx25821_buffer_release(struct videobuf_queue *q,
 				   struct videobuf_buffer *vb);
 extern struct videobuf_queue *get_queue(struct cx25821_fh *fh);
@@ -132,14 +133,18 @@ extern int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 extern int cx25821_vidioc_reqbufs(struct file *file, void *priv,
 				  struct v4l2_requestbuffers *p);
 extern int cx25821_vidioc_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *p);
-extern int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
-extern int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id * tvnorms);
+				   struct v4l2_buffer *p);
+extern int cx25821_vidioc_qbuf(struct file *file, void *priv,
+			       struct v4l2_buffer *p);
+extern int cx25821_vidioc_s_std(struct file *file, void *priv,
+				v4l2_std_id *tvnorms);
 extern int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i);
 extern int cx25821_vidioc_enum_input(struct file *file, void *priv,
-			     struct v4l2_input *i);
-extern int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i);
-extern int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i);
+				     struct v4l2_input *i);
+extern int cx25821_vidioc_g_input(struct file *file, void *priv,
+				  unsigned int *i);
+extern int cx25821_vidioc_s_input(struct file *file, void *priv,
+				  unsigned int i);
 extern int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
 				 struct v4l2_control *ctl);
 extern int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
@@ -152,14 +157,17 @@ extern int cx25821_vidioc_s_frequency(struct file *file, void *priv,
 extern int cx25821_vidioc_g_register(struct file *file, void *fh,
 				     struct v4l2_dbg_register *reg);
 extern int cx25821_vidioc_s_register(struct file *file, void *fh,
-			     struct v4l2_dbg_register *reg);
-extern int cx25821_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
-extern int cx25821_vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
+				     struct v4l2_dbg_register *reg);
+extern int cx25821_vidioc_g_tuner(struct file *file, void *priv,
+				  struct v4l2_tuner *t);
+extern int cx25821_vidioc_s_tuner(struct file *file, void *priv,
+				  struct v4l2_tuner *t);
 
 extern int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm);
 extern int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm);
 
-extern int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p);
+extern int cx25821_vidioc_g_priority(struct file *file, void *f,
+				     enum v4l2_priority *p);
 extern int cx25821_vidioc_s_priority(struct file *file, void *f,
 				     enum v4l2_priority prio);
 
@@ -169,9 +177,12 @@ extern int cx25821_set_control(struct cx25821_dev *dev,
 			       struct v4l2_control *ctrl, int chan_num);
 
 extern int cx25821_vidioc_cropcap(struct file *file, void *fh,
-			  struct v4l2_cropcap *cropcap);
-extern int cx25821_vidioc_s_crop(struct file *file, void *priv, struct v4l2_crop *crop);
-extern int cx25821_vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop);
-
-extern int cx25821_vidioc_querystd(struct file *file, void *priv, v4l2_std_id * norm);
+				  struct v4l2_cropcap *cropcap);
+extern int cx25821_vidioc_s_crop(struct file *file, void *priv,
+				 struct v4l2_crop *crop);
+extern int cx25821_vidioc_g_crop(struct file *file, void *priv,
+				 struct v4l2_crop *crop);
+
+extern int cx25821_vidioc_querystd(struct file *file, void *priv,
+				   v4l2_std_id *norm);
 #endif
-- 
1.7.0.4

