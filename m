Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0GRM1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 08:27:30 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43396 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754627Ab0GRM10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 08:27:26 -0400
Date: Sun, 18 Jul 2010 14:27:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>,
        trivial@kernel.org
Subject: [patch] update email address 
Message-ID: <20100718122713.GA28199@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pavel@suse.cz no longer works, replace it with working address.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c268783..1a0fc32 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -93,7 +93,7 @@ Why:	Broken design for runtime control over driver power states, confusing
 	inputs.  This framework was never widely used, and most attempts to
 	use it were broken.  Drivers should instead be exposing domain-specific
 	interfaces either to kernel or to userspace.
-Who:	Pavel Machek <pavel@suse.cz>
+Who:	Pavel Machek <pavel@ucw.cz>
 
 ---------------------------
 
diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index 681ec22..a4a8fc5 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -1,7 +1,7 @@
 /* Disk protection for HP machines.
  *
  * Copyright 2008 Eric Piel
- * Copyright 2009 Pavel Machek <pavel@suse.cz>
+ * Copyright 2009 Pavel Machek <pavel@ucw.cz>
  *
  * GPLv2.
  */
diff --git a/Documentation/power/tricks.txt b/Documentation/power/tricks.txt
index 3b26bb5..a1b8f72 100644
--- a/Documentation/power/tricks.txt
+++ b/Documentation/power/tricks.txt
@@ -1,6 +1,6 @@
 	swsusp/S3 tricks
 	~~~~~~~~~~~~~~~~
-Pavel Machek <pavel@suse.cz>
+Pavel Machek <pavel@ucw.cz>
 
 If you want to trick swsusp/S3 into working, you might want to try:
 
diff --git a/Documentation/sparse.txt b/Documentation/sparse.txt
index 9b659c7..4909d41 100644
--- a/Documentation/sparse.txt
+++ b/Documentation/sparse.txt
@@ -1,5 +1,5 @@
 Copyright 2004 Linus Torvalds
-Copyright 2004 Pavel Machek <pavel@suse.cz>
+Copyright 2004 Pavel Machek <pavel@ucw.cz>
 Copyright 2006 Bob Copeland <me@bobcopeland.com>
 
 Using sparse for typechecking
diff --git a/Documentation/zh_CN/sparse.txt b/Documentation/zh_CN/sparse.txt
index 75992a6..cc144e5 100644
--- a/Documentation/zh_CN/sparse.txt
+++ b/Documentation/zh_CN/sparse.txt
@@ -22,7 +22,7 @@ Documentation/sparse.txt çä¸­ćçżťčŻ
 ---------------------------------------------------------------------
 
 Copyright 2004 Linus Torvalds
-Copyright 2004 Pavel Machek <pavel@suse.cz>
+Copyright 2004 Pavel Machek <pavel@ucw.cz>
 Copyright 2006 Bob Copeland <me@bobcopeland.com>
 
 ä˝żç¨ sparse ĺˇĽĺˇĺçąťĺćŁćĽ
diff --git a/arch/arm/mach-sa1100/collie.c b/arch/arm/mach-sa1100/collie.c
index 5d5f330..16e682d 100644
--- a/arch/arm/mach-sa1100/collie.c
+++ b/arch/arm/mach-sa1100/collie.c
@@ -11,7 +11,7 @@
  * published by the Free Software Foundation.
  *
  * ChangeLog:
- *  2006 Pavel Machek <pavel@suse.cz>
+ *  2006 Pavel Machek <pavel@ucw.cz>
  *  03-06-2004 John Lenz <lenz@cs.wisc.edu>
  *  06-04-2002 Chris Larson <kergoth@digitalnemesis.net>
  *  04-16-2001 Lineo Japan,Inc. ...
diff --git a/arch/powerpc/kernel/suspend.c b/arch/powerpc/kernel/suspend.c
index 6fc6328..0167d53 100644
--- a/arch/powerpc/kernel/suspend.c
+++ b/arch/powerpc/kernel/suspend.c
@@ -3,7 +3,7 @@
  *
  * Distribute under GPLv2
  *
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2002 Pavel Machek <pavel@ucw.cz>
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 82e5086..f51cc55 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -2,7 +2,7 @@
  * sleep.c - x86-specific ACPI sleep support.
  *
  *  Copyright (C) 2001-2003 Patrick Mochel
- *  Copyright (C) 2001-2003 Pavel Machek <pavel@suse.cz>
+ *  Copyright (C) 2001-2003 Pavel Machek <pavel@ucw.cz>
  */
 
 #include <linux/acpi.h>
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index c4f9182..4c9c67b 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -140,7 +140,7 @@
  *         is now the way life works).
  *         Fix thinko in suspend() (wrong return).
  *         Notify drivers on critical suspend.
