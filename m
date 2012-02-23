Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2BWO0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:43 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:31937 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab2BWO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:41 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 20/21] ARM: at91: add at91sam9g25ek.dts in Makefile.boot
Date: Thu, 23 Feb 2012 15:26:04 +0100
Message-Id: <e9bc91a5f8b38e3fc39f640a18af19c9300ca042.1330006537.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile.boot |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
index 2fd051e..be7200b 100644
--- a/arch/arm/mach-at91/Makefile.boot
+++ b/arch/arm/mach-at91/Makefile.boot
@@ -14,3 +14,4 @@ initrd_phys-y	:= 0x20410000
 endif
 
 dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9m10g45ek.dtb usb_a9g20.dtb
+dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9g25ek.dtb
-- 
1.7.9

