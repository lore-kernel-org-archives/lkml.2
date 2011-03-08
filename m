Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1CHUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:29 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58631 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1CHUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:16 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 10/15] staging: xgifb: vb_ext: delete redundant declarations
Date: Tue,  8 Mar 2011 22:16:15 +0200
Message-Id: <1299615380-22922-11-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete redundant declarations.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_ext.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/xgifb/vb_ext.c b/drivers/staging/xgifb/vb_ext.c
index 80c7818..e1f9188 100644
--- a/drivers/staging/xgifb/vb_ext.c
+++ b/drivers/staging/xgifb/vb_ext.c
@@ -9,25 +9,12 @@
 #include "vb_util.h"
 #include "vb_setmode.h"
 #include "vb_ext.h"
-extern unsigned char XGI330_SoftSetting;
-extern unsigned char XGI330_OutputSelect;
-extern unsigned short XGI330_RGBSenseData2;
-extern unsigned short XGI330_YCSenseData2;
-extern unsigned short XGI330_VideoSenseData2;
-void XGI_GetSenseStatus(struct xgi_hw_device_info *HwDeviceExtension,
-		struct vb_device_info *pVBInfo);
 unsigned char XGINew_GetPanelID(struct vb_device_info *pVBInfo);
-unsigned short XGINew_SenseLCD(struct xgi_hw_device_info *,
-		struct vb_device_info *pVBInfo);
 unsigned char XGINew_GetLCDDDCInfo(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo);
-void XGISetDPMS(struct xgi_hw_device_info *pXGIHWDE,
-		unsigned long VESA_POWER_STATE);
 unsigned char XGINew_BridgeIsEnable(struct xgi_hw_device_info *,
 		struct vb_device_info *pVBInfo);
-unsigned char XGINew_Sense(unsigned short tempbx, unsigned short tempcx,
-		struct vb_device_info *pVBInfo);
 unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo);
 
@@ -35,10 +22,6 @@ unsigned char XGINew_SenseHiTV(struct xgi_hw_device_info *HwDeviceExtension,
  *********************** Dynamic Sense ************************
  *************************************************************/
 
-void XGI_WaitDisplay(void);
-unsigned char XGI_Is301C(struct vb_device_info *);
-unsigned char XGI_Is301LV(struct vb_device_info *);
-
 static unsigned char XGINew_Is301B(struct vb_device_info *pVBInfo)
 {
 	unsigned short flag;
-- 
1.5.6.5

