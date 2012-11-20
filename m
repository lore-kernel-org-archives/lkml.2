Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2KTJ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:26:18 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49648 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751817Ab2KTJ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:26:16 -0500
From: Constantine Shulyupin <const@MakeLinux.com>
To: paul@pwsan.com, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH] fix compilation error in cm_common.c
Date: Tue, 20 Nov 2012 11:25:53 +0200
Message-Id: <1353403553-13525-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.126.59.43 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Added required linux/errno.h

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 arch/arm/mach-omap2/cm_common.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/cm_common.c b/arch/arm/mach-omap2/cm_common.c
index 3246cef..3fafc27 100644
--- a/arch/arm/mach-omap2/cm_common.c
+++ b/arch/arm/mach-omap2/cm_common.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/errno.h>
 
 #include "cm2xxx.h"
 #include "cm3xxx.h"
-- 
1.7.9.5

