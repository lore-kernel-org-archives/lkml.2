Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1IVSja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:39:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49847 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1IVSjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:39:24 -0400
MIME-Version: 1.0
Date: Thu, 22 Sep 2011 20:39:22 +0200
Message-ID: <CAA6PgK5XgMcWu2ZY4uK-U3RFbKMqopXZcXH3urtpoUcWzpUB3w@mail.gmail.com>
Subject: [PATCH][TRIVIAL] CREDITS: fixed trailing spaces and reordered alphabetically
From: Jan Keromnes <jan.keromnes@gmail.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In CREDITS, there were some trailing spaces and 3 names that were not
in alphabetical order. I fixed that.

Full git commit can be found here: http://github.com/jankeromnes/linux

Signed-off-by: Jan Keromnes <jan.keromnes@gmail.com>

---

--- CREDITS.orig        2011-09-22 20:13:34.285079424 +0200
+++ CREDITS     2011-09-22 20:13:37.525079394 +0200
@@ -90,7 +90,7 @@ N: Erik Andersen
 E: andersen@codepoet.org
 W: http://www.codepoet.org/
 P: 1024D/30D39057 1BC4 2742 E885 E4DE 9301  0C82 5F9B 643E 30D3 9057
-D: Maintainer of ide-cd and Uniform CD-ROM driver,
+D: Maintainer of ide-cd and Uniform CD-ROM driver,
 D: ATAPI CD-Changer support, Major 2.1.x CD-ROM update.
 S: 352 North 525 East
 S: Springville, Utah 84663
@@ -247,7 +247,7 @@ N: Paul Barton-Davis
 E: pbd@op.net
 D: Driver for WaveFront soundcards (Turtle Beach Maui, Tropez, Tropez+)
 D: Various bugfixes and changes to sound drivers
-S: USA
+S: USA

 N: Carlos Henrique Bauer
 E: chbauer@acm.org
@@ -616,15 +616,15 @@ S: Tamsui town, Taipei county,
 S: Taiwan 251
 S: Republic of China

+N: Michael Elizabeth Chastain
+E: mec@shout.net
+D: Configure, Menuconfig, xconfig
+
 N: Reinette Chatre
 E: reinette.chatre@intel.com
 D: WiMedia Link Protocol implementation
 D: UWB stack bits and pieces

-N: Michael Elizabeth Chastain
-E: mec@shout.net
-D: Configure, Menuconfig, xconfig
-
 N: Raymond Chen
 E: raymondc@microsoft.com
 D: Author of Configure script
@@ -1140,7 +1140,7 @@ N: Daniel J. Frasnelli
 E: dfrasnel@alphalinux.org
 W: http://www.alphalinux.org/
 P: 1024/3EF87611 B9 F1 44 50 D3 E8 C2 80  DA E5 55 AA 56 7C 42 DA
-D: DEC Alpha hacker
+D: DEC Alpha hacker
 D: Miscellaneous bug squisher

 N: Jim Freeman
@@ -1212,7 +1212,7 @@ E: philip@gladstonefamily.net
 D: Kernel / timekeeping stuff
 S: Carlisle, MA 01741
 S: USA
-
+
 N: Jan-Benedict Glaw
 E: jbglaw@lug-owl.de
 D: SRM environment driver (for Alpha systems)
@@ -1233,7 +1233,7 @@ S: P.O. Box 76, Epping
 S: New South Wales, 2121
 S: Australia

-N: Carlos E. Gorges
+N: Carlos E. Gorges
 E: carlos@techlinux.com.br
 D: fix smp support on cmpci driver
 P: 2048G/EA3C4B19 FF31 33A6 0362 4915 B7EB  E541 17D0 0379 EA3C 4B19
@@ -1274,7 +1274,7 @@ E: wgreathouse@smva.com
 E: wgreathouse@myfavoritei.com
 D: Current Belkin USB Serial Adapter F5U103 hacker
 D: Kernel hacker, embedded systems
-S: 7802 Fitzwater Road
+S: 7802 Fitzwater Road
 S: Brecksville, OH  44141-1334
 S: USA

@@ -1315,7 +1315,7 @@ N: Grant Guenther
 E: grant@torque.net
 W: http://www.torque.net/linux-pp.html
 D: original author of ppa driver for parallel port ZIP drive
