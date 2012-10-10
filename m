Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab2JJMiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:38:20 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:59850 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab2JJMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:38:18 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/5] ARM: plat-nomadik: Introduce new DB8540 GPIO registers
Date: Wed, 10 Oct 2012 14:37:59 +0200
Message-ID: <1349872679-31174-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Coquelin <maxime.coquelin@stericsson.com>

DB8540's GPIO controller introduce level detection
support for both interrupts and wakeups.

Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
index c08a54d..cf81111 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
@@ -38,6 +38,9 @@
 #define NMK_GPIO_RWIMSC	0x50
 #define NMK_GPIO_FWIMSC	0x54
 #define NMK_GPIO_WKS	0x58
+/* These appear in DB8540 and later ASICs */
+#define NMK_GPIO_EDGELEVEL 0x5C
+#define NMK_GPIO_LEVEL	0x60
 
 /* Alternate functions: function C is set in hw by setting both A and B */
 #define NMK_GPIO_ALT_GPIO	0
-- 
1.7.11.3

