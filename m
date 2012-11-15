Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767756Ab2KONOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:14:54 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62245 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767726Ab2KONOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:14:53 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/2] ARM: ux500: Disable the MMCI gpio-regulator by default
Date: Thu, 15 Nov 2012 13:14:47 +0000
Message-Id: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all supported boards will require a MMCI gpio-regulator,
therefore it's a good idea to only enable the node when and if
it is required. Let's disable it by default.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 7ce45fc..d8ba489 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -642,6 +642,8 @@
 			gpio-enable = <&tc3589x_gpio 17 0x4>;
 			states = <1800000 0x1
 				  2900000 0x0>;
+
+			status = "disabled";
 		};
 	};
 };
-- 
1.7.9.5

