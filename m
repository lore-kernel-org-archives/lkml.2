Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0C2RqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:46:16 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:55352 "EHLO
	smtp3.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab0C2RqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:46:14 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2010 13:46:14 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0GAIRzdkpbdWOb/2dsb2JhbACBNhzOLIQYBQ
X-IronPort-AV: E=Sophos;i="4.51,329,1267398000"; 
   d="scan'208";a="208581592"
From: =?utf-8?q?Javier=20Mu=C3=B1oz=20Mellid?= <jmunhoz@igalia.com>
To: gregkh@suse.de, teddy.wang@siliconmotion.com.cn
Cc: wuzhangjin@gmail.com, sbraun@emlix.com, ralf@linux-mips.org,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       =?UTF-8?q?Javier=20Mu=C3=B1oz=20Mellid?= <jmunhoz@igalia.com>
Subject: [PATCH] Staging: sm7xx: Fixed coding style issues
Date: Mon, 29 Mar 2010 19:35:24 +0200
Message-Id: <1269884124-32520-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.5.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some style and format issues

Signed-off-by: Javier Muñoz Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |   17 +++++++++--------
 drivers/staging/sm7xx/smtcfb.h |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 9c82a1a..5f8d373 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2006 Silicon Motion Technology Corp.
  * Authors: Ge Wang, gewang@siliconmotion.com
- * 	    Boyod boyod.yang@siliconmotion.com.cn
+ *	    Boyod boyod.yang@siliconmotion.com.cn
  *
  * Copyright (C) 2009 Lemote, Inc.
  * Author: Wu Zhangjin, wuzhangjin@gmail.com
@@ -13,17 +13,18 @@
  *  more details.
  *
  * Version 0.10.26192.21.01
- * 	- Add PowerPC/Big endian support
- * 	- Add 2D support for Lynx
- * 	- Verified on2.6.19.2  Boyod.yang <boyod.yang@siliconmotion.com.cn>
+ *	- Add PowerPC/Big endian support
+ *	- Add 2D support for Lynx
+ *	- Verified on 2.6.19.2
+ *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  *
  * Version 0.09.2621.00.01
- * 	- Only support Linux Kernel's version 2.6.21.
- *	Boyod.yang  <boyod.yang@siliconmotion.com.cn>
+ *	- Only support Linux Kernel's version 2.6.21
+ *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  *
  * Version 0.09
- * 	- Only support Linux Kernel's version 2.6.12.
- * 	Boyod.yang <boyod.yang@siliconmotion.com.cn>
+ *	- Only support Linux Kernel's version 2.6.12
+ *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  */
 
 #ifndef __KERNEL__
diff --git a/drivers/staging/sm7xx/smtcfb.h b/drivers/staging/sm7xx/smtcfb.h
index 7ee565c..0c11383 100644
--- a/drivers/staging/sm7xx/smtcfb.h
+++ b/drivers/staging/sm7xx/smtcfb.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2006 Silicon Motion Technology Corp.
  * Authors:	Ge Wang, gewang@siliconmotion.com
- *	 	Boyod boyod.yang@siliconmotion.com.cn
+ *		Boyod boyod.yang@siliconmotion.com.cn
  *
  * Copyright (C) 2009 Lemote, Inc.
  * Author: Wu Zhangjin, wuzhangjin@gmail.com
-- 
1.7.0.3

