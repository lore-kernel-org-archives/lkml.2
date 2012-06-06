Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2FFPFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:05:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2FFPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:05:54 -0400
Date: Wed, 6 Jun 2012 08:05:42 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-49d0c7a0a425a89190b7c3b1445faba9eb227bec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120605112310.GA11443@dhcp-26-207.brq.redhat.com>
References: <20120605112310.GA11443@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Trivial whitespace fixes
Git-Commit-ID: 49d0c7a0a425a89190b7c3b1445faba9eb227bec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:05:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49d0c7a0a425a89190b7c3b1445faba9eb227bec
Gitweb:     http://git.kernel.org/tip/49d0c7a0a425a89190b7c3b1445faba9eb227bec
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Tue, 5 Jun 2012 13:23:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 10:22:16 +0200

x86/apic: Trivial whitespace fixes

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120605112310.GA11443@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic_flat_64.c   |    2 +-
 arch/x86/kernel/apic/io_apic.c        |    4 ++--
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 0e881c4..de279b3 100644
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
index 910a311..74c5697 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1363,7 +1363,7 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
 
 	if (setup_ioapic_entry(irq, &entry, dest, cfg->vector, attr)) {
-		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+		pr_warn("Failed to setup ioapic entry for ioapic %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
 		__clear_irq_vector(irq, cfg);
 
@@ -1466,7 +1466,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
 static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
-					 unsigned int pin, int vector)
+					unsigned int pin, int vector)
 {
 	struct IO_APIC_route_entry entry;
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 90d999c..2919e45 100644
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
