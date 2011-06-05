Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1FER1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:27:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab1FER1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:27:33 -0400
From: "Ken O'Brien" <kernel@kenobrien.org>
To: gregkh@suse.de
Cc: mikem@ring3k.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH 3/3] Staging: rtl8192e: Fixed numerous coding style issues
Date: Sun,  5 Jun 2011 18:24:33 +0100
Message-Id: <1307294673-26210-2-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307294673-26210-1-git-send-email-kernel@kenobrien.org>
References: <1307294673-26210-1-git-send-email-kernel@kenobrien.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all coding style issues thrown by checkpatch.pl.

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/rtl8192e/dot11d.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192e/dot11d.h b/drivers/staging/rtl8192e/dot11d.h
index 3785fdf..8e64461 100644
--- a/drivers/staging/rtl8192e/dot11d.h
+++ b/drivers/staging/rtl8192e/dot11d.h
@@ -4,17 +4,17 @@
 #ifdef ENABLE_DOT11D
 #include "ieee80211.h"
 
-typedef struct _CHNL_TXPOWER_TRIPLE {
+struct _CHNL_TXPOWER_TRIPLE {
 	u8 FirstChnl;
 	u8  NumChnls;
 	u8  MaxTxPowerInDbm;
-} CHNL_TXPOWER_TRIPLE, *PCHNL_TXPOWER_TRIPLE;
+};
 
-typedef enum _DOT11D_STATE {
+enum _DOT11D_STATE {
 	DOT11D_STATE_NONE = 0,
 	DOT11D_STATE_LEARNED,
 	DOT11D_STATE_DONE,
-} DOT11D_STATE;
+};
 
 /**
  * struct _RT_DOT11D_INFO
@@ -27,7 +27,7 @@ typedef enum _DOT11D_STATE {
  * @CountryIeSrcAddr - Source AP of the country IE
  */
 
-typedef struct _RT_DOT11D_INFO {
+struct _RT_DOT11D_INFO {
 	bool bEnabled;
 
 	u16 CountryIeLen;
@@ -39,7 +39,7 @@ typedef struct _RT_DOT11D_INFO {
 	u8 MaxTxPwrDbmList[MAX_CHANNEL_NUMBER+1];
 
 	DOT11D_STATE State;
-} RT_DOT11D_INFO, *PRT_DOT11D_INFO;
+};
 
 static inline void cpMacAddr(unsigned char *des, unsigned char *src)
 {
-- 
1.7.4.1

