Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0ISXKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:10:37 -0400
Received: from mail.perches.com ([173.55.12.10]:2125 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab0ISXKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:10:36 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH 1/6] MAINTAINERS: Fix Colibri PXA270 file pattern
Date: Sun, 19 Sep 2010 16:10:29 -0700
Message-Id: <53d7035ee03a9d1e9615df8b883349af083d280b.1284937055.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284937055.git.joe@perches.com>
References: <cover.1284937055.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original commit 403d29713e0a5c671d852913a0b5935c0ff00cb7 started
with the wrong file pattern.

CC: Marek Vasut <marek.vasut@gmail.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4c14636..a9f0567 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -708,8 +708,7 @@ ARM/INCOME PXA270 SUPPORT
 M:	Marek Vasut <marek.vasut@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/mach-pxa/income.c
-F:	arch/arm/mach-pxa/include/mach-pxa/income.h
+F:	arch/arm/mach-pxa/colibri-pxa270-income.c
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-- 
1.7.3.rc1

