Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab0FPRcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:32:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:37663 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756308Ab0FPRcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:32:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18/JxtCOA8/gxsCSF3ZrLSTTa2y8BOP2WiAVgSUrK
	RypGkJE3wIw0l9
From: Peter Huewe <PeterHuewe@gmx.de>
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] arm/include: Fix missing semicolon in module.h
Date: Wed, 16 Jun 2010 19:32:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161932.00542.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a missing semicolon which introduced buildfailures [2] for
almost every arm defconfig, introduced by patch cecaa4c6b [1]

This issue arises only if CONFIG_ARM_UNWIND is not set.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100616
References:
[1] cecaa4c6b ARM: 6172/1: module - additional unwind tables for exit/devexit
[2] http://kisskb.ellerman.id.au/kisskb/compiler/11/
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/2725882/

 arch/arm/include/asm/module.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index fcff0d2..cbb0bc2 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -26,7 +26,7 @@ struct mod_arch_specific {
 };
 #else
 struct mod_arch_specific {
-}
+};
 #endif
 
 /*
-- 
1.6.4.4

