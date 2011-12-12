Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1LLFUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1LLFUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:03 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 02/29] Staging: comedi: fix printk issue in dt3000.c
Date: Mon, 12 Dec 2011 10:49:14 +0530
Message-Id: <1323667181-17252-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the dt3000.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Added KERN_facility levels.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt3000.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index f9c16c9..8347bac 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -430,12 +430,12 @@ static char *intr_flags[] = {
 static void debug_intr_flags(unsigned int flags)
 {
 	int i;
-	printk("dt3k: intr_flags:");
+	printk(KERN_DEBUG "dt3k: intr_flags:");
 	for (i = 0; i < 8; i++) {
 		if (flags & (1 << i))
-			printk(" %s", intr_flags[i]);
+			printk(KERN_CONT " %s", intr_flags[i]);
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 #endif
 
-- 
1.7.0.4

