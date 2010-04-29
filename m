Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0D2A3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:29:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:43497 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754910Ab0D2A3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:29:53 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/HWFg9KprHCPKzQKcMSjiVfCrCoHuLxfdmznoo9N
	5lu/1l94I8vZBH
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: David Brown <davidb@codeaurora.org>
Subject: [PATCH] arm/mach-msm: Fix wrong include path.
Date: Thu, 29 Apr 2010 02:29:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, San Mehat <san@google.com>,
       Dima Zavin <dima@android.com>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290229.53378.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure[1] caused by a wrong include path.

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2535826/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100429

 arch/arm/mach-msm/devices.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/devices.c b/arch/arm/mach-msm/devices.c
index 29b1cd6..982f1da 100644
--- a/arch/arm/mach-msm/devices.c
+++ b/arch/arm/mach-msm/devices.c
@@ -24,7 +24,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
-#include <asm/mach/mmc.h>
+#include <mach/mmc.h>
 
 static struct resource resources_uart1[] = {
 	{
-- 
1.6.4.4

