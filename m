Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1JBNrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 09:47:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1JBNrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 09:47:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/11] ARM: include linux/highmem.h in uaccess functions
Date: Sun, 02 Oct 2011 15:46:32 +0200
Message-ID: <1894078.P7yYjKNL5t@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IYMmO/rAC0Zwvr1wKDRCNsIrVfNU0vxzwCc/ZvOGsV6
 wN2nua1ZrlvrIsOmR3Yv878qf9WaWxVPLbG8w3ZE6+TmZmcUrF
 1vgJbSTybHY66l/xGnYbeCsD4fm213ty55lKktoEv3rDbtI/zR
 X3GJw189uxoN+3fVmxpwi1eWmnPE1PkQjazkzdBLBemAek07CW
 s8abetuvzdE5MmsG+ca3nlxyzzYTHfhX25TJHHsnx7+VpgGpRV
 2iKI/fC6IXii5WqUDHUX+rILYkugEKZ+kfYq/6hxqp9CL+hfR/
 jbQGMyQPsykwPjrC2L1Fh6nM+OXyuLT8sl+CDWNB1BeCmO3qJ+
 NfllJd7t3Lm4scqQcUJ4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When highpte support is enabled, this is required to build
the kernel.
    
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
I was missing this patch at first, but now found it in the omap branch.

diff --git a/arch/arm/lib/uaccess_with_memcpy.c b/arch/arm/lib/uaccess_with_memcpy.c
index 8b9b136..025f742 100644
--- a/arch/arm/lib/uaccess_with_memcpy.c
+++ b/arch/arm/lib/uaccess_with_memcpy.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <linux/hardirq.h> /* for in_atomic() */
 #include <linux/gfp.h>
+#include <linux/highmem.h>
 #include <asm/current.h>
 #include <asm/page.h>
 
