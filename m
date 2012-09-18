Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2IRNBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:01:03 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:34360 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753296Ab2IRNBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:01:02 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/2] ARM: LPC32xx: DTS update for devicetree completion of spi-pl022
Date: Tue, 18 Sep 2012 15:00:27 +0200
Message-Id: <1347973228-29839-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi-pl022 got a further update to its devicetree support, completing properties
such that no platform data is necessary anymore. This patch adjusts
lpc32xx.dtsi accordingly.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
I will do a git pull request for arm-soc.git when the respective change in
spi-pl022.c is merged.

 arch/arm/boot/dts/lpc32xx.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -91,6 +91,7 @@
 				compatible = "arm,pl022", "arm,primecell";
 				reg = <0x20084000 0x1000>;
 				interrupts = <0x14 0>;
+				pl022,bus-id = <0>;
 			};
 
 			spi1: spi@20088000 {
@@ -102,6 +103,7 @@
 				compatible = "arm,pl022", "arm,primecell";
 				reg = <0x2008c000 0x1000>;
 				interrupts = <0x15 0>;
+				pl022,bus-id = <1>;
 			};
 
 			spi2: spi@20090000 {
