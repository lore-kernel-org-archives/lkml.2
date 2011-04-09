Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1DIRnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 13:43:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51566 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1DIRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 13:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DH1auiinRCx5nKIcc9NvTSUf0aXSXEcW0BL/n/XnW/bN27Gdgl6A23nJ57c6nFslrG
         DzW7olj0WBk44AKVd23pV4eM89ikxdU4OUNl+YL34Pl+1Jq6kQnyJ26vPio9wLgiRXjx
         u2N7uRM+AbNPe5IeSD2aGtMwkC9bdiIh0Qtww=
From: wanlong.gao@gmail.com
To: ralf@linux-mips.org, david.woodhouse@intel.com, akpm@linux-foundation.org,
        mingo@elte.hu
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] MIPS:fix the build warning
Date: Sun, 10 Apr 2011 01:42:17 +0800
Message-Id: <1302370937-832-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

LEDS_CLASS is a bool config .
Value 'm' is invalid for LEDS_CLASS.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/mips/configs/lemote2f_defconfig |    2 +-
 arch/mips/configs/malta_defconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index 167c1d0..cb2c5ea 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -329,7 +329,7 @@ CONFIG_USB_LED=m
 CONFIG_USB_GADGET=m
 CONFIG_USB_GADGET_M66592=y
 CONFIG_MMC=m
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_STAGING=y
 # CONFIG_STAGING_EXCLUDE_BUILD is not set
 CONFIG_FB_SM7XX=y
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 7270f31..5527abb 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -374,7 +374,7 @@ CONFIG_FB_CIRRUS=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_HID=m
-CONFIG_LEDS_CLASS=m
+CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_IDE_DISK=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
-- 
1.7.3

