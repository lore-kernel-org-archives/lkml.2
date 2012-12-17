Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2LQLXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:23:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:43443 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2LQLXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:23:34 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <broonie@opensource.wolfsonmicro.com>, <voice.shen@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3] ARM: at91/dts: fix typo in SSC status property
Date: Mon, 17 Dec 2012 12:23:24 +0100
Message-ID: <10c033465336fc6cc82b6006153b0c456021589e.1355742707.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1355742707.git.nicolas.ferre@atmel.com>
References: <cover.1355742707.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bo Shen <voice.shen@atmel.com>

Change the value of status to "disabled" to conform with
property requirement.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
[nicolas.ferre@atmel.com: commit subject line and typos]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9263.dtsi | 4 ++--
 arch/arm/boot/dts/at91sam9g45.dtsi | 4 ++--
 arch/arm/boot/dts/at91sam9x5.dtsi  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 8e6251f..32ec62c 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -368,14 +368,14 @@
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfff98000 0x4000>;
 				interrupts = <16 4 5>;
-				status = "disable";
+				status = "disabled";
 			};
 
 			ssc1: ssc@fff9c000 {
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfff9c000 0x4000>;
 				interrupts = <17 4 5>;
-				status = "disable";
+				status = "disabled";
 			};
 
 			macb0: ethernet@fffbc000 {
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index fa1ae0c..231858f 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -425,14 +425,14 @@
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xfff9c000 0x4000>;
 				interrupts = <16 4 5>;
-				status = "disable";
+				status = "disabled";
 			};
 
 			ssc1: ssc@fffa0000 {
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xfffa0000 0x4000>;
 				interrupts = <17 4 5>;
-				status = "disable";
+				status = "disabled";
 			};
 
 			adc0: adc@fffb0000 {
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 617ede5..40ac3a4 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -92,7 +92,7 @@
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xf0010000 0x4000>;
 				interrupts = <28 4 5>;
-				status = "disable";
+				status = "disabled";
 			};
 
 			tcb0: timer@f8008000 {
-- 
1.8.0

