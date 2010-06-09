Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0FIXMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:12:39 -0400
Received: from www.tglx.de ([62.245.132.106]:43443 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab0FIXMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:12:38 -0400
Date: Thu, 10 Jun 2010 01:12:32 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
Subject: [PATCH 1/3] uio: Remove IRQF_DISABLED flag from uio_pdrv_genirq.c
Message-ID: <20100609231232.GC2555@local>
References: <20100609230841.GB2555@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609230841.GB2555@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove IRQF_DISABLED flag since it is deprecated and a no-op in the
current kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 drivers/uio/uio_pdrv_genirq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 61e569d..7174d51 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -155,7 +155,6 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	 * Interrupt sharing is not supported.
 	 */
 
-	uioinfo->irq_flags |= IRQF_DISABLED;
 	uioinfo->handler = uio_pdrv_genirq_handler;
 	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
 	uioinfo->open = uio_pdrv_genirq_open;
-- 
1.7.0

