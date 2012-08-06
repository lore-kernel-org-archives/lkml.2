Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2HFKru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:47:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40879 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2HFKrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:47:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/6] ARM: ux500: Match-up compatible stings with associated MFD cell
Date: Mon,  6 Aug 2012 11:46:41 +0100
Message-Id: <1344250002-6011-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, we've either taken the IRQs listed in the MFD cell defined
in the AB8500 driver, or the ones in Device Tree when we probed each
AB8500 MFD device independently. However, now we make a logical choice
based on whether we're running Device Tree or not. For this to happen
we need the compatible stings in the AB8500 MFD cell and the DT to
match-up. We do that here.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 83229f7..0282353 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -355,7 +355,7 @@
 				};
 
 				ab8500-ponkey {
-					compatible = "stericsson,ab8500-ponkey";
+					compatible = "stericsson,ab8500-poweron-key";
 					interrupts = <6 0x4
 						      7 0x4>;
 					interrupt-names = "ONKEY_DBF", "ONKEY_DBR";
-- 
1.7.9.5

