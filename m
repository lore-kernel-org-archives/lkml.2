Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992619Ab2JYTGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992568Ab2JYTGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:06:51 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: update email and git tree
Date: Thu, 25 Oct 2012 17:06:38 -0200
Message-Id: <1351191998-13860-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While mchehab@infradead.org is valid, I prefer to use just one email
for all patches upstream, instead of receiving some things on one
emails, and others on some other place.

While here, also update the main linux-media development tree,
as the one at kernel.org is used mainly for patch merging and it
is generally delayed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e73060f..2bf8543 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1724,10 +1724,10 @@ F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
 
 BTTV VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@infradead.org>
+M:	Mauro Carvalho Chehab <mchehab@redhat.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	Documentation/video4linux/bttv/
 F:	drivers/media/pci/bt8xx/bttv*
@@ -1757,7 +1757,7 @@ F:	fs/cachefiles/
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
 F:	drivers/media/platform/marvell-ccic/
@@ -2144,7 +2144,7 @@ CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 W:	http://www.ivtvdriver.org/index.php/Cx18
 S:	Maintained
@@ -3318,56 +3318,56 @@ F:	drivers/net/ethernet/aeroflex/
 GSPCA FINEPIX SUBDRIVER
 M:	Frank Zago <frank@zago.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/finepix.c
 
 GSPCA GL860 SUBDRIVER
 M:	Olivier Lorin <o.lorin@laposte.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/gl860/
 
 GSPCA M5602 SUBDRIVER
 M:	Erik Andren <erik.andren@gmail.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/m5602/
 
 GSPCA PAC207 SONIXB SUBDRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/pac207.c
 
 GSPCA SN9C20X SUBDRIVER
 M:	Brian Johnson <brijohn@gmail.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/sn9c20x.c
 
 GSPCA T613 SUBDRIVER
 M:	Leandro Costantino <lcostantino@gmail.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/t613.c
 
 GSPCA USB WEBCAM DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/
 
 STK1160 USB VIDEO CAPTURE DRIVER
 M:	Ezequiel Garcia <elezegarcia@gmail.com>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/stk1160/
 
@@ -4095,7 +4095,7 @@ IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 W:	http://www.ivtvdriver.org
 S:	Maintained
 F:	Documentation/video4linux/*.ivtv
@@ -4728,12 +4728,12 @@ F:	Documentation/hwmon/max6650
 F:	drivers/hwmon/max6650.c
 
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
-M:	Mauro Carvalho Chehab <mchehab@infradead.org>
+M:	Mauro Carvalho Chehab <mchehab@redhat.com>
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 Q:	http://patchwork.kernel.org/project/linux-media/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	Documentation/dvb/
 F:	Documentation/video4linux/
@@ -5270,7 +5270,7 @@ F:	drivers/char/pcmcia/cm4040_cs.*
 OMNIVISION OV7670 SENSOR DRIVER
 M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/ov7670.c
 
@@ -5813,7 +5813,7 @@ M:	Mike Isely <isely@pobox.com>
 L:	pvrusb2@isely.net	(subscribers-only)
 L:	linux-media@vger.kernel.org
 W:	http://www.isely.net/pvrusb2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	Documentation/video4linux/README.pvrusb2
 F:	drivers/media/usb/pvrusb2/
@@ -6203,7 +6203,7 @@ F:	drivers/mmc/host/s3cmci.*
 SAA7146 VIDEO4LINUX-2 DRIVER
 M:	Michael Hunold <michael@mihu.de>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
 F:	drivers/media/common/saa7146/
@@ -6655,7 +6655,7 @@ F:	arch/ia64/sn/
 SOC-CAMERA V4L2 SUBSYSTEM
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	include/media/soc*
 F:	drivers/media/i2c/soc_camera/
@@ -7690,7 +7690,7 @@ USB SN9C1xx DRIVER
 M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	Documentation/video4linux/sn9c102.txt
@@ -7726,7 +7726,7 @@ USB VIDEO CLASS
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-uvc-devel@lists.sourceforge.net (subscribers-only)
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 W:	http://www.ideasonboard.org/uvc/
 S:	Maintained
 F:	drivers/media/usb/uvc/
@@ -7754,7 +7754,7 @@ USB ZR364XX DRIVER
 M:	Antoine Jacquet <royale@zerezo.com>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+T:	git git://linuxtv.org/media_tree.git
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 F:	Documentation/video4linux/zr364xx.txt
-- 
1.7.11.7

