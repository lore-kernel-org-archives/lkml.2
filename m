Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0FIXPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:15:55 -0400
Received: from www.tglx.de ([62.245.132.106]:55001 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0FIXPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:15:54 -0400
Date: Thu, 10 Jun 2010 01:15:49 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>, Greg KH <gregkh@suse.de>
Subject: [PATCH 2/3] uio: Remove IRQF_DISABLED from uio_sercos3.c
Message-ID: <20100609231549.GD2555@local>
References: <20100609230841.GB2555@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609230841.GB2555@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove IRQF_DISABLED since it is deprecated and a no-op in the
current kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
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
1.7.0

