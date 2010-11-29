Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0K2NK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:10:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51993 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0K2NKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:10:17 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC v5 1/9] include:linux: videodev2.h: FM Rx control class
Date: Mon, 29 Nov 2010 09:18:35 -0500
Message-Id: <1291040323-2641-2-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1291040323-2641-1-git-send-email-manjunatha_halli@ti.com>
References: <1291040323-2641-1-git-send-email-manjunatha_halli@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Introduce V4L2_CTRL_CLASS_FM_RX for FM receivers similar to
V4L2_CTRL_CLASS_FM_TX.
Few controls such as RSSI threshold, Alternate Frequency are for
now under this class.

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 include/linux/videodev2.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5f6f470..5ab66a9 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -932,6 +932,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
+#define V4L2_CTRL_CLASS_FM_RX 0x009c0000	/* FM Tuner control class */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1304,6 +1305,10 @@ enum  v4l2_exposure_auto_type {
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
 
+/* FM Tuner class control IDs */
+#define V4L2_CID_FM_RX_CLASS_BASE            (V4L2_CTRL_CLASS_FM_RX | 0x900)
+#define V4L2_CID_FM_RX_CLASS                 (V4L2_CTRL_CLASS_FM_RX | 1)
+
 #define V4L2_CID_RDS_TX_DEVIATION		(V4L2_CID_FM_TX_CLASS_BASE + 1)
 #define V4L2_CID_RDS_TX_PI			(V4L2_CID_FM_TX_CLASS_BASE + 2)
 #define V4L2_CID_RDS_TX_PTY			(V4L2_CID_FM_TX_CLASS_BASE + 3)
@@ -1333,6 +1338,9 @@ enum v4l2_preemphasis {
 #define V4L2_CID_TUNE_POWER_LEVEL		(V4L2_CID_FM_TX_CLASS_BASE + 113)
 #define V4L2_CID_TUNE_ANTENNA_CAPACITOR		(V4L2_CID_FM_TX_CLASS_BASE + 114)
 
+#define V4L2_CID_RSSI_THRESHOLD		(V4L2_CID_FM_RX_CLASS_BASE + 2)
+#define V4L2_CID_TUNE_AF                       (V4L2_CID_FM_RX_CLASS_BASE + 3)
+
 /*
  *	T U N I N G
  */
-- 
1.5.6.3

