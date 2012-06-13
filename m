Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2FMQIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:08:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45949 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab2FMQIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:08:24 -0400
Message-ID: <4FD8BAE4.4050606@linaro.org>
Date: Wed, 13 Jun 2012 17:08:04 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: [PATCH 2/3] ARM: ux500: Add i2c configurations to the Device Tree
 for DB8500 based devices
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
In-Reply-To: <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Wed, 13 Jun 2012 16:21:14 +0100
Subject: [PATCH 2/3] ARM: ux500: Add i2c configurations to the Device Tree
 for DB8500 based devices

For correct operation of the i2c-nomadik driver, it requires some
information surrounding clock-frequencies, delay times and thresholds.
Here we apply those configurations to be used when a platform is
booted via the device Tree.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/db8500.dtsi |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index 00a4c3e..f3050f1 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -455,6 +455,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <100000>;
+			stericsson,slsu = <0xe>;
+			stericsson,tft = <1>;
+			stericsson,rft = <8>;
+			stericsson,timeout = <200>;
+			stericsson,i2c_freq_mode_fast;
 		};
 
 		i2c@80122000 {
@@ -464,6 +471,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <100000>;
+			stericsson,slsu = <0xe>;
+			stericsson,tft = <1>;
+			stericsson,rft = <8>;
+			stericsson,timeout = <200>;
+			stericsson,i2c_freq_mode_fast;
 		};
 
 		i2c@80128000 {
@@ -473,6 +487,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <100000>;
+			stericsson,slsu = <0xe>;
+			stericsson,tft = <1>;
+			stericsson,rft = <8>;
+			stericsson,timeout = <200>;
+			stericsson,i2c_freq_mode_fast;
 		};
 
 		i2c@80110000 {
@@ -482,6 +503,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <100000>;
+			stericsson,slsu = <0xe>;
+			stericsson,tft = <1>;
+			stericsson,rft = <8>;
+			stericsson,timeout = <200>;
+			stericsson,i2c_freq_mode_fast;
 		};
 
 		i2c@8012a000 {
@@ -491,6 +519,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <100000>;
+			stericsson,slsu = <0xe>;
+			stericsson,tft = <1>;
+			stericsson,rft = <8>;
+			stericsson,timeout = <200>;
+			stericsson,i2c_freq_mode_fast;
 		};
 
 		ssp@80002000 {
-- 
1.7.9.5
