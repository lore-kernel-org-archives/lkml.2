Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1CZWiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 18:38:00 -0400
Received: from mail.perches.com ([173.55.12.10]:4292 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1CZWhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 18:37:47 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] MAINTAINERS: Update various tty patterns
Date: Sat, 26 Mar 2011 15:37:43 -0700
Message-Id: <6780ef6ee0a6129692b162251a15cee44a5e9347.1301178998.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <1d67762792f7d409375f5a29c2159f39164ac166.1301178998.git.joe@perches.com>
References: <1d67762792f7d409375f5a29c2159f39164ac166.1301178998.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 4a6514e6d0
("tty: move obsolete and broken tty drivers to drivers/staging/tty/")
and a6afd9f3e8
("tty: move a number of tty drivers from drivers/char/ to drivers/tty/")
moved files around.

Update patterns and orphan some files that were moved to staging.

cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 735f124..a512d04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -184,10 +184,9 @@ F:	Documentation/filesystems/9p.txt
 F:	fs/9p/
 
 A2232 SERIAL BOARD DRIVER
-M:	Enver Haase <A2232@gmx.net>
 L:	linux-m68k@lists.linux-m68k.org
-S:	Maintained
-F:	drivers/char/ser_a2232*
+S:	Orphan
+F:	drivers/staging/generic_serial/ser_a2232*
 
 AACRAID SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
@@ -1833,11 +1832,10 @@ S:	Maintained
 F:	drivers/platform/x86/compal-laptop.c
 
 COMPUTONE INTELLIPORT MULTIPORT CARD
-M:	"Michael H. Warfield" <mhw@wittsend.com>
 W:	http://www.wittsend.com/computone.html
-S:	Maintained
+S:	Orphan
 F:	Documentation/serial/computone.txt
-F:	drivers/char/ip2/
+F:	drivers/staging/tty/ip2/
 
 CONEXANT ACCESSRUNNER USB DRIVER
 M:	Simon Arlott <cxacru@fire.lp0.eu>
@@ -2020,7 +2018,7 @@ F:	drivers/net/wan/cycx*
 CYCLADES ASYNC MUX DRIVER
 W:	http://www.cyclades.com/
 S:	Orphan
-F:	drivers/char/cyclades.c
+F:	drivers/tty/cyclades.c
 F:	include/linux/cyclades.h
 
 CYCLADES PC300 DRIVER
@@ -2134,8 +2132,8 @@ L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphan
 F:	Documentation/serial/digiepca.txt
-F:	drivers/char/epca*
-F:	drivers/char/digi*
+F:	drivers/staging/tty/epca*
+F:	drivers/staging/tty/digi*
 
 DIOLAN U2C-12 I2C DRIVER
 M:	Guenter Roeck <guenter.roeck@ericsson.com>
@@ -4218,7 +4216,7 @@ MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	Documentation/serial/moxa-smartio
-F:	drivers/char/mxser.*
+F:	drivers/tty/mxser.*
 
 MSI LAPTOP SUPPORT
 M:	"Lee, Chun-Yi" <jlee@novell.com>
@@ -4260,7 +4258,7 @@ F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
 S:	Orphan
-F:	drivers/char/isicom.c
+F:	drivers/tty/isicom.c
 F:	include/linux/isicom.h
 
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
@@ -5299,14 +5297,14 @@ F:	drivers/memstick/host/r592.*
 RISCOM8 DRIVER
 S:	Orphan
 F:	Documentation/serial/riscom8.txt
-F:	drivers/char/riscom8*
+F:	drivers/staging/tty/riscom8*
 
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
 S:	Maintained
 F:	Documentation/serial/rocket.txt
-F:	drivers/char/rocket*
+F:	drivers/tty/rocket*
 
 ROSE NETWORK LAYER
 M:	Ralf Baechle <ralf@linux-mips.org>
@@ -5942,10 +5940,9 @@ F:	arch/arm/mach-spear6xx/spear600.c
 F:	arch/arm/mach-spear6xx/spear600_evb.c
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
-M:	Roger Wolff <R.E.Wolff@BitWizard.nl>
-S:	Supported
+S:	Orphan
 F:	Documentation/serial/specialix.txt
-F:	drivers/char/specialix*
+F:	drivers/staging/tty/specialix*
 
 SPI SUBSYSTEM
 M:	David Brownell <dbrownell@users.sourceforge.net>
-- 
1.7.4.2.g597a6.dirty

