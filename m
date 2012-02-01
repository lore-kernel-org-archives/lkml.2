Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab2BAEKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 23:10:53 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36444 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab2BAEKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 23:10:52 -0500
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 23:10:51 EST
X-Sasl-enc: bGCPtFD55GwqhLILhgvrrg9mvKd3uPTx6IALV/wqpvvN 1328068926
Date: Tue, 31 Jan 2012 20:02:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Greg's suse email address is dead
Message-ID: <20120201040200.GA3821@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My email address has changed, the suse.de one is now dead, so update all
of my MAINTAINER entries with the correct one so that patches don't get
lost.

Also change the status of some of my entries as I'm supposed to be doing
this stuff now for real.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/MAINTAINERS b/MAINTAINERS
index a1fce9a..252972b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -159,7 +159,7 @@ S:	Maintained
 F:	drivers/net/ethernet/realtek/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Maintained
@@ -1783,9 +1783,9 @@ X:	net/wireless/wext*
 
 CHAR and MISC DRIVERS
 M:	Arnd Bergmann <arnd@arndb.de>
-M:	Greg Kroah-Hartman <greg@kroah.com>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
-S:	Maintained
+S:	Supported
 F:	drivers/char/*
 F:	drivers/misc/*
 
@@ -2320,7 +2320,7 @@ F:	lib/lru_cache.c
 F:	Documentation/blockdev/drbd/
 
 DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git
 S:	Supported
 F:	Documentation/kobject.txt
@@ -6276,15 +6276,15 @@ S:	Maintained
 F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
-M:	Greg Kroah-Hartman <greg@kroah.com>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	stable@vger.kernel.org
-S:	Maintained
+S:	Supported
 
 STAGING SUBSYSTEM
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
 L:	devel@driverdev.osuosl.org
-S:	Maintained
+S:	Supported
 F:	drivers/staging/
 
 STAGING - AGERE HERMES II and II.5 WIRELESS DRIVERS
@@ -6669,8 +6669,8 @@ S:	Maintained
 K:	^Subject:.*(?i)trivial
 
 TTY LAYER
-M:	Greg Kroah-Hartman <gregkh@suse.de>
-S:	Maintained
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6.git
 F:	drivers/tty/
 F:	drivers/tty/serial/serial_core.c
@@ -6958,7 +6958,7 @@ S:	Maintained
 F:	drivers/usb/serial/digi_acceleport.c
 
 USB SERIAL DRIVER
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	Documentation/usb/usb-serial.txt
@@ -6973,9 +6973,8 @@ S:	Maintained
 F:	drivers/usb/serial/empeg.c
 
 USB SERIAL KEYSPAN DRIVER
-M:	Greg Kroah-Hartman <greg@kroah.com>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-usb@vger.kernel.org
-W:	http://www.kroah.com/linux/
 S:	Maintained
 F:	drivers/usb/serial/*keyspan*
 
@@ -7003,7 +7002,7 @@ F:	Documentation/video4linux/sn9c102.txt
 F:	drivers/media/video/sn9c102/
 
 USB SUBSYSTEM
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
@@ -7090,7 +7089,7 @@ F:	fs/hppfs/
 
 USERSPACE I/O (UIO)
 M:	"Hans J. Koch" <hjk@hansjkoch.de>
-M:	Greg Kroah-Hartman <gregkh@suse.de>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
