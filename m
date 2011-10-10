Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1JJPXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:23:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50393 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1JJPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:23:32 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/4] staging: et131x: Remove unused mac defines
Date: Mon, 10 Oct 2011 16:22:09 +0100
Message-Id: <1318260129-2749-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unused defines from et1310_mac.c.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 042bc44..65179a3 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -89,17 +89,9 @@
 #include "et131x_adapter.h"
 #include "et131x.h"
 
-
-#define COUNTER_WRAP_28_BIT 0x10000000
-#define COUNTER_WRAP_22_BIT 0x400000
 #define COUNTER_WRAP_16_BIT 0x10000
 #define COUNTER_WRAP_12_BIT 0x1000
 
-#define COUNTER_MASK_28_BIT (COUNTER_WRAP_28_BIT - 1)
-#define COUNTER_MASK_22_BIT (COUNTER_WRAP_22_BIT - 1)
-#define COUNTER_MASK_16_BIT (COUNTER_WRAP_16_BIT - 1)
-#define COUNTER_MASK_12_BIT (COUNTER_WRAP_12_BIT - 1)
-
 /**
  * et1310_config_mac_regs1 - Initialize the first part of MAC regs
  * @adapter: pointer to our adapter structure
-- 
1.7.6.4

