Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1FEHMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:12:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57121 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1FEHMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:12:05 -0400
Subject: [RFC PATCH] MAINTAINERS: Saying goodbye to David Brownell
To: joe@perches.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 05 Jun 2011 01:12:03 -0600
Message-ID: <20110605071058.25982.76948.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had to say goodbye when David passed away recently.  David had a
huge impact on our community, both personally in the lives of the
people he worked with, and technically in the design and maintenance
of several subsystems.  He is greatly missed.

He also leaves behind a number of much loved subsystems now orphaned.
This patch updates the MAINTAINERS file for the areas that David was
responsible for.  While it removes Davids name from the MAINTAINERS
file, it by no mean should be seen as forgetting David's involvement
or the work he's accomplished.  Indeed, his name remains prominent
in the changelog and copyright notices of many files in the kernel.

Rather, this is intended to highlight the work that David accomplished
and to ask for volunteers to pick up from where David left off.

g.

---
 MAINTAINERS |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..fb02949 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4252,8 +4252,7 @@ F:	drivers/mmc/
 F:	include/linux/mmc/
 
 MULTIMEDIA CARD (MMC) ETC. OVER SPI
-M:	David Brownell <dbrownell@users.sourceforge.net>
-S:	Odd Fixes
+S:	Orphan
 F:	drivers/mmc/host/mmc_spi.c
 F:	include/linux/spi/mmc_spi.h
 
@@ -4603,7 +4602,6 @@ F:	drivers/media/video/omap3isp/*
 
 OMAP USB SUPPORT
 M:	Felipe Balbi <balbi@ti.com>
-M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
@@ -5984,7 +5982,6 @@ F:	Documentation/serial/specialix.txt
 F:	drivers/staging/tty/specialix*
 
 SPI SUBSYSTEM
-M:	David Brownell <dbrownell@users.sourceforge.net>
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
@@ -6432,9 +6429,8 @@ S:	Maintained
 F:	drivers/usb/misc/rio500*
 
 USB EHCI DRIVER
-M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
-S:	Odd Fixes
+S:	Orphan
 F:	Documentation/usb/ehci.txt
 F:	drivers/usb/host/ehci*
 
@@ -6448,10 +6444,9 @@ S:	Maintained
 F:	drivers/media/video/et61x251/
 
 USB GADGET/PERIPHERAL SUBSYSTEM
-M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org/gadget
-S:	Maintained
+S:	Orphan
 F:	drivers/usb/gadget/
 F:	include/linux/usb/gadget*
 
@@ -6492,9 +6487,8 @@ S:	Maintained
 F:	sound/usb/midi.*
 
 USB OHCI DRIVER
-M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
-S:	Odd Fixes
+S:	Orphan
 F:	Documentation/usb/ohci.txt
 F:	drivers/usb/host/ohci*
 

