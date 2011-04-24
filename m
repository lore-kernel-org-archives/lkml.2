Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1DXIiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 04:38:08 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42636 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab1DXIiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 04:38:04 -0400
Date: Sun, 24 Apr 2011 10:38:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Roman Zippel <zippel@linux-m68k.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Roman Zippel has been MIA for several years.
Message-ID: <alpine.DEB.2.00.1104241036570.16333@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hence make AFFS and HFS orphans, and remove him as an m68k maintainer.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 MAINTAINERS |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ec36003..0a84d29 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -404,8 +404,8 @@ S:	Maintained
 F:	sound/oss/aedsp16.c
 
 AFFS FILE SYSTEM
-M:	Roman Zippel <zippel@linux-m68k.org>
-S:	Maintained
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
 F:	Documentation/filesystems/affs.txt
 F:	fs/affs/
 
@@ -2943,8 +2943,8 @@ F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
 
 HFS FILESYSTEM
-M:	Roman Zippel <zippel@linux-m68k.org>
-S:	Maintained
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
 
@@ -3992,7 +3992,6 @@ F:	arch/m32r/
 
 M68K ARCHITECTURE
 M:	Geert Uytterhoeven <geert@linux-m68k.org>
-M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
