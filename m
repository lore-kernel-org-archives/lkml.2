Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2DPVfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:35:53 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21598 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2DPVfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:35:51 -0400
Date: Mon, 16 Apr 2012 23:35:49 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-doc@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        trivial@kernel.org, kjsisson@bellsouth.net,
        Ben Dooks <ben-linux@fluff.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ben Dooks <ben@simtec.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Andy Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josua Dietze <digidietze@draisberghof.de>,
        Andiry Xu <andiry.xu@amd.com>, Matthew Garrett <mjg@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH] [Trivial] Documentation: Add newline at end-of-file to files
 lacking one
Message-ID: <alpine.LNX.2.00.1204162329190.21898@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply adds a newline character at end-of-file to those
files in Documentation/ that currently lack one.

This is done for a few different reasons:

A) It's rather annoying when you do "cat some_file.txt" that your
   prompt/cursor ends up at the end of the last line of output rather
   than on a new line.

B) Some tools that process files line-by-line may get confused by the
   lack of a newline on the last line.

C) The "\ No newline at end of file" line in diffs annoys me for some
   reason.

So, let's just add the missing newline once and for all.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Documentation/ABI/stable/vdso                                  |    2 +-
 Documentation/ABI/testing/sysfs-block-zram                     |    2 +-
 Documentation/ABI/testing/sysfs-bus-usb                        |    2 +-
 Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg      |    2 +-
 Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870 |    2 +-
 Documentation/arm/Samsung-S3C24XX/H1940.txt                    |    2 +-
 Documentation/arm/Samsung-S3C24XX/SMDK2440.txt                 |    2 +-
 Documentation/dvb/opera-firmware.txt                           |    2 +-
 Documentation/sound/alsa/hdspm.txt                             |    2 +-
 Documentation/video4linux/cpia2_overview.txt                   |    2 +-
 Documentation/video4linux/stv680.txt                           |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/stable/vdso b/Documentation/ABI/stable/vdso
index 8a1cbb5..7cdfc28 100644
--- a/Documentation/ABI/stable/vdso
+++ b/Documentation/ABI/stable/vdso
@@ -24,4 +24,4 @@ though.
 
 (As of this writing, this ABI documentation as been confirmed for x86_64.
  The maintainers of the other vDSO-using architectures should confirm
- that it is correct for their architecture.)
\ No newline at end of file
+ that it is correct for their architecture.)
diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index c8b3b48..ec93fe3 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -96,4 +96,4 @@ Description:
 		overhead, allocated for this disk. So, allocator space
 		efficiency can be calculated using compr_data_size and this
 		statistic.
-		Unit: bytes
\ No newline at end of file
+		Unit: bytes
diff --git a/Documentation/ABI/testing/sysfs-bus-usb b/Documentation/ABI/testing/sysfs-bus-usb
index 7c22a53..b521754 100644
--- a/Documentation/ABI/testing/sysfs-bus-usb
+++ b/Documentation/ABI/testing/sysfs-bus-usb
@@ -192,4 +192,4 @@ Description:
 		combination of hub decriptor bits and platform-specific data
 		such as ACPI. This file will read either "removable" or
 		"fixed" if the information is available, and "unknown"
-		otherwise.
\ No newline at end of file
+		otherwise.
diff --git a/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg b/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg
index cb830df..70d00df 100644
--- a/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg
+++ b/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg
@@ -40,4 +40,4 @@ Description:	Controls the decimal places on the device.
 		the value of 10 ** n. Assume this field has
 		the value k and has 1 or more decimal places set,
 		to set the mth place (where m is not already set),
-		change this fields value to k + 10 ** m.
\ No newline at end of file
+		change this fields value to k + 10 ** m.
diff --git a/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870 b/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
index 4a9c545..33e6488 100644
--- a/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
+++ b/Documentation/ABI/testing/sysfs-class-backlight-driver-adp8870
@@ -53,4 +53,4 @@ Description:
 		Documentation/ABI/stable/sysfs-class-backlight.
 		It can be enabled by writing the value stored in
 		/sys/class/backlight/<backlight>/max_brightness to
