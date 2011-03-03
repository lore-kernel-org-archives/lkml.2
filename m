Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1CCFqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:46:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54420 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1CCFqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:46:08 -0500
Date: Thu, 03 Mar 2011 14:45:38 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] Add maintainer of Samsung Mobile Machine support
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <20110303054538.GA21727@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 03 Mar 2011 05:45:44.0247 (UTC)
 FILETIME=[3CF06470:01CBD966]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Add maintainer of Samsung Mobile machine support.
Currently, Aquila, Goni, Universal (C210), and Nuri board are supported.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 8afba63..c306ab8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1010,6 +1010,15 @@ L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-s5p*/
 
+ARM/SAMSUNG MOBILE MACHINE SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-s5pv210/mach-aquila.c
+F:	arch/arm/mach-s5pv210/mach-goni.c
+F:	arch/arm/mach-exynos4/mach-universal_c210.c
+F:	arch/arm/mach-exynos4/mach-nuri.c
+
 ARM/SAMSUNG S5P SERIES FIMC SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