-D: original architect of the parallel-port sharing scheme
+D: original architect of the parallel-port sharing scheme
 D: PARIDE subsystem: drivers for parallel port IDE & ATAPI devices
 S: 44 St. Joseph Street, Suite 506
 S: Toronto, Ontario, M4Y 2W4
@@ -1454,7 +1454,7 @@ N: Benjamin Herrenschmidt
 E: benh@kernel.crashing.org
 D: Various parts of PPC/PPC64 & PowerMac
 S: 312/107 Canberra Avenue
-S: Griffith, ACT 2603
+S: Griffith, ACT 2603
 S: Australia

 N: Sebastian Hetze
@@ -1728,7 +1728,7 @@ S: Hungary
 N: Bernhard Kaindl
 E: bkaindl@netway.at
 E: edv@bartelt.via.at
-D: Author of a menu based configuration tool, kmenu, which
+D: Author of a menu based configuration tool, kmenu, which
 D: is the predecessor of 'make menuconfig' and 'make xconfig'.
 D: digiboard driver update(modularisation work and 2.1.x upd)
 S: Tallak 95
@@ -1884,7 +1884,7 @@ W: http://www.xos.nl/
 D: IP transparent proxy support
 S: X/OS Experts in Open Systems BV
 S: Kruislaan 419
-S: 1098 VA Amsterdam
+S: 1098 VA Amsterdam
 S: The Netherlands

 N: Goran Koruga
@@ -1956,7 +1956,7 @@ S: Germany

 N: Andrzej M. Krzysztofowicz
 E: ankry@mif.pg.gda.pl
-D: Some 8-bit XT disk driver and devfs hacking
+D: Some 8-bit XT disk driver and devfs hacking
 D: Aladdin 1533/1543(C) chipset IDE
 D: PIIX chipset IDE
 S: ul. Matemblewska 1B/10
@@ -2309,7 +2309,7 @@ E: mge@EZ-Darmstadt.Telekom.de
 D: Logical Volume Manager
 S: Bartningstr. 12
 S: 64289 Darmstadt
-S: Germany
+S: Germany

 N: Mark W. McClelland
 E: mmcclell@bigfoot.com
@@ -2394,7 +2394,7 @@ E: meskes@debian.org
 P: 1024/04B6E8F5 6C 77 33 CA CC D6 22 03  AB AB 15 A3 AE AD 39 7D
 D: Kernel hacker. PostgreSQL hacker. Software watchdog daemon.
 D: Maintainer of several Debian packages
-S: Th.-Heuss-Str. 61
+S: Th.-Heuss-Str. 61
 S: D-41812 Erkelenz
 S: Germany

@@ -2489,6 +2489,10 @@ S: 12725 SW Millikan Way, Suite 400
 S: Beaverton, Oregon 97005
 S: USA

+N: Thomas Molina
+E: tmolina@cablespeed.com
+D: bug fixes, documentation, minor hackery
+
 N: Eberhard Mönkeberg
 E: emoenke@gwdg.de
 D: CDROM driver "sbpcd" (Matsushita/Panasonic/Soundblaster)
@@ -2496,10 +2500,6 @@ S: Ruhstrathöhe 2 b.
 S: D-37085 Göttingen
 S: Germany

-N: Thomas Molina
-E: tmolina@cablespeed.com
-D: bug fixes, documentation, minor hackery
-
 N: Paul Moore
 E: paul.moore@hp.com
 D: NetLabel author
@@ -2621,7 +2621,7 @@ E: neuffer@goofy.zdv.uni-mainz.de
 W: http://www.i-Connect.Net/~mike/
 D: Developer and maintainer of the EATA-DMA SCSI driver
 D: Co-developer EATA-PIO SCSI driver
-D: /proc/scsi and assorted other snippets
+D: /proc/scsi and assorted other snippets
 S: Zum Schiersteiner Grund 2
 S: 55127 Mainz
 S: Germany
@@ -2733,13 +2733,6 @@ S: RR #5, 497 Pole Line Road
 S: Thunder Bay, Ontario
 S: CANADA P7C 5M9

