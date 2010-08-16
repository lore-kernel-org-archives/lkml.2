Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab0HPIcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:32:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0HPIcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:32:02 -0400
From: Michal Simek <monstr@monstr.eu>
To: glikely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] microblaze: Fixup function of/address cleaning
Date: Mon, 16 Aug 2010 10:31:52 +0200
Message-Id: <1281947514-25319-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 22ae782f86b726f9cea752c0f269ff6dcdf2f6e1
anccidentaly removed linux/of_address.h header.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/prom.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index 5012b22..66894b5 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -22,7 +22,6 @@
 #include <linux/types.h>
 #include <asm/irq.h>
 #include <asm/atomic.h>
-#include <linux/of_address.h>
 
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
@@ -90,6 +89,7 @@ extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
  * by this file, but there are a bunch of .c files that currently depend
  * on it.  Eventually they will be cleaned up. */
 #include <linux/of_fdt.h>
+#include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 
-- 
1.5.5.6

