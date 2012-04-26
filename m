Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2DZSqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:46:35 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:31178 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab2DZSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQUnUhBRPBsHEogRuniQZQSVfZBAgmo
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960577"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 6/7] staging: sm7xx: remove driver version support
Date: Thu, 26 Apr 2012 20:45:54 +0200
Message-Id: <1335465955-32057-7-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes non used version support. Code won't show version
message almost 4 years old.

Tested with SM712

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |    3 +--
 drivers/staging/sm7xx/smtcfb.h |    2 --
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 5defdaf..83756a8 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -821,8 +821,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	int err;
 	unsigned long pFramebufferPhysical;
 
-	dev_info(&pdev->dev,
-		 "Silicon Motion display driver " SMTC_LINUX_FB_VERSION);
+	dev_info(&pdev->dev, "Silicon Motion display driver.");
 
 	err = pci_enable_device(pdev);	/* enable SMTC chip */
 	if (err)
diff --git a/drivers/staging/sm7xx/smtcfb.h b/drivers/staging/sm7xx/smtcfb.h
index 70283a1..43d86f8 100644
--- a/drivers/staging/sm7xx/smtcfb.h
+++ b/drivers/staging/sm7xx/smtcfb.h
@@ -13,8 +13,6 @@
  *  more details.
  */
 
-#define SMTC_LINUX_FB_VERSION	"version 0.11.2619.21.01 July 27, 2008"
-
 #define NR_PALETTE        256
 #define NR_RGB            2
 
-- 
1.7.2.5

