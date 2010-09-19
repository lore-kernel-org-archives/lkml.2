Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0ISXLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:11:13 -0400
Received: from mail.perches.com ([173.55.12.10]:2130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0ISXKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:10:36 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 2/6] MAINTAINERS: Merge imote2 and stargate
Date: Sun, 19 Sep 2010 16:10:30 -0700
Message-Id: <33b49e667f4b875a383dd5ba1db168b6ce8225ec.1284937055.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284937055.git.joe@perches.com>
References: <cover.1284937055.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed by commit dcd925f95194da42e42cea7e5f901f9746cf441c

CC: Jonathan Cameron <jic23@cam.ac.uk>
CC: Eric Miao <eric.y.miao@gmail.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a9f0567..03929b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -755,13 +755,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ixp4xx/
 
-ARM/INTEL RESEARCH IMOTE 2 MACHINE SUPPORT
-M:	Jonathan Cameron <jic23@cam.ac.uk>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/mach-pxa/imote2.c
-
-ARM/INTEL RESEARCH STARGATE 2 MACHINE SUPPORT
+ARM/INTEL RESEARCH IMOTE/STARGATE 2 MACHINE SUPPORT
 M:	Jonathan Cameron <jic23@cam.ac.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-- 
1.7.3.rc1

