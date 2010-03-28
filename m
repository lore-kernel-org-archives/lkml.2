Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0C1FMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 01:12:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38323 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0C1FMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 01:12:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZddCwg4wBW3QkY3ajK4ToZ/NEGBegMN3XA0p22Dn+Bydo9A6VirgmRc8nBRFF4cnWb
         QgxA5Yodmy86o3v356UeGRCj8VvaPkKnWv2b+1kkkGdZPmKU5PRg0HIIFKiTOW4Q44iL
         WOpKDv+sOIt7S+nx2n40cR3J7UUxET9Qsq7Tk=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH] Staging: sm7xx: Fixed coding style issues.
Date: Sun, 28 Mar 2010 16:31:15 +1100
Message-Id: <1269754275-12614-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of tabs before spaces and some other minor issues.
Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/sm7xx/smtcfb.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 9c82a1a..1cc86ae 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2006 Silicon Motion Technology Corp.
  * Authors: Ge Wang, gewang@siliconmotion.com
- * 	    Boyod boyod.yang@siliconmotion.com.cn
+ *          Boyod boyod.yang@siliconmotion.com.cn
  *
  * Copyright (C) 2009 Lemote, Inc.
  * Author: Wu Zhangjin, wuzhangjin@gmail.com
@@ -13,17 +13,17 @@
  *  more details.
  *
  * Version 0.10.26192.21.01
- * 	- Add PowerPC/Big endian support
- * 	- Add 2D support for Lynx
- * 	- Verified on2.6.19.2  Boyod.yang <boyod.yang@siliconmotion.com.cn>
+ *     - Add PowerPC/Big endian support
+ *     - Add 2D support for Lynx
+ *     - Verified on2.6.19.2  Boyod.yang <boyod.yang@siliconmotion.com.cn>
  *
  * Version 0.09.2621.00.01
- * 	- Only support Linux Kernel's version 2.6.21.
- *	Boyod.yang  <boyod.yang@siliconmotion.com.cn>
+ *     - Only support Linux Kernel's version 2.6.21.
+ *       Boyod.yang  <boyod.yang@siliconmotion.com.cn>
  *
  * Version 0.09
- * 	- Only support Linux Kernel's version 2.6.12.
- * 	Boyod.yang <boyod.yang@siliconmotion.com.cn>
+ *     - Only support Linux Kernel's version 2.6.12.
+ *       Boyod.yang <boyod.yang@siliconmotion.com.cn>
  */
 
 #ifndef __KERNEL__
-- 
1.6.3.3

