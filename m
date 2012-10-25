Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422904Ab2JYJ6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:58:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64740 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422833Ab2JYJ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:57:32 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/8] ARM: ux500: CONFIG: Enable GPIO Regulators
Date: Thu, 25 Oct 2012 10:57:10 +0100
Message-Id: <1351159031-25391-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
References: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is the intention to convert the MMC voltage changing from
GPIO flipping to using a proper GPIO regulator interface. A
prerequisite of that is to enable the GPIO regulator
functionality. As this affects all ux5x0 based boards we'll
do it here instead of in the Kconfigs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/u8500_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 0575d8a..50d3c22 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -76,6 +76,7 @@ CONFIG_AB8500_CORE=y
 CONFIG_REGULATOR=y
 CONFIG_REGULATOR_AB8500=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
+CONFIG_REGULATOR_GPIO=y
 # CONFIG_HID_SUPPORT is not set
 CONFIG_USB_GADGET=y
 CONFIG_AB8500_USB=y
-- 
1.7.9.5

