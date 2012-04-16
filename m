Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2DPJVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:21:34 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:8714 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab2DPJVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:30 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 04/12] ARM: at91: Export at91_matrix_base
Date: Mon, 16 Apr 2012 11:20:48 +0200
Message-Id: <ac8c411c8360c281d1fb5e03a975e9088d069ded.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

at91_matrix_* macro's are used by at91_udc usb gadget driver,
which can be built as module, therefore we need to export the
variable containing matrix base address.

Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 0607847..f44a2e7 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -293,6 +293,7 @@ void __init at91_ioremap_rstc(u32 base_addr)
 }
 
 void __iomem *at91_matrix_base;
+EXPORT_SYMBOL_GPL(at91_matrix_base);
 
 void __init at91_ioremap_matrix(u32 base_addr)
 {
-- 
1.7.10

