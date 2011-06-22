Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab1FVSlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:41:46 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:47564 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758244Ab1FVSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:41:44 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [9/15] staging: ft1000-pcmcia: delete unused APP_INFO_BLOCK typedefs
Date: Wed, 22 Jun 2011 20:41:35 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222041.37476.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused APP_INFO_BLOCK typedefs and associated variables.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -281,8 +281,6 @@ struct pseudo_hdr
 #define  TRUE                   0x1
 #define  FALSE                  0x0
 
-#define  MAX_NUM_APP            6
-
 #define MAXIMUM_ASIC_HB_CNT      15
 
 struct drv_msg {
@@ -317,12 +315,6 @@ struct dsp_init_msg {
     u8 RfCalDate[CALDATESZ];    // Rf Calibration date
 } __attribute__ ((packed));
 
-typedef struct _APP_INFO_BLOCK
-{
-    u32 fileobject;                // Application's file object
-    u16 app_id;                    // Application id
-} APP_INFO_BLOCK, *PAPP_INFO_BLOCK;
-
 typedef struct _PROV_RECORD {
     struct list_head list;
     u8 *pprov_data;
@@ -365,8 +357,6 @@ typedef struct _FT1000_INFO {
     u8 RfCalDate[CALDATESZ];
     u16 DSP_TIME[4];
     struct list_head prov_list;
-    int appcnt;
-    APP_INFO_BLOCK app_info[MAX_NUM_APP];
     u16 DSPInfoBlklen;
     u16 DrvMsgPend;
 	int (*ft1000_reset)(void *);

-- 
Ondrej Zary
