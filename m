Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab0FITks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:40:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2940 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377Ab0FITio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:44 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH 03/12] MAINTAINERS: Update ARM/VOIPAC PXA270 file patterns
Date: Wed,  9 Jun 2010 12:38:29 -0700
Message-Id: <b37a125e2205a491313b7ed3dff4bfdaad6a86fe.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9046e97..eaffcbe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1008,7 +1008,7 @@ M:	Marek Vasut <marek.vasut@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-pxa/vpac270.c
-F:	arch/arm/mach-pxa/include/mach-pxa/vpac270.h
+F:	arch/arm/mach-pxa/include/mach/vpac270.h
 
 ARM/ZIPIT Z2 SUPPORT
 M:	Marek Vasut <marek.vasut@gmail.com>
-- 
1.7.1.244.gbdc4

