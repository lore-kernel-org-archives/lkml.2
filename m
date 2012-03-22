Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2CVHKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:10:21 -0400
Received: from server.atrad.com.au ([150.101.241.2]:43603 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2CVHKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:10:17 -0400
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2012 03:10:17 EDT
Date: Thu, 22 Mar 2012 17:11:00 +1030
From: Jonathan Woithe <jwoithe@just42.net>
To: linux-kernel@vger.kernel.org
Cc: jwoithe@just42.net
Subject: [PATCH] Email/web address change
Message-ID: <20120322064100.GA22857@marvin.atrad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Below is a trivial patch against the kernel tree which updates occurances of
my email address in the kernel tree.  However, I am not certain what the
acceptable practice is when addresses of contributors are updated -
particularly for addresses inside individual source files - so if some of
these changes are out of order please let me know and I'll redo the patch
accordingly.

Please CC me on replies - thanks.

Regards
  jonathan

diff -ru linux-3.3-orig//CREDITS linux-3.3//CREDITS
--- linux-3.3-orig//CREDITS	2012-03-19 09:45:34.000000000 +1030
+++ linux-3.3//CREDITS	2012-03-22 16:55:14.475424237 +1030
@@ -3814,8 +3814,8 @@
 D: Author of the longest-living linux bug
 
 N: Jonathan Woithe
-E: jwoithe@physics.adelaide.edu.au
-W: http://www.physics.adelaide.edu.au/~jwoithe
+E: jwoithe@just42.net
+W: http://www.just42.net/jwoithe
 D: ALS-007 sound card extensions to Sound Blaster driver
 S: 20 Jordan St
 S: Valley View, SA 5093
diff -ru linux-3.3-orig//Documentation/sound/oss/ALS linux-3.3//Documentation/sound/oss/ALS
--- linux-3.3-orig//Documentation/sound/oss/ALS	2012-03-19 09:45:34.000000000 +1030
+++ linux-3.3//Documentation/sound/oss/ALS	2012-03-22 16:57:02.831630212 +1030
@@ -57,10 +57,10 @@
     DSP/PCM/audio out (L&R), FM (L&R) and Mic in (mono).
 
 Jonathan Woithe
-jwoithe@physics.adelaide.edu.au
+jwoithe@just42.net
 30 March 1998
 
 Modified 2000-02-26 by Dave Forrest, drf5n@virginia.edu to add ALS100/ALS200
 Modified 2000-04-10 by Paul Laufer, pelaufer@csupomona.edu to add ISAPnP info.
-Modified 2000-11-19 by Jonathan Woithe, jwoithe@physics.adelaide.edu.au
+Modified 2000-11-19 by Jonathan Woithe, jwoithe@just42.net
  - updated information for kernel 2.4.x.
diff -ru linux-3.3-orig//MAINTAINERS linux-3.3//MAINTAINERS
--- linux-3.3-orig//MAINTAINERS	2012-03-19 09:45:34.000000000 +1030
+++ linux-3.3//MAINTAINERS	2012-03-22 16:55:40.799474266 +1030
@@ -2853,7 +2853,7 @@
 F:	arch/frv/
 
 FUJITSU LAPTOP EXTRAS
-M:	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
+M:	Jonathan Woithe <jwoithe@just42.net>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/fujitsu-laptop.c
diff -ru linux-3.3-orig//drivers/platform/x86/fujitsu-laptop.c linux-3.3//drivers/platform/x86/fujitsu-laptop.c
--- linux-3.3-orig//drivers/platform/x86/fujitsu-laptop.c	2012-03-19 09:45:34.000000000 +1030
+++ linux-3.3//drivers/platform/x86/fujitsu-laptop.c	2012-03-22 16:57:34.735690881 +1030
@@ -1,7 +1,7 @@
 /*-*-linux-c-*-*/
 
 /*
-  Copyright (C) 2007,2008 Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
+  Copyright (C) 2007,2008 Jonathan Woithe <jwoithe@just42.net>
   Copyright (C) 2008 Peter Gruber <nokos@gmx.net>
   Copyright (C) 2008 Tony Vroon <tony@linx.net>
   Based on earlier work:
diff -ru linux-3.3-orig//drivers/usb/storage/unusual_devs.h linux-3.3//drivers/usb/storage/unusual_devs.h
--- linux-3.3-orig//drivers/usb/storage/unusual_devs.h	2012-03-19 09:45:34.000000000 +1030
+++ linux-3.3//drivers/usb/storage/unusual_devs.h	2012-03-22 16:57:53.099725805 +1030
@@ -110,7 +110,7 @@
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
-/* Deduced by Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
+/* Deduced by Jonathan Woithe <jwoithe@just42.net>
  * Entry needed for flags: US_FL_FIX_INQUIRY because initial inquiry message
  * always fails and confuses drive.
  */
diff -ru linux-3.3-orig//sound/isa/als100.c linux-3.3//sound/isa/als100.c
--- linux-3.3-orig//sound/isa/als100.c	2012-03-19 09:45:34.000000000 +1030
+++ linux-3.3//sound/isa/als100.c	2012-03-22 16:58:32.631800997 +1030
@@ -7,7 +7,7 @@
     Thanks to Pierfrancesco 'qM2' Passerini.
 
     Generalised for soundcards based on DT-0196 and ALS-007 chips
-    by Jonathan Woithe <jwoithe@physics.adelaide.edu.au>: June 2002.
+    by Jonathan Woithe <jwoithe@just42.net>: June 2002.
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
diff -ru linux-3.3-orig//sound/pci/hda/patch_realtek.c linux-3.3//sound/pci/hda/patch_realtek.c
--- linux-3.3-orig//sound/pci/hda/patch_realtek.c	2012-03-19 09:45:34.000000000 +1030
+++ linux-3.3//sound/pci/hda/patch_realtek.c	2012-03-22 16:59:01.051855061 +1030
@@ -6,7 +6,7 @@
  * Copyright (c) 2004 Kailang Yang <kailang@realtek.com.tw>
  *                    PeiSen Hou <pshou@realtek.com.tw>
  *                    Takashi Iwai <tiwai@suse.de>
- *                    Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
+ *                    Jonathan Woithe <jwoithe@just42.net>
  *
  *  This driver is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
