Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab2GRM77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:59:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:35752 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2GRM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:59:56 -0400
From: Torben Hohn <torbenh@linutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel@vger.kernel.org, Torben Hohn <torbenh@linutronix.de>
Subject: [PATCH] arm imx31: add a few pinmux settings the tt01 needs
Date: Wed, 18 Jul 2012 14:58:25 +0200
Message-Id: <1342616305-24722-1-git-send-email-torbenh@linutronix.de>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the Pinmux Settings for the PP4 SSI Port multiplexible
onto the first UART Pins.

Signed-off-by: Torben Hohn <torbenh@linutronix.de>
---
 arch/arm/plat-mxc/include/mach/iomux-mx3.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx3.h b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
index 63f22a0..019b0a0 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
@@ -515,12 +515,16 @@ enum iomux_pins {
 #define MX31_PIN_CSPI3_SPI_RDY__CTS3	IOMUX_MODE(MX31_PIN_CSPI3_SPI_RDY, IOMUX_CONFIG_ALT1)
 #define MX31_PIN_CTS1__CTS1		IOMUX_MODE(MX31_PIN_CTS1, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_RTS1__RTS1		IOMUX_MODE(MX31_PIN_RTS1, IOMUX_CONFIG_FUNC)
+#define MX31_PIN_RTS1__SFS		IOMUX_MODE(MX31_PIN_RTS1, IOMUX_CONFIG_ALT2)
 #define MX31_PIN_TXD1__TXD1		IOMUX_MODE(MX31_PIN_TXD1, IOMUX_CONFIG_FUNC)
+#define MX31_PIN_TXD1__SCK		IOMUX_MODE(MX31_PIN_TXD1, IOMUX_CONFIG_ALT2)
 #define MX31_PIN_RXD1__RXD1		IOMUX_MODE(MX31_PIN_RXD1, IOMUX_CONFIG_FUNC)
+#define MX31_PIN_RXD1__STXDA		IOMUX_MODE(MX31_PIN_RXD1, IOMUX_CONFIG_ALT2)
 #define MX31_PIN_DCD_DCE1__DCD_DCE1	IOMUX_MODE(MX31_PIN_DCD_DCE1, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_RI_DCE1__RI_DCE1	IOMUX_MODE(MX31_PIN_RI_DCE1, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_DSR_DCE1__DSR_DCE1	IOMUX_MODE(MX31_PIN_DSR_DCE1, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_DTR_DCE1__DTR_DCE1	IOMUX_MODE(MX31_PIN_DTR_DCE1, IOMUX_CONFIG_FUNC)
+#define MX31_PIN_DTR_DCE1__SRXDA	IOMUX_MODE(MX31_PIN_DTR_DCE1, IOMUX_CONFIG_ALT2)
 #define MX31_PIN_CTS2__CTS2		IOMUX_MODE(MX31_PIN_CTS2, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_RTS2__RTS2		IOMUX_MODE(MX31_PIN_RTS2, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_TXD2__TXD2		IOMUX_MODE(MX31_PIN_TXD2, IOMUX_CONFIG_FUNC)
@@ -724,6 +728,7 @@ enum iomux_pins {
 #define MX31_PIN_KEY_ROW2_KEY_ROW2	IOMUX_MODE(MX31_PIN_KEY_ROW2, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_KEY_ROW3_KEY_ROW3	IOMUX_MODE(MX31_PIN_KEY_ROW3, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_KEY_ROW4_KEY_ROW4	IOMUX_MODE(MX31_PIN_KEY_ROW4, IOMUX_CONFIG_FUNC)
+#define MX31_PIN_KEY_ROW4_GPIO		IOMUX_MODE(MX31_PIN_KEY_ROW4, IOMUX_CONFIG_GPIO)
 #define MX31_PIN_KEY_ROW5_KEY_ROW5	IOMUX_MODE(MX31_PIN_KEY_ROW5, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_KEY_ROW6_KEY_ROW6	IOMUX_MODE(MX31_PIN_KEY_ROW6, IOMUX_CONFIG_FUNC)
 #define MX31_PIN_KEY_ROW7_KEY_ROW7	IOMUX_MODE(MX31_PIN_KEY_ROW7, IOMUX_CONFIG_FUNC)
-- 
1.7.10

