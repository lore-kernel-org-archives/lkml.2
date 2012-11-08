Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2KHM5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:57:43 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51092 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab2KHM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:57:41 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, rob@landley.net, linux-doc@vger.kernel.org,
        trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: Fix typo within Documentations
Date: Thu,  8 Nov 2012 21:57:35 +0900
Message-Id: <1352379455-21356-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Documentations
---
 Documentation/ABI/testing/dev-kmsg                      | 2 +-
 Documentation/ABI/testing/sysfs-devices-power           | 2 +-
 Documentation/ABI/testing/sysfs-driver-ppi              | 2 +-
 Documentation/dma-buf-sharing.txt                       | 4 ++--
 Documentation/fault-injection/notifier-error-inject.txt | 4 ++--
 Documentation/hid/uhid.txt                              | 2 +-
 Documentation/input/alps.txt                            | 2 +-
 Documentation/kbuild/modules.txt                        | 2 +-
 Documentation/misc-devices/mei/mei-amt-version.c        | 4 ++--
 Documentation/video4linux/bttv/Cards                    | 2 +-
 Documentation/vm/frontswap.txt                          | 2 +-
 11 files changed, 14 insertions(+), 14 deletions(-)

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
index 7fc2997..9d43e76 100644
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
diff --git a/Documentation/ABI/testing/sysfs-driver-ppi b/Documentation/ABI/testing/sysfs-driver-ppi
index 97a003e..7d1435b 100644
--- a/Documentation/ABI/testing/sysfs-driver-ppi
+++ b/Documentation/ABI/testing/sysfs-driver-ppi
@@ -5,7 +5,7 @@ Contact:	xiaoyan.zhang@intel.com
 Description:
 		This folder includes the attributes related with PPI (Physical
 		Presence Interface). Only if TPM is supported by BIOS, this
-		folder makes sence. The folder path can be got by command
+		folder makes sense. The folder path can be got by command
 		'find /sys/ -name 'pcrs''. For the detail information of PPI,
 		please refer to the PPI specification from
 		http://www.trustedcomputinggroup.org/
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
 
diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 3fb39e0..69372fb 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -470,7 +470,7 @@ build.
 
 	Sometimes, an external module uses exported symbols from
 	another external module. kbuild needs to have full knowledge of
-	all symbols to avoid spitting out warnings about undefined
+	all symbols to avoid spliitting out warnings about undefined
 	symbols. Three solutions exist for this situation.
 
 	NOTE: The method with a top-level kbuild file is recommended
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
-- 
1.8.0.rc3.16.g8ead1bf

