Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1F3WEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:04:24 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34232 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752252Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/28] staging: ft1000-pcmcia: delete unused APP_INFO_BLOCK typedefs
Date: Fri,  1 Jul 2011 00:03:40 +0200
Message-Id: <1309471437-12633-12-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused APP_INFO_BLOCK typedefs and associated variables.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index ecead81..b3aefd8 100644
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

