Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1KPKPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:15:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47359 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab1KPKPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:15:24 -0500
From: Il Han <corone.il.han@gmail.com>
To: Marin Mitov <mitov@issp.bas.bg>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Il Han <corone.il.han@gmail.com>
Subject: [PATCH] dt3155v4l: make the parameter declarations agree.
Date: Wed, 16 Nov 2011 19:15:07 +0900
Message-Id: <1321438507-28446-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assignment from incompatible pointer type.
Make the parameter declarations agree.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 04e93c4..2e50924 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -218,9 +218,9 @@ dt3155_start_acq(struct dt3155_priv *pd)
  *	driver-specific callbacks (vb2_ops)
  */
 static int
-dt3155_queue_setup(struct vb2_queue *q, unsigned int *num_buffers,
-			unsigned int *num_planes, unsigned long sizes[],
-						void *alloc_ctxs[])
+dt3155_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned long sizes[], void *alloc_ctxs[])
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 	void *ret;
@@ -262,7 +262,7 @@ dt3155_buf_prepare(struct vb2_buffer *vb)
 }
 
 static int
-dt3155_start_streaming(struct vb2_queue *q)
+dt3155_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	return 0;
 }
-- 
1.7.4.1

