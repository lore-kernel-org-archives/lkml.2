Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab1ANJoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:44:30 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:46889 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751530Ab1ANJoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:44:24 -0500
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux@simtec.co.uk, Ben Dooks <ben-linux@fluff.org>,
        Simtec Support <support@simtec.co.uk>
Subject: [PATCH 2/3] MAINTAINERS: Fixup file entries for "SIMTEC EB2410ITX (BAST)"
Date: Fri, 14 Jan 2011 09:44:14 +0000
Message-Id: <e9390dadfd1d6ba97a0ba7b19e16e5798b60dcba.1294998254.git.ben-linux@fluff.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
References: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
In-Reply-To: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
References: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the correct files for the Simtec BAST machine, ensuring the IDE and IRQ
routing are added, and move to the machine specific file instead of trying
to catch all of arch/arm/mach-s3c2410

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Simtec Linux Team <linux@simtec.co.uk>
Cc: Simtec Support <support@simtec.co.uk>
---
 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 464f0ec..4a99ddf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5566,7 +5566,9 @@ P:	Ben Dooks
 M:	Vincent Sanders <support@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
-F:	arch/arm/mach-s3c2410/
+F:	arch/arm/mach-s3c2410/mach-bast.c
+F:	arch/arm/mach-s3c2410/bast-ide.c
+F:	arch/arm/mach-s3c2410/bast-irq.c
 
 TI DAVINCI MACHINE SUPPORT
 M:	Kevin Hilman <khilman@deeprootsystems.com>
-- 
1.7.1

