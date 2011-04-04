Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1DDWNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:13:48 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60760 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754996Ab1DDWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:12:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WYADahwSDliSN+W3snekznW818lLomcTCoMyNGHYSWfCJnUk63ngvjR+XXr8BTOQ/Xy3JHHGuFIDtGCVwXfffwdwxbV0nJDL4E7yNw4YxelYQE11iaZ0AL6lTRCFqNXV;
Date: Mon, 4 Apr 2011 15:04:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>,
        Sylvestre Ledru <sylvestre.ledru@scilab.org>
Cc: torvalds <torvalds@linux-foundation.org>, gregkh <greg@kroah.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5/8] Documentation: fix minor typos/spelling
Message-Id: <20110404150446.d2cf4778.rdunlap@xenotime.net>
In-Reply-To: <20110404145803.8663081d.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Fix some minor typos:
 * informations => information
 * there own => their own
 * these => this

Signed-off-by: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/ABI/testing/sysfs-driver-hid-roccat-kone     |    2 +-
 Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus |    8 ++++----
 Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus |    8 ++++----
 Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra     |    8 ++++----
 Documentation/ABI/testing/sysfs-platform-asus-laptop       |    2 +-
 Documentation/devicetree/booting-without-of.txt            |    6 +++---
 Documentation/dvb/udev.txt                                 |    2 +-
 Documentation/edac.txt                                     |    2 +-
 Documentation/kernel-parameters.txt                        |    4 ++--
 Documentation/laptops/asus-laptop.txt                      |    4 ++--
 Documentation/networking/batman-adv.txt                    |    2 +-
 Documentation/s390/Debugging390.txt                        |    2 +-
 Documentation/scsi/sym53c8xx_2.txt                         |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt            |    2 +-
 Documentation/sound/oss/AudioExcelDSP16                    |    6 +++---
 Documentation/sound/oss/README.ymfsb                       |    2 +-
 Documentation/video4linux/bttv/Insmod-options              |    2 +-
 Documentation/video4linux/bttv/Sound-FAQ                   |    2 +-
 Documentation/video4linux/et61x251.txt                     |    4 ++--
 Documentation/video4linux/sn9c102.txt                      |    4 ++--
 Documentation/video4linux/w9968cf.txt                      |    2 +-
 Documentation/video4linux/zc0301.txt                       |    6 +++---
 arch/powerpc/mm/tlb_low_64e.S                              |    2 +-
 arch/powerpc/platforms/Kconfig                             |    2 +-
 24 files changed, 43 insertions(+), 43 deletions(-)

--- linux-2.6.38-git18.orig/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
+++ linux-2.6.38-git18/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
@@ -40,7 +40,7 @@ What:		/sys/bus/usb/devices/<busnum>-<de
 Date:		March 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
 Description:	The mouse can store 5 profiles which can be switched by the
-                press of a button. A profile holds informations like button
+                press of a button. A profile holds information like button
                 mappings, sensitivity, the colors of the 5 leds and light
                 effects.
                 When read, these files return the respective profile. The
--- linux-2.6.38-git18.orig/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ linux-2.6.38-git18/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
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
--- linux-2.6.38-git18.orig/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
+++ linux-2.6.38-git18/Documentation/ABI/testing/sysfs-driver-hid-roccat-kovaplus
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
--- linux-2.6.38-git18.orig/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
+++ linux-2.6.38-git18/Documentation/ABI/testing/sysfs-driver-hid-roccat-pyra
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
--- linux-2.6.38-git18.orig/Documentation/ABI/testing/sysfs-platform-asus-laptop
+++ linux-2.6.38-git18/Documentation/ABI/testing/sysfs-platform-asus-laptop
@@ -27,7 +27,7 @@ KernelVersion:	2.6.20
 Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		Some models like the W1N have a LED display that can be
-		used to display several informations.
+		used to display several items of information.
 		To control the LED display, use the following :
 		    echo 0x0T000DDD > /sys/devices/platform/asus_laptop/
 		where T control the 3 letters display, and DDD the 3 digits display.
