Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2CEQZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:25:07 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:65222 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab2CEQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:25:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of standby24x7@gmail.com designates 10.68.130.72 as permitted sender) smtp.mail=standby24x7@gmail.com; dkim=pass header.i=standby24x7@gmail.com
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Documentation: Fix multiple typo in Documentation
Date: Tue,  6 Mar 2012 01:24:53 +0900
Message-Id: <1330964693-29763-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.9.2.262.gba998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct following typo within 25 files in Documentation.

"explaination" to "explanation" in dmaengine.txt
"fucntion" to "function" in static-keys.txt
"useage" to "usage" in arm/kernel_user_helpers.txt
"tranfer" to "transfer" in DocBook/libata.tmpl
"devided" to "divided" in filesystems/qnx6.txt
"appropriatly" to "appropriately" in i2o/ioctl
"ususally" to "usually" in input/alps.txt
"ocassionally" to "occasionally" in input/alps.txt
"Ths" to "This" in scsi/ChangeLog.megaraid_sas
"preceeded" to "preceded" in virtual/virtio-spec.txt
"guarentees" to "guarantees" in virtual/virtio-spec.txt
"withdrawl" to "withdrawal" in virtual/virtio-spec.txt
"independantly" to "independently" in video4linux/uvcvideo.txt
"Licenced" to "Licensed" in laptops/dslm.c
"adress" to "address" in filesystems/qnx6.txt
"Millenium" to "Millennium" in filesystems/qnx6.txt,
  fb/matrixfb.txt, howmon/adm1275, hwmon/max16064,
  hwmon/max34440, hwmon/max8688, hwmon/ucd9000, hwmon/ucd9200,
  hwmon/zl6100, scsi/tmscsim.txt, input/joystick.txt
"endianess" to "endianness" in filesystems/qnx6.txt,
  ioctl/hdio.txt, networking/fore200e.txt,
  ide/ChangeLog.ide-cd.1994-2004

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

---
 Documentation/DocBook/libata.tmpl            |    4 ++--
 Documentation/arm/kernel_user_helpers.txt    |    2 +-
 Documentation/dmaengine.txt                  |    2 +-
 Documentation/fb/matroxfb.txt                |    6 +++---
 Documentation/filesystems/qnx6.txt           |   26 +++++++++++++-------------
 Documentation/hwmon/adm1275                  |    2 +-
 Documentation/hwmon/max16064                 |    4 ++--
 Documentation/hwmon/max34440                 |    4 ++--
 Documentation/hwmon/max8688                  |    4 ++--
 Documentation/hwmon/ucd9000                  |    6 +++---
 Documentation/hwmon/ucd9200                  |    8 ++++----
 Documentation/hwmon/zl6100                   |    4 ++--
 Documentation/i2o/ioctl                      |   12 ++++++------
 Documentation/ide/ChangeLog.ide-cd.1994-2004 |    2 +-
 Documentation/input/alps.txt                 |    4 ++--
 Documentation/input/joystick.txt             |    2 +-
 Documentation/ioctl/hdio.txt                 |    4 ++--
 Documentation/laptops/dslm.c                 |    2 +-
 Documentation/networking/fore200e.txt        |    2 +-
 Documentation/scsi/ChangeLog.lpfc            |    2 +-
 Documentation/scsi/ChangeLog.megaraid_sas    |    2 +-
 Documentation/scsi/tmscsim.txt               |    2 +-
 Documentation/static-keys.txt                |    2 +-
 Documentation/video4linux/uvcvideo.txt       |    2 +-
 Documentation/virtual/virtio-spec.txt        |    8 ++++----
 25 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index 880c956..31df1aa 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -945,7 +945,7 @@ and other resources, etc.
 
         <listitem>
 	<para>
-	!BSY &amp;&amp; ERR after CDB tranfer starts but before the
+	!BSY &amp;&amp; ERR after CDB transfer starts but before the
         last byte of CDB is transferred.  ATA/ATAPI standard states
         that &quot;The device shall not terminate the PACKET command
         with an error before the last byte of the command packet has
