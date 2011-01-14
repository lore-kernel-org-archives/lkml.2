Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1ANJoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:44:38 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:46891 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752070Ab1ANJoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:44:24 -0500
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux@simtec.co.uk, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 1/3] MAINTAINERS: Move s3c2410 drivers to ARM/SAMSUNG ARM
Date: Fri, 14 Jan 2011 09:44:13 +0000
Message-Id: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currnetly two entries under the "SIMTEC EB2410ITX (BAST)"
machine entry for drivers/*/*s3c2410*, which is catching everything
s3c2410 driver related.

This entry is for a specific S3C2410 based machine, so move these two
file entries to the "ARM/SAMSUNG ARM ARCHITECTURES" entry, where it
will reach a wider audience of interested parties.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Simtec Linux Team <linux@simtec.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 64d7621..464f0ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -975,6 +975,8 @@ S:	Maintained
 F:	arch/arm/plat-samsung/
 F:	arch/arm/plat-s3c24xx/
 F:	arch/arm/plat-s5p/
+F:	drivers/*/*s3c2410*
+F:	drivers/*/*/*s3c2410*
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
@@ -5565,8 +5567,6 @@ M:	Vincent Sanders <support@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
 F:	arch/arm/mach-s3c2410/
-F:	drivers/*/*s3c2410*
-F:	drivers/*/*/*s3c2410*
 
 TI DAVINCI MACHINE SUPPORT
 M:	Kevin Hilman <khilman@deeprootsystems.com>
-- 
1.7.1

