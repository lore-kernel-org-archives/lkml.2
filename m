Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2LJXW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:22:29 -0500
Received: from wren.arvixe.com ([50.97.138.99]:55615 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab2LJXW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:22:28 -0500
From: Przemo Firszt <przemo@firszt.eu>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 2/9] rtl8712: remove unused macros from rtl8712/wifi.h
Date: Mon, 10 Dec 2012 23:21:20 +0000
Message-Id: <1355181685-4444-2-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
References: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those definitions are not used anywhere in the kernel. If you know any
reason why they should stay in the code please speak up!

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/wifi.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8712/wifi.h b/drivers/staging/rtl8712/wifi.h
index c08ed2a..73d7cd2 100644
--- a/drivers/staging/rtl8712/wifi.h
+++ b/drivers/staging/rtl8712/wifi.h
@@ -437,11 +437,7 @@ static inline unsigned char *get_hdr_bssid(unsigned char *pframe)
 #define _SSID_IE_		0
 #define _SUPPORTEDRATES_IE_	1
 #define _DSSET_IE_		3
-#define _TIM_IE_		5
 #define _IBSS_PARA_IE_		6
-#define _CHLGETXT_IE_		16
-#define _RSN_IE_2_		48`
-#define _SSN_IE_1_		221
 #define _ERPINFO_IE_		42
 #define _EXT_SUPPORTEDRATES_IE_	50
 
-- 
1.8.0.1

