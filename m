Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107Ab2JXOqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:46:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35755 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935068Ab2JXOpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:45:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/6] ARM: ux500: Specify AMBA Primecell IDs for Nomadik I2C in DT
Date: Wed, 24 Oct 2012 15:45:24 +0100
Message-Id: <1351089926-32161-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the Nomadik I2C driver has been converted to an AMBA one, we
are required to provide the Primecell IDs via platform code. When
booting with DT enabled these have to be specified in the device
nodes. We do that here.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 536df5d..4ed1b4b 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -452,6 +452,8 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80004000 0x1000>;
 			interrupts = <0 21 0x4>;
+			arm,primecell-periphid = <0x180024>;
+
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
@@ -463,6 +465,8 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80122000 0x1000>;
 			interrupts = <0 22 0x4>;
+			arm,primecell-periphid = <0x180024>;
+
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
@@ -474,6 +478,8 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80128000 0x1000>;
 			interrupts = <0 55 0x4>;
+			arm,primecell-periphid = <0x180024>;
+
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
@@ -485,6 +491,8 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80110000 0x1000>;
 			interrupts = <0 12 0x4>;
+			arm,primecell-periphid = <0x180024>;
+
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
@@ -496,6 +504,8 @@
 			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x8012a000 0x1000>;
 			interrupts = <0 51 0x4>;
+			arm,primecell-periphid = <0x180024>;
+
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
-- 
1.7.9.5