-N: Inaky Perez-Gonzalez
-E: inaky.perez-gonzalez@intel.com
-E: linux-wimax@intel.com
-E: inakypg@yahoo.com
-D: WiMAX stack
-D: Intel Wireless WiMAX Connection 2400 driver
-
 N: Yuri Per
 E: yuri@pts.mipt.ru
 D: Some smbfs fixes
@@ -2749,6 +2742,10 @@ S: Russia

 N: Inaky Perez-Gonzalez
 E: inaky.perez-gonzalez@intel.com
+E: linux-wimax@intel.com
+E: inakypg@yahoo.com
+D: WiMAX stack
+D: Intel Wireless WiMAX Connection 2400 driver
 D: UWB stack, HWA-RC driver and HWA-HC drivers
 D: Wireless USB additions to the USB stack
 D: WiMedia Link Protocol bits and pieces
@@ -2845,7 +2842,7 @@ D: Embedded PowerPC 4xx/6xx/7xx/74xx sup
 S: Chandler, Arizona 85249
 S: USA

-N: Frederic Potter
+N: Frederic Potter
 E: fpotter@cirpack.com
 D: Some PCI kernel support

@@ -3234,21 +3231,21 @@ S: Klosterweg 28 / i309
 S: 76131 Karlsruhe
 S: Germany

-N: James Simmons
+N: James Simmons
 E: jsimmons@infradead.org
-E: jsimmons@users.sf.net
+E: jsimmons@users.sf.net
 D: Frame buffer device maintainer
 D: input layer development
 D: tty/console layer
-D: various mipsel devices
-S: 115 Carmel Avenue
+D: various mipsel devices
+S: 115 Carmel Avenue
 S: El Cerrito CA 94530
-S: USA
+S: USA

 N: Jaspreet Singh
 E: jaspreet@sangoma.com
 W: www.sangoma.com
-D: WANPIPE drivers & API Support for Sangoma S508/FT1 cards
+D: WANPIPE drivers & API Support for Sangoma S508/FT1 cards
 S: Sangoma Technologies Inc.,
 S: 1001 Denison Street
 S: Suite 101
@@ -3268,7 +3265,7 @@ N: Craig Small
 E: csmall@triode.apana.org.au
 E: vk2xlz@gonzo.vk2xlz.ampr.org (packet radio)
 D: Gracilis PackeTwin device driver
-D: RSPF daemon
+D: RSPF daemon
 S: 10 Stockalls Place
 S: Minto, NSW, 2566
 S: Australia
@@ -3473,7 +3470,7 @@ N: Tsu-Sheng Tsao
 E: tsusheng@scf.usc.edu
 D: IGMP(Internet Group Management Protocol) version 2
 S: 2F 14 ALY 31 LN 166 SEC 1 SHIH-PEI RD
-S: Taipei
+S: Taipei
 S: Taiwan 112
 S: Republic of China
 S: 24335 Delta Drive
@@ -3624,7 +3621,7 @@ D: Produced the Slackware distribution,
 D: patches for ghostscript, worked on color 'ls', etc.
 S: 301 15th Street S.
 S: Moorhead, Minnesota 56560
-S: USA
+S: USA

 N: Jos Vos
 E: jos@xos.nl
@@ -3632,7 +3629,7 @@ W: http://www.xos.nl/
 D: Various IP firewall updates, ipfwadm
 S: X/OS Experts in Open Systems BV
 S: Kruislaan 419
-S: 1098 VA Amsterdam
+S: 1098 VA Amsterdam
 S: The Netherlands

 N: Jeroen Vreeken
@@ -3872,7 +3869,7 @@ S: People's Repulic of China
 N: Victor Yodaiken
 E: yodaiken@fsmlabs.com
 D: RTLinux (RealTime Linux)
-S: POB 1822
+S: POB 1822
 S: Socorro NM, 87801
 S: USA

@@ -3967,7 +3964,7 @@ S: France


 # Don't add your name here, unless you really _are_ after Marc
-# alphabetically. Leonard used to be very proud of being the
+# alphabetically. Leonard used to be very proud of being the
 # last entry, and he'll get positively pissed if he can't even
 # be second-to-last.  (and this file really _is_ supposed to be
 # in alphabetic order)
