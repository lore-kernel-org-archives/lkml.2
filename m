Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0FITjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:39:16 -0400
Received: from mail.perches.com ([173.55.12.10]:2944 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab0FITis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:48 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 09/12] MAINTAINERS: Update SPEAR CLOCK FRAMEWORK SUPPORT file patterns
Date: Wed,  9 Jun 2010 12:38:35 -0700
Message-Id: <f6763204e6230cd9d098acfa85d1b8c1b2dbd686.1276112118.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8aac474..6402d30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5354,7 +5354,8 @@ S:	Maintained
 F:	arch/arm/mach-spear*/clock.c
 F:	arch/arm/mach-spear*/include/mach/clkdev.h
 F:	arch/arm/plat-spear/clock.c
-F:	arch/arm/plat-spear/include/plat/clock.h and clkdev.h
+F:	arch/arm/plat-spear/include/plat/clkdev.h
+F:	arch/arm/plat-spear/include/plat/clock.h
 
 SPEAR PAD MULTIPLEXING SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
-- 
1.7.1.244.gbdc4

