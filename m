Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab1JNMb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:31:28 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58823 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab1JNMbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:31:25 -0400
Subject: [PATCH 18/21] pci: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:30:39 +0200
Message-ID: <1318595439.6132.77.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/pci/Kconfig |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0fa466a..b42798f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -51,17 +51,6 @@ config XEN_PCIDEV_FRONTEND
           The PCI device frontend driver allows the kernel to import arbitrary
           PCI devices from a PCI backend to support PCI driver domains.
 
-config XEN_PCIDEV_FE_DEBUG
-        bool "Xen PCI Frontend debugging"
-        depends on XEN_PCIDEV_FRONTEND && PCI_DEBUG
-	help
-	  Say Y here if you want the Xen PCI frontend to produce a bunch of debug
-	  messages to the system log.  Select this if you are having a
-	  problem with Xen PCI frontend support and want to see more of what is
-	  going on.
-
-	  When in doubt, say N.
-
 config HT_IRQ
 	bool "Interrupts on hypertransport devices"
 	default y
-- 
1.7.4.4




