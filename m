Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1LJCIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 21:08:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51438 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1LJCIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 21:08:19 -0500
Message-ID: <1323482888.11437.1.camel@phoenix>
Subject: [PATCH] ARM: pxa: Include linux/export.h in balloon3.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Sat, 10 Dec 2011 10:08:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/export.h to fix below build warning:

  CC      arch/arm/mach-pxa/balloon3.o
arch/arm/mach-pxa/balloon3.c:85: warning: data definition has no type or storage class
arch/arm/mach-pxa/balloon3.c:85: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/mach-pxa/balloon3.c:85: warning: parameter names (without types) in function declaration

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-pxa/balloon3.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
index 5971c46..c35456f 100644
--- a/arch/arm/mach-pxa/balloon3.c
+++ b/arch/arm/mach-pxa/balloon3.c
@@ -13,6 +13,7 @@
  *  published by the Free Software Foundation.
  */
 
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-- 
1.7.5.4