@@ -1050,7 +1050,7 @@ and other resources, etc.
 	   to complete a command.  Combined with the fact that MWDMA
 	   and PIO transfer errors aren't allowed to use ICRC bit up to
 	   ATA/ATAPI-7, it seems to imply that ABRT bit alone could
-	   indicate tranfer errors.
+	   indicate transfer errors.
 	   </para>
 	   <para>
 	   However, ATA/ATAPI-8 draft revision 1f removes the part
diff --git a/Documentation/arm/kernel_user_helpers.txt b/Documentation/arm/kernel_user_helpers.txt
index a17df9f..5673594 100644
--- a/Documentation/arm/kernel_user_helpers.txt
+++ b/Documentation/arm/kernel_user_helpers.txt
@@ -25,7 +25,7 @@ inline (either in the code emitted directly by the compiler, or part of
 the implementation of a library call) when optimizing for a recent enough
 processor that has the necessary native support, but only if resulting
 binaries are already to be incompatible with earlier ARM processors due to
-useage of similar native instructions for other things.  In other words
+usage of similar native instructions for other things.  In other words
 don't make binaries unable to run on earlier processors just for the sake
 of not using these kernel helpers if your compiled code is not going to
 use new instructions for other purpose.
diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
index bbe6cb3..879b6e3 100644
--- a/Documentation/dmaengine.txt
+++ b/Documentation/dmaengine.txt
@@ -63,7 +63,7 @@ The slave DMA usage consists of following steps:
 				  struct dma_slave_config *config)
 
    Please see the dma_slave_config structure definition in dmaengine.h
-   for a detailed explaination of the struct members.  Please note
+   for a detailed explanation of the struct members.  Please note
    that the 'direction' member will be going away as it duplicates the
    direction given in the prepare call.
 
