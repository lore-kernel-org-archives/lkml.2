Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2FNQyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:54:16 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:51468 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932295Ab2FNQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:50 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 16/23] ARM: LPC32xx: Build arch dtbs
Date: Thu, 14 Jun 2012 18:51:06 +0200
Message-Id: <1339692673-7848-17-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Add ea3250.dtb and phy3250.dtb to the list of dtbs to be built

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/Makefile.boot |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/Makefile.boot
+++ linux-2.6/arch/arm/mach-lpc32xx/Makefile.boot
@@ -2,3 +2,4 @@
 params_phys-y	:= 0x80000100
 initrd_phys-y	:= 0x82000000
 
+dtb-$(CONFIG_ARCH_LPC32XX) += ea3250.dtb phy3250.dtb
