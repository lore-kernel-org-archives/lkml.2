Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1IPGT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52475 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1IPGT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:26 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 43/44] Staging: cx25821: cx25821-video.h: Fix indent
Date: Fri, 16 Sep 2011 14:15:16 +0800
Message-Id: <1316153717-7272-44-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indent of function arguments.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/staging/cx25821/cx25821-video.h
index 4247788..e4aa4df 100644
--- a/drivers/staging/cx25821/cx25821-video.h
+++ b/drivers/staging/cx25821/cx25821-video.h
@@ -87,7 +87,7 @@ extern struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc);
 extern struct cx25821_data timeout_data[MAX_VID_CHANNEL_NUM];
 
 extern void cx25821_dump_video_queue(struct cx25821_dev *dev,
-			     struct cx25821_dmaqueue *q);
+				     struct cx25821_dmaqueue *q);
 extern void cx25821_video_wakeup(struct cx25821_dev *dev,
 				 struct cx25821_dmaqueue *q, u32 count);
 
@@ -96,11 +96,11 @@ extern int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm);
 #endif
 
 extern int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
-		   unsigned int bit);
+			   unsigned int bit);
 extern int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit);
 extern int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit);
 extern void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
-		     unsigned int bits);
+			     unsigned int bits);
 extern int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input);
 extern int cx25821_start_video_dma(struct cx25821_dev *dev,
 				   struct cx25821_dmaqueue *q,
@@ -119,18 +119,18 @@ extern int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 extern int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 			  enum v4l2_field field);
 extern void cx25821_buffer_release(struct videobuf_queue *q,
-			   struct videobuf_buffer *vb);
+				   struct videobuf_buffer *vb);
 extern struct videobuf_queue *get_queue(struct cx25821_fh *fh);
 extern int cx25821_get_resource(struct cx25821_fh *fh, int resource);
 extern int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma);
 extern int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
-				  struct v4l2_format *f);
+					  struct v4l2_format *f);
 extern int cx25821_vidioc_querycap(struct file *file, void *priv,
-			   struct v4l2_capability *cap);
+				   struct v4l2_capability *cap);
 extern int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
-				   struct v4l2_fmtdesc *f);
+					   struct v4l2_fmtdesc *f);
 extern int cx25821_vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *p);
+				  struct v4l2_requestbuffers *p);
 extern int cx25821_vidioc_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *p);
 extern int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
@@ -141,16 +141,16 @@ extern int cx25821_vidioc_enum_input(struct file *file, void *priv,
 extern int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i);
 extern int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i);
 extern int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctl);
+				 struct v4l2_control *ctl);
 extern int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f);
+					struct v4l2_format *f);
 extern int cx25821_vidioc_g_frequency(struct file *file, void *priv,
-			      struct v4l2_frequency *f);
+				      struct v4l2_frequency *f);
 extern int cx25821_set_freq(struct cx25821_dev *dev, struct v4l2_frequency *f);
 extern int cx25821_vidioc_s_frequency(struct file *file, void *priv,
-			      struct v4l2_frequency *f);
+				      struct v4l2_frequency *f);
 extern int cx25821_vidioc_g_register(struct file *file, void *fh,
-			     struct v4l2_dbg_register *reg);
+				     struct v4l2_dbg_register *reg);
 extern int cx25821_vidioc_s_register(struct file *file, void *fh,
 			     struct v4l2_dbg_register *reg);
 extern int cx25821_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
@@ -161,10 +161,10 @@ extern int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm);
 
 extern int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p);
 extern int cx25821_vidioc_s_priority(struct file *file, void *f,
-			     enum v4l2_priority prio);
+				     enum v4l2_priority prio);
 
 extern int cx25821_vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qctrl);
+				    struct v4l2_queryctrl *qctrl);
 extern int cx25821_set_control(struct cx25821_dev *dev,
 			       struct v4l2_control *ctrl, int chan_num);
 
-- 
1.7.0.4

