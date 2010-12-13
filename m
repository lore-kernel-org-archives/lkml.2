Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab0LMMbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:22 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:41598 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530Ab0LMMbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:19 -0500
Date: Mon, 13 Dec 2010 13:31:18 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] mfd: twl6030: irq_data conversion.
Message-ID: <20101213123118.GA15575@mail.wantstofly.org>
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
 drivers/mfd/twl6030-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index aaedb11..8785272 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -325,7 +325,7 @@ int twl6030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	 */
 	twl6030_irq_chip = dummy_irq_chip;
 	twl6030_irq_chip.name = "twl6030";
-	twl6030_irq_chip.set_type = NULL;
+	twl6030_irq_chip.irq_set_type = NULL;
 
 	for (i = irq_base; i < irq_end; i++) {
 		set_irq_chip_and_handler(i, &twl6030_irq_chip,
-- 
1.7.1

