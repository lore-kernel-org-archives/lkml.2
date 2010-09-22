Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0IVKie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:38:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42746 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0IVKhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:37:47 -0400
From: x0130808@ti.com
To: linux-kernel@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>, Pramodh AG <pramodh_ag@ti.com>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [RFC/PATCH 6/9] drivers:media:video: Adding new CIDs for FM RX ctls
Date: Wed, 22 Sep 2010 07:48:36 -0400
Message-Id: <1285156119-28531-7-git-send-email-x0130808@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1285156119-28531-6-git-send-email-x0130808@ti.com>
References: <1285156119-28531-1-git-send-email-x0130808@ti.com>
 <1285156119-28531-2-git-send-email-x0130808@ti.com>
 <1285156119-28531-3-git-send-email-x0130808@ti.com>
 <1285156119-28531-4-git-send-email-x0130808@ti.com>
 <1285156119-28531-5-git-send-email-x0130808@ti.com>
 <1285156119-28531-6-git-send-email-x0130808@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja Mani <raja_mani@ti.com>

Add support for the following new Control IDs (CID)
   V4L2_CID_RSSI_THRESHOLD - RSSI Threshold
   V4L2_CID_TUNE_AF        - Alternative Frequency

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/video/v4l2-common.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 4e53b0b..5a8e528 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -520,6 +520,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_PREEMPHASIS:	return "Pre-emphasis settings";
 	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
+	case V4L2_CID_RSSI_THRESHOLD:	return "RSSI Threshold";
+	case V4L2_CID_TUNE_AF:		return "Alternative Frequency";
 
 	default:
 		return NULL;
@@ -585,6 +587,8 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
 	case V4L2_CID_EXPOSURE_AUTO:
 	case V4L2_CID_COLORFX:
 	case V4L2_CID_TUNE_PREEMPHASIS:
+	case V4L2_CID_RSSI_THRESHOLD:
+	case V4L2_CID_TUNE_AF:
 		qctrl->type = V4L2_CTRL_TYPE_MENU;
 		step = 1;
 		break;
-- 
1.5.6.3

