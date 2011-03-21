Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1CUBpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 21:45:46 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:45606 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1CUBpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 21:45:43 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] MAINTAINERS: Add EXYNOS ARM Architectures
Date: Mon, 21 Mar 2011 10:10:39 +0900
Message-Id: <1300669839-9778-1-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c7a41b1..0a78b7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1020,12 +1020,13 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c64xx/
 
-ARM/S5P ARM ARCHITECTURES
+ARM/S5P EXYNOS ARM ARCHITECTURES
 M:	Kukjin Kim <kgene.kim@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-s5p*/
+F:	arch/arm/mach-exynos*/
 
 ARM/SAMSUNG MOBILE MACHINE SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
-- 
1.7.1

