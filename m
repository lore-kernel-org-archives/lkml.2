Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1CHUR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:17:57 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58631 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab1CHUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:19 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 13/15] staging: xgifb: vb_init: delete redundant declarations
Date: Tue,  8 Mar 2011 22:16:18 +0200
Message-Id: <1299615380-22922-14-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete redundant declarations.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index a16827e..24dc00c 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -17,17 +17,6 @@
 
 static unsigned char XGINew_ChannelAB, XGINew_DataBusWidth;
 
-unsigned short XGINew_DRAMType[17][5] = {
-	{0x0C, 0x0A, 0x02, 0x40, 0x39}, {0x0D, 0x0A, 0x01, 0x40, 0x48},
-	{0x0C, 0x09, 0x02, 0x20, 0x35}, {0x0D, 0x09, 0x01, 0x20, 0x44},
-	{0x0C, 0x08, 0x02, 0x10, 0x31}, {0x0D, 0x08, 0x01, 0x10, 0x40},
-	{0x0C, 0x0A, 0x01, 0x20, 0x34}, {0x0C, 0x09, 0x01, 0x08, 0x32},
-	{0x0B, 0x08, 0x02, 0x08, 0x21}, {0x0C, 0x08, 0x01, 0x08, 0x30},
-	{0x0A, 0x08, 0x02, 0x04, 0x11}, {0x0B, 0x0A, 0x01, 0x10, 0x28},
-	{0x09, 0x08, 0x02, 0x02, 0x01}, {0x0B, 0x09, 0x01, 0x08, 0x24},
-	{0x0B, 0x08, 0x01, 0x04, 0x20}, {0x0A, 0x08, 0x01, 0x02, 0x10},
-	{0x09, 0x08, 0x01, 0x01, 0x00} };
-
 static unsigned short XGINew_SDRDRAM_TYPE[13][5] = {
 	{ 2, 12, 9, 64, 0x35},
 	{ 1, 13, 9, 64, 0x44},
@@ -73,12 +62,10 @@ void     XGINew_SetDRAMSize_340(struct xgi_hw_device_info *, struct vb_device_in
 void     XGINew_SetDRAMSize_310(struct xgi_hw_device_info *, struct vb_device_info *);
 void     XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *);
 void     XGINew_SetDRAMModeRegister(struct vb_device_info *);
-void     XGINew_SetDRAMModeRegister340(struct xgi_hw_device_info *HwDeviceExtension);
 void XGINew_SetDRAMDefaultRegister340(struct xgi_hw_device_info *HwDeviceExtension,
 				      unsigned long, struct vb_device_info *);
 unsigned char XGINew_GetXG20DRAMType(struct xgi_hw_device_info *HwDeviceExtension,
 				     struct vb_device_info *pVBInfo);
-unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension);
 
 int      XGINew_DDRSizing340(struct xgi_hw_device_info *, struct vb_device_info *);
 void     XGINew_DisableRefresh(struct xgi_hw_device_info *, struct vb_device_info *) ;
@@ -87,19 +74,11 @@ int      XGINew_SDRSizing(struct vb_device_info *);
 int      XGINew_DDRSizing(struct vb_device_info *);
 void     XGINew_EnableRefresh(struct xgi_hw_device_info *, struct vb_device_info *);
 static int      XGINew_RAMType;		/*int      ModeIDOffset,StandTable,CRT1Table,ScreenOffset,REFIndex;*/
-#if 0
-static unsigned long	 UNIROM;
-#endif
-unsigned char  ChkLFB(struct vb_device_info *);
-void     XGINew_Delay15us(unsigned long);
 void     SetPowerConsume(struct xgi_hw_device_info *HwDeviceExtension,
 			 unsigned long XGI_P3d4Port);
 void     ReadVBIOSTablData(unsigned char ChipType, struct vb_device_info *pVBInfo);
 void     XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVBInfo);
-void     XGINew_SetDRAMModeRegister_XG20(struct xgi_hw_device_info *HwDeviceExtension);
-void     XGINew_SetDRAMModeRegister_XG27(struct xgi_hw_device_info *HwDeviceExtension);
 void     XGINew_ChkSenseStatus(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-void     XGINew_SetModeScratch(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
 void     XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
 unsigned char    GetXG21FPBits(struct vb_device_info *pVBInfo);
 void     XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo) ;
-- 
1.5.6.5

