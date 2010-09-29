Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0I2CwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 22:52:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40505 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0I2CwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 22:52:21 -0400
Date: Wed, 29 Sep 2010 11:52:00 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH 1/2] MAINTAINERS: Add Samsung Mobile Board maintainers
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rmk@arm.linux.org.uk, kgene.kim@samsung.com, m.szyprowski@samsung.com
Message-id: <20100929025200.GA7998@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Sep 2010 02:52:03.0960 (UTC)
 FILETIME=[4BEF8780:01CB5F81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Add Samsung Mobile Board, Aquila, Goni (SDK board), and Universal(C210) maintainers

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: kgene.kim@samsung.com
---
 MAINTAINERS |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 668682d..8ae1797 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -962,6 +962,21 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
 
+ARM/S5PC110 AQUILA,GONI MACHINE SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Marek Szyprowski <m.szyprowski@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org
+S:	Maintained
+F:	arch/arm/mach-s5pv210/mach-aquila.c
+F:	arch/arm/mach-s5pv210/mach-goni.c
+
+ARM/S5PC210 UNIVERSAL MACHINE SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Marek Szyprowski <m.szyprowski@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org
+S:	Maintained
+F:	arch/arm/mach-s5pv310/mach-universal_c210.c
+
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
 M:	Magnus Damm <magnus.damm@gmail.com>
-- 
1.5.3.3

