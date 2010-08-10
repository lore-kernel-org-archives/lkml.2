Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0HJGqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 02:46:35 -0400
Received: from mail.perches.com ([173.55.12.10]:2354 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab0HJGqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 02:46:30 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] MAINTAINERS: Update ARM/S3C patterns
Date: Mon,  9 Aug 2010 23:46:28 -0700
Message-Id: <28b93faea32a3f5a3f79a68b92c60ba7dad99425.1281422516.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for merged SOCs

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 MAINTAINERS |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 832f904..13a6d02 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -908,20 +908,13 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
 
-ARM/S3C2440 ARM ARCHITECTURE
+ARM/S3C2440 and S3C2442 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
 
-ARM/S3C2442 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c2442/
-
 ARM/S3C2443 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -929,19 +922,12 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2443/
 
-ARM/S3C6400 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c6400/
-
-ARM/S3C6410 ARM ARCHITECTURE
+ARM/S3C64xx ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
-F:	arch/arm/mach-s3c6410/
+F:	arch/arm/mach-s3c64xx/
 
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
-- 
1.7.2.19.g9a302

