Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1CXXyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:54:33 -0400
Received: from santostefano.inria.fr ([193.51.192.151]:53494 "HELO
	santostefano.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750949Ab1CXXyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:54:31 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 19:54:30 EDT
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
To: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sylvestre Ledru <sylvestre.ledru@scilab.org>
Subject: [PATCH] Fix some minor typos: * informations => information * there own => their own * an => and (bug #14973)
Date: Fri, 25 Mar 2011 00:47:44 +0100
Message-Id: <1301010464-22583-1-git-send-email-sylvestre.ledru@scilab.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sylvestre Ledru <sylvestre.ledru@scilab.org>
---
 .../ABI/testing/sysfs-driver-hid-roccat-kone       |    2 +-
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |    8 ++++----
 .../ABI/testing/sysfs-driver-hid-roccat-kovaplus   |    8 ++++----
 .../ABI/testing/sysfs-driver-hid-roccat-pyra       |    8 ++++----
 .../ABI/testing/sysfs-platform-asus-laptop         |    2 +-
 Documentation/devicetree/booting-without-of.txt    |    6 +++---
 Documentation/dvb/udev.txt                         |    2 +-
 Documentation/edac.txt                             |    2 +-
 Documentation/kernel-parameters.txt                |    4 ++--
 Documentation/laptops/asus-laptop.txt              |    4 ++--
 Documentation/networking/batman-adv.txt            |    2 +-
 Documentation/s390/Debugging390.txt                |    2 +-
 Documentation/scsi/sym53c8xx_2.txt                 |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt    |    2 +-
 Documentation/sound/oss/AudioExcelDSP16            |    6 +++---
 Documentation/sound/oss/README.ymfsb               |    2 +-
 Documentation/video4linux/bttv/Insmod-options      |    2 +-
 Documentation/video4linux/bttv/Sound-FAQ           |    2 +-
 Documentation/video4linux/et61x251.txt             |    4 ++--
 Documentation/video4linux/sn9c102.txt              |    4 ++--
 Documentation/video4linux/w9968cf.txt              |    2 +-
 Documentation/video4linux/zc0301.txt               |    6 +++---
 arch/powerpc/mm/tlb_low_64e.S                      |    2 +-
 arch/powerpc/platforms/Kconfig                     |    2 +-
 fs/notify/fanotify/Kconfig                         |    2 +-
 25 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
index b4c4f15..3ca3971 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -40,7 +40,7 @@ What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
-                press of a button. A profile holds informations like button
+                press of a button. A profile holds information like button
                 mappings, sensitivity, the colors of the 5 leds and light
                 effects.
                 When read, these files return the respective profile. The
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
index 00efced..326e054 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -33,7 +33,7 @@ Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds informations about button layout.
+		profile_buttons holds information about button layout.
 		When written, this file lets one write the respective profile
 		buttons back to the mouse. The data has to be 77 bytes long.
 		The mouse will reject invalid data.
@@ -47,7 +47,7 @@ Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds informations about button layout.
+		profile_buttons holds information about button layout.
 		When read, these files return the respective profile buttons.
 		The returned data is 77 bytes in size.
 		This file is readonly.
@@ -58,7 +58,7 @@ Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_settings holds informations like resolution, sensitivity
+		profile_settings holds information like resolution, sensitivity
 		and light effects.
 		When written, this file lets one write the respective profile
 		settings back to the mouse. The data has to be 43 bytes long.
@@ -73,7 +73,7 @@ Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_settings holds informations like resolution, sensitivity
+		profile_settings holds information like resolution, sensitivity
 		and light effects.
 		When read, these files return the respective profile settings.
 		The returned data is 43 bytes in size.
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
index fdfa16f..20f937c 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
@@ -52,7 +52,7 @@ Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds informations about button layout.
+		profile_buttons holds information about button layout.
 		When written, this file lets one write the respective profile
 		buttons back to the mouse. The data has to be 23 bytes long.
 		The mouse will reject invalid data.
@@ -66,7 +66,7 @@ Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds informations about button layout.
+		profile_buttons holds information about button layout.
 		When read, these files return the respective profile buttons.
 		The returned data is 23 bytes in size.
 		This file is readonly.
@@ -77,7 +77,7 @@ Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_settings holds informations like resolution, sensitivity
+		profile_settings holds information like resolution, sensitivity
 		and light effects.
 		When written, this file lets one write the respective profile
 		settings back to the mouse. The data has to be 16 bytes long.
@@ -92,7 +92,7 @@ Date:		January 2011
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_settings holds informations like resolution, sensitivity
+		profile_settings holds information like resolution, sensitivity
 		and light effects.
 		When read, these files return the respective profile settings.
 		The returned data is 16 bytes in size.
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
index 5fab71a..3f8de50 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
@@ -39,7 +39,7 @@ Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_settings holds informations like resolution, sensitivity
+		profile_settings holds information like resolution, sensitivity
 		and light effects.
 		When written, this file lets one write the respective profile
 		settings back to the mouse. The data has to be 13 bytes long.
@@ -54,7 +54,7 @@ Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_settings holds informations like resolution, sensitivity
+		profile_settings holds information like resolution, sensitivity
 		and light effects.
 		When read, these files return the respective profile settings.
 		The returned data is 13 bytes in size.
@@ -66,7 +66,7 @@ Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds informations about button layout.
+		profile_buttons holds information about button layout.
 		When written, this file lets one write the respective profile
 		buttons back to the mouse. The data has to be 19 bytes long.
 		The mouse will reject invalid data.
@@ -80,7 +80,7 @@ Date:		August 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
 		press of a button. A profile is split in settings and buttons.
-		profile_buttons holds informations about button layout.
+		profile_buttons holds information about button layout.
 		When read, these files return the respective profile buttons.
 		The returned data is 19 bytes in size.
 		This file is readonly.
diff --git a/Documentation/ABI/testing/sysfs-platform-asus-laptop b/Documentation/ABI/testing/sysfs-platform-asus-laptop
index 41ff8ae..01160d8 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-asus-laptop
@@ -27,7 +27,7 @@ KernelVersion:	2.6.20
 Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		Some models like the W1N have a LED display that can be
-		used to display several informations.
+		used to display several information.
 		To control the LED display, use the following :
 		    echo 0x0T000DDD > /sys/devices/platform/asus_laptop/
 		where T control the 3 letters display, and DDD the 3 digits display.
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 55fd262..50619a0 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -138,7 +138,7 @@ and properties to be present. This will be described in detail in
 section III, but, for example, the kernel does not require you to
 create a node for every PCI device in the system. It is a requirement
 to have a node for PCI host bridges in order to provide interrupt
-routing informations and memory/IO ranges, among others. It is also
+routing information and memory/IO ranges, among others. It is also
 recommended to define nodes for on chip devices and other buses that
 don't specifically fit in an existing OF specification. This creates a
 great flexibility in the way the kernel can then probe those and match
@@ -385,7 +385,7 @@ struct boot_param_header {
      among others, by kexec. If you are on an SMP system, this value
      should match the content of the "reg" property of the CPU node in
      the device-tree corresponding to the CPU calling the kernel entry
-     point (see further chapters for more informations on the required
+     point (see further chapters for more information on the required
      device-tree contents)
 
    - size_dt_strings
@@ -553,7 +553,7 @@ looks like in practice.
 
 This tree is almost a minimal tree. It pretty much contains the
 minimal set of required nodes and properties to boot a linux kernel;
-that is, some basic model informations at the root, the CPUs, and the
+that is, some basic model information at the root, the CPUs, and the
 physical memory layout.  It also includes misc information passed
 through /chosen, like in this example, the platform type (mandatory)
 and the kernel command line arguments (optional).
diff --git a/Documentation/dvb/udev.txt b/Documentation/dvb/udev.txt
index 68ee224..412305b 100644
--- a/Documentation/dvb/udev.txt
+++ b/Documentation/dvb/udev.txt
@@ -1,7 +1,7 @@
 The DVB subsystem currently registers to the sysfs subsystem using the
 "class_simple" interface.
 
-This means that only the basic informations like module loading parameters
+This means that only the basic information like module loading parameters
 are presented through sysfs. Other things that might be interesting are
 currently *not* available.
 
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 9ee774d..ccc07c2 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -311,7 +311,7 @@ Total Correctable Errors count attribute file:
 	'ce_noinfo_count'
 
 	This attribute file displays the number of CEs that
-	have occurred wherewith no informations as to which DIMM slot
+	have occurred wherewith no information as to which DIMM slot
 	is having errors. Memory is handicapped, but operational,
 	yet no information is available to indicate which slot
 	the failing memory is in. This count field should be also
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d18a9e1..29ac507 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2463,8 +2463,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
-			topology informations if the hardware supports these.
-			The scheduler will make use of these informations and
+			topology information if the hardware supports these.
+			The scheduler will make use of this information and
 			e.g. base its process migration decisions on it.
 			Default is on.
 
diff --git a/Documentation/laptops/asus-laptop.txt b/Documentation/laptops/asus-laptop.txt
index c1c5be8..90d8b86 100644
--- a/Documentation/laptops/asus-laptop.txt
+++ b/Documentation/laptops/asus-laptop.txt
@@ -61,7 +61,7 @@ Usage
   Hotkeys are also reported as input keys (like keyboards) you can check
   which key are supported using "xev" under X11.
 
-  You can get informations on the version of your DSDT table by reading the
+  You can get information on the version of your DSDT table by reading the
   /sys/devices/platform/asus-laptop/infos entry. If you have a question or a
   bug report to do, please include the output of this entry.
 
@@ -178,7 +178,7 @@ LED display
 -----------
 
   Some models like the W1N have a LED display that can be used to display
-  several informations.
+  several information.
 
   LED display works for the following models:
     W1000N
diff --git a/Documentation/networking/batman-adv.txt b/Documentation/networking/batman-adv.txt
index 18afcd8..ee496eb 100644
--- a/Documentation/networking/batman-adv.txt
+++ b/Documentation/networking/batman-adv.txt
@@ -72,7 +72,7 @@ folder:
 #  fragmentation    gw_sel_class  vis_mode
 
 
-There is a special folder for debugging informations:
+There is a special folder for debugging information:
 
 #  ls /sys/kernel/debug/batman_adv/bat0/
 #  gateways     socket        transtable_global  vis_data
diff --git a/Documentation/s390/Debugging390.txt b/Documentation/s390/Debugging390.txt
index 86f9f74..efe998b 100644
--- a/Documentation/s390/Debugging390.txt
+++ b/Documentation/s390/Debugging390.txt
@@ -2273,7 +2273,7 @@ IP forwarding is on.
 There is a lot of useful info in here best found by going in & having a look around,
 so I'll take you through some entries I consider important.
 
-All the processes running on the machine have there own entry defined by
+All the processes running on the machine have their own entry defined by
 /proc/<pid>
 So lets have a look at the init process
 cd /proc/1
diff --git a/Documentation/scsi/sym53c8xx_2.txt b/Documentation/scsi/sym53c8xx_2.txt
index 6f63b79..6af8f7a 100644
--- a/Documentation/scsi/sym53c8xx_2.txt
+++ b/Documentation/scsi/sym53c8xx_2.txt
@@ -285,7 +285,7 @@ from the driver.
 
 7. Profiling information
 
-This driver does not provide profiling informations as did its predecessors.
+This driver does not provide profiling information as did its predecessors.
 This feature was not this useful and added complexity to the code. 
 As the driver code got more complex, I have decided to remove everything 
 that didn't seem actually useful.
diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index 3c1eddd..181ba5b 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -2229,7 +2229,7 @@ Proc interfaces (/proc/asound)
 
 /proc/asound/card#/pcm#[cp]/oss
 -------------------------------
-  String "erase" - erase all additional informations about OSS applications
+  String "erase" - erase all additional information about OSS applications
   String "<app_name> <fragments> <fragment_size> [<options>]"
 
    <app_name> - name of application with (higher priority) or without path
diff --git a/Documentation/sound/oss/AudioExcelDSP16 b/Documentation/sound/oss/AudioExcelDSP16
index c0f0892..e0dc064 100644
--- a/Documentation/sound/oss/AudioExcelDSP16
+++ b/Documentation/sound/oss/AudioExcelDSP16
@@ -1,10 +1,10 @@
 Driver
 ------
 
-Informations about Audio Excel DSP 16 driver can be found in the source
+Information about Audio Excel DSP 16 driver can be found in the source
 file aedsp16.c
 Please, read the head of the source before using it. It contain useful
-informations.
+information.
 
 Configuration
 -------------
@@ -68,7 +68,7 @@ Sound cards supported
 This driver supports the SC-6000 and SC-6600 based Gallant's sound card.
 It don't support the Audio Excel DSP 16 III (try the SC-6600 code).
 I'm working on the III version of the card: if someone have useful
-informations about it, please let me know.
+information about it, please let me know.
 For all the non-supported audio cards, you have to boot MS-DOS (or WIN95)
 activating the audio card with the MS-DOS device driver, then you have to
 <ctrl>-<alt>-<del> and boot Linux.
diff --git a/Documentation/sound/oss/README.ymfsb b/Documentation/sound/oss/README.ymfsb
index af8a7d3..b6b7790 100644
--- a/Documentation/sound/oss/README.ymfsb
+++ b/Documentation/sound/oss/README.ymfsb
@@ -5,7 +5,7 @@ FIRST OF ALL
 ============
 
   This code references YAMAHA's sample codes and data sheets.
-  I respect and thank for all people they made open the informations
+  I respect and thank for all people they made open the information
   about YMF7xx cards.
 
   And this codes heavily based on Jeff Garzik <jgarzik@pobox.com>'s
diff --git a/Documentation/video4linux/bttv/Insmod-options b/Documentation/video4linux/bttv/Insmod-options
index bbe3ed6..14c065f 100644
--- a/Documentation/video4linux/bttv/Insmod-options
+++ b/Documentation/video4linux/bttv/Insmod-options
@@ -1,5 +1,5 @@
 
-Note: "modinfo <module>" prints various informations about a kernel
+Note: "modinfo <module>" prints various information about a kernel
 module, among them a complete and up-to-date list of insmod options.
 This list tends to be outdated because it is updated manually ...
 
diff --git a/Documentation/video4linux/bttv/Sound-FAQ b/Documentation/video4linux/bttv/Sound-FAQ
index 1e6328f..bc5e41d 100644
--- a/Documentation/video4linux/bttv/Sound-FAQ
+++ b/Documentation/video4linux/bttv/Sound-FAQ
@@ -8,7 +8,7 @@ completely by the bt8xx chip, which is common on all boards.  But
 sound is handled in slightly different ways on each board.
 
 To handle the grabber boards correctly, there is a array tvcards[] in
-bttv-cards.c, which holds the informations required for each board.
+bttv-cards.c, which holds the information required for each board.
 Sound will work only, if the correct entry is used (for video it often
 makes no difference).  The bttv driver prints a line to the kernel
 log, telling which card type is used.  Like this one:
diff --git a/Documentation/video4linux/et61x251.txt b/Documentation/video4linux/et61x251.txt
index 1247566..e0cdae4 100644
--- a/Documentation/video4linux/et61x251.txt
+++ b/Documentation/video4linux/et61x251.txt
@@ -191,10 +191,10 @@ Syntax:         <n>
 Description:    Debugging information level, from 0 to 3:
 		0 = none (use carefully)
 		1 = critical errors
-		2 = significant informations
+		2 = significant information
 		3 = more verbose messages
 		Level 3 is useful for testing only, when only one device
-		is used at the same time. It also shows some more informations
+		is used at the same time. It also shows some more information
 		about the hardware being detected. This module parameter can be
 		changed at runtime thanks to the /sys filesystem interface.
 Default:        2
diff --git a/Documentation/video4linux/sn9c102.txt b/Documentation/video4linux/sn9c102.txt
index 73de405..b4f6704 100644
--- a/Documentation/video4linux/sn9c102.txt
+++ b/Documentation/video4linux/sn9c102.txt
@@ -214,10 +214,10 @@ Syntax:         <n>
 Description:    Debugging information level, from 0 to 3:
 		0 = none (use carefully)
 		1 = critical errors
-		2 = significant informations
+		2 = significant information
 		3 = more verbose messages
 		Level 3 is useful for testing only. It also shows some more
-		informations about the hardware being detected.
+		information about the hardware being detected.
 		This parameter can be changed at runtime thanks to the /sys
 		filesystem interface.
 Default:        2
diff --git a/Documentation/video4linux/w9968cf.txt b/Documentation/video4linux/w9968cf.txt
index 05138e8..9649450 100644
--- a/Documentation/video4linux/w9968cf.txt
+++ b/Documentation/video4linux/w9968cf.txt
@@ -413,7 +413,7 @@ Syntax:         <n>
 Description:    Debugging information level, from 0 to 6:
 		0 = none (use carefully)
 		1 = critical errors
-		2 = significant informations
+		2 = significant information
 		3 = configuration or general messages
 		4 = warnings
 		5 = called functions
diff --git a/Documentation/video4linux/zc0301.txt b/Documentation/video4linux/zc0301.txt
index befdfda..b41c83c 100644
--- a/Documentation/video4linux/zc0301.txt
+++ b/Documentation/video4linux/zc0301.txt
@@ -181,10 +181,10 @@ Syntax:         <n>
 Description:    Debugging information level, from 0 to 3:
 		0 = none (use carefully)
 		1 = critical errors
-		2 = significant informations
+		2 = significant information
 		3 = more verbose messages
 		Level 3 is useful for testing only, when only one device
-		is used at the same time. It also shows some more informations
+		is used at the same time. It also shows some information
 		about the hardware being detected. This module parameter can be
 		changed at runtime thanks to the /sys filesystem interface.
 Default:        2
@@ -261,7 +261,7 @@ the fingerprint is: '88E8 F32F 7244 68BA 3958  5D40 99DA 5D2A FCE6 35A4'.
 
 11. Credits
 ===========
-- Informations about the chip internals needed to enable the I2C protocol have
+- Information about the chip internals needed to enable the I2C protocol have
   been taken from the documentation of the ZC030x Video4Linux1 driver written
   by Andrew Birkett <andy@nobugs.org>;
 - The initialization values of the ZC0301 controller connected to the PAS202BCB
diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64e.S
index 8526bd9..2228151 100644
--- a/arch/powerpc/mm/tlb_low_64e.S
+++ b/arch/powerpc/mm/tlb_low_64e.S
@@ -431,7 +431,7 @@ virt_page_table_tlb_miss_fault:
 	 * The thing is, we know that in normal circumstances, this is
 	 * always called as a second level tlb miss for SW load or as a first
 	 * level TLB miss for HW load, so we should be able to peek at the
-	 * relevant informations in the first exception frame in the PACA.
+	 * relevant information in the first exception frame in the PACA.
 	 *
 	 * However, we do need to double check that, because we may just hit
 	 * a stray kernel pointer or a userland attack trying to hit those
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index 2057682..f7b0772 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -46,7 +46,7 @@ config PPC_OF_BOOT_TRAMPOLINE
 	help
 	  Support from booting from Open Firmware or yaboot using an
 	  Open Firmware client interface. This enables the kernel to
-	  communicate with open firmware to retrieve system informations
+	  communicate with open firmware to retrieve system information
 	  such as the device tree.
 
 	  In case of doubt, say Y
diff --git a/fs/notify/fanotify/Kconfig b/fs/notify/fanotify/Kconfig
index 7dceff0..30dc09c 100644
--- a/fs/notify/fanotify/Kconfig
+++ b/fs/notify/fanotify/Kconfig
@@ -6,7 +6,7 @@ config FANOTIFY
 	---help---
 	   Say Y here to enable fanotify suport.  fanotify is a file access
 	   notification system which differs from inotify in that it sends
-	   an open file descriptor to the userspace listener along with
+	   and opens file descriptor to the userspace listener along with
 	   the event.
 
 	   If unsure, say Y.
-- 
1.7.4.1

