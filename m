Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2GaNdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:33:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37555 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2GaNb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:31:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/6] ARM: ux500: Enable HIGHMEM on all mop500 platforms
Date: Tue, 31 Jul 2012 14:31:30 +0100
Message-Id: <1343741493-17671-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kernel commandline for ux500 based devices includes
hard-coded allocations for things like mali and hwmem, which
actually run over lowmem. Here we enable highmem in order to
avoid memory corruption errors.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index c013bbf..f51c351 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -28,6 +28,7 @@ config MACH_MOP500
 	select I2C
 	select I2C_NOMADIK
 	select SOC_BUS
+	select HIGHMEM
 	help
 	  Include support for the MOP500 development platform.
 
-- 
1.7.9.5

