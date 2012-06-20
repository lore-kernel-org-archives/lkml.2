Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2FTJEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:04:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:7428 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746Ab2FTJEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:04:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <grant.likely@secretlab.ca>,
        <tglx@linutronix.de>, <benh@kernel.crashing.org>
Subject: [RFC PATCH 1/2] irq_domain: correct a minor wrong comment for linear revmap
Date: Wed, 20 Jun 2012 17:00:30 +0800
Message-ID: <1340182831-10477-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

The revmap type should be linear for irq_domain_add_linear function.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 3e4ea85..cb83554 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -219,7 +219,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 EXPORT_SYMBOL_GPL(irq_domain_add_legacy);
 
 /**
- * irq_domain_add_linear() - Allocate and register a legacy revmap irq_domain.
+ * irq_domain_add_linear() - Allocate and register a linear revmap irq_domain.
  * @of_node: pointer to interrupt controller's device tree node.
  * @size: Number of interrupts in the domain.
  * @ops: map/unmap domain callbacks
-- 
1.7.0.4


