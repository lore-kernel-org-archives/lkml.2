Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab1INQb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:31:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41204 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1INQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:31:55 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/5] irq: add declaration of irq_domain_simple_ops to irqdomain.h
Date: Wed, 14 Sep 2011 11:31:36 -0500
Message-Id: <1316017900-19918-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

irq_domain_simple_ops is exported, but is not declared in irqdomain.h, so
add it.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdomain.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index e807ad6..3ad553e 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -80,6 +80,7 @@ extern void irq_domain_del(struct irq_domain *domain);
 #endif /* CONFIG_IRQ_DOMAIN */
 
 #if defined(CONFIG_IRQ_DOMAIN) && defined(CONFIG_OF_IRQ)
+extern struct irq_domain_ops irq_domain_simple_ops;
 extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
 extern void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start);
-- 
1.7.5.4

