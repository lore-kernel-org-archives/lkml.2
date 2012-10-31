Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291Ab2J3SO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:14:58 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59060 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934118Ab2J3SMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:46 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] arm-dt: Enable DT proc updates.
Date: Wed, 31 Oct 2012 17:57:49 +0200
Message-Id: <1351699069-4661-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch enables dynamic changes of the DT tree on runtime
to be visible to the device-tree proc interface.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/include/asm/prom.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
index aeae9c6..6d65ba2 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -11,6 +11,8 @@
 #ifndef __ASMARM_PROM_H
 #define __ASMARM_PROM_H
 
+#define HAVE_ARCH_DEVTREE_FIXUPS
+
 #ifdef CONFIG_OF
 
 extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
-- 
1.7.12