--- linux-2.6.38-git18.orig/Documentation/devicetree/booting-without-of.txt
+++ linux-2.6.38-git18/Documentation/devicetree/booting-without-of.txt
@@ -138,7 +138,7 @@ and properties to be present. This will 
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
--- linux-2.6.38-git18.orig/Documentation/dvb/udev.txt
+++ linux-2.6.38-git18/Documentation/dvb/udev.txt
@@ -1,7 +1,7 @@
 The DVB subsystem currently registers to the sysfs subsystem using the
 "class_simple" interface.
 
-This means that only the basic informations like module loading parameters
+This means that only the basic information like module loading parameters
 are presented through sysfs. Other things that might be interesting are
 currently *not* available.
 
--- linux-2.6.38-git18.orig/Documentation/edac.txt
+++ linux-2.6.38-git18/Documentation/edac.txt
@@ -311,7 +311,7 @@ Total Correctable Errors count attribute
 	'ce_noinfo_count'
 
 	This attribute file displays the number of CEs that
-	have occurred wherewith no informations as to which DIMM slot
+	have occurred wherewith no information as to which DIMM slot
 	is having errors. Memory is handicapped, but operational,
 	yet no information is available to indicate which slot
 	the failing memory is in. This count field should be also
--- linux-2.6.38-git18.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.38-git18/Documentation/kernel-parameters.txt
@@ -2478,8 +2478,8 @@ bytes respectively. Such letter suffixes
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
-			topology informations if the hardware supports these.
-			The scheduler will make use of these informations and
+			topology information if the hardware supports this.
+			The scheduler will make use of this information and
 			e.g. base its process migration decisions on it.
 			Default is on.
 
--- linux-2.6.38-git18.orig/Documentation/laptops/asus-laptop.txt
+++ linux-2.6.38-git18/Documentation/laptops/asus-laptop.txt
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
+  several items of information.
 
   LED display works for the following models:
     W1000N
--- linux-2.6.38-git18.orig/Documentation/networking/batman-adv.txt
+++ linux-2.6.38-git18/Documentation/networking/batman-adv.txt
@@ -72,7 +72,7 @@ folder:
 #  fragmentation    gw_sel_class  vis_mode
 
 
-There is a special folder for debugging informations:
+There is a special folder for debugging information:
 
 #  ls /sys/kernel/debug/batman_adv/bat0/
 #  gateways     socket        transtable_global  vis_data
--- linux-2.6.38-git18.orig/Documentation/s390/Debugging390.txt
+++ linux-2.6.38-git18/Documentation/s390/Debugging390.txt
@@ -2273,7 +2273,7 @@ IP forwarding is on.
 There is a lot of useful info in here best found by going in & having a look around,
 so I'll take you through some entries I consider important.
 
-All the processes running on the machine have there own entry defined by
+All the processes running on the machine have their own entry defined by
 /proc/<pid>
 So lets have a look at the init process
 cd /proc/1
--- linux-2.6.38-git18.orig/Documentation/scsi/sym53c8xx_2.txt
+++ linux-2.6.38-git18/Documentation/scsi/sym53c8xx_2.txt
@@ -285,7 +285,7 @@ from the driver.
 
 7. Profiling information
 
-This driver does not provide profiling informations as did its predecessors.
+This driver does not provide profiling information as did its predecessors.
 This feature was not this useful and added complexity to the code. 
 As the driver code got more complex, I have decided to remove everything 
 that didn't seem actually useful.
--- linux-2.6.38-git18.orig/Documentation/sound/alsa/ALSA-Configuration.txt
+++ linux-2.6.38-git18/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -2229,7 +2229,7 @@ Proc interfaces (/proc/asound)
 
 /proc/asound/card#/pcm#[cp]/oss
 -------------------------------
-  String "erase" - erase all additional informations about OSS applications
+  String "erase" - erase all additional information about OSS applications
   String "<app_name> <fragments> <fragment_size> [<options>]"
 
    <app_name> - name of application with (higher priority) or without path
--- linux-2.6.38-git18.orig/Documentation/sound/oss/AudioExcelDSP16
+++ linux-2.6.38-git18/Documentation/sound/oss/AudioExcelDSP16
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
--- linux-2.6.38-git18.orig/Documentation/sound/oss/README.ymfsb
+++ linux-2.6.38-git18/Documentation/sound/oss/README.ymfsb
@@ -5,7 +5,7 @@ FIRST OF ALL
 ============
 
   This code references YAMAHA's sample codes and data sheets.
