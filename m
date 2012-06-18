Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2FRLaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:30:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43210 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2FRLaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:30:52 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [RFC PATCH 5/8] AMP: smp: Extend number of IPIs
Date: Mon, 18 Jun 2012 13:30:08 +0200
Message-Id: <1340019011-18642-6-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GIC supports up to 16 IPIs.

Signed-off-by: Michal Simek <monstr@monstr.eu>

---
Please correct me if this code is also designed for different
interrupt controller which doesn't support 16 IPIs.
---
 arch/arm/include/asm/hardirq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/hardirq.h b/arch/arm/include/asm/hardirq.h
index 436e60b..3e9ded5 100644
--- a/arch/arm/include/asm/hardirq.h
+++ b/arch/arm/include/asm/hardirq.h
@@ -5,7 +5,7 @@
 #include <linux/threads.h>
 #include <asm/irq.h>
 
-#define NR_IPI	5
+#define NR_IPI	16
 
 typedef struct {
 	unsigned int __softirq_pending;
-- 
1.7.0.4

