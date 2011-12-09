Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1LIEWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:22:08 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54582 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753503Ab1LIEWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:22:03 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v3.2 01/10] MAINTAINERS: Update various arm F: patterns
Date: Thu,  8 Dec 2011 20:21:39 -0800
Message-Id: <93140a66f3e5446d224acafa30e4a3b9a6727f3e.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Track renames and missing or deleted files.

CC: Russell King <linux@arm.linux.org.uk>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b4f1802..7daf771 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -919,7 +919,6 @@ M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Nicolas Pitre <nico@fluxnic.net>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Odd Fixes
-F:	arch/arm/mach-loki/
 F:	arch/arm/mach-kirkwood/
 F:	arch/arm/mach-mv78xx0/
 F:	arch/arm/mach-orion5x/
@@ -1081,8 +1080,8 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-s5pv210/mach-aquila.c
 F:	arch/arm/mach-s5pv210/mach-goni.c
-F:	arch/arm/mach-exynos4/mach-universal_c210.c
-F:	arch/arm/mach-exynos4/mach-nuri.c
+F:	arch/arm/mach-exynos/mach-universal_c210.c
+F:	arch/arm/mach-exynos/mach-nuri.c
 
 ARM/SAMSUNG S5P SERIES FIMC SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -1110,7 +1109,6 @@ M:	Tomasz Stanislawski <t.stanislaws@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-tv.c
 F:	drivers/media/video/s5p-tv/
 
 ARM/SHMOBILE ARM ARCHITECTURE
@@ -1152,7 +1150,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.mcuos.com
 S:	Maintained
 F:	arch/arm/mach-w90x900/
-F:	arch/arm/mach-nuc93x/
 F:	drivers/input/keyboard/w90p910_keypad.c
 F:	drivers/input/touchscreen/w90p910_ts.c
 F:	drivers/watchdog/nuc900_wdt.c
@@ -6186,9 +6183,7 @@ M:	Viresh Kumar <viresh.kumar@st.com>
 W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/mach-spear*/clock.c
-F:	arch/arm/mach-spear*/include/mach/clkdev.h
 F:	arch/arm/plat-spear/clock.c
-F:	arch/arm/plat-spear/include/plat/clkdev.h
 F:	arch/arm/plat-spear/include/plat/clock.h
 
 SPEAR PAD MULTIPLEXING SUPPORT
-- 
1.7.8.111.gad25c.dirty

