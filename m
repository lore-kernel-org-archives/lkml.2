Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2FZDdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567Ab2FZDdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:33:13 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 10/16] sh/PCI: adjust section annotations for 'pcibios_setup()'
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 21:32:05 -0600
Message-ID: <20120626033205.16434.38166.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pcibios_setup() consistently use the "__init" section annotation.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 arch/sh/drivers/pci/fixups-sdk7786.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/drivers/pci/fixups-sdk7786.c b/arch/sh/drivers/pci/fixups-sdk7786.c
index 0e18ee3..36eb6fc 100644
--- a/arch/sh/drivers/pci/fixups-sdk7786.c
+++ b/arch/sh/drivers/pci/fixups-sdk7786.c
@@ -23,9 +23,9 @@
  * Misconfigurations can be detected through the FPGA via the slot
  * resistors to determine card presence. Hotplug remains unsupported.
  */
-static unsigned int slot4en __devinitdata;
+static unsigned int slot4en __initdata;
 
-char *__devinit pcibios_setup(char *str)
+char *__init pcibios_setup(char *str)
 {
 	if (strcmp(str, "slot4en") == 0) {
 		slot4en = 1;

