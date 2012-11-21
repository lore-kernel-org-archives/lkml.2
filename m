Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2KUCeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:34:22 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2KUC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 16/42] sh: Select PINCTRL for CPU subtypes that require it
Date: Wed, 21 Nov 2012 03:27:17 +0100
Message-Id: <1353464863-10281-17-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be required when the sh-pfc driver will move to
drivers/pinctrl/.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/sh/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index babc2b8..c72b616 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -276,6 +276,7 @@ config CPU_SUBTYPE_SH7203
 	select SYS_SUPPORTS_CMT
 	select SYS_SUPPORTS_MTU2
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select PINCTRL
 
 config CPU_SUBTYPE_SH7206
 	bool "Support SH7206 processor"
@@ -296,6 +297,7 @@ config CPU_SUBTYPE_SH7264
 	select CPU_HAS_FPU
 	select SYS_SUPPORTS_CMT
 	select SYS_SUPPORTS_MTU2
+	select PINCTRL
 
 config CPU_SUBTYPE_SH7269
 	bool "Support SH7269 processor"
@@ -303,6 +305,7 @@ config CPU_SUBTYPE_SH7269
 	select CPU_HAS_FPU
 	select SYS_SUPPORTS_CMT
 	select SYS_SUPPORTS_MTU2
+	select PINCTRL
 
 config CPU_SUBTYPE_MXG
 	bool "Support MX-G processor"
@@ -364,6 +367,7 @@ config CPU_SUBTYPE_SH7720
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
+	select PINCTRL
 	help
 	  Select SH7720 if you have a SH3-DSP SH7720 CPU.
 
@@ -429,6 +433,7 @@ config CPU_SUBTYPE_SH7723
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select PINCTRL
 	help
 	  Select SH7723 if you have an SH-MobileR2 CPU.
 
@@ -440,6 +445,7 @@ config CPU_SUBTYPE_SH7724
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select PINCTRL
 	help
 	  Select SH7724 if you have an SH-MobileR2R CPU.
 
@@ -450,6 +456,7 @@ config CPU_SUBTYPE_SH7734
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select USB_ARCH_HAS_OHCI
 	select USB_ARCH_HAS_EHCI
+	select PINCTRL
 	help
 	  Select SH7734 if you have a SH4A SH7734 CPU.
 
@@ -460,6 +467,7 @@ config CPU_SUBTYPE_SH7757
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select USB_ARCH_HAS_OHCI
 	select USB_ARCH_HAS_EHCI
+	select PINCTRL
 	help
 	  Select SH7757 if you have a SH4A SH7757 CPU.
 
@@ -486,6 +494,7 @@ config CPU_SUBTYPE_SH7785
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
 	bool "Support SH7786 processor"
@@ -498,6 +507,7 @@ config CPU_SUBTYPE_SH7786
 	select USB_OHCI_SH if USB_OHCI_HCD
 	select USB_ARCH_HAS_EHCI
 	select USB_EHCI_SH if USB_EHCI_HCD
+	select PINCTRL
 
 config CPU_SUBTYPE_SHX3
 	bool "Support SH-X3 processor"
@@ -505,6 +515,7 @@ config CPU_SUBTYPE_SHX3
 	select CPU_SHX3
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select ARCH_REQUIRE_GPIOLIB
+	select PINCTRL
 
 # SH4AL-DSP Processor Support
 
@@ -523,6 +534,7 @@ config CPU_SUBTYPE_SH7722
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select PINCTRL
 
 config CPU_SUBTYPE_SH7366
 	bool "Support SH7366 processor"
-- 
1.7.8.6

