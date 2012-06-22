Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050Ab2FVNAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:00:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40487 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761946Ab2FVNAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:00:32 -0400
From: Daniel Lawrence <daniel@danielscottlawrence.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
Cc: hsweeten@visionengravers.com, daniel@danielscottlawrence.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fixed print_k coding style issue in acl7225b.c
Date: Fri, 22 Jun 2012 23:00:20 +1000
Message-Id: <1340370020-9662-1-git-send-email-daniel@danielscottlawrence.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the acl7225b.c file that fixes up 2 print_k warnings
found by the checkpatch.pl tool.

Signed-off-by: Daniel Lawrence <daniel@danielscottlawrence.com>
---
 drivers/staging/comedi/drivers/acl7225b.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index 4e4fc41..5392358 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -72,10 +72,10 @@ static int acl7225b_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 	iorange = this_board->io_range;
-	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
+	pr_info("comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
 	       this_board->name, iobase);
 	if (!request_region(iobase, iorange, "acl7225b")) {
-		printk(KERN_ERR "comedi%d: request_region failed - I/O port conflict\n",
+		pr_err("comedi%d: request_region failed - I/O port conflict\n",
 			dev->minor);
 		return -EIO;
 	}
-- 
1.7.9.5

