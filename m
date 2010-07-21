Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab0GUEzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:55:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41254 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686Ab0GUEyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l1c/QXar3cAL5LTVmfHMZdFH/6ikel56MY8nsA2f4WyaOvmB9oX4L8Evpil32H2xOq
         g0XTFJ0symMMtPfUx+oHtZjKOgZECJ60/juf9dt4x3M5ugNf/JC3ZrkHOa2rleT2e/UN
         YwO1orl0bxh1zOQ0SQEOzZuYkIn6revcm+aME=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 61/61]Documentation/ioctl/ioctl-number.txt update web address.
Date: Tue, 20 Jul 2010 21:54:42 -0700
Message-Id: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Th epatch below removes some unused web addresses that I cannot find
and updates a web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ioctl/ioctl-number.txt |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index dd5806f..65a1436 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -74,7 +74,7 @@ Code  Seq#(hex)	Include File		Comments
 0x10	00-0F	drivers/char/s390/vmcp.h
 0x12	all	linux/fs.h
 		linux/blkpg.h
-0x1b	all	InfiniBand Subsystem	<http://www.openib.org/>
+0x1b	all	InfiniBand Subsystem	<http://infiniband.sourceforge.net/>
 0x20	all	drivers/cdrom/cm206.h
 0x22	all	scsi/sg.h
 '#'	00-3F	IEEE 1394 Subsystem	Block for the entire subsystem
@@ -190,7 +190,7 @@ Code  Seq#(hex)	Include File		Comments
 '['	00-07	linux/usb/tmc.h		USB Test and Measurement Devices
 					<mailto:gregkh@suse.de>
 'a'	all	linux/atm*.h, linux/sonet.h	ATM on linux
-					<http://lrcwww.epfl.ch/linux-atm/magic.html>
+					<http://lrcwww.epfl.ch/>
 'b'	00-FF				conflict! bit3 vme host bridge
 					<mailto:natalia@nikhefk.nikhef.nl>
 'b'	00-0F	media/bt819.h		conflict!
@@ -225,7 +225,6 @@ Code  Seq#(hex)	Include File		Comments
 'k'	00-0F	linux/spi/spidev.h	conflict!
 'k'	00-05	video/kyro.h		conflict!
 'l'	00-3F	linux/tcfs_fs.h		transparent cryptographic file system
-					<http://mikonos.dia.unisa.it/tcfs>
 'l'	40-7F	linux/udf_fs_i.h	in development:
 					<http://sourceforge.net/projects/linux-udf/>
 'm'	00-09	linux/mmtimer.h		conflict!
@@ -252,7 +251,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
 'q'	80-FF	linux/telephony.h	Internet PhoneJACK, Internet LineJACK
-		linux/ixjuser.h		<http://www.quicknet.net>
+		linux/ixjuser.h		
 'r'	00-1F	linux/msdos_fs.h and fs/fat/dir.c
 's'	all	linux/cdk.h
 't'	00-7F	linux/if_ppp.h
@@ -286,7 +285,7 @@ Code  Seq#(hex)	Include File		Comments
 0x89	F0-FF	linux/sockios.h		SIOCDEVPRIVATE range
 0x8B	all	linux/wireless.h
 0x8C	00-3F				WiNRADiO driver
-					<http://www.proximity.com.au/~brian/winradio/>
+					<http://www.winradio.com.au/>
 0x90	00	drivers/cdrom/sbpcd.h
 0x92	00-0F	drivers/usb/mon/mon_bin.c
 0x93	60-7F	linux/auto_fs.h
-- 
1.7.1.rc1.21.gf3bd6

