Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1JMNtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:49:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54173 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1JMNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:48:59 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 7/7] Staging: comedi: fix printk issue in ni_labpc_cs.c
Date: Thu, 13 Oct 2011 19:18:13 +0530
Message-Id: <1318513693-4213-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc_cs.c file that fixes up a printk warning
found by the checkpatch.pl tool.
converted printk to pr_<level>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_labpc_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index 832a517..49f004c 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -145,7 +145,7 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		irq = link->irq;
 		break;
 	default:
-		printk("bug! couldn't determine board type\n");
+		pr_warn("bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
-- 
1.7.6.4

