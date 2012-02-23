Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2BWOaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:30:21 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:30486 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2BWO0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:32 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 21/21] ARM: at91: properly sort dtb files in Makefile.boot
Date: Thu, 23 Feb 2012 15:26:05 +0100
Message-Id: <d5e5a7f987458f42f24a557a0f4e35f94c43fc09.1330006537.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
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

