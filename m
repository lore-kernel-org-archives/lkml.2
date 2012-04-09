Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab2DIL7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 07:59:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36446 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab2DIL7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 07:59:06 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/V3] [trivial] Documentation: Fix multiple typo in Documentation
Date: Mon,  9 Apr 2012 20:58:55 +0900
Message-Id: <1333972735-12670-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Documentation.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Rob Landley <rob@landley.net>
---
 Documentation/ABI/testing/sysfs-bus-usb            |    4 +--
 Documentation/DocBook/kernel-hacking.tmpl          |    2 +-
 Documentation/DocBook/libata.tmpl                  |    2 +-
 Documentation/DocBook/media/v4l/controls.xml       |    6 ++---
 Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
 .../devicetree/bindings/net/can/fsl-flexcan.txt    |    2 +-
 Documentation/dvb/opera-firmware.txt               |    4 +--
 Documentation/edac.txt                             |    2 +-
 Documentation/filesystems/nfs/pnfs.txt             |    2 +-
 Documentation/filesystems/qnx6.txt                 |   28 ++++++++++----------
 Documentation/hwmon/it87                           |    2 +-
 Documentation/memory-hotplug.txt                   |    2 +-
 Documentation/networking/can.txt                   |    2 +-
 Documentation/parisc/debugging                     |    2 +-
 Documentation/sound/alsa/compress_offload.txt      |    2 +-
 Documentation/static-keys.txt                      |    2 +-
 16 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-usb b/Documentation/ABI/testing/sysfs-bus-usb
index 7c22a53..303923b 100644
--- a/Documentation/ABI/testing/sysfs-bus-usb
+++ b/Documentation/ABI/testing/sysfs-bus-usb
@@ -189,7 +189,7 @@ Contact:	Matthew Garrett <mjg@redhat.com>
 Description:
 		Some information about whether a given USB device is
 		physically fixed to the platform can be inferred from a
-		combination of hub decriptor bits and platform-specific data
+		combination of hub descriptor bits and platform-specific data
 		such as ACPI. This file will read either "removable" or
 		"fixed" if the information is available, and "unknown"
