Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1G3Pon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:44:43 -0400
Received: from mta21.charter.net ([216.33.127.81]:55776 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1G3Pog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:44:36 -0400
X-Authority-Analysis: v=1.1 cv=9p7SjTZeSDUoepfMOc4Nsety+m2Qz47GaesuhdPPf9o=
 c=1 sm=1 a=Y-Xa6sjusHoA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=ywb5jiRdAAAA:8 a=FKcYwT7qAAAA:8 a=q3bFVz8phfM1WQm4WMgA:9
 a=hO6-NAvlA-CbkXu3u3YA:7 a=8ayuLyWxgakA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: laurent.pinchart@ideasonboard.com
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        jpiszcz@lucidpixels.com, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] uvcvideo: correct kernel version reference
Date: Sat, 30 Jul 2011 10:47:30 -0500
Message-Id: <1312040850-21475-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan>
References: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change from v2.6.42 to v3.2

Reported-by: Justin Piszcz <jpiszcz@lucidpixels.com>
Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 drivers/media/video/uvc/uvcvideo.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index ea71d5f..6d6e3f9 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -546,7 +546,7 @@ static void uvc_v4l2_ioctl_warn(void)
 		return;
 
 	uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} "
-		   "ioctls will be removed in 2.6.42.\n");
+		   "ioctls will be removed in 3.2.\n");
 	uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/upgrade/ "
 		   "for upgrade instructions.\n");
 	warned = 1;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index df32a43..4419c34 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -7,7 +7,7 @@
 #ifndef __KERNEL__
 /*
  * This header provides binary compatibility with applications using the private
- * uvcvideo API. This API is deprecated and will be removed in 2.6.42.
+ * uvcvideo API. This API is deprecated and will be removed in 3.2.
  * Applications should be recompiled against the public linux/uvcvideo.h header.
  */
 #warn "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instead."
-- 
1.7.2.5

