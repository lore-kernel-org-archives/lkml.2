Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2CDOQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 09:16:24 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51297 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab2CDOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 09:16:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of standby24x7@gmail.com designates 10.68.220.38 as permitted sender) smtp.mail=standby24x7@gmail.com; dkim=pass header.i=standby24x7@gmail.com
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Documentation: Fix multiple typo in Documentation
Date: Sun,  4 Mar 2012 23:16:11 +0900
Message-Id: <1330870571-23424-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.9.2.262.gba998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct following typo within 17 files in Documentation. 

"specifing" to "specifying" in vm/unevictable-lru.txt
"subjet" to "subject" in security/Smack.txt
"fulfil" to "fulfill" in security/keys.txt
"symmetic" to "symmetric" in security/keys-trusted-encrypted.txt
"Refererence" to "Reference" in device-mapper/dm-raid.txt
"strutures" to "structures" in device-mapper/persistent-data.txt
"attribude" to "attribute" in kbuild/kconfig-language.txt
"satisified" to "satisfied" in virtual/kvm/mmu.txt
"artificically" to "artificially" in virtual/kvm/mmu.txt
"hierarhical" to "hierarchical" in cgroups/blkio-controller.txt
"hierarhcy" to "hierarchy" in cgroups/blkio-controller.txt
"exising" to "existing" in cgroups/blkio-controller.txt
"deivce" to "device" in cgroups/blkio-controller.txt
"subjectd" to "subjected" in cgroups/blkio-contoller.txt
"Priorty" to "Priority" in filesystem/ext4.txt
"systme" to "system" in filesystem/ext4.txt
"fileystem" to "filesystem" in filesystem/gfs2-uevents.txt
"returing" to "returning" in filesystem/vfs.txt
"practise" to "practice" in devicetree/booting-without-of.txt
"evalutation" to "evaluation" in devicetree/bindings/arm/sirf.txt
"adresse" to "address" in devicetree/bindings/arm/omap/omap.txt
"shedule" to "schedule" in ABI/obsolete/sysfs-class-rfkill
"dyanmic" to "dynamic" in ABI/stable/sysfs-module

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/ABI/obsolete/sysfs-class-rfkill      |    2 +-
 Documentation/ABI/stable/sysfs-module              |    2 +-
 Documentation/cgroups/blkio-controller.txt         |   18 +++++++++---------
 Documentation/device-mapper/dm-raid.txt            |    2 +-
 Documentation/device-mapper/persistent-data.txt    |    2 +-
 .../devicetree/bindings/arm/omap/omap.txt          |    2 +-
 Documentation/devicetree/bindings/arm/sirf.txt     |    2 +-
 Documentation/devicetree/booting-without-of.txt    |    2 +-
 Documentation/filesystems/ext4.txt                 |    4 ++--
 Documentation/filesystems/gfs2-uevents.txt         |    2 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 Documentation/kbuild/kconfig-language.txt          |    2 +-
 Documentation/security/Smack.txt                   |    2 +-
 Documentation/security/keys-trusted-encrypted.txt  |    2 +-
 Documentation/security/keys.txt                    |    2 +-
 Documentation/virtual/kvm/mmu.txt                  |    4 ++--
 Documentation/vm/unevictable-lru.txt               |    2 +-
 17 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/Documentation/ABI/obsolete/sysfs-class-rfkill b/Documentation/ABI/obsolete/sysfs-class-rfkill
index 4201d5b..ff60ad9 100644
--- a/Documentation/ABI/obsolete/sysfs-class-rfkill
+++ b/Documentation/ABI/obsolete/sysfs-class-rfkill
@@ -7,7 +7,7 @@ Date:		09-Jul-2007
 KernelVersion	v2.6.22
 Contact:	linux-wireless@vger.kernel.org
 Description: 	Current state of the transmitter.
-		This file is deprecated and sheduled to be removed in 2014,
+		This file is deprecated and scheduled to be removed in 2014,
 		because its not possible to express the 'soft and hard block'
 		state of the rfkill driver.
 Values: 	A numeric value.
