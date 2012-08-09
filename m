Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab2HIP50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:57:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33315 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758483Ab2HIP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:57:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Match Power-On-Key MFD and DTS compatible strings
Date: Thu,  9 Aug 2012 16:57:06 +0100
Message-Id: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compatible string found in the Power-On-Key's MFD cell matches
the device name provided in the driver. Keeping this naming convention
seems like a good idea, so we're changing the one found in the DTS
file to match.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 5106662..7d84f46 100644
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

