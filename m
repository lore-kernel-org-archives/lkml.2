Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2FFOcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:32:07 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56034 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754788Ab2FFOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:32:05 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 10:32:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAMFmz09bdWOb/2dsb2JhbABFhU6uZ4EHgkIPAUY1AiYCYBKID6RJkmCBI458gRIDlR2PeoJi
X-IronPort-AV: E=Sophos;i="4.75,724,1330902000"; 
   d="scan'208";a="999999518"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 1/4] Staging: xgifb: Remove #ifdef MODULE
Date: Wed,  6 Jun 2012 16:22:04 +0200
Message-Id: <1338992527-5659-1-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for MODULE is not needed. In a static compilation the parameters
definition is valid and module_exit() does nothing.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 85dbf32..61dc7cb 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2325,8 +2325,6 @@ module_init(xgifb_init);
 /*                      MODULE                       */
 /*****************************************************/
 
-#ifdef MODULE
-
 MODULE_DESCRIPTION("Z7 Z9 Z9S Z11 framebuffer device driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("XGITECH , Others");
@@ -2359,5 +2357,3 @@ static void __exit xgifb_remove_module(void)
 }
 
 module_exit(xgifb_remove_module);
-
-#endif	/*  /MODULE  */
-- 
1.7.9.5

