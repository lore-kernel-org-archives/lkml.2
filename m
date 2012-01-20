Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2ATUgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:36:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47213 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756060Ab2ATUgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:36:45 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Amit Kucheria <amit.kucheria@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/5] MAINTAINERS: Remove iMX5 section
Date: Fri, 20 Jan 2012 12:36:18 -0800
Message-Id: <5ba44157a422cee8a4bc3ebf1ec00b0d99c5ba10.1327091633.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327091633.git.joe@perches.com>
References: <cover.1327091633.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 784a90c0a7d8f5 ("ARM i.MX: Merge i.MX5 support into mach-imx")
merged the files, remove the iMX5 section.

cc: Amit Kucheria <amit.kucheria@canonical.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a37165b..39d9e78 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -789,12 +789,6 @@ F:	arch/arm/mach-mx*/
 F:	arch/arm/mach-imx/
 F:	arch/arm/plat-mxc/
 
-ARM/FREESCALE IMX51
-M:	Amit Kucheria <amit.kucheria@canonical.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/mach-mx5/
-
 ARM/FREESCALE IMX6
 M:	Shawn Guo <shawn.guo@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.7.8.111.gad25c.dirty