- *         Make kapmd absorb more idle time (Pavel Machek <pavel@suse.cz>
+ *         Make kapmd absorb more idle time (Pavel Machek <pavel@ucw.cz>
  *         modified by sfr).
  *         Disable interrupts while we are suspended (Andy Henroid
  *         <andy_henroid@yahoo.com> fixed by sfr).
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 7ec2123..0af9aa2 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -9,7 +9,7 @@
  *  Based on the powernow-k7.c module written by Dave Jones.
  *  (C) 2003 Dave Jones on behalf of SuSE Labs
  *  (C) 2004 Dominik Brodowski <linux@brodo.de>
- *  (C) 2004 Pavel Machek <pavel@suse.cz>
+ *  (C) 2004 Pavel Machek <pavel@ucw.cz>
  *  Licensed under the terms of the GNU GPL License version 2.
  *  Based upon datasheets & sample CPUs kindly provided by AMD.
  *
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ee41bba..9a66746 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -2,7 +2,7 @@
  *  linux/arch/x86_64/mm/init.c
  *
  *  Copyright (C) 1995  Linus Torvalds
- *  Copyright (C) 2000  Pavel Machek <pavel@suse.cz>
+ *  Copyright (C) 2000  Pavel Machek <pavel@ucw.cz>
  *  Copyright (C) 2002,2003 Andi Kleen <ak@suse.de>
  */
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 1290ba5..e7e8c5f 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -4,7 +4,7 @@
  * Distribute under GPLv2
  *
  * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2002 Pavel Machek <pavel@ucw.cz>
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index d24f983..460f314 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -4,7 +4,7 @@
  * Distribute under GPLv2
  *
  * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
- * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2002 Pavel Machek <pavel@ucw.cz>
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 218d091..16c3c86 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -4,7 +4,7 @@
  * Note that you can not swap over this thing, yet. Seems to work but
  * deadlocks sometimes - you can not swap over TCP in general.
  * 
- * Copyright 1997-2000, 2008 Pavel Machek <pavel@suse.cz>
+ * Copyright 1997-2000, 2008 Pavel Machek <pavel@ucw.cz>
  * Parts copyright 2001 Steven Whitehouse <steve@chygwyn.com>
  *
  * This file is released under GPLv2 or later.
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index 6030410..5d6fd01 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -2,7 +2,7 @@
  * USB ViCam WebCam driver
  * Copyright (c) 2002 Joe Burks (jburks@wavicle.org),
  *                    Christopher L Cheney (ccheney@cheney.cx),
- *                    Pavel Machek (pavel@suse.cz),
+ *                    Pavel Machek (pavel@ucw.cz),
  *                    John Tyner (jtyner@cs.ucr.edu),
  *                    Monroe Williams (monroe@pobox.com)
  *
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 9004a5f..d2f20c2 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -5,7 +5,7 @@
  * Copyright (C) 1997-2000  Jakub Jelinek  (jakub@redhat.com)
  * Copyright (C) 1998  Eddie C. Dost  (ecd@skynet.be)
  * Copyright (C) 2001,2002  Andi Kleen, SuSE Labs
- * Copyright (C) 2003       Pavel Machek (pavel@suse.cz)
+ * Copyright (C) 2003       Pavel Machek (pavel@ucw.cz)
  * Copyright (C) 2005       Philippe De Muyter (phdm@macqel.be)
  * Copyright (C) 2008       Hans Verkuil <hverkuil@xs4all.nl>
  *
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 681419d..251caa0 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2008 Pavel Machek <pavel@suse.cz>
+ * Copyright 2008 Pavel Machek <pavel@ucw.cz>
  *
  * Distribute under GPLv2.
  *
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 61d7550..8413a56 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -2,7 +2,7 @@
  * cdc-acm.c
  *
  * Copyright (c) 1999 Armin Fuerst	<fuerst@in.tum.de>
- * Copyright (c) 1999 Pavel Machek	<pavel@suse.cz>
+ * Copyright (c) 1999 Pavel Machek	<pavel@ucw.cz>
  * Copyright (c) 1999 Johannes Erdfelt	<johannes@erdfelt.com>
  * Copyright (c) 2000 Vojtech Pavlik	<vojtech@suse.cz>
  * Copyright (c) 2004 Oliver Neukum	<oliver@neukum.name>
diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 2250095..84f9e52 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -2,7 +2,7 @@
  * usblp.c
  *
  * Copyright (c) 1999 Michael Gee	<michael@linuxspecific.com>
- * Copyright (c) 1999 Pavel Machek	<pavel@suse.cz>
+ * Copyright (c) 1999 Pavel Machek	<pavel@ucw.cz>
  * Copyright (c) 2000 Randy Dunlap	<rdunlap@xenotime.net>
  * Copyright (c) 2000 Vojtech Pavlik	<vojtech@suse.cz>
  # Copyright (c) 2001 Pete Zaitcev	<zaitcev@redhat.com>
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 7571bc2..d2f5901 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -2,7 +2,7 @@
  * Backlight control code for Sharp Zaurus SL-5500
  *
  * Copyright 2005 John Lenz <lenz@cs.wisc.edu>
- * Maintainer: Pavel Machek <pavel@suse.cz> (unless John wants to :-)
+ * Maintainer: Pavel Machek <pavel@ucw.cz> (unless John wants to :-)
  * GPL v2
  *
  * This driver assumes single CPU. That's okay, because collie is
@@ -246,6 +246,6 @@ static void __exit locomolcd_exit(void)
 module_init(locomolcd_init);
 module_exit(locomolcd_exit);
 
-MODULE_AUTHOR("John Lenz <lenz@cs.wisc.edu>, Pavel Machek <pavel@suse.cz>");
+MODULE_AUTHOR("John Lenz <lenz@cs.wisc.edu>, Pavel Machek <pavel@ucw.cz>");
 MODULE_DESCRIPTION("Collie LCD driver");
 MODULE_LICENSE("GPL");
diff --git a/fs/compat.c b/fs/compat.c
index 6490d21..c6fda9a 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -8,7 +8,7 @@
  *  Copyright (C) 1997-2000  Jakub Jelinek  (jakub@redhat.com)
  *  Copyright (C) 1998       Eddie C. Dost  (ecd@skynet.be)
  *  Copyright (C) 2001,2002  Andi Kleen, SuSE Labs 
- *  Copyright (C) 2003       Pavel Machek (pavel@suse.cz)
+ *  Copyright (C) 2003       Pavel Machek (pavel@ucw.cz)
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640d..5ead376 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1997-2000  Jakub Jelinek  (jakub@redhat.com)
  * Copyright (C) 1998  Eddie C. Dost  (ecd@skynet.be)
  * Copyright (C) 2001,2002  Andi Kleen, SuSE Labs 
- * Copyright (C) 2003       Pavel Machek (pavel@suse.cz)
+ * Copyright (C) 2003       Pavel Machek (pavel@ucw.cz)
  *
  * These routines maintain argument size conversion between 32bit and 64bit
  * ioctls.
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 5cb7cd1..568efbc 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2000-2001 VERITAS Software Corporation.
  * Copyright (C) 2002-2004 Timesys Corporation
  * Copyright (C) 2003-2004 Amit S. Kale <amitkale@linsyssoft.com>
- * Copyright (C) 2004 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2004 Pavel Machek <pavel@ucw.cz>
  * Copyright (C) 2004-2006 Tom Rini <trini@kernel.crashing.org>
  * Copyright (C) 2004-2006 LinSysSoft Technologies Pvt. Ltd.
  * Copyright (C) 2005-2009 Wind River Systems, Inc.
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 4b17b32..4e58472 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -6,7 +6,7 @@
  * Copyright (C) 2000-2001 VERITAS Software Corporation.
  * Copyright (C) 2002-2004 Timesys Corporation
  * Copyright (C) 2003-2004 Amit S. Kale <amitkale@linsyssoft.com>
- * Copyright (C) 2004 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2004 Pavel Machek <pavel@ucw.cz>
  * Copyright (C) 2004-2006 Tom Rini <trini@kernel.crashing.org>
  * Copyright (C) 2004-2006 LinSysSoft Technologies Pvt. Ltd.
  * Copyright (C) 2005-2009 Wind River Systems, Inc.
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index aa9e916..6b202e7 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -3,7 +3,7 @@
  *
  * Copyright (c) 2003 Patrick Mochel
  * Copyright (c) 2003 Open Source Development Lab
- * Copyright (c) 2004 Pavel Machek <pavel@suse.cz>
+ * Copyright (c) 2004 Pavel Machek <pavel@ucw.cz>
  * Copyright (c) 2009 Rafael J. Wysocki, Novell Inc.
  *
  * This file is released under the GPLv2.
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 25ce010..f6cd6fa 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -3,7 +3,7 @@
  *
  * This file provides system snapshot/restore functionality for swsusp.
  *
- * Copyright (C) 1998-2005 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 1998-2005 Pavel Machek <pavel@ucw.cz>
  * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
  *
  * This file is released under the GPLv2.
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index b0bb217..48a0aa9 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -4,7 +4,7 @@
  * This file provides functions for reading the suspend image from
  * and writing it to a swap partition.
  *
- * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@ucw.cz>
  * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
  *
  * This file is released under the GPLv2.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
