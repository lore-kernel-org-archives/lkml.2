Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab0HKCZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:25:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47631 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab0HKCZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:25:38 -0400
Subject: [PATCH] arm: fix small Kconfig typo
From: john stultz <johnstul@us.ibm.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 19:25:34 -0700
Message-ID: <1281493534.2955.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Russell,

	The following minor fix is needed to get current -git to build.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 232f0c7..656e8ff 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1185,7 +1185,7 @@ config LOCAL_TIMERS
 		ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_TEGRA)
 	default y
 	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || \\
-		ARCH_U8500 || ARCH_TEGRA
+		ARCH_U8500 || ARCH_TEGRA)
 	help
 	  Enable support for local timers on SMP platforms, rather then the
 	  legacy IPI broadcast method.  Local timers allows the system


