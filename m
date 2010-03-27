Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0C0Bup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:50:45 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:53567 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0C0Bt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nRaiEDQGviVMRYAeqORIMEqTkL2jH+UQKIyvO76jXBsedF49Z1IZuwzkrU4FuPDfRw
         IBqx7JXjUnmREGfwVM0x/L9F0nTIAi1J25qqkVLzO2+e3ON49Sz+Nq6WJCad2rbHsCkS
         hZcjuONQ7o1PDMxnwBgGbE/RZkIgH7VJQGiJI=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 7/9] Staging: comedi: cb_das16_cs: fixed multiple brace coding style issue
Date: Sat, 27 Mar 2010 09:48:41 +0800
Message-Id: <1269654523-2682-8-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple coding style issue

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index bc375e7..bf8271f 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -174,16 +174,16 @@ static int das16cs_attach(struct comedi_device *dev,
 	printk("I/O base=0x%04lx ", dev->iobase);
 
 	printk("fingerprint:\n");
-	for (i = 0; i < 48; i += 2) {
+	for (i = 0; i < 48; i += 2)
 		printk("%04x ", inw(dev->iobase + i));
-	}
+
 	printk("\n");
 
 	ret = request_irq(link->irq.AssignedIRQ, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
-	if (ret < 0) {
+	if (ret < 0)
 		return ret;
-	}
+
 	dev->irq = link->irq.AssignedIRQ;
 	printk("irq=%u ", dev->irq);
 
@@ -261,9 +261,9 @@ static int das16cs_detach(struct comedi_device *dev)
 {
 	printk("comedi%d: das16cs: remove\n", dev->minor);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
+
 
 	return 0;
 }
-- 
1.7.0.3

