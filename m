Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1HKFKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:10:42 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42469 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1HKFKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:10:38 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix printk() issue in adv_pci1710.c
Date: Thu, 11 Aug 2011 10:55:10 +0530
Message-Id: <1313040310-10749-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix warning issue in adv_pci1710.c>
References: <[PATCH]Staging: comedi: fix warning issue in adv_pci1710.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the adv_pci1710.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 Converted printks to pr_<levels>
 drivers/staging/comedi/drivers/adv_pci1710.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index da2b75b..2ae98a7 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -925,14 +925,14 @@ static int pci171x_ai_docmd_and_mode(int mode, struct comedi_device *dev,
 */
 static void pci171x_cmdtest_out(int e, struct comedi_cmd *cmd)
 {
-	printk("adv_pci1710 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
-	       cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
-	printk("adv_pci1710 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
-	       cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
-	printk("adv_pci1710 e=%d stopsrc=%x scanend=%x\n", e, cmd->stop_src,
-	       cmd->scan_end_src);
-	printk("adv_pci1710 e=%d stoparg=%d scanendarg=%d chanlistlen=%d\n",
-	       e, cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
+	pr_debug("adv_pci1710 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
+			cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
+	pr_debug("adv_pci1710 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
+			cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
+	pr_debug("adv_pci1710 e=%d stopsrc=%x scanend=%x\n", e, cmd->stop_src,
+			cmd->scan_end_src);
+	pr_debug("adv_pci1710 e=%d stoparg=%d scanendarg=%d chanlistlen=%d\n",
+			e, cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
 }
 #endif
 
-- 
1.6.5.2