-		/sys/class/backlight/<backlight>/brightness.
\ No newline at end of file
+		/sys/class/backlight/<backlight>/brightness.
diff --git a/Documentation/arm/Samsung-S3C24XX/H1940.txt b/Documentation/arm/Samsung-S3C24XX/H1940.txt
index f4a7b22..b738859 100644
--- a/Documentation/arm/Samsung-S3C24XX/H1940.txt
+++ b/Documentation/arm/Samsung-S3C24XX/H1940.txt
@@ -37,4 +37,4 @@ Maintainers
   Thanks to the many others who have also provided support.
 
 
-(c) 2005 Ben Dooks
\ No newline at end of file
+(c) 2005 Ben Dooks
diff --git a/Documentation/arm/Samsung-S3C24XX/SMDK2440.txt b/Documentation/arm/Samsung-S3C24XX/SMDK2440.txt
index 32e1eae..429390b 100644
--- a/Documentation/arm/Samsung-S3C24XX/SMDK2440.txt
+++ b/Documentation/arm/Samsung-S3C24XX/SMDK2440.txt
@@ -53,4 +53,4 @@ Maintainers
   and to Simtec Electronics for allowing me time to work on this.
 
 
-(c) 2004 Ben Dooks
\ No newline at end of file
+(c) 2004 Ben Dooks
diff --git a/Documentation/dvb/opera-firmware.txt b/Documentation/dvb/opera-firmware.txt
index 93e784c..ac5d86f 100644
--- a/Documentation/dvb/opera-firmware.txt
+++ b/Documentation/dvb/opera-firmware.txt
@@ -24,4 +24,4 @@ After that the driver can load the firmware
 in kernel config and have hotplug running).
 
 
-Marco Gittler <g.marco@freenet.de>
\ No newline at end of file
+Marco Gittler <g.marco@freenet.de>
diff --git a/Documentation/sound/alsa/hdspm.txt b/Documentation/sound/alsa/hdspm.txt
index 7a67ff7..7ba3194 100644
--- a/Documentation/sound/alsa/hdspm.txt
+++ b/Documentation/sound/alsa/hdspm.txt
@@ -359,4 +359,4 @@ Calling Parameter:
    enable_monitor int array (min = 1, max = 8), 
      "Enable Analog Out on Channel 63/64 by default."
 
-      note: here the analog output is enabled (but not routed).
\ No newline at end of file
+      note: here the analog output is enabled (but not routed).
diff --git a/Documentation/video4linux/cpia2_overview.txt b/Documentation/video4linux/cpia2_overview.txt
index a6e5366..ad6adbe 100644
--- a/Documentation/video4linux/cpia2_overview.txt
+++ b/Documentation/video4linux/cpia2_overview.txt
@@ -35,4 +35,4 @@ the camera.  There are three modes for this.  Block mode requests a number
 of contiguous registers.  Random mode reads or writes random registers with
 a tuple structure containing address/value pairs.  The repeat mode is only
 used by VP4 to load a firmware patch.  It contains a starting address and
-a sequence of bytes to be written into a gpio port.
\ No newline at end of file
+a sequence of bytes to be written into a gpio port.
diff --git a/Documentation/video4linux/stv680.txt b/Documentation/video4linux/stv680.txt
index 4f8946f..e3de336 100644
--- a/Documentation/video4linux/stv680.txt
+++ b/Documentation/video4linux/stv680.txt
@@ -50,4 +50,4 @@ The latest info on this driver can be found at:
 http://personal.clt.bellsouth.net/~kjsisson or at
 http://stv0680-usb.sourceforge.net
 
-Any questions to me can be send to:  kjsisson@bellsouth.net
\ No newline at end of file
+Any questions to me can be send to:  kjsisson@bellsouth.net
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

