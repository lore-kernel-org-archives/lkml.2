Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1JTGUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:20:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38039 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1JTGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:20:36 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 7/24] Staging: comedi: fix printk issue in ni_labpc_cs.c
Date: Thu, 20 Oct 2011 11:48:53 +0530
Message-Id: <1319091550-2558-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
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
+		pr_err("bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
-- 
1.7.6.4

