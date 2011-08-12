Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1HLWzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:55:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50575 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1HLWzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:55:18 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 06/12] arm/dt: Tegra: Add pinmux node
Date: Fri, 12 Aug 2011 16:54:51 -0600
Message-Id: <1313189697-21287-7-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pinmux node to tegra20.dtsi in order to instantiate the future
pinmux device. Add pinmux nodes to Harmony and Seaboard, which detail
the entire default pinmux configuration. This configuration is identical
to that in board-harmony/seaboard-pinmux.c.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra-harmony.dts  |  464 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts |  401 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi       |    5 +
 3 files changed, 870 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
index c9bb847..066a338 100644
--- a/arch/arm/boot/dts/tegra-harmony.dts
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -30,6 +30,470 @@
 		>;
 	};
 
+	pinmux: pinmux@70000000 {
+		ATA {
+			nvidia,function = "IDE";
+		};
+		ATB {
+			nvidia,function = "SDIO4";
+		};
+		ATC {
+			nvidia,function = "NAND";
+		};
+		ATD {
+			nvidia,function = "GMI";
+		};
+		ATE {
+			nvidia,function = "GMI";
+		};
+		CDEV1 {
+			nvidia,function = "PLLA_OUT";
+		};
+		CDEV2 {
+			nvidia,function = "PLLP_OUT4";
+			nvidia,pull = "down";
+			nvidia,tristate;
+		};
+		CRTP {
+			nvidia,function = "CRT";
+			nvidia,tristate;
+		};
+		CSUS {
+			nvidia,function = "VI_SENSOR_CLK";
+			nvidia,pull = "down";
+			nvidia,tristate;
+		};
+		DAP1 {
+			nvidia,function = "DAP1";
+		};
+		DAP2 {
+			nvidia,function = "DAP2";
+			nvidia,tristate;
+		};
+		DAP3 {
+			nvidia,function = "DAP3";
+			nvidia,tristate;
+		};
+		DAP4 {
+			nvidia,function = "DAP4";
+			nvidia,tristate;
+		};
+		DDC {
+			nvidia,function = "I2C2";
+			nvidia,pull = "up";
+		};
+		DTA {
+			nvidia,function = "SDIO2";
+			nvidia,pull = "up";
+		};
+		DTB {
+			nvidia,function = "RSVD1";
+		};
+		DTC {
+			nvidia,function = "RSVD1";
+			nvidia,tristate;
+		};
+		DTD {
+			nvidia,function = "SDIO2";
+			nvidia,pull = "up";
+		};
+		DTE {
+			nvidia,function = "RSVD1";
+			nvidia,tristate;
+		};
+		DTF {
+			nvidia,function = "I2C3";
+			nvidia,tristate;
+		};
+		GMA {
+			nvidia,function = "SDIO4";
+		};
+		GMB {
+			nvidia,function = "GMI";
+		};
+		GMC {
+			nvidia,function = "UARTD";
+		};
+		GMD {
+			nvidia,function = "GMI";
+		};
+		GME {
+			nvidia,function = "SDIO4";
+		};
+		GPU {
+			nvidia,function = "GMI";
+			nvidia,tristate;
+		};
+		GPU7 {
+			nvidia,function = "RTCK";
+		};
+		GPV {
+			nvidia,function = "PCIE";
+			nvidia,tristate;
+		};
+		HDINT {
+			nvidia,function = "HDMI";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		I2CP {
+			nvidia,function = "I2C";
+		};
+		IRRX {
+			nvidia,function = "UARTA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		IRTX {
+			nvidia,function = "UARTA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		KBCA {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCB {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCC {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCD {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCE {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCF {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		LCSN {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LD0 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD1 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD10 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD11 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD12 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD13 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD14 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD15 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD16 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD17 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD2 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD3 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD4 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD5 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD6 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD7 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD8 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LD9 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LDC {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LDI {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LHP0 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LHP1 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LHP2 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LHS {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+		};
+		LM0 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+		};
+		LM1 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LPP {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LPW0 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+		};
+		LPW1 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LPW2 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+		};
+		LSC0 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+		};
+		LSC1 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LSCK {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LSDA {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LSDI {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LSPI {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+		};
+		LVP0 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		LVP1 {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "down";
+		};
+		LVS {
+			nvidia,function = "DISPLAYA";
+			nvidia,pull = "up";
+		};
+		OWC {
+			nvidia,function = "RSVD2";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		PMC {
+			nvidia,function = "PWR_ON";
+		};
+		PTA {
+			nvidia,function = "HDMI";
+		};
+		RM {
+			nvidia,function = "I2C";
+		};
+		SDB {
+			nvidia,function = "PWM";
+			nvidia,tristate;
+		};
+		SDC {
+			nvidia,function = "PWM";
+			nvidia,pull = "up";
+		};
+		SDD {
+			nvidia,function = "PWM";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		SDIO1 {
+			nvidia,function = "SDIO1";
+			nvidia,tristate;
+		};
+		SLXA {
+			nvidia,function = "PCIE";
+			nvidia,tristate;
+		};
+		SLXC {
+			nvidia,function = "SPDIF";
+			nvidia,tristate;
+		};
+		SLXD {
+			nvidia,function = "SPDIF";
+			nvidia,tristate;
+		};
+		SLXK {
+			nvidia,function = "PCIE";
+			nvidia,tristate;
+		};
+		SPDI {
+			nvidia,function = "RSVD2";
+			nvidia,tristate;
+		};
+		SPDO {
+			nvidia,function = "RSVD2";
+			nvidia,tristate;
+		};
+		SPIA {
+			nvidia,function = "GMI";
+		};
+		SPIB {
+			nvidia,function = "GMI";
+		};
+		SPIC {
+			nvidia,function = "GMI";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		SPID {
+			nvidia,function = "SPI1";
+			nvidia,pull = "down";
+			nvidia,tristate;
+		};
+		SPIE {
+			nvidia,function = "SPI1";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		SPIF {
+			nvidia,function = "SPI1";
+			nvidia,pull = "down";
+			nvidia,tristate;
+		};
+		SPIG {
+			nvidia,function = "SPI2_ALT";
+			nvidia,tristate;
+		};
+		SPIH {
+			nvidia,function = "SPI2_ALT";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		UAA {
+			nvidia,function = "ULPI";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		UAB {
+			nvidia,function = "ULPI";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		UAC {
+			nvidia,function = "RSVD2";
+			nvidia,tristate;
+		};
+		UAD {
+			nvidia,function = "IRDA";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		UCA {
+			nvidia,function = "UARTC";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		UCB {
+			nvidia,function = "UARTC";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		UDA {
+			nvidia,function = "ULPI";
+			nvidia,tristate;
+		};
+		CK32 {
+			nvidia,function = "NONE";
+		};
+		DDRC {
+			nvidia,function = "NONE";
+		};
+		PMCA {
+			nvidia,function = "NONE";
+		};
+		PMCB {
+			nvidia,function = "NONE";
+		};
+		PMCC {
+			nvidia,function = "NONE";
+		};
+		PMCD {
+			nvidia,function = "NONE";
+		};
+		PMCE {
+			nvidia,function = "NONE";
+		};
+		XM2C {
+			nvidia,function = "NONE";
+		};
+		XM2D {
+			nvidia,function = "NONE";
+		};
+	};
+
 	i2c@7000c000 {
 		clock-frequency = <400000>;
 
diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index b0d44a5..7ac3ab3 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -24,6 +24,407 @@
 		>;
 	};
 
+	pinmux: pinmux@70000000 {
+		ATA {
+			nvidia,function = "IDE";
+		};
+		ATB {
+			nvidia,function = "SDIO4";
+		};
+		ATC {
+			nvidia,function = "NAND";
+		};
+		ATD {
+			nvidia,function = "GMI";
+		};
+		ATE {
+			nvidia,function = "GMI";
+			nvidia,tristate;
+		};
+		CDEV1 {
+			nvidia,function = "PLLA_OUT";
+		};
+		CDEV2 {
+			nvidia,function = "PLLP_OUT4";
+		};
+		CRTP {
+			nvidia,function = "CRT";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		CSUS {
+			nvidia,function = "VI_SENSOR_CLK";
+			nvidia,tristate;
+		};
+		DAP1 {
+			nvidia,function = "DAP1";
+		};
+		DAP2 {
+			nvidia,function = "DAP2";
+		};
+		DAP3 {
+			nvidia,function = "DAP3";
+			nvidia,tristate;
+		};
+		DAP4 {
+			nvidia,function = "DAP4";
+		};
+		DDC {
+			nvidia,function = "RSVD2";
+			nvidia,tristate;
+		};
+		DTA {
+			nvidia,function = "VI";
+			nvidia,pull = "down";
+		};
+		DTB {
+			nvidia,function = "VI";
+			nvidia,pull = "down";
+		};
+		DTC {
+			nvidia,function = "VI";
+			nvidia,pull = "down";
+		};
+		DTD {
+			nvidia,function = "VI";
+			nvidia,pull = "down";
+		};
+		DTE {
+			nvidia,function = "VI";
+			nvidia,pull = "down";
+			nvidia,tristate;
+		};
+		DTF {
+			nvidia,function = "I2C3";
+		};
+		GMA {
+			nvidia,function = "SDIO4";
+		};
+		GMB {
+			nvidia,function = "GMI";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		GMC {
+			nvidia,function = "UARTD";
+		};
+		GMD {
+			nvidia,function = "SFLASH";
+		};
+		GME {
+			nvidia,function = "SDIO4";
+		};
+		GPU {
+			nvidia,function = "PWM";
+		};
+		GPU7 {
+			nvidia,function = "RTCK";
+		};
+		GPV {
+			nvidia,function = "PCIE";
+			nvidia,tristate;
+		};
+		HDINT {
+			nvidia,function = "HDMI";
+			nvidia,tristate;
+		};
+		I2CP {
+			nvidia,function = "I2C";
+		};
+		IRRX {
+			nvidia,function = "UARTB";
+		};
+		IRTX {
+			nvidia,function = "UARTB";
+		};
+		KBCA {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCB {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCC {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCD {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCE {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		KBCF {
+			nvidia,function = "KBC";
+			nvidia,pull = "up";
+		};
+		LCSN {
+			nvidia,function = "RSVD4";
+			nvidia,tristate;
+		};
+		LD0 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD1 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD10 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD11 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD12 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD13 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD14 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD15 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD16 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD17 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD2 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD3 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD4 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD5 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD6 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD7 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD8 {
+			nvidia,function = "DISPLAYA";
+		};
+		LD9 {
+			nvidia,function = "DISPLAYA";
+		};
+		LDC {
+			nvidia,function = "RSVD4";
+			nvidia,tristate;
+		};
+		LDI {
+			nvidia,function = "DISPLAYA";
+		};
+		LHP0 {
+			nvidia,function = "DISPLAYA";
+		};
+		LHP1 {
+			nvidia,function = "DISPLAYA";
+		};
+		LHP2 {
+			nvidia,function = "DISPLAYA";
+		};
+		LHS {
+			nvidia,function = "DISPLAYA";
+		};
+		LM0 {
+			nvidia,function = "RSVD4";
+		};
+		LM1 {
+			nvidia,function = "CRT";
+			nvidia,tristate;
+		};
+		LPP {
+			nvidia,function = "DISPLAYA";
+		};
+		LPW0 {
+			nvidia,function = "HDMI";
+		};
+		LPW1 {
+			nvidia,function = "RSVD4";
+			nvidia,tristate;
+		};
+		LPW2 {
+			nvidia,function = "HDMI";
+		};
+		LSC0 {
+			nvidia,function = "DISPLAYA";
+		};
+		LSC1 {
+			nvidia,function = "HDMI";
+			nvidia,tristate;
+		};
+		LSCK {
+			nvidia,function = "HDMI";
+			nvidia,tristate;
+		};
+		LSDA {
+			nvidia,function = "HDMI";
+			nvidia,tristate;
+		};
+		LSDI {
+			nvidia,function = "RSVD4";
+			nvidia,tristate;
+		};
+		LSPI {
+			nvidia,function = "DISPLAYA";
+		};
+		LVP0 {
+			nvidia,function = "RSVD4";
+			nvidia,tristate;
+		};
+		LVP1 {
+			nvidia,function = "DISPLAYA";
+		};
+		LVS {
+			nvidia,function = "DISPLAYA";
+		};
+		OWC {
+			nvidia,function = "RSVD2";
+			nvidia,tristate;
+		};
+		PMC {
+			nvidia,function = "PWR_ON";
+		};
+		PTA {
+			nvidia,function = "HDMI";
+		};
+		RM {
+			nvidia,function = "I2C";
+		};
+		SDB {
+			nvidia,function = "SDIO3";
+		};
+		SDC {
+			nvidia,function = "SDIO3";
+		};
+		SDD {
+			nvidia,function = "SDIO3";
+		};
+		SDIO1 {
+			nvidia,function = "SDIO1";
+			nvidia,pull = "up";
+		};
+		SLXA {
+			nvidia,function = "PCIE";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		SLXC {
+			nvidia,function = "SPDIF";
+			nvidia,tristate;
+		};
+		SLXD {
+			nvidia,function = "SPDIF";
+		};
+		SLXK {
+			nvidia,function = "PCIE";
+		};
+		SPDI {
+			nvidia,function = "RSVD2";
+		};
+		SPDO {
+			nvidia,function = "RSVD2";
+		};
+		SPIA {
+			nvidia,function = "GMI";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		SPIB {
+			nvidia,function = "GMI";
+			nvidia,tristate;
+		};
+		SPIC {
+			nvidia,function = "GMI";
+			nvidia,pull = "up";
+		};
+		SPID {
+			nvidia,function = "SPI1";
+			nvidia,tristate;
+		};
+		SPIE {
+			nvidia,function = "SPI1";
+			nvidia,tristate;
+		};
+		SPIF {
+			nvidia,function = "SPI1";
+			nvidia,pull = "down";
+			nvidia,tristate;
+		};
+		SPIG {
+			nvidia,function = "SPI2_ALT";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		SPIH {
+			nvidia,function = "SPI2_ALT";
+			nvidia,pull = "up";
+			nvidia,tristate;
+		};
+		UAA {
+			nvidia,function = "ULPI";
+			nvidia,pull = "up";
+		};
+		UAB {
+			nvidia,function = "ULPI";
+			nvidia,pull = "up";
+		};
+		UAC {
+			nvidia,function = "RSVD2";
+		};
+		UAD {
+			nvidia,function = "IRDA";
+		};
+		UCA {
+			nvidia,function = "UARTC";
+		};
+		UCB {
+			nvidia,function = "UARTC";
+		};
+		UDA {
+			nvidia,function = "ULPI";
+		};
+		CK32 {
+			nvidia,function = "NONE";
+		};
+		DDRC {
+			nvidia,function = "NONE";
+		};
+		PMCA {
+			nvidia,function = "NONE";
+		};
+		PMCB {
+			nvidia,function = "NONE";
+		};
+		PMCC {
+			nvidia,function = "NONE";
+		};
+		PMCD {
+			nvidia,function = "NONE";
+		};
+		PMCE {
+			nvidia,function = "NONE";
+		};
+		XM2C {
+			nvidia,function = "NONE";
+		};
+		XM2D {
+			nvidia,function = "NONE";
+		};
+	};
+
 	serial@70006300 {
 		clock-frequency = < 216000000 >;
 	};
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 5727595..5921c1d 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -77,6 +77,11 @@
 		gpio-controller;
 	};
 
+	pinmux: pinmux@70000000 {
+		compatible = "nvidia,tegra20-pinmux";
+		reg = < 0x70000000 0xc00 >;
+	};
+
 	serial@70006000 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006000 0x40>;
-- 
1.7.0.4

