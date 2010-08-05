Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664Ab0HEWlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:41:00 -0400
Received: from kroah.org ([198.145.64.141]:37682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760836Ab0HEWYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/28] uio: Remove IRQF_DISABLED flag from uio_pdrv_genirq.c
Date: Thu,  5 Aug 2010 15:23:51 -0700
Message-Id: <1281047058-23716-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@linutronix.de>

Remove IRQF_DISABLED flag since it is deprecated and a no-op in the
current kernel.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

