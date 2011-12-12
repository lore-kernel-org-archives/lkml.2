Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1LLHXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:23:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36721 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1LLHXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:23:01 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 30/30] Staging: comedi: fix printk issue in jr3_pci.c
Date: Mon, 12 Dec 2011 12:52:19 +0530
Message-Id: <1323674539-19307-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the jr3_pci.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Added KERN_facility levels for printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/jr3_pci.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 2a97894..6a79ba1 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -593,24 +593,24 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 					min_full_scale =
 					    get_min_full_scales(channel);
 					printk("Obtained Min. Full Scales:\n");
-					printk("%i   ", (min_full_scale).fx);
-					printk("%i   ", (min_full_scale).fy);
-					printk("%i   ", (min_full_scale).fz);
-					printk("%i   ", (min_full_scale).mx);
-					printk("%i   ", (min_full_scale).my);
-					printk("%i   ", (min_full_scale).mz);
-					printk("\n");
+					printk(KERN_DEBUG "%i ", (min_full_scale).fx);
+					printk(KERN_CONT "%i ", (min_full_scale).fy);
+					printk(KERN_CONT "%i ", (min_full_scale).fz);
+					printk(KERN_CONT "%i ", (min_full_scale).mx);
+					printk(KERN_CONT "%i ", (min_full_scale).my);
+					printk(KERN_CONT "%i ", (min_full_scale).mz);
+					printk(KERN_CONT "\n");
 
 					max_full_scale =
 					    get_max_full_scales(channel);
 					printk("Obtained Max. Full Scales:\n");
-					printk("%i   ", (max_full_scale).fx);
-					printk("%i   ", (max_full_scale).fy);
-					printk("%i   ", (max_full_scale).fz);
-					printk("%i   ", (max_full_scale).mx);
-					printk("%i   ", (max_full_scale).my);
-					printk("%i   ", (max_full_scale).mz);
-					printk("\n");
+					printk(KERN_DEBUG "%i ", (max_full_scale).fx);
+					printk(KERN_CONT "%i ", (max_full_scale).fy);
+					printk(KERN_CONT "%i ", (max_full_scale).fz);
+					printk(KERN_CONT "%i ", (max_full_scale).mx);
+					printk(KERN_CONT "%i ", (max_full_scale).my);
+					printk(KERN_CONT "%i ", (max_full_scale).mz);
+					printk(KERN_CONT "\n");
 
 					set_full_scales(channel,
 							max_full_scale);
-- 
1.7.0.4

