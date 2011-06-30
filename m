Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1F3Jvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:51:33 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:32918 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490Ab1F3JvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:51:20 -0400
From: Felipe Balbi <balbi@ti.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/7] mfd: twl4030-irq: remove trailing whitespaces
Date: Thu, 30 Jun 2011 12:51:04 +0300
Message-Id: <1309427470-605-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309427470-605-1-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trivial patch, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 8a7ee31..7be97cb 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -620,7 +620,7 @@ static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
 
 static struct irq_chip twl4030_sih_irq_chip = {
 	.name		= "twl4030",
-	.irq_mask      	= twl4030_sih_mask,
+	.irq_mask	= twl4030_sih_mask,
 	.irq_unmask	= twl4030_sih_unmask,
 	.irq_set_type	= twl4030_sih_set_type,
 };
-- 
1.7.6