-		otherwise.
\ No newline at end of file
+		otherwise.
diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index 07a9c48..eee7142 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -1289,7 +1289,7 @@ static struct block_device_operations opt_fops = {
  * Sparc assembly will do this to ya.
  */
 C_LABEL(cputypvar):
-        .asciz "compatability"
+        .asciz "compatibility"
 
 /* Tested on SS-5, SS-10. Probably someone at Sun applied a spell-checker. */
         .align 4
diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index 31df1aa..deb71ba 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -918,7 +918,7 @@ and other resources, etc.
         <title>HSM violation</title>
         <para>
         This error is indicated when STATUS value doesn't match HSM
-        requirement during issuing or excution any ATA/ATAPI command.
+        requirement during issuing or execution any ATA/ATAPI command.
         </para>
 
 	<itemizedlist>
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b84f25e..dd03cf4 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2023,7 +2023,7 @@ Possible values are:</entry>
 		<entry>integer</entry>
 	      </row>
 	      <row><entry spanname="descr">Cyclic intra macroblock refresh. This is the number of continuous macroblocks
-refreshed every frame. Each frame a succesive set of macroblocks is refreshed until the cycle completes and starts from the
+refreshed every frame. Each frame a successive set of macroblocks is refreshed until the cycle completes and starts from the
 top of the frame. Applicable to H264, H263 and MPEG4 encoder.</entry>
 	      </row>
 
@@ -2183,7 +2183,7 @@ Applicable to the MPEG4 and H264 encoders.</entry>
 		<entry>integer</entry>
 	      </row>
 	      <row><entry spanname="descr">The Video Buffer Verifier size in kilobytes, it is used as a limitation of frame skip.
-The VBV is defined in the standard as a mean to verify that the produced stream will be succesfully decoded.
+The VBV is defined in the standard as a mean to verify that the produced stream will be successfully decoded.
 The standard describes it as "Part of a hypothetical decoder that is conceptually connected to the
 output of the encoder. Its purpose is to provide a constraint on the variability of the data rate that an
 encoder or editing process may produce.".
@@ -2196,7 +2196,7 @@ Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
 		<entry>integer</entry>
 	      </row>
 	      <row><entry spanname="descr">The Coded Picture Buffer size in kilobytes, it is used as a limitation of frame skip.
-The CPB is defined in the H264 standard as a mean to verify that the produced stream will be succesfully decoded.
+The CPB is defined in the H264 standard as a mean to verify that the produced stream will be successfully decoded.
 Applicable to the H264 encoder.</entry>
 	      </row>
 
diff --git a/Documentation/blackfin/bfin-gpio-notes.txt b/Documentation/blackfin/bfin-gpio-notes.txt
index d36b01f..d245f39 100644
--- a/Documentation/blackfin/bfin-gpio-notes.txt
+++ b/Documentation/blackfin/bfin-gpio-notes.txt
@@ -53,7 +53,7 @@
 
 3. But there are some exceptions
     - Kernel permit the identical GPIO be requested both as GPIO and GPIO
-    interrut.
+    interrupt.
     Some drivers, like gpio-keys, need this behavior. Kernel only print out
     warning messages like,
 	bfin-gpio: GPIO 24 is already reserved by gpio-keys: BTN0, and you are
diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index 1ad80d5..f31b686 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -1,4 +1,4 @@
-Flexcan CAN contoller on Freescale's ARM and PowerPC system-on-a-chip (SOC).
+Flexcan CAN controller on Freescale's ARM and PowerPC system-on-a-chip (SOC).
 
 Required properties:
 
diff --git a/Documentation/dvb/opera-firmware.txt b/Documentation/dvb/opera-firmware.txt
index 93e784c..fb66831 100644
--- a/Documentation/dvb/opera-firmware.txt
+++ b/Documentation/dvb/opera-firmware.txt
@@ -8,7 +8,7 @@ from the windriver disk into this directory.
 
 Then run
 
-./get_dvb_firware opera1
+./get_dvb_firmware opera1
 
 and after that you have 2 files:
 
@@ -24,4 +24,4 @@ After that the driver can load the firmware
 in kernel config and have hotplug running).
 
 
-Marco Gittler <g.marco@freenet.de>
\ No newline at end of file
+Marco Gittler <g.marco@freenet.de>
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index fdcc49f..03df2b0 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -734,7 +734,7 @@ were done at i7core_edac driver. This chapter will cover those differences
    associated with a physical CPU socket.
 
    Each MC have 3 physical read channels, 3 physical write channels and
-   3 logic channels. The driver currenty sees it as just 3 channels.
+   3 logic channels. The driver currently sees it as just 3 channels.
    Each channel can have up to 3 DIMMs.
 
    The minimum known unity is DIMMs. There are no information about csrows.