diff --git a/Documentation/ABI/stable/sysfs-module b/Documentation/ABI/stable/sysfs-module
index 75be431..a0dd21c 100644
--- a/Documentation/ABI/stable/sysfs-module
+++ b/Documentation/ABI/stable/sysfs-module
@@ -6,7 +6,7 @@ Description:
 		The name of the module that is in the kernel.  This
 		module name will show up either if the module is built
 		directly into the kernel, or if it is loaded as a
-		dyanmic module.
+		dynamic module.
 
 	/sys/module/MODULENAME/parameters
 		This directory contains individual files that are each
diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 84f0a15..b4b1fb3 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -94,11 +94,11 @@ Throttling/Upper Limit policy
 
 Hierarchical Cgroups
 ====================
-- Currently none of the IO control policy supports hierarhical groups. But
-  cgroup interface does allow creation of hierarhical cgroups and internally
+- Currently none of the IO control policy supports hierarchical groups. But
+  cgroup interface does allow creation of hierarchical cgroups and internally
   IO policies treat them as flat hierarchy.
 
-  So this patch will allow creation of cgroup hierarhcy but at the backend
+  So this patch will allow creation of cgroup hierarchcy but at the backend
   everything will be treated as flat. So if somebody created a hierarchy like
   as follows.
 
@@ -266,7 +266,7 @@ Proportional weight policy files
 - blkio.idle_time
 	- Debugging aid only enabled if CONFIG_DEBUG_BLK_CGROUP=y.
 	  This is the amount of time spent by the IO scheduler idling for a
-	  given cgroup in anticipation of a better request than the exising ones
+	  given cgroup in anticipation of a better request than the existing ones
 	  from other queues/cgroups. This is in nanoseconds. If this is read
 	  when the cgroup is in an idling state, the stat will only report the
 	  idle_time accumulated till the last idle period and will not include
@@ -283,34 +283,34 @@ Throttling/Upper limit policy files
 -----------------------------------
 - blkio.throttle.read_bps_device
 	- Specifies upper limit on READ rate from the device. IO rate is
-	  specified in bytes per second. Rules are per deivce. Following is
+	  specified in bytes per second. Rules are per device. Following is
 	  the format.
 
   echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.read_bps_device
 
 - blkio.throttle.write_bps_device
 	- Specifies upper limit on WRITE rate to the device. IO rate is
-	  specified in bytes per second. Rules are per deivce. Following is
+	  specified in bytes per second. Rules are per device. Following is
 	  the format.
 
   echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.write_bps_device
 
 - blkio.throttle.read_iops_device
 	- Specifies upper limit on READ rate from the device. IO rate is
-	  specified in IO per second. Rules are per deivce. Following is
+	  specified in IO per second. Rules are per device. Following is
 	  the format.
 
   echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.read_iops_device
 
 - blkio.throttle.write_iops_device
 	- Specifies upper limit on WRITE rate to the device. IO rate is
-	  specified in io per second. Rules are per deivce. Following is
+	  specified in io per second. Rules are per device. Following is
 	  the format.
 
   echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.write_iops_device
 
 Note: If both BW and IOPS rules are specified for a device, then IO is
