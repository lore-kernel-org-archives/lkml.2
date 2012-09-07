Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab2IGLSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:18:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41152 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760351Ab2IGLP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/19] ARM: ux500: Enable SSP (SPI) for HREF when booting Device Tree
Date: Fri,  7 Sep 2012 12:14:49 +0100
Message-Id: <1347016499-29354-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add a new SSP node to the HREF's Device Tree file which
activates the generic one found in the .dtsi file. This will
allow probing of the SSP driver when Device Tree is enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index d8ed29e..49bdabd 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -92,5 +92,9 @@
 		msp3: msp@80125000 {
 			status = "okay";
 		};
+
+		ssp@80002000 {
+			status = "okay";
+		};
 	};
 };
-- 
1.7.9.5