diff --git a/Documentation/fb/matroxfb.txt b/Documentation/fb/matroxfb.txt
index e5ce8a1..a75cf19 100644
--- a/Documentation/fb/matroxfb.txt
+++ b/Documentation/fb/matroxfb.txt
@@ -177,8 +177,8 @@ sgram    - tells to driver that you have Gxx0 with SGRAM memory. It has no
            effect without `init'.
 sdram    - tells to driver that you have Gxx0 with SDRAM memory.
            It is a default.
-inv24    - change timings parameters for 24bpp modes on Millenium and
-           Millenium II. Specify this if you see strange color shadows around
+inv24    - change timings parameters for 24bpp modes on Millennium and
+           Millennium II. Specify this if you see strange color shadows around
 	   characters.
 noinv24  - use standard timings. It is the default.
 inverse  - invert colors on screen (for LCD displays)
@@ -204,7 +204,7 @@ grayscale - enable grayscale summing. It works in PSEUDOCOLOR modes (text,
 	    can paint colors.
 nograyscale - disable grayscale summing. It is default.
 cross4MB - enables that pixel line can cross 4MB boundary. It is default for
-           non-Millenium.
+           non-Millennium.
 nocross4MB - pixel line must not cross 4MB boundary. It is default for
              Millenium I or II, because of these devices have hardware
 	     limitations which do not allow this. But this option is
diff --git a/Documentation/filesystems/qnx6.txt b/Documentation/filesystems/qnx6.txt
index 050223e..1a2e929 100644
--- a/Documentation/filesystems/qnx6.txt
+++ b/Documentation/filesystems/qnx6.txt
@@ -17,7 +17,7 @@ concepts of blocks, inodes and directories.
 On QNX it is possible to create little endian and big endian qnx6 filesystems.
 This feature makes it possible to create and use a different endianness fs
 for the target (QNX is used on quite a range of embedded systems) plattform
-running on a different endianess.
+running on a different endianness.
 The Linux driver handles endianness transparently. (LE and BE)
 
 Blocks
@@ -26,7 +26,7 @@ Blocks
 The space in the device or file is split up into blocks. These are a fixed
 size of 512, 1024, 2048 or 4096, which is decided when the filesystem is
 created.
-Blockpointers are 32bit, so the maximum space that can be adressed is
+Blockpointers are 32bit, so the maximum space that can be addressed is
 2^32 * 4096 bytes or 16TB
 
 The superblocks
@@ -47,16 +47,16 @@ inactive superblock.
 Each superblock holds a set of root inodes for the different filesystem
 parts. (Inode, Bitmap and Longfilenames)
 Each of these root nodes holds information like total size of the stored
-data and the adressing levels in that specific tree.
-If the level value is 0, up to 16 direct blocks can be adressed by each
+data and the addressing levels in that specific tree.
+If the level value is 0, up to 16 direct blocks can be addressed by each
 node.
-Level 1 adds an additional indirect adressing level where each indirect
-adressing block holds up to blocksize / 4 bytes pointers to data blocks.
-Level 2 adds an additional indirect adressig block level (so, already up
-to 16 * 256 * 256 = 1048576 blocks that can be adressed by such a tree)a
+Level 1 adds an additional indirect addressing level where each indirect
+addressing block holds up to blocksize / 4 bytes pointers to data blocks.
+Level 2 adds an additional indirect addressig block level (so, already up
+to 16 * 256 * 256 = 1048576 blocks that can be addressed by such a tree)a
 
 Unused block pointers are always set to ~0 - regardless of root node,
-indirect adressing blocks or inodes.
+indirect addressing blocks or inodes.
 Data leaves are always on the lowest level. So no data is stored on upper
 tree levels.
 
@@ -83,8 +83,8 @@ size, number of blocks used, access time, change time and modification time.
 Object mode field is POSIX format. (which makes things easier)
 
 There are also pointers to the first 16 blocks, if the object data can be
-adressed with 16 direct blocks.
-For more than 16 blocks an indirect adressing in form of another tree is
+addressed with 16 direct blocks.
+For more than 16 blocks an indirect addressing in form of another tree is
 used. (scheme is the same as the one used for the superblock root nodes)
 
 The filesize is stored 64bit. Inode counting starts with 1. (whilst long
@@ -124,7 +124,7 @@ underlaying filesystem.
 Long filenames
 --------------
 
-Long filenames are stored in a seperate adressing tree. The staring point
+Long filenames are stored in a separate addressing tree. The staring point
 is the longfilename root node in the active superblock.
 Each data block (tree leaves) holds one long filename. That filename is
 limited to 510 bytes. The first two starting bytes are used as length field
@@ -148,7 +148,7 @@ smaller than addressing space in the bitmap.
 Bitmap system area
 ------------------
 
-The bitmap itself is devided into three parts.
+The bitmap itself is divided into three parts.
 First the system area, that is split into two halfs.
 Then userspace.
 
diff --git a/Documentation/hwmon/adm1275 b/Documentation/hwmon/adm1275
index ab70d96..e5f982c 100644
--- a/Documentation/hwmon/adm1275
+++ b/Documentation/hwmon/adm1275
@@ -53,7 +53,7 @@ attributes are write-only, all other attributes are read-only.
 in1_label		"vin1" or "vout1" depending on chip variant and
 			configuration.
 in1_input		Measured voltage.
-in1_min			Minumum Voltage.
+in1_min			Minimum Voltage.
 in1_max			Maximum voltage.
 in1_min_alarm		Voltage low alarm.
 in1_max_alarm		Voltage high alarm.
diff --git a/Documentation/hwmon/max16064 b/Documentation/hwmon/max16064
index f6e8bcb..f8b4780 100644
--- a/Documentation/hwmon/max16064
+++ b/Documentation/hwmon/max16064
@@ -42,9 +42,9 @@ attributes are read-only.
 
 in[1-4]_label		"vout[1-4]"
 in[1-4]_input		Measured voltage. From READ_VOUT register.
-in[1-4]_min		Minumum Voltage. From VOUT_UV_WARN_LIMIT register.
+in[1-4]_min		Minimum Voltage. From VOUT_UV_WARN_LIMIT register.
 in[1-4]_max		Maximum voltage. From VOUT_OV_WARN_LIMIT register.
-in[1-4]_lcrit		Critical minumum Voltage. VOUT_UV_FAULT_LIMIT register.
+in[1-4]_lcrit		Critical minimum Voltage. VOUT_UV_FAULT_LIMIT register.
 in[1-4]_crit		Critical maximum voltage. From VOUT_OV_FAULT_LIMIT register.
 in[1-4]_min_alarm	Voltage low alarm. From VOLTAGE_UV_WARNING status.
 in[1-4]_max_alarm	Voltage high alarm. From VOLTAGE_OV_WARNING status.
diff --git a/Documentation/hwmon/max34440 b/Documentation/hwmon/max34440
index 36b335c..ebc2971 100644
--- a/Documentation/hwmon/max34440
+++ b/Documentation/hwmon/max34440
@@ -48,9 +48,9 @@ attributes are read-only.
 
 in[1-6]_label		"vout[1-6]".
 in[1-6]_input		Measured voltage. From READ_VOUT register.
-in[1-6]_min		Minumum Voltage. From VOUT_UV_WARN_LIMIT register.
+in[1-6]_min		Minimum Voltage. From VOUT_UV_WARN_LIMIT register.
 in[1-6]_max		Maximum voltage. From VOUT_OV_WARN_LIMIT register.
-in[1-6]_lcrit		Critical minumum Voltage. VOUT_UV_FAULT_LIMIT register.
+in[1-6]_lcrit		Critical minimum Voltage. VOUT_UV_FAULT_LIMIT register.
 in[1-6]_crit		Critical maximum voltage. From VOUT_OV_FAULT_LIMIT register.
 in[1-6]_min_alarm	Voltage low alarm. From VOLTAGE_UV_WARNING status.
 in[1-6]_max_alarm	Voltage high alarm. From VOLTAGE_OV_WARNING status.
diff --git a/Documentation/hwmon/max8688 b/Documentation/hwmon/max8688
index 71ed10a..fe84987 100644
--- a/Documentation/hwmon/max8688
+++ b/Documentation/hwmon/max8688
@@ -42,9 +42,9 @@ attributes are read-only.
 
 in1_label		"vout1"
 in1_input		Measured voltage. From READ_VOUT register.
-in1_min			Minumum Voltage. From VOUT_UV_WARN_LIMIT register.
+in1_min			Minimum Voltage. From VOUT_UV_WARN_LIMIT register.
 in1_max			Maximum voltage. From VOUT_OV_WARN_LIMIT register.
-in1_lcrit		Critical minumum Voltage. VOUT_UV_FAULT_LIMIT register.
+in1_lcrit		Critical minimum Voltage. VOUT_UV_FAULT_LIMIT register.
 in1_crit		Critical maximum voltage. From VOUT_OV_FAULT_LIMIT register.
 in1_min_alarm		Voltage low alarm. From VOLTAGE_UV_WARNING status.
 in1_max_alarm		Voltage high alarm. From VOLTAGE_OV_WARNING status.
diff --git a/Documentation/hwmon/ucd9000 b/Documentation/hwmon/ucd9000
index 40ca6db..0df5f27 100644
--- a/Documentation/hwmon/ucd9000
+++ b/Documentation/hwmon/ucd9000
@@ -70,9 +70,9 @@ attributes are read-only.
 
 in[1-12]_label		"vout[1-12]".
 in[1-12]_input		Measured voltage. From READ_VOUT register.
-in[1-12]_min		Minumum Voltage. From VOUT_UV_WARN_LIMIT register.
+in[1-12]_min		Minimum Voltage. From VOUT_UV_WARN_LIMIT register.
 in[1-12]_max		Maximum voltage. From VOUT_OV_WARN_LIMIT register.
-in[1-12]_lcrit		Critical minumum Voltage. VOUT_UV_FAULT_LIMIT register.
+in[1-12]_lcrit		Critical minimum Voltage. VOUT_UV_FAULT_LIMIT register.
 in[1-12]_crit		Critical maximum voltage. From VOUT_OV_FAULT_LIMIT register.
 in[1-12]_min_alarm	Voltage low alarm. From VOLTAGE_UV_WARNING status.
 in[1-12]_max_alarm	Voltage high alarm. From VOLTAGE_OV_WARNING status.
@@ -82,7 +82,7 @@ in[1-12]_crit_alarm	Voltage critical high alarm. From VOLTAGE_OV_FAULT status.
 curr[1-12]_label	"iout[1-12]".
 curr[1-12]_input	Measured current. From READ_IOUT register.
 curr[1-12]_max		Maximum current. From IOUT_OC_WARN_LIMIT register.
-curr[1-12]_lcrit	Critical minumum output current. From IOUT_UC_FAULT_LIMIT
+curr[1-12]_lcrit	Critical minimum output current. From IOUT_UC_FAULT_LIMIT
 			register.
 curr[1-12]_crit		Critical maximum current. From IOUT_OC_FAULT_LIMIT register.
 curr[1-12]_max_alarm	Current high alarm. From IOUT_OC_WARNING status.
diff --git a/Documentation/hwmon/ucd9200 b/Documentation/hwmon/ucd9200
index 3c58607..1abb179 100644
--- a/Documentation/hwmon/ucd9200
+++ b/Documentation/hwmon/ucd9200
@@ -54,9 +54,9 @@ attributes are read-only.
 
 in1_label		"vin".
 in1_input		Measured voltage. From READ_VIN register.
-in1_min			Minumum Voltage. From VIN_UV_WARN_LIMIT register.
+in1_min			Minimum Voltage. From VIN_UV_WARN_LIMIT register.
 in1_max			Maximum voltage. From VIN_OV_WARN_LIMIT register.
-in1_lcrit		Critical minumum Voltage. VIN_UV_FAULT_LIMIT register.
+in1_lcrit		Critical minimum Voltage. VIN_UV_FAULT_LIMIT register.
 in1_crit		Critical maximum voltage. From VIN_OV_FAULT_LIMIT register.
 in1_min_alarm		Voltage low alarm. From VIN_UV_WARNING status.
 in1_max_alarm		Voltage high alarm. From VIN_OV_WARNING status.
@@ -67,7 +67,7 @@ in[2-5]_label		"vout[1-4]".
 in[2-5]_input		Measured voltage. From READ_VOUT register.
 in[2-5]_min		Minumum Voltage. From VOUT_UV_WARN_LIMIT register.
 in[2-5]_max		Maximum voltage. From VOUT_OV_WARN_LIMIT register.
-in[2-5]_lcrit		Critical minumum Voltage. VOUT_UV_FAULT_LIMIT register.
+in[2-5]_lcrit		Critical minimum Voltage. VOUT_UV_FAULT_LIMIT register.
 in[2-5]_crit		Critical maximum voltage. From VOUT_OV_FAULT_LIMIT register.
 in[2-5]_min_alarm	Voltage low alarm. From VOLTAGE_UV_WARNING status.
 in[2-5]_max_alarm	Voltage high alarm. From VOLTAGE_OV_WARNING status.
@@ -80,7 +80,7 @@ curr1_input		Measured current. From READ_IIN register.
 curr[2-5]_label		"iout[1-4]".
 curr[2-5]_input		Measured current. From READ_IOUT register.
 curr[2-5]_max		Maximum current. From IOUT_OC_WARN_LIMIT register.
-curr[2-5]_lcrit		Critical minumum output current. From IOUT_UC_FAULT_LIMIT
+curr[2-5]_lcrit		Critical minimum output current. From IOUT_UC_FAULT_LIMIT
 			register.
 curr[2-5]_crit		Critical maximum current. From IOUT_OC_FAULT_LIMIT register.
 curr[2-5]_max_alarm	Current high alarm. From IOUT_OC_WARNING status.
diff --git a/Documentation/hwmon/zl6100 b/Documentation/hwmon/zl6100
index 51f76a1..5865a24 100644
--- a/Documentation/hwmon/zl6100
+++ b/Documentation/hwmon/zl6100
@@ -108,7 +108,7 @@ in1_label		"vin"
 in1_input		Measured input voltage.
 in1_min			Minimum input voltage.
 in1_max			Maximum input voltage.
-in1_lcrit		Critical minumum input voltage.
+in1_lcrit		Critical minimum input voltage.
 in1_crit		Critical maximum input voltage.
 in1_min_alarm		Input voltage low alarm.
 in1_max_alarm		Input voltage high alarm.
@@ -117,7 +117,7 @@ in1_crit_alarm		Input voltage critical high alarm.
 
 in2_label		"vout1"
 in2_input		Measured output voltage.
-in2_lcrit		Critical minumum output Voltage.
+in2_lcrit		Critical minimum output Voltage.
 in2_crit		Critical maximum output voltage.
 in2_lcrit_alarm		Critical output voltage critical low alarm.
 in2_crit_alarm		Critical output voltage critical high alarm.
diff --git a/Documentation/i2o/ioctl b/Documentation/i2o/ioctl
index 22ca53a..27c3c54 100644
--- a/Documentation/i2o/ioctl
+++ b/Documentation/i2o/ioctl
@@ -138,7 +138,7 @@ VI. Setting Parameters
 
    The return value is the size in bytes of the data written into
    ops->resbuf if no errors occur.  If an error occurs, -1 is returned
-   and errno is set appropriatly:
+   and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -222,7 +222,7 @@ VIII. Downloading Software
    RETURNS
 
    This function returns 0 no errors occur. If an error occurs, -1
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -264,7 +264,7 @@ IX. Uploading Software
    RETURNS
 
    This function returns 0 if no errors occur.  If an error occurs, -1
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -301,7 +301,7 @@ X. Removing Software
    RETURNS
 
    This function returns 0 if no errors occur.  If an error occurs, -1
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
@@ -325,7 +325,7 @@ X. Validating Configuration
    RETURNS
 
    This function returns 0 if no erro occur.  If an error occurs, -1 is
-   returned and errno is set appropriatly:
+   returned and errno is set appropriately:
 
       ETIMEDOUT   Timeout waiting for reply message
       ENXIO       Invalid IOP number
@@ -360,7 +360,7 @@ XI. Configuration Dialog
    RETURNS
 
    This function returns 0 if no error occur. If an error occurs, -1
-   is returned and errno is set appropriatly:
+   is returned and errno is set appropriately:
 
       EFAULT      Invalid user space pointer was passed
       ENXIO       Invalid IOP number
diff --git a/Documentation/ide/ChangeLog.ide-cd.1994-2004 b/Documentation/ide/ChangeLog.ide-cd.1994-2004
index 190d17b..b2cf804 100644
--- a/Documentation/ide/ChangeLog.ide-cd.1994-2004
+++ b/Documentation/ide/ChangeLog.ide-cd.1994-2004
@@ -175,7 +175,7 @@
  *                         since the .pdf version doesn't seem to work...
  *                     -- Updated the TODO list to something more current.
  *
- * 4.15  Aug 25, 1998  -- Updated ide-cd.h to respect mechine endianess,
+ * 4.15  Aug 25, 1998  -- Updated ide-cd.h to respect mechine endianness,
  *                         patch thanks to "Eddie C. Dost" <ecd@skynet.be>
  *
  * 4.50  Oct 19, 1998  -- New maintainers!
diff --git a/Documentation/input/alps.txt b/Documentation/input/alps.txt
index 2f95308..c7c5d33 100644
--- a/Documentation/input/alps.txt
+++ b/Documentation/input/alps.txt
@@ -132,8 +132,8 @@ number of contacts (f1 and f0 in the table below).
  byte 5:    0    1    ?    ?    ?    ?   f1   f0
 
 This packet only appears after a position packet with the mt bit set, and
-ususally only appears when there are two or more contacts (although
-ocassionally it's seen with only a single contact).
+usually only appears when there are two or more contacts (although
+occasionally it's seen with only a single contact).
 
 The final v3 packet type is the trackstick packet.
 
diff --git a/Documentation/input/joystick.txt b/Documentation/input/joystick.txt
index 8007b7c..87ac40c 100644
--- a/Documentation/input/joystick.txt
+++ b/Documentation/input/joystick.txt
@@ -330,7 +330,7 @@ the USB documentation for how to setup an USB mouse.
   The TM DirectConnect (BSP) protocol is supported by the tmdc.c
 module. This includes, but is not limited to:
 
-* ThrustMaster Millenium 3D Inceptor
+* ThrustMaster Millennium 3D Inceptor
 * ThrustMaster 3D Rage Pad
 * ThrustMaster Fusion Digital Game Pad
 
diff --git a/Documentation/ioctl/hdio.txt b/Documentation/ioctl/hdio.txt
index 91a6ecb..18eb98c 100644
--- a/Documentation/ioctl/hdio.txt
+++ b/Documentation/ioctl/hdio.txt
@@ -596,7 +596,7 @@ HDIO_DRIVE_TASKFILE		execute raw taskfile
 	     if CHS/LBA28
 
 	  The association between in_flags.all and each enable
-	  bitfield flips depending on endianess; fortunately, TASKFILE
+	  bitfield flips depending on endianness; fortunately, TASKFILE
 	  only uses inflags.b.data bit and ignores all other bits.
 	  The end result is that, on any endian machines, it has no
 	  effect other than modifying in_flags on completion.
@@ -720,7 +720,7 @@ HDIO_DRIVE_TASKFILE		execute raw taskfile
 
 	  [6] Do not access {in|out}_flags->all except for resetting
 	  all the bits.  Always access individual bit fields.  ->all
-	  value will flip depending on endianess.  For the same
+	  value will flip depending on endianness.  For the same
 	  reason, do not use IDE_{TASKFILE|HOB}_STD_{OUT|IN}_FLAGS
 	  constants defined in hdreg.h.
 
diff --git a/Documentation/laptops/dslm.c b/Documentation/laptops/dslm.c
index 72ff290..d5dd2d4 100644
--- a/Documentation/laptops/dslm.c
+++ b/Documentation/laptops/dslm.c
@@ -2,7 +2,7 @@
  * dslm.c
  * Simple Disk Sleep Monitor
  *  by Bartek Kania
- * Licenced under the GPL
+ * Licensed under the GPL
  */
 #include <unistd.h>
 #include <stdlib.h>
diff --git a/Documentation/networking/fore200e.txt b/Documentation/networking/fore200e.txt
index 6e0d2a9..f648eb2 100644
--- a/Documentation/networking/fore200e.txt
+++ b/Documentation/networking/fore200e.txt
@@ -44,7 +44,7 @@ the 'software updates' pages. The firmware binaries are part of
 the various ForeThought software distributions.
 
 Notice that different versions of the PCA-200E firmware exist, depending
-on the endianess of the host architecture. The driver is shipped with
+on the endianness of the host architecture. The driver is shipped with
 both little and big endian PCA firmware images.
 
 Name and location of the new firmware images can be set at kernel
diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index c56ec99..2f6d595 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -1718,7 +1718,7 @@ Changes from 20040319 to 20040326
 	* lpfc_els_timeout_handler() now uses system timer.
 	* Further cleanup of #ifdef powerpc
 	* lpfc_scsi_timeout_handler() now uses system timer.
-	* Replace common driver's own defines for endianess w/ Linux's
+	* Replace common driver's own defines for endianness w/ Linux's
 	  __BIG_ENDIAN etc.
 	* Added #ifdef IPFC for all IPFC specific code.
 	* lpfc_disc_retry_rptlun() now uses system timer.
diff --git a/Documentation/scsi/ChangeLog.megaraid_sas b/Documentation/scsi/ChangeLog.megaraid_sas
index 57566ba..83f8ea8 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -510,7 +510,7 @@ i.	Support for 1078 type (ppc IOP) controller, device id : 0x60 added.
 3 Older Version   : 00.00.02.02 
 i.	Register 16 byte CDB capability with scsi midlayer 
 
-	"Ths patch properly registers the 16 byte command length capability of the 
+	"This patch properly registers the 16 byte command length capability of the 
 	megaraid_sas controlled hardware with the scsi midlayer. All megaraid_sas 
 	hardware supports 16 byte CDB's."
 
diff --git a/Documentation/scsi/tmscsim.txt b/Documentation/scsi/tmscsim.txt
index 61c0531..3303d21 100644
--- a/Documentation/scsi/tmscsim.txt
+++ b/Documentation/scsi/tmscsim.txt
@@ -102,7 +102,7 @@ So take at least the following measures:
   ftp://student.physik.uni-dortmund.de/pub/linux/kernel/bootdisk.gz
 
 One more warning: I used to overclock my PCI bus to 41.67 MHz. My Tekram
-DC390F (Sym53c875) accepted this as well as my Millenium. But the Am53C974
+DC390F (Sym53c875) accepted this as well as my Millennium. But the Am53C974
 produced errors and started to corrupt my disks. So don't do that! A 37.50
 MHz PCI bus works for me, though, but I don't recommend using higher clocks
 than the 33.33 MHz being in the PCI spec.
diff --git a/Documentation/static-keys.txt b/Documentation/static-keys.txt
index d93f3c0..9f5263d 100644
--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.txt
@@ -235,7 +235,7 @@ label case adds:
 6 (mov) + 2 (test) + 2 (jne) = 10 - 5 (5 byte jump 0) = 5 addition bytes.
 
 If we then include the padding bytes, the jump label code saves, 16 total bytes
-of instruction memory for this small fucntion. In this case the non-jump label
+of instruction memory for this small function. In this case the non-jump label
 function is 80 bytes long. Thus, we have have saved 20% of the instruction
 footprint. We can in fact improve this even further, since the 5-byte no-op
 really can be a 2-byte no-op since we can reach the branch with a 2-byte jmp.
diff --git a/Documentation/video4linux/uvcvideo.txt b/Documentation/video4linux/uvcvideo.txt
index 848d620..35ce19c 100644
--- a/Documentation/video4linux/uvcvideo.txt
+++ b/Documentation/video4linux/uvcvideo.txt
@@ -116,7 +116,7 @@ Description:
 	A UVC control can be mapped to several V4L2 controls. For instance,
 	a UVC pan/tilt control could be mapped to separate pan and tilt V4L2
 	controls. The UVC control is divided into non overlapping fields using
-	the 'size' and 'offset' fields and are then independantly mapped to
+	the 'size' and 'offset' fields and are then independently mapped to
 	V4L2 control.
 
 	For signed integer V4L2 controls the data_type field should be set to
diff --git a/Documentation/virtual/virtio-spec.txt b/Documentation/virtual/virtio-spec.txt
index 401ffd0..289cf77 100644
--- a/Documentation/virtual/virtio-spec.txt
+++ b/Documentation/virtual/virtio-spec.txt
@@ -1387,7 +1387,7 @@ segmentation, if both guests are amenable.
 
 Packets are transmitted by placing them in the transmitq, and
 buffers for incoming packets are placed in the receiveq. In each
-case, the packet itself is preceeded by a header:
+case, the packet itself is preceded by a header:
 
 struct virtio_net_hdr {
 
@@ -1629,7 +1629,7 @@ struct virtio_net_ctrl_mac {
 
 The device can filter incoming packets by any number of
 destination MAC addresses.[footnote:
-Since there are no guarentees, it can use a hash filter
+Since there are no guarantees, it can use a hash filter
 orsilently switch to allmulti or promiscuous mode if it is given
 too many addresses.
 ] This table is set using the class VIRTIO_NET_CTRL_MAC and the
@@ -1806,7 +1806,7 @@ the FLUSH and FLUSH_OUT types are equivalent, the device does not
 distinguish between them
 ]). If the device has VIRTIO_BLK_F_BARRIER feature the high bit
 (VIRTIO_BLK_T_BARRIER) indicates that this request acts as a
-barrier and that all preceeding requests must be complete before
+barrier and that all preceding requests must be complete before
 this one, and all following requests must not be started until
 this is complete. Note that a barrier does not flush caches in
 the underlying backend device in host, and thus does not serve as
@@ -2119,7 +2119,7 @@ This is historical, and independent of the guest page size
 
   Otherwise, the guest may begin to re-use pages previously given
     to the balloon before the device has acknowledged their
-    withdrawl. [footnote:
+    withdrawal. [footnote:
 In this case, deflation advice is merely a courtesy
 ]
 
-- 
1.7.9.2.262.gba998