-      subjectd to both the constraints.
+      subjected to both the constraints.
 
 - blkio.throttle.io_serviced
 	- Number of IOs (bio) completed to/from the disk by the group (as
diff --git a/Documentation/device-mapper/dm-raid.txt b/Documentation/device-mapper/dm-raid.txt
index 2a8c113..946c733 100644
--- a/Documentation/device-mapper/dm-raid.txt
+++ b/Documentation/device-mapper/dm-raid.txt
@@ -28,7 +28,7 @@ The target is named "raid" and it accepts the following parameters:
   raid6_nc	RAID6 N continue
 		- rotating parity N (right-to-left) with data continuation
 
-  Refererence: Chapter 4 of
+  Reference: Chapter 4 of
   http://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf
 
 <#raid_params>: The number of parameters that follow.
diff --git a/Documentation/device-mapper/persistent-data.txt b/Documentation/device-mapper/persistent-data.txt
index 0e5df9b..a333bcb 100644
--- a/Documentation/device-mapper/persistent-data.txt
+++ b/Documentation/device-mapper/persistent-data.txt
@@ -3,7 +3,7 @@ Introduction
 
 The more-sophisticated device-mapper targets require complex metadata
 that is managed in kernel.  In late 2010 we were seeing that various
-different targets were rolling their own data strutures, for example:
+different targets were rolling their own data structures, for example:
 
 - Mikulas Patocka's multisnap implementation
 - Heinz Mauelshagen's thin provisioning target
diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index ce78498..e78e8bc 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -5,7 +5,7 @@ IPs present in the SoC.
 On top of that an omap_device is created to extend the platform_device
 capabilities and to allow binding with one or several hwmods.
 The hwmods will contain all the information to build the device:
-adresse range, irq lines, dma lines, interconnect, PRCM register,
+address range, irq lines, dma lines, interconnect, PRCM register,
 clock domain, input clocks.
 For the moment just point to the existing hwmod, the next step will be
 to move data from hwmod to device-tree representation.
diff --git a/Documentation/devicetree/bindings/arm/sirf.txt b/Documentation/devicetree/bindings/arm/sirf.txt
index 6b07f65..1881e1c 100644
--- a/Documentation/devicetree/bindings/arm/sirf.txt
+++ b/Documentation/devicetree/bindings/arm/sirf.txt
@@ -1,3 +1,3 @@
-prima2 "cb" evalutation board
+prima2 "cb" evaluation board
 Required root node properties:
     - compatible = "sirf,prima2-cb", "sirf,prima2";
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 7c1329d..da0bfeb 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -169,7 +169,7 @@ it with special cases.
 
         b) Entry with a flattened device-tree block.  Firmware loads the
         physical address of the flattened device tree block (dtb) into r2,
-        r1 is not used, but it is considered good practise to use a valid
+        r1 is not used, but it is considered good practice to use a valid
         machine number as described in Documentation/arm/Booting.
 
                 r0 : 0
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 990219c..1b7f9ac 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -305,7 +305,7 @@ min_batch_time=usec	This parameter sets the commit time (as
 			fast disks, at the cost of increasing latency.
 
 journal_ioprio=prio	The I/O priority (from 0 to 7, where 0 is the
-			highest priorty) which should be used for I/O
+			highest priority) which should be used for I/O
 			operations submitted by kjournald2 during a
 			commit operation.  This defaults to 3, which is
 			a slightly higher priority than the default I/O
@@ -340,7 +340,7 @@ noinit_itable		Do not initialize any uninitialized inode table
 init_itable=n		The lazy itable init code will wait n times the
 			number of milliseconds it took to zero out the
 			previous block group's inode table.  This
-			minimizes the impact on the systme performance
+			minimizes the impact on the system performance
 			while file system's inode table is being initialized.
 
 discard			Controls whether ext4 should issue discard/TRIM
diff --git a/Documentation/filesystems/gfs2-uevents.txt b/Documentation/filesystems/gfs2-uevents.txt
index d818896..19a19eb 100644
--- a/Documentation/filesystems/gfs2-uevents.txt
+++ b/Documentation/filesystems/gfs2-uevents.txt
@@ -62,7 +62,7 @@ be fixed.
 
 The REMOVE uevent is generated at the end of an unsuccessful mount
 or at the end of a umount of the filesystem. All REMOVE uevents will
