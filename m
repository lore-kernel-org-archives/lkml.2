Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1IPGWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:22:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49551 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1IPGSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:18 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 26/44] Staging: cx25821: Change indent with spaces to tabs 22
Date: Fri, 16 Sep 2011 14:14:59 +0800
Message-Id: <1316153717-7272-27-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 709fe3d..4cea791 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1208,9 +1208,9 @@ int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
 {
 	struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;
-       struct cx25821_fh *fh = f;
+	struct cx25821_fh *fh = f;
 
-       *p = v4l2_prio_max(&dev->channels[fh->channel_id].prio);
+	*p = v4l2_prio_max(&dev->channels[fh->channel_id].prio);
 
 	return 0;
 }
@@ -1221,8 +1221,8 @@ int cx25821_vidioc_s_priority(struct file *file, void *f,
 	struct cx25821_fh *fh = f;
 	struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;
 
-       return v4l2_prio_change(&dev->channels[fh->channel_id]
-				       .prio, &fh->prio, prio);
+	return v4l2_prio_change(&dev->channels[fh->channel_id].prio, &fh->prio,
+			prio);
 }
 
 #ifdef TUNER_FLAG
@@ -1235,15 +1235,14 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id * tvnorms)
 	dprintk(1, "%s()\n", __func__);
 
 	if (fh) {
-	       err = v4l2_prio_check(&dev->channels[fh->channel_id]
-					       .prio, fh->prio);
+		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
+				      fh->prio);
 		if (0 != err)
 			return err;
 	}
 
-	if (dev->tvnorm == *tvnorms) {
+	if (dev->tvnorm == *tvnorms)
 		return 0;
-	}
 
 	mutex_lock(&dev->lock);
 	cx25821_set_tvnorm(dev, *tvnorms);
@@ -1257,7 +1256,7 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id * tvnorms)
 
 int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i)
 {
-	static const char *iname[] = {
+	static const char * const iname[] = {
 		[CX25821_VMUX_COMPOSITE] = "Composite",
 		[CX25821_VMUX_SVIDEO] = "S-Video",
 		[CX25821_VMUX_DEBUG] = "for debug only",
@@ -1305,8 +1304,8 @@ int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	dprintk(1, "%s(%d)\n", __func__, i);
 
 	if (fh) {
-	       err = v4l2_prio_check(&dev->channels[fh->channel_id]
-					       .prio, fh->prio);
+		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
+				      fh->prio);
 		if (0 != err)
 			return err;
 	}
-- 
1.7.0.4

