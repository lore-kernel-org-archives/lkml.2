Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0GRWFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 18:05:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50301 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab0GRWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 18:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lH7ghJ5ZywWyUmugtiZJWwdUOJDSYtQFiASMU6AJ/iUDtSLTbJDYMpiMdpTUvcyx7u
         lIbaxq+5nBMSYtBZ7z6iIl0A9Z6wyQyqQESO6kd+OfZsqTkNgehc/G2/+kfe4EaXiUFB
         l6vVRHkPLM1aay2X9Hk4T8c8VbWqQfUJulRbw=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Niadh <neilmunro@gmail.com>
Subject: [PATCH 631/631] Staging: RT2860: Cleaned all bar one in chlist.h
Date: Sun, 18 Jul 2010 23:09:37 +0100
Message-Id: <1279490977-14418-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

I have cleaned all errors and all bar one warning in chlist.h. The remaining warning is a line over 80 characters warning.
Breaking it doesnt look all that easy.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/chlist.h |   50 ++++++++++++++++++---------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rt2860/chlist.h b/drivers/staging/rt2860/chlist.h
index ada65e5..1231e69 100644
--- a/drivers/staging/rt2860/chlist.h
+++ b/drivers/staging/rt2860/chlist.h
@@ -73,35 +73,31 @@ struct rt_ch_freq_map {
 extern struct rt_ch_freq_map CH_HZ_ID_MAP[];
 extern int CH_HZ_ID_MAP_NUM;
 
-#define     MAP_CHANNEL_ID_TO_KHZ(_ch, _khz)					\
-		do{													\
-			int _chIdx;											\
-			for (_chIdx = 0; _chIdx < CH_HZ_ID_MAP_NUM; _chIdx++)\
-			{													\
-				if ((_ch) == CH_HZ_ID_MAP[_chIdx].channel)			\
-				{												\
-					(_khz) = CH_HZ_ID_MAP[_chIdx].freqKHz * 1000;	\
-					break;										\
-				}												\
-			}													\
-			if (_chIdx == CH_HZ_ID_MAP_NUM)					\
-				(_khz) = 2412000;									\
-            }while(0)
+#define     MAP_CHANNEL_ID_TO_KHZ(_ch, _khz)		\
+		do {							\
+			int _chIdx;					\
+			for (_chIdx = 0; _chIdx < CH_HZ_ID_MAP_NUM; _chIdx++) {\
+				if ((_ch) == CH_HZ_ID_MAP[_chIdx].channel) { \
+					(_khz) = CH_HZ_ID_MAP[_chIdx].freqKHz * 1000;\
+					break;				\
+				}					\
+			}						\
+			if (_chIdx == CH_HZ_ID_MAP_NUM)	\
+				(_khz) = 2412000;		\
+		} while (0)
 
 #define     MAP_KHZ_TO_CHANNEL_ID(_khz, _ch)                 \
-		do{													\
-			int _chIdx;											\
-			for (_chIdx = 0; _chIdx < CH_HZ_ID_MAP_NUM; _chIdx++)\
-			{													\
-				if ((_khz) == CH_HZ_ID_MAP[_chIdx].freqKHz)			\
-				{												\
-					(_ch) = CH_HZ_ID_MAP[_chIdx].channel;			\
-					break;										\
-				}												\
-			}													\
-			if (_chIdx == CH_HZ_ID_MAP_NUM)					\
-				(_ch) = 1;											\
-		}while(0)
+		do {							\
+			int _chIdx;				\
+			for (_chIdx = 0; _chIdx < CH_HZ_ID_MAP_NUM; _chIdx++) {\
+				if ((_khz) == CH_HZ_ID_MAP[_chIdx].freqKHz) {\
+					(_ch) = CH_HZ_ID_MAP[_chIdx].channel; \
+					break;			\
+				}					\
+			}						\
+			if (_chIdx == CH_HZ_ID_MAP_NUM)			\
+				(_ch) = 1;				\
+		} while (0)
 
 void BuildChannelListEx(struct rt_rtmp_adapter *pAd);
 
-- 
1.7.1.1