-  I respect and thank for all people they made open the informations
+  I respect and thank for all people they made open the information
   about YMF7xx cards.
 
   And this codes heavily based on Jeff Garzik <jgarzik@pobox.com>'s
--- linux-2.6.38-git18.orig/Documentation/video4linux/bttv/Insmod-options
+++ linux-2.6.38-git18/Documentation/video4linux/bttv/Insmod-options
@@ -1,5 +1,5 @@
 
-Note: "modinfo <module>" prints various informations about a kernel
+Note: "modinfo <module>" prints various information about a kernel
 module, among them a complete and up-to-date list of insmod options.
 This list tends to be outdated because it is updated manually ...
 
--- linux-2.6.38-git18.orig/Documentation/video4linux/bttv/Sound-FAQ
+++ linux-2.6.38-git18/Documentation/video4linux/bttv/Sound-FAQ
@@ -8,7 +8,7 @@ completely by the bt8xx chip, which is c
 sound is handled in slightly different ways on each board.
 
 To handle the grabber boards correctly, there is a array tvcards[] in
-bttv-cards.c, which holds the informations required for each board.
+bttv-cards.c, which holds the information required for each board.
 Sound will work only, if the correct entry is used (for video it often
 makes no difference).  The bttv driver prints a line to the kernel
 log, telling which card type is used.  Like this one:
--- linux-2.6.38-git18.orig/Documentation/video4linux/et61x251.txt
+++ linux-2.6.38-git18/Documentation/video4linux/et61x251.txt
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
--- linux-2.6.38-git18.orig/Documentation/video4linux/sn9c102.txt
+++ linux-2.6.38-git18/Documentation/video4linux/sn9c102.txt
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
--- linux-2.6.38-git18.orig/Documentation/video4linux/w9968cf.txt
+++ linux-2.6.38-git18/Documentation/video4linux/w9968cf.txt
@@ -413,7 +413,7 @@ Syntax:         <n>
 Description:    Debugging information level, from 0 to 6:
 		0 = none (use carefully)
 		1 = critical errors
-		2 = significant informations
+		2 = significant information
 		3 = configuration or general messages
 		4 = warnings
 		5 = called functions
--- linux-2.6.38-git18.orig/Documentation/video4linux/zc0301.txt
+++ linux-2.6.38-git18/Documentation/video4linux/zc0301.txt
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
@@ -261,7 +261,7 @@ the fingerprint is: '88E8 F32F 7244 68BA
 
 11. Credits
 ===========
-- Informations about the chip internals needed to enable the I2C protocol have
+- Information about the chip internals needed to enable the I2C protocol have
   been taken from the documentation of the ZC030x Video4Linux1 driver written
   by Andrew Birkett <andy@nobugs.org>;
 - The initialization values of the ZC0301 controller connected to the PAS202BCB
--- linux-2.6.38-git18.orig/arch/powerpc/mm/tlb_low_64e.S
+++ linux-2.6.38-git18/arch/powerpc/mm/tlb_low_64e.S
@@ -431,7 +431,7 @@ virt_page_table_tlb_miss_fault:
 	 * The thing is, we know that in normal circumstances, this is
 	 * always called as a second level tlb miss for SW load or as a first
 	 * level TLB miss for HW load, so we should be able to peek at the
-	 * relevant informations in the first exception frame in the PACA.
+	 * relevant information in the first exception frame in the PACA.
 	 *
 	 * However, we do need to double check that, because we may just hit
 	 * a stray kernel pointer or a userland attack trying to hit those
--- linux-2.6.38-git18.orig/arch/powerpc/platforms/Kconfig
+++ linux-2.6.38-git18/arch/powerpc/platforms/Kconfig
@@ -46,7 +46,7 @@ config PPC_OF_BOOT_TRAMPOLINE
 	help
 	  Support from booting from Open Firmware or yaboot using an
 	  Open Firmware client interface. This enables the kernel to
-	  communicate with open firmware to retrieve system informations
+	  communicate with open firmware to retrieve system information
 	  such as the device tree.
 
 	  In case of doubt, say Y
