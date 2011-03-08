Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1CHUSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:18:25 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58628 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab1CHUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:18 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 12/15] staging: xgifb: vb_ext: make internal functions static
Date: Tue,  8 Mar 2011 22:16:17 +0200
Message-Id: <1299615380-22922-13-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make internal functions static.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index cc78815..33a0635 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -9,13 +9,13 @@
 #include "vb_util.h"
 #include "vb_setmode.h"
 #include "vb_ext.h"
-unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo);
-unsigned char XGINew_GetLCDDDCInfo(
+static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo);
+static unsigned char XGINew_GetLCDDDCInfo(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo);
-unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *,
+static unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *,
 		struct vb_device_info *pVBInfo);
-unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension,
+static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo);
 
 /**************************************************************
@@ -34,7 +34,7 @@ static unsigned char XGINew_Is301B(struct vb_device_info *pVBInfo)
 		return 1;
 }
 
-unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx, struct vb_device_info *pVBInfo)
+static unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp, i, tempch;
 
@@ -214,7 +214,7 @@ unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *HwDeviceExtension, str
 	return temp;
 }
 
-unsigned char XGINew_GetLCDDDCInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+static unsigned char XGINew_GetLCDDDCInfo(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
 {
 	unsigned short temp;
 
@@ -256,7 +256,7 @@ unsigned char XGINew_GetLCDDDCInfo(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 }
 
-unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
+static unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 {
 	unsigned short PanelTypeTable[16] = { SyncNN | PanelRGB18Bit
 			| Panel800x600  | _PanelType00, SyncNN | PanelRGB18Bit
@@ -318,7 +318,7 @@ unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo)
 	}
 }
 
-unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+static unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
 {
 	unsigned short flag;
 
@@ -334,7 +334,7 @@ unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *HwDeviceExtension
 	return 0;
 }
 
-unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
+static unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo)
 {
 	unsigned short tempbx, tempcx, temp, i, tempch;
 
-- 
1.5.6.5

