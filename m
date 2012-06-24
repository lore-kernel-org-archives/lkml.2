Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2FXNs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 09:48:57 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:57037 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756124Ab2FXNrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 09:47:46 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 5/7] ARM: LPC32xx: Defconfig update
Date: Sun, 24 Jun 2012 15:47:15 +0200
Message-Id: <1340545637-5449-6-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340545637-5449-1-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defconfig update for LPC32xx adds interrupt and polled gpio keyboard
drivers.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/configs/lpc32xx_defconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/arch/arm/configs/lpc32xx_defconfig
+++ linux-2.6/arch/arm/configs/lpc32xx_defconfig
@@ -18,6 +18,7 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_ARCH_LPC32XX=y
+CONFIG_KEYBOARD_GPIO_POLLED=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
@@ -89,6 +90,7 @@ CONFIG_INPUT_MOUSEDEV_SCREEN_X=240
 CONFIG_INPUT_MOUSEDEV_SCREEN_Y=320
 CONFIG_INPUT_EVDEV=y
 # CONFIG_KEYBOARD_ATKBD is not set
+CONFIG_KEYBOARD_GPIO=y
 CONFIG_KEYBOARD_LPC32XX=y
 # CONFIG_INPUT_MOUSE is not set
 CONFIG_INPUT_TOUCHSCREEN=y
