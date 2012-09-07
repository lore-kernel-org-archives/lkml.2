Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518Ab2IGLTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:19:22 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60528 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760365Ab2IGLPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/19] ARM: ux500: Add UART support to the HREF Device Tree
Date: Fri,  7 Sep 2012 12:14:42 +0100
Message-Id: <1347016499-29354-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add three nodes enabling UART support on the HREF hardware
reference board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 96bf8a3..32cd7a0 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -21,6 +21,16 @@
 	};
 
 	soc-u9500 {
+		uart@80120000 {
+			status = "okay";
+		};
 
+		uart@80121000 {
+			status = "okay";
+		};
+
+		uart@80007000 {
+			status = "okay";
+		};
 	};
 };
-- 
1.7.9.5

