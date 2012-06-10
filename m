Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2FJA6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 20:58:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25195 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2FJA6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 20:58:36 -0400
Date: Sun, 10 Jun 2012 02:58:34 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Jens Axboe <axboe@kernel.dk>, Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, trivial@kernel.org
Subject: [PATCH] mtip32xx: Remove unneeded version.h include in header
Message-ID: <alpine.LNX.2.00.1206100257130.15651@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/block/mtip32xx/mtip32xx.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index b2c88da..adb1aae 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -26,7 +26,6 @@
 #include <linux/ata.h>
 #include <linux/interrupt.h>
 #include <linux/genhd.h>
-#include <linux/version.h>
 
 /* Offset of Subsystem Device ID in pci confoguration space */
 #define PCI_SUBSYSTEM_DEVICEID	0x2E
-- 
1.7.10.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

