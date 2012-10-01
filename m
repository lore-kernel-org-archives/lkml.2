Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2JAUqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:46:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49208 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab2JAUq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:46:29 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] arm/dts: at91sam9g20ek_common: Fix typos in buttons labels.
Date: Mon,  1 Oct 2012 22:46:09 +0200
Message-Id: <1349124369-28742-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |    4 ++--
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
1.7.9.5

