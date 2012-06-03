Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2FCQ0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 12:26:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34502 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2FCQ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 12:26:35 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, asamymuthupa@micron.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH] mtip32xx: Remove version.h header file inclusion
Date: Sun,  3 Jun 2012 21:56:21 +0530
Message-Id: <1338740781-10918-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

version.h header file inclusion is no longer required.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/block/mtip32xx/mtip32xx.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
1.7.5.4

