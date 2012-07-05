Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2GENGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:06:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48465 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab2GENGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: [PATCH 0/9] Final batch of clean-ups bound for v3.6
Date: Thu,  5 Jul 2012 14:06:03 +0100
Message-Id: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch-set we provide the last batch of clean-ups related 
to the Device Tree enablement of Snowball and other DB8500 based
chipsets. Most of these clean-ups are nice and  easy 
simplifications of code, or recommendations from particular 
Mainline Maintainers.

 .../devicetree/bindings/gpio/gpio-nmk.txt          |    2 +-
 arch/arm/boot/dts/db8500.dtsi                      |   18 +-
 arch/arm/mach-ux500/board-mop500-regulators.c      |  176 --------------------
 arch/arm/mach-ux500/board-mop500-regulators.h      |    2 -
 arch/arm/mach-ux500/board-mop500.c                 |   20 +--
 arch/arm/mach-ux500/cpu-db8500.c                   |   13 +-
 drivers/input/misc/ab8500-ponkey.c                 |    2 +
 drivers/pinctrl/pinctrl-nomadik.c                  |    4 +-
 include/linux/mfd/abx500/ab8500.h                  |    3 -
 9 files changed, 18 insertions(+), 222 deletions(-)

