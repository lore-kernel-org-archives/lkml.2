Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2HXGuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 02:50:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33351 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2HXGuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 02:50:12 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20Documentation=3A=20Fix=20typo=20in=20Documentation?=
Date: Fri, 24 Aug 2012 15:49:47 +0900
Message-Id: <1345790987-20046-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3.4.g91e4bfe
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo various documents in Documentations

Singed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/ABI/testing/dev-kmsg                      | 2 +-
 Documentation/ABI/testing/sysfs-devices-power           | 2 +-
 Documentation/DocBook/kernel-hacking.tmpl               | 2 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml         | 2 +-
 Documentation/DocBook/media_api.tmpl                    | 2 +-
 Documentation/clk.txt                                   | 2 +-
 Documentation/dma-buf-sharing.txt                       | 4 ++--
 Documentation/fault-injection/notifier-error-inject.txt | 4 ++--
 Documentation/filesystems/nfs/Exporting                 | 2 +-
 Documentation/hid/uhid.txt                              | 2 +-
 Documentation/hwmon/adt7410                             | 2 +-
 Documentation/hwmon/sht15                               | 2 +-
 Documentation/input/alps.txt                            | 2 +-
 Documentation/misc-devices/mei/mei-amt-version.c        | 4 ++--
 Documentation/sound/alsa/ALSA-Configuration.txt         | 2 +-
 Documentation/sound/alsa/seq_oss.html                   | 2 +-
 Documentation/video4linux/bttv/Cards                    | 2 +-
 Documentation/vm/frontswap.txt                          | 2 +-
 Documentation/w1/slaves/w1_ds28e04                      | 2 +-
 19 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/Documentation/ABI/testing/dev-kmsg b/Documentation/ABI/testing/dev-kmsg
index 7e7e07a..bb820be 100644
--- a/Documentation/ABI/testing/dev-kmsg
+++ b/Documentation/ABI/testing/dev-kmsg
@@ -92,7 +92,7 @@ Description:	The /dev/kmsg character device node provides userspace access
 		The flags field carries '-' by default. A 'c' indicates a
 		fragment of a line. All following fragments are flagged with
 		'+'. Note, that these hints about continuation lines are not
-		neccessarily correct, and the stream could be interleaved with
+		necessarily correct, and the stream could be interleaved with
 		unrelated messages, but merging the lines in the output
 		usually produces better human readable results. A similar
 		logic is used internally when messages are printed to the
diff --git a/Documentation/ABI/testing/sysfs-devices-power b/Documentation/ABI/testing/sysfs-devices-power
index 45000f0..f76a044 100644
--- a/Documentation/ABI/testing/sysfs-devices-power
+++ b/Documentation/ABI/testing/sysfs-devices-power
@@ -164,7 +164,7 @@ Contact:	Rafael J. Wysocki <rjw@sisk.pl>
 Description:
 		The /sys/devices/.../wakeup_prevent_sleep_time_ms attribute
 		contains the total time the device has been preventing
-		opportunistic transitions to sleep states from occuring.
+		opportunistic transitions to sleep states from occurring.
 		This attribute is read-only.  If the device is not enabled to
 		wake up the system from sleep states, this attribute is not
 		present.
diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index eee7142..e446e65 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -1281,7 +1281,7 @@ static struct block_device_operations opt_fops = {
 
   <programlisting>
 /*
- * Sun people can't spell worth damn. "compatability" indeed.
+ * Sun people can't spell worth damn. "compatibility" indeed.
  * At least we *know* we can't spell, and use a spell-checker.
  */
 
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index bb4777a..a11b871 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -1,6 +1,6 @@
 <section id="FE_GET_SET_PROPERTY">
 <title><constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></title>
-<para>This section describes the DVB version 5 extention of the DVB-API, also
+<para>This section describes the DVB version 5 extension of the DVB-API, also
 called "S2API", as this API were added to provide support for DVB-S2. It was
 designed to be able to replace the old frontend API. Yet, the DISEQC and
 the capability ioctls weren't implemented yet via the new way.</para>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index f2413ac..e79b7ca 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -50,7 +50,7 @@ Foundation. A copy of the license is included in the chapter entitled
 	<title>Introduction</title>
 
 	<para>This document covers the Linux Kernel to Userspace API's used by
-		video and radio straming devices, including video cameras,
+		video and radio streaming devices, including video cameras,
 		analog and digital TV receiver cards, AM/FM receiver cards,
 		streaming capture devices.</para>
 	<para>It is divided into four parts.</para>
diff --git a/Documentation/clk.txt b/Documentation/clk.txt
index 1943fae..777dee2 100644
--- a/Documentation/clk.txt
+++ b/Documentation/clk.txt
@@ -176,7 +176,7 @@ int clk_foo_enable(struct clk_hw *hw)
 Below is a matrix detailing which clk_ops are mandatory based upon the
 hardware capbilities of that clock.  A cell marked as "y" means
 mandatory, a cell marked as "n" implies that either including that
-callback is invalid or otherwise uneccesary.  Empty cells are either
+callback is invalid or otherwise uneccessary.  Empty cells are either
 optional or must be evaluated on a case-by-case basis.
 
                            clock hardware characteristics
diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index ad86fb8..0188903 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -376,7 +376,7 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
    leaving the cpu domain and flushing caches at fault time. Note that all the
    dma_buf files share the same anon inode, hence the exporter needs to replace
    the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
-   requred. This is because the kernel uses the underlying inode's address_space
+   required. This is because the kernel uses the underlying inode's address_space
    for vma tracking (and hence pte tracking at shootdown time with
    unmap_mapping_range).
 
@@ -388,7 +388,7 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
    Exporters that shoot down mappings (for any reasons) shall not do any
    synchronization at fault time with outstanding device operations.
    Synchronization is an orthogonal issue to sharing the backing storage of a
-   buffer and hence should not be handled by dma-buf itself. This is explictly
+   buffer and hence should not be handled by dma-buf itself. This is explicitly
    mentioned here because many people seem to want something like this, but if
    different exporters handle this differently, buffer sharing can fail in
    interesting ways depending upong the exporter (if userspace starts depending
diff --git a/Documentation/fault-injection/notifier-error-inject.txt b/Documentation/fault-injection/notifier-error-inject.txt
index c83526c..09adabe 100644
--- a/Documentation/fault-injection/notifier-error-inject.txt
+++ b/Documentation/fault-injection/notifier-error-inject.txt
@@ -1,7 +1,7 @@
 Notifier error injection
 ========================
 
-Notifier error injection provides the ability to inject artifical errors to
+Notifier error injection provides the ability to inject artificial errors to
 specified notifier chain callbacks. It is useful to test the error handling of
 notifier call chain failures which is rarely executed.  There are kernel
 modules that can be used to test the following notifiers.
@@ -14,7 +14,7 @@ modules that can be used to test the following notifiers.
 CPU notifier error injection module
 -----------------------------------
 This feature can be used to test the error handling of the CPU notifiers by
-injecting artifical errors to CPU notifier chain callbacks.
+injecting artificial errors to CPU notifier chain callbacks.
 
 If the notifier call chain should be failed with some events notified, write
 the error code to debugfs interface
diff --git a/Documentation/filesystems/nfs/Exporting b/Documentation/filesystems/nfs/Exporting
index 09994c2..e543b1a 100644
--- a/Documentation/filesystems/nfs/Exporting
+++ b/Documentation/filesystems/nfs/Exporting
@@ -93,7 +93,7 @@ For a filesystem to be exportable it must:
    2/ make sure that d_splice_alias is used rather than d_add
       when ->lookup finds an inode for a given parent and name.
 
-      If inode is NULL, d_splice_alias(inode, dentry) is eqivalent to
+      If inode is NULL, d_splice_alias(inode, dentry) is equivalent to
 
 		d_add(dentry, inode), NULL
 
diff --git a/Documentation/hid/uhid.txt b/Documentation/hid/uhid.txt
index 4627c42..3c74121 100644
--- a/Documentation/hid/uhid.txt
+++ b/Documentation/hid/uhid.txt
@@ -108,7 +108,7 @@ the request was handled successfully.
   UHID_FEATURE_ANSWER:
   If you receive a UHID_FEATURE request you must answer with this request. You
   must copy the "id" field from the request into the answer. Set the "err" field
-  to 0 if no error occured or to EIO if an I/O error occurred.
+  to 0 if no error occurred or to EIO if an I/O error occurred.
   If "err" is 0 then you should fill the buffer of the answer with the results
   of the feature request and set "size" correspondingly.
 
diff --git a/Documentation/hwmon/adt7410 b/Documentation/hwmon/adt7410
index 9600400..92e730e 100644
--- a/Documentation/hwmon/adt7410
+++ b/Documentation/hwmon/adt7410
@@ -22,7 +22,7 @@ temperature set point has been exceeded. Both pins can be set up with a common
 hysteresis of 0°C - 15°C and a fault queue, ranging from 1 to 4 events. Both
 pins can individually set to be active-low or active-high, while the whole
 device can either run in comparator mode or interrupt mode. The ADT7410
-supports continous temperature sampling, as well as sampling one temperature
+supports continuous temperature sampling, as well as sampling one temperature
 value per second or even justget one sample on demand for power saving.
 Besides, it can completely power down its ADC, if power management is
 required.
diff --git a/Documentation/hwmon/sht15 b/Documentation/hwmon/sht15
index 02850bd..778987d 100644
--- a/Documentation/hwmon/sht15
+++ b/Documentation/hwmon/sht15
@@ -40,7 +40,7 @@ bits for humidity, or 12 bits for temperature and 8 bits for humidity.
 The humidity calibration coefficients are programmed into an OTP memory on the
 chip. These coefficients are used to internally calibrate the signals from the
 sensors. Disabling the reload of those coefficients allows saving 10ms for each
-measurement and decrease power consumption, while loosing on precision.
+measurement and decrease power consumption, while losing on precision.
 
 Some options may be set directly in the sht15_platform_data structure
 or via sysfs attributes.
diff --git a/Documentation/input/alps.txt b/Documentation/input/alps.txt
index ae8ba9a..3262b6e 100644
--- a/Documentation/input/alps.txt
+++ b/Documentation/input/alps.txt
@@ -133,7 +133,7 @@ number of contacts (f1 and f0 in the table below).
 
 This packet only appears after a position packet with the mt bit set, and
 usually only appears when there are two or more contacts (although
-occassionally it's seen with only a single contact).
+occasionally it's seen with only a single contact).
 
 The final v3 packet type is the trackstick packet.
 
diff --git a/Documentation/misc-devices/mei/mei-amt-version.c b/Documentation/misc-devices/mei/mei-amt-version.c
index 01804f2..49e4f77 100644
--- a/Documentation/misc-devices/mei/mei-amt-version.c
+++ b/Documentation/misc-devices/mei/mei-amt-version.c
@@ -214,7 +214,7 @@ out:
 }
 
 /***************************************************************************
- * Intel Advanced Management Technolgy ME Client
+ * Intel Advanced Management Technology ME Client
  ***************************************************************************/
 
 #define AMT_MAJOR_VERSION 1
@@ -256,7 +256,7 @@ struct amt_code_versions {
 } __attribute__((packed));
 
 /***************************************************************************
- * Intel Advanced Management Technolgy Host Interface
+ * Intel Advanced Management Technology Host Interface
  ***************************************************************************/
 
 struct amt_host_if_msg_header {
diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index 4e4d0bc..3ff6eab 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -905,7 +905,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
     models depending on the codec chip.  The list of available models
     is found in HD-Audio-Models.txt
 
-    The model name "genric" is treated as a special case.  When this
+    The model name "generic" is treated as a special case.  When this
     model is given, the driver uses the generic codec parser without
     "codec-patch".  It's sometimes good for testing and debugging.
 
diff --git a/Documentation/sound/alsa/seq_oss.html b/Documentation/sound/alsa/seq_oss.html
index d9776cf..9663b45 100644
--- a/Documentation/sound/alsa/seq_oss.html
+++ b/Documentation/sound/alsa/seq_oss.html
@@ -285,7 +285,7 @@ sample data.
 <H4>
 7.2.4 Close Callback</H4>
 The <TT>close</TT> callback is called when this device is closed by the
-applicaion. If any private data was allocated in open callback, it must
+application. If any private data was allocated in open callback, it must
 be released in the close callback. The deletion of ALSA port should be
 done here, too. This callback must not be NULL.
 <H4>
diff --git a/Documentation/video4linux/bttv/Cards b/Documentation/video4linux/bttv/Cards
index db833ce..a8fb6e2 100644
--- a/Documentation/video4linux/bttv/Cards
+++ b/Documentation/video4linux/bttv/Cards
@@ -43,7 +43,7 @@ Very nice card if you only have satellite TV but several tuners connected
 to the card via composite.
 
 Many thanks to Matrix-Vision for giving us 2 cards for free which made
-Bt848a/Bt849 single crytal operation support possible!!!
+Bt848a/Bt849 single crystal operation support possible!!!
 
 
 
diff --git a/Documentation/vm/frontswap.txt b/Documentation/vm/frontswap.txt
index 5ef2d13..c71a019 100644
--- a/Documentation/vm/frontswap.txt
+++ b/Documentation/vm/frontswap.txt
@@ -193,7 +193,7 @@ faster.
    or maybe swap-over-nbd/NFS)?
 
 No.  First, the existing swap subsystem doesn't allow for any kind of
-swap hierarchy.  Perhaps it could be rewritten to accomodate a hierarchy,
+swap hierarchy.  Perhaps it could be rewritten to accommodate a hierarchy,
 but this would require fairly drastic changes.  Even if it were
 rewritten, the existing swap subsystem uses the block I/O layer which
 assumes a swap device is fixed size and any page in it is linearly
diff --git a/Documentation/w1/slaves/w1_ds28e04 b/Documentation/w1/slaves/w1_ds28e04
index 85bc9a7..7819b65 100644
--- a/Documentation/w1/slaves/w1_ds28e04
+++ b/Documentation/w1/slaves/w1_ds28e04
@@ -24,7 +24,7 @@ Memory Access
 
 	A write operation on the "eeprom" file writes the given byte sequence
 	to the EEPROM of the DS28E04. If CRC checking mode is enabled only
-	fully alligned blocks of 32 bytes with valid CRC16 values (in bytes 30
+	fully aligned blocks of 32 bytes with valid CRC16 values (in bytes 30
 	and 31) are allowed to be written.
 
 PIO Access
-- 
1.7.12.rc3.4.g91e4bfe

