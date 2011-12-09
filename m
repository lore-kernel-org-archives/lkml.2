Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab1LIINb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:13:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58576 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751313Ab1LIIN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:13:29 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/8] MAINTAINERS: staging: tty: Update F: patterns
Date: Fri,  9 Dec 2011 00:12:49 -0800
Message-Id: <7a0202ecba6df6fc98651422a0dc7e0b7e79f513.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 51c9d654c2d ("Staging: delete tty drivers")
removed the files, delete the sections too.

CC: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 149c676..8a889b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1895,12 +1895,6 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/compal-laptop.c
 
-COMPUTONE INTELLIPORT MULTIPORT CARD
-W:	http://www.wittsend.com/computone.html
-S:	Orphan
-F:	Documentation/serial/computone.txt
-F:	drivers/staging/tty/ip2/
-
 CONEXANT ACCESSRUNNER USB DRIVER
 M:	Simon Arlott <cxacru@fire.lp0.eu>
 L:	accessrunner-general@lists.sourceforge.net
@@ -2204,15 +2198,6 @@ F:	drivers/md/dm*
 F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 
-DIGI INTL. EPCA DRIVER
-M:	"Digi International, Inc" <Eng.Linux@digi.com>
-L:	Eng.Linux@digi.com
-W:	http://www.digi.com
-S:	Orphan
-F:	Documentation/serial/digiepca.txt
-F:	drivers/staging/tty/epca*
-F:	drivers/staging/tty/digi*
-
 DIOLAN U2C-12 I2C DRIVER
 M:	Guenter Roeck <guenter.roeck@ericsson.com>
 L:	linux-i2c@vger.kernel.org
@@ -5533,11 +5518,6 @@ M:	Maxim Levitsky <maximlevitsky@gmail.com>
 S:	Maintained
 F:	drivers/memstick/host/r592.*
 
-RISCOM8 DRIVER
-S:	Orphan
-F:	Documentation/serial/riscom8.txt
-F:	drivers/staging/tty/riscom8*
-
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
@@ -6198,11 +6178,6 @@ F:	arch/arm/mach-spear3xx/spear3*0_evb.c
 F:	arch/arm/mach-spear6xx/spear600.c
 F:	arch/arm/mach-spear6xx/spear600_evb.c
 
-SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
-S:	Orphan
-F:	Documentation/serial/specialix.txt
-F:	drivers/staging/tty/specialix*
-
 SPI SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
-- 
1.7.8.111.gad25c.dirty

