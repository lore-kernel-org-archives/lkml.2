Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab1D3Pod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:44:33 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34563 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1D3Poa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:44:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgGABcuvE1bdWOb/2dsb2JhbACYUY49wXSGAASOeY4k
X-IronPort-AV: E=Sophos;i="4.64,293,1301868000"; 
   d="scan'208";a="835750729"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@suse.de
Cc: wuzhangjin@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 2/2] staging: sm7xx: minor cleanup
Date: Sat, 30 Apr 2011 17:44:26 +0200
Message-Id: <1304178266-10161-2-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1304178266-10161-1-git-send-email-jmunhoz@igalia.com>
References: <1304178266-10161-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sync code comments with TODO, fix some style and format issues

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/TODO     |    1 -
 drivers/staging/sm7xx/smtcfb.c |   16 ++++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/sm7xx/TODO b/drivers/staging/sm7xx/TODO
index a66d9e4..b0f5318 100644
--- a/drivers/staging/sm7xx/TODO
+++ b/drivers/staging/sm7xx/TODO
@@ -2,7 +2,6 @@ TODO:
 - Dual head support
 - 2D acceleration support
 - use kernel coding style
-- checkpatch.pl clean
 - refine the code and remove unused code
 - use kernel framebuffer mode setting instead of hard code
 - move it to drivers/video/sm7xx/ or make it be drivers/video/sm7xxfb.c
diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index 976a080..c0d943f 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -14,15 +14,15 @@
  *
  * Version 0.10.26192.21.01
  *	- Add PowerPC/Big endian support
- *	- Add 2D support for Lynx
- *	- Verified on2.6.19.2  Boyod.yang <boyod.yang@siliconmotion.com.cn>
+ *	- Verified on 2.6.19.2
+ *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  *
  * Version 0.09.2621.00.01
- *	- Only support Linux Kernel's version 2.6.21.
- *	Boyod.yang  <boyod.yang@siliconmotion.com.cn>
+ *	- Only support Linux Kernel's version 2.6.21
+ *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  *
  * Version 0.09
- *	- Only support Linux Kernel's version 2.6.12.
+ *	- Only support Linux Kernel's version 2.6.12
  *	Boyod.yang <boyod.yang@siliconmotion.com.cn>
  */
 
@@ -99,17 +99,17 @@ struct vesa_mode_table	{
 static struct vesa_mode_table vesa_mode[] = {
 	{"0x301", 640,  480,  8},
 	{"0x303", 800,  600,  8},
-	{"0x305", 1024, 768,	8},
+	{"0x305", 1024, 768,  8},
 	{"0x307", 1280, 1024, 8},
 
 	{"0x311", 640,  480,  16},
 	{"0x314", 800,  600,  16},
-	{"0x317", 1024, 768,	16},
+	{"0x317", 1024, 768,  16},
 	{"0x31A", 1280, 1024, 16},
 
 	{"0x312", 640,  480,  24},
 	{"0x315", 800,  600,  24},
-	{"0x318", 1024, 768,	24},
+	{"0x318", 1024, 768,  24},
 	{"0x31B", 1280, 1024, 24},
 };
 
-- 
1.7.4.1