diff --git a/Documentation/filesystems/nfs/pnfs.txt b/Documentation/filesystems/nfs/pnfs.txt
index c7919c6..52ae07f 100644
--- a/Documentation/filesystems/nfs/pnfs.txt
+++ b/Documentation/filesystems/nfs/pnfs.txt
@@ -93,7 +93,7 @@ The API to the login script is as follows:
 				(allways exists)
 				(More protocols can be defined in the future.
 				 The client does not interpret this string it is
-				 passed unchanged as recieved from the Server)
+				 passed unchanged as received from the Server)
 		-o		osdname of the requested target OSD
 				(Might be empty)
 				(A string which denotes the OSD name, there is a
diff --git a/Documentation/filesystems/qnx6.txt b/Documentation/filesystems/qnx6.txt
index 050223e..0708584 100644
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
 
@@ -64,7 +64,7 @@ The first Superblock is located at 0x2000. (0x2000 is the bootblock size)
 The Audi MMI 3G first superblock directly starts at byte 0.
 Second superblock position can either be calculated from the superblock
 information (total number of filesystem blocks) or by taking the highest
-device address, zeroing the last 3 bytes and then substracting 0x1000 from
+device address, zeroing the last 3 bytes and then subtracting 0x1000 from
 that address.
 
 0x1000 is the size reserved for each superblock - regardless of the
@@ -83,8 +83,8 @@ size, number of blocks used, access time, change time and modification time.
 Object mode field is POSIX format. (which makes things easier)
 
 There are also pointers to the first 16 blocks, if the object data can be
-adressed with 16 direct blocks.
-For more than 16 blocks an indirect adressing in form of another tree is
+addressed with 16 direct blocks.
+For more than 16 blocks an indirect addressing in form of another tree is
 used. (scheme is the same as the one used for the superblock root nodes)
 
 The filesize is stored 64bit. Inode counting starts with 1. (whilst long
@@ -118,13 +118,13 @@ no block pointers and the directory file record pointing to the target file
 inode.
 
 Character and block special devices do not exist in QNX as those files
-are handled by the QNX kernel/drivers and created in /dev independant of the
+are handled by the QNX kernel/drivers and created in /dev independent of the
 underlaying filesystem.
 
 Long filenames
 --------------
 
-Long filenames are stored in a seperate adressing tree. The staring point
+Long filenames are stored in a separate addressing tree. The staring point
 is the longfilename root node in the active superblock.
 Each data block (tree leaves) holds one long filename. That filename is
 limited to 510 bytes. The first two starting bytes are used as length field
diff --git a/Documentation/hwmon/it87 b/Documentation/hwmon/it87
index 899128d..87850d8 100644
--- a/Documentation/hwmon/it87
+++ b/Documentation/hwmon/it87
@@ -71,7 +71,7 @@ Module Parameters
 Hardware Interfaces
 -------------------
 
-All the chips suported by this driver are LPC Super-I/O chips, accessed
+All the chips supported by this driver are LPC Super-I/O chips, accessed
 through the LPC bus (ISA-like I/O ports). The IT8712F additionally has an
 SMBus interface to the hardware monitoring functions. This driver no
 longer supports this interface though, as it is slower and less reliable
diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 8f485d7..6d0c251 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -341,7 +341,7 @@ Need more implementation yet....
 --------------------------------
 8. Memory hotplug event notifier
 --------------------------------
-Memory hotplug has event notifer. There are 6 types of notification.
+Memory hotplug has event notifier. There are 6 types of notification.
 
 MEMORY_GOING_ONLINE
   Generated before new memory becomes available in order to be able to
diff --git a/Documentation/networking/can.txt b/Documentation/networking/can.txt
index 56ca3b7..ac29539 100644
--- a/Documentation/networking/can.txt
+++ b/Documentation/networking/can.txt
@@ -649,7 +649,7 @@ solution for a couple of reasons:
   The CAN device must be configured via netlink interface. The supported
   netlink message types are defined and briefly described in
   "include/linux/can/netlink.h". CAN link support for the program "ip"
-  of the IPROUTE2 utility suite is avaiable and it can be used as shown
+  of the IPROUTE2 utility suite is available and it can be used as shown
   below:
 
   - Setting CAN device properties:
diff --git a/Documentation/parisc/debugging b/Documentation/parisc/debugging
index d728594..7d75223 100644
--- a/Documentation/parisc/debugging
+++ b/Documentation/parisc/debugging
@@ -34,6 +34,6 @@ registers interruption handlers read to find out where the machine
 was interrupted - so if you get an interruption between the instruction
 that clears the Q bit and the RFI that sets it again you don't know
 where exactly it happened.  If you're lucky the IAOQ will point to the
-instrucion that cleared the Q bit, if you're not it points anywhere
+instruction that cleared the Q bit, if you're not it points anywhere
 at all.  Usually Q bit problems will show themselves in unexplainable
 system hangs or running off the end of physical memory.
diff --git a/Documentation/sound/alsa/compress_offload.txt b/Documentation/sound/alsa/compress_offload.txt
index c83a835..90e9b3a 100644
--- a/Documentation/sound/alsa/compress_offload.txt
+++ b/Documentation/sound/alsa/compress_offload.txt
@@ -18,7 +18,7 @@ processing. Support for such hardware has not been very good in Linux,
 mostly because of a lack of a generic API available in the mainline
 kernel.
 
-Rather than requiring a compability break with an API change of the
+Rather than requiring a compatibility break with an API change of the
 ALSA PCM interface, a new 'Compressed Data' API is introduced to
 provide a control and data-streaming interface for audio DSPs.
 
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
-- 
1.7.10

