Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab2ESLPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:15:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36720 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682Ab2ESLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:15:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] irq_domain: Document size parameter of irq_domain_add_linear()
Date: Sat, 19 May 2012 12:15:35 +0100
Message-Id: <1337426135-9807-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/irq/irqdomain.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 0e0ba5f..d0e50eb 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -156,6 +156,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 /**
  * irq_domain_add_linear() - Allocate and register a legacy revmap irq_domain.
  * @of_node: pointer to interrupt controller's device tree node.
+ * @size: Number of interrupts in the domain.
  * @ops: map/unmap domain callbacks
  * @host_data: Controller private data pointer
  */
-- 
1.7.10

