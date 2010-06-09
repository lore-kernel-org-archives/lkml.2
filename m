Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab0FITka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:40:30 -0400
Received: from mail.perches.com ([173.55.12.10]:2943 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab0FITip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:45 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH 04/12] MAINTAINERS: Update ARM/ZIPIT Z2 SUPPORT file patterns
Date: Wed,  9 Jun 2010 12:38:30 -0700
Message-Id: <70f0ddd940aadb78d4de10c5fdaa837b0fb335b9.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use correct file location

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eaffcbe..6facecc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1015,7 +1015,7 @@ M:	Marek Vasut <marek.vasut@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-pxa/z2.c
-F:	arch/arm/mach-pxa/include/mach-pxa/z2.h
+F:	arch/arm/mach-pxa/include/mach/z2.h
 
 ASC7621 HARDWARE MONITOR DRIVER
 M:	George Joseph <george.joseph@fairview5.com>
-- 
1.7.1.244.gbdc4

