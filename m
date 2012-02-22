Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2BVQPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:15:47 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:47100 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2BVQPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:15:45 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] ARM: at91: properly sort dtb files in Makefile.boot
Date: Wed, 22 Feb 2012 17:15:27 +0100
Message-Id: <8c91dafd3099fbe875ecd599455e4c3a4983b6f9.1329926750.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329927327-10613-1-git-send-email-nicolas.ferre@atmel.com>
References: <5a6951fcbe28c3093c936d40c4b28f7ae3161d8d.1329903206.git.nicolas.ferre@atmel.com>
 <1329927327-10613-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <76d3abda7e00e0bd2c8b42b2cf87ff8da16314c0.1329926750.git.nicolas.ferre@atmel.com>
References: <76d3abda7e00e0bd2c8b42b2cf87ff8da16314c0.1329926750.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile.boot |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
index be7200b..0da66ca 100644
--- a/arch/arm/mach-at91/Makefile.boot
+++ b/arch/arm/mach-at91/Makefile.boot
@@ -13,5 +13,10 @@ params_phys-y	:= 0x20000100
 initrd_phys-y	:= 0x20410000
 endif
 
-dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9m10g45ek.dtb usb_a9g20.dtb
+# Keep dtb files sorted alphabetically for each SoC
+# sam9g20
+dtb-$(CONFIG_MACH_AT91SAM_DT) += usb_a9g20.dtb
+# sam9g45
+dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9m10g45ek.dtb
+# sam9x5
 dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9g25ek.dtb
-- 
1.7.9

