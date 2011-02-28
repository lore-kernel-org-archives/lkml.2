Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1B1XUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:20:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59553 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1B1XUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:20:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:to:cc:from:subject;
        b=BYeDtvyEsL/XKLsKHWenkeKOhHq/0HhidpmOwAmvgNkLF+Fl6EnDtWTZEJ1fW7pxol
         EWp7S0bTF7YJWwViL+n0n6kqzdOZi1cM4yexolDYAv+BGLZO51psyOIaQGsB0dvNVyhR
         2WZ8SMoVMPjaE2ehDQhqj4UxNyNORd3ofwm3Y=
Message-ID: <4d6c2da3.cc7e0e0a.2116.ffffde18@mx.google.com>
Date: Tue,  1 Mar 2011 00:20:01 +0100
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Subject: [PATCH] MIPS: Jz4740: Add HAVE_CLK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jz4740 supports the clock framework but doesn't have HAVE_CLK defined, so define
it!

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
---
 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f5ecc05..6199128 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -208,6 +208,7 @@ config MACH_JZ4740
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_HAS_EARLY_PRINTK
 	select HAVE_PWM
+	select HAVE_CLK
 
 config LASAT
 	bool "LASAT Networks platforms"
-- 
1.7.4

