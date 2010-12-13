Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0LMMbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:12 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36155 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0LMMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:09 -0500
Date: Mon, 13 Dec 2010 13:31:08 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/20] mfd: tc35892: irq_data conversion.
Message-ID: <20101213123108.GW15575@mail.wantstofly.org>
References: <cover.1292241952.git.buytenh@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292241952.git.buytenh@wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/mfd/tc35892.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tc35892.c b/drivers/mfd/tc35892.c
index e619e2a..797bb5a 100644
--- a/drivers/mfd/tc35892.c
+++ b/drivers/mfd/tc35892.c
@@ -163,15 +163,15 @@ static irqreturn_t tc35892_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void tc35892_irq_dummy(unsigned int irq)
+static void tc35892_irq_dummy(struct irq_data *d)
 {
 	/* No mask/unmask at this level */
 }
 
 static struct irq_chip tc35892_irq_chip = {
-	.name	= "tc35892",
-	.mask	= tc35892_irq_dummy,
-	.unmask	= tc35892_irq_dummy,
+	.name		= "tc35892",
+	.irq_mask	= tc35892_irq_dummy,
+	.irq_unmask	= tc35892_irq_dummy,
 };
 
 static int tc35892_irq_init(struct tc35892 *tc35892)
-- 
1.7.1

