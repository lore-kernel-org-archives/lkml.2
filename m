Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab1FER1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:27:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1FER1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:27:02 -0400
From: "Ken O'Brien" <kernel@kenobrien.org>
To: gregkh@suse.de
Cc: mikem@ring3k.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH 2/3] Staging: rtl8192e: Fixed numerous coding style issues
Date: Sun,  5 Jun 2011 18:24:32 +0100
Message-Id: <1307294673-26210-1-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style review: fixed all warnings, and all but three
typedef errors.

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/rtl8192e/dot11d.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192e/dot11d.h b/drivers/staging/rtl8192e/dot11d.h
index 106ebcf..3785fdf 100644
--- a/drivers/staging/rtl8192e/dot11d.h
+++ b/drivers/staging/rtl8192e/dot11d.h
@@ -19,11 +19,11 @@ typedef enum _DOT11D_STATE {
 /**
  * struct _RT_DOT11D_INFO
  * @CountryIeLen: value greater than 0 if @CountryIeBuf contains
- * 	          valid country information element.
+ *		  valid country information element.
  * @chanell_map: holds channel values
  *		0 - invalid,
  *		1 - valid (active scan),
- *	 	2 - valid (passive scan)
+ *		2 - valid (passive scan)
  * @CountryIeSrcAddr - Source AP of the country IE
  */
 
@@ -49,7 +49,7 @@ static inline void cpMacAddr(unsigned char *des, unsigned char *src)
 #define GET_DOT11D_INFO(__pIeeeDev) ((PRT_DOT11D_INFO) \
 			((__pIeeeDev)->pDot11dInfo))
 
-#define IS_DOT11D_ENABLE(__pIeeeDev) GET_DOT11D_INFO(__pIeeeDev)->bEnabled
+#define IS_DOT11D_ENABLE(__pIeeeDev) (GET_DOT11D_INFO(__pIeeeDev)->bEnabled)
 #define IS_COUNTRY_IE_VALID(__pIeeeDev) \
 			(GET_DOT11D_INFO(__pIeeeDev)->CountryIeLen > 0)
 
@@ -66,9 +66,10 @@ static inline void cpMacAddr(unsigned char *des, unsigned char *src)
 	(__Ie).Octet, (__Ie).Length)))
 
 #define CIE_WATCHDOG_TH 1
-#define GET_CIE_WATCHDOG(__pIeeeDev) GET_DOT11D_INFO(__pIeeeDev)->CountryIeWatchdog
+#define GET_CIE_WATCHDOG(__pIeeeDev) (GET_DOT11D_INFO(__pIeeeDev)-> \
+							CountryIeWatchdog)
 #define RESET_CIE_WATCHDOG(__pIeeeDev) GET_CIE_WATCHDOG(__pIeeeDev) = 0
-#define UPDATE_CIE_WATCHDOG(__pIeeeDev) ++GET_CIE_WATCHDOG(__pIeeeDev)
+#define UPDATE_CIE_WATCHDOG(__pIeeeDev) (++GET_CIE_WATCHDOG(__pIeeeDev))
 
 #define IS_DOT11D_STATE_DONE(__pIeeeDev) \
 		(GET_DOT11D_INFO(__pIeeeDev)->State == DOT11D_STATE_DONE)
-- 
1.7.4.1

