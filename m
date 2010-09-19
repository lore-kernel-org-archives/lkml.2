Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0ISXLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:11:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2131 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab0ISXKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:10:36 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 3/6] MAINTAINERS: Merge s3c-244x sections
Date: Sun, 19 Sep 2010 16:10:31 -0700
Message-Id: <5223bb179da804659b4c0d8332488535200fe13c.1284937055.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284937055.git.joe@perches.com>
References: <cover.1284937055.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed by commit 70556b143ae4cf404a73c2461a6bf7fef3fefbf7

CC: Ben Dooks <ben-linux@fluff.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03929b5..a887d83 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -920,25 +920,12 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
 
-ARM/S3C2440 ARM ARCHITECTURE
+ARM/S3C244x ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
-
-ARM/S3C2442 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
-F:	arch/arm/mach-s3c2442/
-
-ARM/S3C2443 ARM ARCHITECTURE
-M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.fluff.org/ben/linux/
-S:	Maintained
 F:	arch/arm/mach-s3c2443/
 
 ARM/S3C6400 ARM ARCHITECTURE
-- 
1.7.3.rc1