-have been preceded by at least an ADD uevent for the same fileystem,
+have been preceded by at least an ADD uevent for the same filesystem,
 and unlike the other uevents is generated automatically by the kernel's
 kobject subsystem.
 
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3d9393b..e916e3d 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -993,7 +993,7 @@ struct dentry_operations {
 
 	If the 'rcu_walk' parameter is true, then the caller is doing a
 	pathwalk in RCU-walk mode.  Sleeping is not permitted in this mode,
-	and the caller can be asked to leave it and call again by returing
+	and the caller can be asked to leave it and call again by returning
 	-ECHILD.
 
 	This function is only used if DCACHE_MANAGE_TRANSIT is set on the
diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 44e2649..a686f9c 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -117,7 +117,7 @@ applicable everywhere (see syntax).
   This attribute is only applicable to menu blocks, if the condition is
   false, the menu block is not displayed to the user (the symbols
   contained there can still be selected by other symbols, though). It is
-  similar to a conditional "prompt" attribude for individual menu
+  similar to a conditional "prompt" attribute for individual menu
   entries. Default value of "visible" is true.
 
 - numerical ranges: "range" <symbol> <symbol> ["if" <expr>]
diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index e9dab41..d2f72ae 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -536,6 +536,6 @@ writing a single character to the /smack/logging file :
 3 : log denied & accepted
 
 Events are logged as 'key=value' pairs, for each event you at least will get
-the subjet, the object, the rights requested, the action, the kernel function
+the subject, the object, the rights requested, the action, the kernel function
 that triggered the event, plus other pairs depending on the type of event
 audited.
diff --git a/Documentation/security/keys-trusted-encrypted.txt b/Documentation/security/keys-trusted-encrypted.txt
index c9e4855..e105ae9 100644
--- a/Documentation/security/keys-trusted-encrypted.txt
+++ b/Documentation/security/keys-trusted-encrypted.txt
@@ -1,7 +1,7 @@
 			Trusted and Encrypted Keys
 
 Trusted and Encrypted Keys are two new key types added to the existing kernel
-key ring service.  Both of these new types are variable length symmetic keys,
+key ring service.  Both of these new types are variable length symmetric keys,
 and in both cases all keys are created in the kernel, and user space sees,
 stores, and loads only encrypted blobs.  Trusted Keys require the availability
 of a Trusted Platform Module (TPM) chip for greater security, while Encrypted
diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 713ec23..7877170 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -672,7 +672,7 @@ The keyctl syscall functions are:
 
      If the kernel calls back to userspace to complete the instantiation of a
      key, userspace should use this call mark the key as negative before the
-     invoked process returns if it is unable to fulfil the request.
+     invoked process returns if it is unable to fulfill the request.
 
      The process must have write access on the key to be able to instantiate
      it, and the key must be uninstantiated.
diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 5dc972c..fa5f1db 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -347,7 +347,7 @@ To instantiate a large spte, four constraints must be satisfied:
 
 - the spte must point to a large host page
 - the guest pte must be a large pte of at least equivalent size (if tdp is
-  enabled, there is no guest pte and this condition is satisified)
+  enabled, there is no guest pte and this condition is satisfied)
 - if the spte will be writeable, the large page frame may not overlap any
   write-protected pages
 - the guest page must be wholly contained by a single memory slot
@@ -356,7 +356,7 @@ To check the last two conditions, the mmu maintains a ->write_count set of
 arrays for each memory slot and large page size.  Every write protected page
 causes its write_count to be incremented, thus preventing instantiation of
 a large spte.  The frames at the end of an unaligned memory slot have
-artificically inflated ->write_counts so they can never be instantiated.
+artificially inflated ->write_counts so they can never be instantiated.
 
 Further reading
 ===============
diff --git a/Documentation/vm/unevictable-lru.txt b/Documentation/vm/unevictable-lru.txt
index 609d1a3..fa206cc 100644
--- a/Documentation/vm/unevictable-lru.txt
+++ b/Documentation/vm/unevictable-lru.txt
@@ -619,7 +619,7 @@ all PTEs from the page.  For this purpose, the unevictable/mlock infrastructure
 introduced a variant of try_to_unmap() called try_to_munlock().
 
 try_to_munlock() calls the same functions as try_to_unmap() for anonymous and
-mapped file pages with an additional argument specifing unlock versus unmap
+mapped file pages with an additional argument specifying unlock versus unmap
 processing.  Again, these functions walk the respective reverse maps looking
 for VM_LOCKED VMAs.  When such a VMA is found for anonymous pages and file
 pages mapped in linear VMAs, as in the try_to_unmap() case, the functions
-- 
1.7.9.2.262.gba998

