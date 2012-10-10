Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2JJPTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:19:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38349 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2JJPTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:19:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/6] ARM: ux500: Add UART support to the u9540 Device Tree
Date: Wed, 10 Oct 2012 16:18:53 +0100
Message-Id: <1349882335-6786-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
References: <1349882335-6786-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the 3 UART nodes required to enable serial ports on the u9540.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/u9540.dts |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/u9540.dts b/arch/arm/boot/dts/u9540.dts
index 0a66f34..28efe20 100644
--- a/arch/arm/boot/dts/u9540.dts
+++ b/arch/arm/boot/dts/u9540.dts
@@ -21,6 +21,17 @@
 	};
 
 	soc-u9500 {
-	};
 
+		uart@80120000 {
+			status = "okay";
+		};
+
+		uart@80121000 {
+			status = "okay";
+		};
+
+		uart@80007000 {
+			status = "okay";
+		};
+	};
 };
-- 
1.7.9.5

