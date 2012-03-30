Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659Ab2C3Mbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:31:46 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:17506 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302Ab2C3Mbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:31:38 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Cc: ludovic.desroches@atmel.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        olof@lixom.net, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: include newly created system_misc.h file
Date: Fri, 30 Mar 2012 14:31:09 +0200
Message-Id: <1333110669-24554-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

system.h file has been split by commit "0195c00". Now include
system_misc.h for having access to arm_pm_restart.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi,

It seems that this split of system.h is now in linus' tree. AT91 build
is broken without this patch.

I will include it in a "at91-fixes" series that I will rebase on top
of 3.4-rc1.

 arch/arm/mach-at91/setup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 1083739..d4d334a 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -12,6 +12,7 @@
 #include <linux/of_address.h>
 
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 
 #include <mach/hardware.h>
 #include <mach/cpu.h>
-- 
1.7.9.4

