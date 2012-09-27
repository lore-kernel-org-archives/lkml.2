Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2I0N7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:59:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37481 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2I0N7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:59:43 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/3] staging/sbe-2t3e3: Use netdev_ printks in cpld.c
Date: Thu, 27 Sep 2012 22:59:34 +0900
Message-Id: <1348754374-5056-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
References: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/sbe-2t3e3/cpld.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sbe-2t3e3/cpld.c b/drivers/staging/sbe-2t3e3/cpld.c
index cc2b54d..27365f9 100644
--- a/drivers/staging/sbe-2t3e3/cpld.c
+++ b/drivers/staging/sbe-2t3e3/cpld.c
@@ -338,7 +338,7 @@ void cpld_set_fractional_mode(struct channel *sc, u32 mode,
 			   SBE_2T3E3_CPLD_VAL_FRACTIONAL_MODE_2);
 		break;
 	default:
-		printk(KERN_ERR "wrong mode in set_fractional_mode\n");
+		netdev_err(sc->dev, "wrong mode in set_fractional_mode\n");
 		return;
 	}
 
-- 
1.7.9.5

