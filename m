Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2DQRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:09:27 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:35326 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755477Ab2DQRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:09:23 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 4/8] ARM: LPC32xx: Remove obsolete platform Kconfig
Date: Tue, 17 Apr 2012 19:08:23 +0200
Message-Id: <1334682507-15055-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334682507-15055-1-git-send-email-stigge@antcom.de>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes two Kconfig options now unused (the network driver is
configured via DT now).

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc3

--- linux-2.6.orig/arch/arm/mach-lpc32xx/Kconfig
+++ linux-2.6/arch/arm/mach-lpc32xx/Kconfig
@@ -29,30 +29,4 @@ config ARCH_LPC32XX_UART6_SELECT
 
 endmenu
 
-menu "LPC32XX chip components"
-
-config ARCH_LPC32XX_IRAM_FOR_NET
-	bool "Use IRAM for network buffers"
-	default y
-	help
-	  Say Y here to use the LPC internal fast IRAM (i.e. 256KB SRAM) as
-	  network buffer.  If the total combined required buffer sizes is
-	  larger than the size of IRAM, then SDRAM will be used instead.
-
-	  This can be enabled safely if the IRAM is not intended for other
-	  uses.
-
-config ARCH_LPC32XX_MII_SUPPORT
-	bool "Check to enable MII support or leave disabled for RMII support"
-	help
-	  Say Y here to enable MII support, or N for RMII support. Regardless of
-	  which support is selected, the ethernet interface driver needs to be
-	  selected in the device driver networking section.
-
-	  The PHY3250 reference board uses RMII, so users of this board should
-	  say N.
-
-endmenu
-
 endif
-

