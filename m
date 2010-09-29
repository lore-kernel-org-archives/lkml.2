Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0I2JJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 05:09:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13049 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0I2JJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 05:09:15 -0400
Date: Wed, 29 Sep 2010 18:09:04 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH v3 2/2] MAINTAINERS: Add Samsung S5P series FIMC maintainers
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rmk@arm.linux.org.uk, kgene.kim@samsung.com, m.szyprowski@samsung.com,
        pawel@osciak.com, t.fujak@samsung.com, s.nawrocki@samsung.com
Message-id: <20100929090904.GA21199@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Sep 2010 09:09:12.0614 (UTC)
 FILETIME=[FBAA1C60:01CB5FB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Add Samsung S5P series FIMC(Camera Interface) maintainers

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
	Write the right maintainers

 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ae1797..1e233d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -977,6 +977,16 @@ L:	linux-arm-kernel@lists.infradead.org
 S:	Maintained
 F:	arch/arm/mach-s5pv310/mach-universal_c210.c
 
+ARM/SAMSUNG S5P SERIES FIMC SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	arch/arm/plat-s5p/dev-fimc*
+F:	arch/arm/plat-samsung/include/plat/*fimc*
+F:	drivers/media/video/s5p-fimc/
+
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
 M:	Magnus Damm <magnus.damm@gmail.com>
-- 
1.5.3.3

