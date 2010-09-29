Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0I2Dqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:46:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43844 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab0I2Dqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:46:30 -0400
Date: Wed, 29 Sep 2010 12:46:04 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH v2 2/2] MAINTAINERS: Add Samsung S5P series FIMC maintainers
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rmk@arm.linux.org.uk, kgene.kim@samsung.com, m.szyprowski@samsung.com,
        pawel@osciak.com, t.fujak@samsung.com, joe@perches.com
Message-id: <20100929034604.GA8159@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Sep 2010 03:46:09.0005 (UTC)
 FILETIME=[DA2219D0:01CB5F88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Add Samsung S5P series FIMC(Camera Interface) maintainers

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8ae1797..3cdcf49 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -977,6 +977,17 @@ L:	linux-arm-kernel@lists.infradead.org
 S:	Maintained
 F:	arch/arm/mach-s5pv310/mach-universal_c210.c
 
+ARM/S5P SERIES FIMC SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Pawel Osciak <pawel@osciak.com>
+M:	Tomasz Fujak <t.fujak@samsung.com>
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

