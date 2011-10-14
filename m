Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab1JNMaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:30:06 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58411 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1JNMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:30:04 -0400
Subject: [PATCH 11/21] ARM: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:29:16 +0200
Message-ID: <1318595356.6132.69.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_AT91SAM9260_SAM9XE is simply unused.

MACH_TRIZEPS_UCONXS doesn't offfer anything MACH_TRIZEPS_ANY doesn't
already offer (ie, providing a way to not select MACH_TRIZEPS_CONXS,
which actually suggest the "choice" they are part of should be
"optional").

Add a comment that CPU_IXP46X and CPU_IXP43X could be merged. What
would be a nice new name?

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/arm/mach-at91/Kconfig   |    6 ------
 arch/arm/mach-ixp4xx/Kconfig |    1 +
 arch/arm/mach-pxa/Kconfig    |    3 ---
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 2248467..db23f3d 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -190,12 +190,6 @@ if ARCH_AT91SAM9260
 
 comment "AT91SAM9260 Variants"
 
-config ARCH_AT91SAM9260_SAM9XE
-	bool "AT91SAM9XE"
-	help
-	  Select this if you are using Atmel's AT91SAM9XE System-on-Chip.
-	  They are basically AT91SAM9260s with various sizes of embedded Flash.
-
 comment "AT91SAM9260 / AT91SAM9XE Board Type"
 
 config MACH_AT91SAM9260EK
diff --git a/arch/arm/mach-ixp4xx/Kconfig b/arch/arm/mach-ixp4xx/Kconfig
index 6f991c5..56f867c 100644
--- a/arch/arm/mach-ixp4xx/Kconfig
+++ b/arch/arm/mach-ixp4xx/Kconfig
@@ -151,6 +151,7 @@ config MACH_ARCOM_VULCAN
 #
 # Certain registers and IRQs are only enabled if supporting IXP465 CPUs
 #
+# XXX These two options can be merged. What is a nice name?
 config CPU_IXP46X
 	bool
 	depends on MACH_IXDP465
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index cd19309..4a03fda 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -184,9 +184,6 @@ choice
 config MACH_TRIZEPS_CONXS
 	bool "ConXS Eval Board"
 
-config MACH_TRIZEPS_UCONXS
-	bool "uConXS Eval Board"
-
 config MACH_TRIZEPS_ANY
 	bool "another Board"
 
-- 
1.7.4.4




