Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0ISXLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:11:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2134 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab0ISXKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:10:36 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 4/6] MAINTAINERS: Merge s3c6400 and 6410 to 64xx
Date: Sun, 19 Sep 2010 16:10:32 -0700
Message-Id: <dd27452d35e70fef18f9228f42b644a69fdeb7b3.1284937055.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284937055.git.joe@perches.com>
References: <cover.1284937055.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed by commit 431107ea5b680a24a4d01fbd3a178a3eb932f378

CC: Ben Dooks <ben-linux@fluff.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a887d83..5011ac4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -928,19 +928,12 @@ S:	Maintained
 F:	arch/arm/mach-s3c2440/
 F:	arch/arm/mach-s3c2443/
 
-ARM/S3C6400 ARM ARCHITECTURE
+ARM/S3C64xx ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
-F:	arch/arm/mach-s3c6400/
-
-ARM/S3C6410 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c6410/
+F:	arch/arm/mach-s3c64xx/
 
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
-- 
1.7.3.rc1

