Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200Ab2JXPeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:34:37 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11147 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999Ab2JXPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:34:32 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <voice.shen@atmel.com>,
        <marek.belisko@open-nandra.com>, <ivan.shugov@gmail.com>,
        <josh.wu@atmel.com>
Subject: [PATCH 5/8] ARM: at91/dts: at91sam9g20ek_common: Fix typos in buttons labels.
Date: Wed, 24 Oct 2012 17:33:54 +0200
Message-ID: <8e817f3a385af38a7a86ee555109bd093fb5fe39.1351092432.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <cover.1351092432.git.nicolas.ferre@atmel.com>
References: <cover.1351092432.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Belisko <marek.belisko@open-nandra.com>

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index b06c0db..e6391a4 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -126,14 +126,14 @@
 		#size-cells = <0>;
 
 		btn3 {
-			label = "Buttin 3";
+			label = "Button 3";
 			gpios = <&pioA 30 1>;
 			linux,code = <0x103>;
 			gpio-key,wakeup;
 		};
 
 		btn4 {
-			label = "Buttin 4";
+			label = "Button 4";
 			gpios = <&pioA 31 1>;
 			linux,code = <0x104>;
 			gpio-key,wakeup;
-- 
1.7.11.3

