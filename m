Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab2FELXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635Ab2FELXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:23:22 -0400
Date: Tue, 5 Jun 2012 13:23:15 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/8] x86: apic: Trivial whitespace fixes
Message-ID: <20120605112310.GA11443@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/apic_flat_64.c   |    2 +-
 arch/x86/kernel/apic/io_apic.c        |    4 ++--
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 359b689..8ef4e15 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -92,7 +92,7 @@ static void flat_send_IPI_mask(const struct cpumask *cpumask, int vector)
 }
 
 static void
- flat_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector)
+flat_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector)
 {
 	unsigned long mask = cpumask_bits(cpumask)[0];
 	int cpu = smp_processor_id();
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..1afedef 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1481,7 +1481,7 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
 
 	if (setup_ioapic_entry(irq, &entry, dest, cfg->vector, attr)) {
-		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+		pr_warn("Failed to setup ioapic entry for ioapic %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
 		__clear_irq_vector(irq, cfg);
 
@@ -1584,7 +1584,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
 static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
-					 unsigned int pin, int vector)
+					unsigned int pin, int vector)
 {
 	struct IO_APIC_route_entry entry;
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 48f3103..8f012b2 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -81,7 +81,7 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 }
 
 static void
- x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
 	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
