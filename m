Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab2FZEBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:01:20 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:48179 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726Ab2FZEAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:00:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAM8y6U9bdWOb/2dsb2JhbABEtiyBB4IYAQEFeRAgMTwbBxKID7kkkTcDlS6QAYJh
X-IronPort-AV: E=Sophos;i="4.77,476,1336341600"; 
   d="scan'208";a="532687843"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 1/4] staging: sm7xxfb: dead code removal
Date: Tue, 26 Jun 2012 06:00:14 +0200
Message-Id: <1340683217-7986-2-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
References: <1340683217-7986-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch removes dead code.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xx.h   |    1 -
 drivers/staging/sm7xxfb/sm7xxfb.c |    4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xx.h b/drivers/staging/sm7xxfb/sm7xx.h
index 43d86f8..333f33c 100644
--- a/drivers/staging/sm7xxfb/sm7xx.h
+++ b/drivers/staging/sm7xxfb/sm7xx.h
@@ -14,7 +14,6 @@
  */
 
 #define NR_PALETTE        256
-#define NR_RGB            2
 
 #define FB_ACCEL_SMI_LYNX 88
 
diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 21dab34..a8c5652 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -42,10 +42,6 @@ struct screen_info smtc_screen_info;
 struct smtcfb_info {
 	struct fb_info fb;
 	struct pci_dev *pdev;
-	struct {
-		u8 red, green, blue;
-	} palette[NR_RGB];
-	u_int palette_size;
 
 	u16 chipID;
 	unsigned char __iomem *m_pMMIO;
-- 
1.7.10

