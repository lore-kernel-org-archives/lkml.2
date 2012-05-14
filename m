Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab2ENU2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:28:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51702 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812Ab2ENU13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:27:29 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V6 3/5] Add new CID for FM TX RDS Alternate Frequency
Date: Mon, 14 May 2012 15:27:22 -0500
Message-ID: <1337027244-2595-4-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
References: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/video/v4l2-ctrls.c |    1 +
 include/linux/videodev2.h        |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9d7608e..610076c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -608,6 +608,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
 	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
 	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
+	case V4L2_CID_RDS_TX_AF_FREQ:		return "RDS Alternate Frequency";
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
 	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
 	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 91bc47b..3931a99 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1699,6 +1699,7 @@ enum  v4l2_exposure_auto_type {
 #define V4L2_CID_RDS_TX_PTY			(V4L2_CID_FM_TX_CLASS_BASE + 3)
 #define V4L2_CID_RDS_TX_PS_NAME			(V4L2_CID_FM_TX_CLASS_BASE + 5)
 #define V4L2_CID_RDS_TX_RADIO_TEXT		(V4L2_CID_FM_TX_CLASS_BASE + 6)
+#define V4L2_CID_RDS_TX_AF_FREQ			(V4L2_CID_FM_TX_CLASS_BASE + 7)
 
 #define V4L2_CID_AUDIO_LIMITER_ENABLED		(V4L2_CID_FM_TX_CLASS_BASE + 64)
 #define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME	(V4L2_CID_FM_TX_CLASS_BASE + 65)
-- 
1.7.4.1

