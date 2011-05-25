Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1EYIKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:10:44 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:59188 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756946Ab1EYIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:10:43 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio/nomadik: remove dangling Kconfig selects
Date: Wed, 25 May 2011 10:10:23 +0200
Message-ID: <1306311023-2368-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

With the movement of the Nomadik GPIO driver we compile the driver
when PLAT_NOMADIK is selected to this Kconfig option is gone.

Reported-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This goes on top of the GPIO movement patches posted yesterday,
it might conflict with something but solving that is sufficiently
trivial I think.
---
 arch/arm/mach-nomadik/Kconfig |    1 -
 arch/arm/mach-ux500/Kconfig   |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-nomadik/Kconfig b/arch/arm/mach-nomadik/Kconfig
index 71f3ea6..3c5e0f5 100644
--- a/arch/arm/mach-nomadik/Kconfig
+++ b/arch/arm/mach-nomadik/Kconfig
@@ -6,7 +6,6 @@ config MACH_NOMADIK_8815NHK
 	bool "ST 8815 Nomadik Hardware Kit (evaluation board)"
 	select NOMADIK_8815
 	select HAS_MTU
-	select NOMADIK_GPIO
 
 endmenu
 
diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 5862601..fa58882 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -5,7 +5,6 @@ config UX500_SOC_COMMON
 	default y
 	select ARM_GIC
 	select HAS_MTU
-	select NOMADIK_GPIO
 	select ARM_ERRATA_753970
 
 menu "Ux500 SoC"
-- 
1.7.3.2

