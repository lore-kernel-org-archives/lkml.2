Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab2K1Gmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 01:42:42 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44855 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2K1Gml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 01:42:41 -0500
Message-ID: <1354084955.18972.2.camel@phoenix>
Subject: [PATCH] ARM: mmp: select PINCTRL for ARCH_MMP
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 28 Nov 2012 14:42:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes PINCTRL related config options visible.
Otherwise there is no way to build pinctrl drivers for MMP2, PXA168 and PXA910.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
This patch was sent on https://lkml.org/lkml/2012/11/12/10
Resend to Haojian's correct email address.

 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1fd4208..2f8bfd4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -591,6 +591,7 @@ config ARCH_MMP
 	select GPIO_PXA
 	select IRQ_DOMAIN
 	select NEED_MACH_GPIO_H
+	select PINCTRL
 	select PLAT_PXA
 	select SPARSE_IRQ
 	help
-- 
1.7.9.5



