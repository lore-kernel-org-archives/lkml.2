Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1KBBt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 21:49:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48420 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1KBBtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 21:49:55 -0400
Message-ID: <1320198586.9065.2.camel@phoenix>
Subject: [PATCH] ARM: OMAP: dmtimer: Include linux/module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 02 Nov 2011 09:49:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/module.h to fix below build error:

  CC      arch/arm/plat-omap/dmtimer.o
arch/arm/plat-omap/dmtimer.c:184: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:184: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:184: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:215: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:215: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:215: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:228: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:228: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:228: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:234: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:234: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:234: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:240: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:240: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:240: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:248: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:248: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:248: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:294: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:294: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:294: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:302: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:302: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:302: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:316: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:316: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:316: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:344: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:344: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:344: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:361: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:361: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:361: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:380: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:380: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:380: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:406: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:406: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:406: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:443: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:443: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:443: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:468: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:468: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:468: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:494: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:494: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:494: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:517: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:517: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:517: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:534: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:534: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:534: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:549: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:549: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:549: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:561: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:561: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:561: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:572: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:572: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:572: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:587: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:587: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:587: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:604: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:604: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/arm/plat-omap/dmtimer.c:604: warning: parameter names (without types) in function declaration
arch/arm/plat-omap/dmtimer.c:746: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-omap/dmtimer.c:746: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:746: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
arch/arm/plat-omap/dmtimer.c:746: warning: function declaration isn't a prototype
arch/arm/plat-omap/dmtimer.c:747: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-omap/dmtimer.c:747: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:747: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
arch/arm/plat-omap/dmtimer.c:747: warning: function declaration isn't a prototype
arch/arm/plat-omap/dmtimer.c:748: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-omap/dmtimer.c:748: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:748: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
arch/arm/plat-omap/dmtimer.c:748: warning: function declaration isn't a prototype
arch/arm/plat-omap/dmtimer.c:749: error: expected declaration specifiers or '...' before string constant
arch/arm/plat-omap/dmtimer.c:749: warning: data definition has no type or storage class
arch/arm/plat-omap/dmtimer.c:749: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
arch/arm/plat-omap/dmtimer.c:749: warning: function declaration isn't a prototype
make[1]: *** [arch/arm/plat-omap/dmtimer.o] Error 1
make: *** [arch/arm/plat-omap] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I got the build error by make omap2plus_defconfig on linux-next 20111101.

 arch/arm/plat-omap/dmtimer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 2def4e1..af3b92b 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -35,6 +35,7 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/module.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-- 
1.7.5.4



