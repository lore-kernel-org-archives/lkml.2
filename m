Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2EBVnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:43:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2EBVmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:42:36 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V3 3/5] [Media] Add new CID for FM TX RDS Alternate Frequency
Date: Wed, 2 May 2012 16:42:29 -0500
Message-ID: <1335994951-15842-4-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1335994951-15842-1-git-send-email-manjunatha_halli@ti.com>
References: <1335994951-15842-1-git-send-email-manjunatha_halli@ti.com>
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
index e1bba7d..b4ddd6b 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -614,6 +614,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
 	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
 	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
+	case V4L2_CID_RDS_TX_AF_FREQ:		return "RDS Alternate Frequency";
 	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
 	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
 	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index f94acfd..2514658 100644
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

