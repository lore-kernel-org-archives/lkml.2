Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab0I1GG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:06:26 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:57968 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab0I1GGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:06:25 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, rmk@arm.linux.org.uk,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] MAINTAINERS: Updates maintainer for S5P ARM ARCHITECTURES
Date: Tue, 28 Sep 2010 14:46:36 +0900
Message-Id: <1285652796-24558-1-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c36f5d7..acad9b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -962,6 +962,13 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
 
+ARM/S5P ARM ARCHITECTURES
+M:	Kukjin Kim <kgene.kim@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-s5p*/
+
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
 M:	Magnus Damm <magnus.damm@gmail.com>
-- 
1.6.2.5

