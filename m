Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1IPGQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:16:51 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:54926 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1IPGQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:16:49 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 04/44] Staging: cx25821: Fix indent in comment
Date: Fri, 16 Sep 2011 14:14:37 +0800
Message-Id: <1316153717-7272-5-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent in comment to use tabs instead of spaces.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 1aebc99..116727a 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -203,19 +203,19 @@ struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
 /*
 static int cx25821_ctrl_query(struct v4l2_queryctrl *qctrl)
 {
-    int i;
+	int i;
 
-    if (qctrl->id < V4L2_CID_BASE || qctrl->id >= V4L2_CID_LASTP1)
-	return -EINVAL;
-    for (i = 0; i < CX25821_CTLS; i++)
-	if (cx25821_ctls[i].v.id == qctrl->id)
-	    break;
-    if (i == CX25821_CTLS) {
-	*qctrl = no_ctl;
+	if (qctrl->id < V4L2_CID_BASE || qctrl->id >= V4L2_CID_LASTP1)
+		return -EINVAL;
+	for (i = 0; i < CX25821_CTLS; i++)
+		if (cx25821_ctls[i].v.id == qctrl->id)
+			break;
+	if (i == CX25821_CTLS) {
+		*qctrl = no_ctl;
+		return 0;
+	}
+	*qctrl = cx25821_ctls[i].v;
 	return 0;
-    }
-    *qctrl = cx25821_ctls[i].v;
-    return 0;
 }
 */
 
-- 
1.7.0.4

