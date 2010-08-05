Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677Ab0HEWkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:40:06 -0400
Received: from kroah.org ([198.145.64.141]:37688 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760841Ab0HEWYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/28] uio: Remove IRQF_DISABLED from uio_sercos3.c
Date: Thu,  5 Aug 2010 15:23:52 -0700
Message-Id: <1281047058-23716-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

Remove IRQF_DISABLED since it is deprecated and a no-op in the
current kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Acked-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_sercos3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 3d461cd..a187fa1 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -154,7 +154,7 @@ static int __devinit sercos3_pci_probe(struct pci_dev *dev,
 	info->name = "Sercos_III_PCI";
 	info->version = "0.0.1";
 	info->irq = dev->irq;
-	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->irq_flags = IRQF_SHARED;
 	info->handler = sercos3_handler;
 	info->irqcontrol = sercos3_irqcontrol;
 
-- 
1.7.2

