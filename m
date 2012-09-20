Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2ITMTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:19:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab2ITMNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/32] ARM: ux500: Match Power-On-Key MFD and DTS compatible strings
Date: Thu, 20 Sep 2012 14:12:28 +0200
Message-Id: <1348143170-2130-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compatible string found in the Power-On-Key's MFD cell matches
the device name provided in the driver. Keeping this naming convention
seems like a good idea, so we're changing the one found in the DTS
file to match.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index daedefe..dc290d0 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -374,7 +374,7 @@
 				};
 
 				ab8500-ponkey {
-					compatible = "stericsson,ab8500-ponkey";
+					compatible = "stericsson,ab8500-poweron-key";
 					interrupts = <6 0x4
 						      7 0x4>;
 					interrupt-names = "ONKEY_DBF", "ONKEY_DBR";
-- 
1.7.9.5

