Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888Ab1IOUQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:16:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:47975 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934640Ab1IOUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="49297072"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, dhowells@redhat.com
Subject: [PATCH 02/27] Initconst section fixes for FRV
Date: Thu, 15 Sep 2011 13:09:29 -0700
Message-Id: <1316117394-21666-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: dhowells@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/frv/kernel/setup.c         |    2 +-
 arch/frv/mb93090-mb00/pci-irq.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 75cf7f4..1f1e5ef 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -184,7 +184,7 @@ static struct clock_cmode __pminitdata clock_cmodes_fr555[16] = {
 	[6]	= {	_x1,	_x1_5,	_x1_5,	_x4_5,	_x0_375	},
 };
 
-static const struct clock_cmode __pminitdata *clock_cmodes;
+static const struct clock_cmode __pminitconst *clock_cmodes;
 static int __pminitdata clock_doubled;
 
 static struct uart_port __pminitdata __frv_uart0 = {
diff --git a/arch/frv/mb93090-mb00/pci-irq.c b/arch/frv/mb93090-mb00/pci-irq.c
index 20f6497..c677b9d 100644
--- a/arch/frv/mb93090-mb00/pci-irq.c
+++ b/arch/frv/mb93090-mb00/pci-irq.c
@@ -28,7 +28,7 @@
  *
  */
 
-static const uint8_t __initdata pci_bus0_irq_routing[32][4] = {
+static const uint8_t __initconst pci_bus0_irq_routing[32][4] = {
 	[0 ] = { IRQ_FPGA_MB86943_PCI_INTA },
 	[16] = { IRQ_FPGA_RTL8029_INTA },
 	[17] = { IRQ_FPGA_PCI_INTC, IRQ_FPGA_PCI_INTD, IRQ_FPGA_PCI_INTA, IRQ_FPGA_PCI_INTB },
-- 
1.7.4.4

