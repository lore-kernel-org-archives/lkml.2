Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1KUNeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:34:18 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:51319 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1KUNeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:34:17 -0500
Message-ID: <1321882445.32195.3.camel@x61.thuisdomein>
Subject: [PATCH] ARM: imx: drop 'ARCH_MX31' and 'ARCH_MX35'
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 21 Nov 2011 14:34:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 27ad4bf72a ("ARM: imx: move mx3 support to mach-imx") kept
ARCH_MX31 and ARCH_MX35 'for compatibility'. Now that they aren't
actually used anymore, they can be dropped entirely.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
"git grep" tested only.

 arch/arm/mach-imx/Kconfig |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 5f7f9c2..c44aa97 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -10,11 +10,6 @@ config HAVE_IMX_MMDC
 config HAVE_IMX_SRC
 	bool
 
-#
-# ARCH_MX31 and ARCH_MX35 are left for compatibility
-# Some usages assume that having one of them implies not having (e.g.) ARCH_MX2.
-# To easily distinguish good and reviewed from unreviewed usages new (and IMHO
-# more sensible) names are used: SOC_IMX31 and SOC_IMX35
 config ARCH_MX1
 	bool
 
@@ -27,12 +22,6 @@ config ARCH_MX25
 config MACH_MX27
 	bool
 
-config ARCH_MX31
-	bool
-
-config ARCH_MX35
-	bool
-
 config SOC_IMX1
 	bool
 	select ARCH_MX1
@@ -72,7 +61,6 @@ config SOC_IMX31
 	select CPU_V6
 	select IMX_HAVE_PLATFORM_MXC_RNGA
 	select ARCH_MXC_AUDMUX_V2
-	select ARCH_MX31
 	select MXC_AVIC
 	select SMP_ON_UP if SMP
 
@@ -82,7 +70,6 @@ config SOC_IMX35
 	select ARCH_MXC_IOMUX_V3
 	select ARCH_MXC_AUDMUX_V2
 	select HAVE_EPIT
-	select ARCH_MX35
 	select MXC_AVIC
 	select SMP_ON_UP if SMP
 
-- 
1.7.7.3

