Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab0DVVNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:13:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47435 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431Ab0DVVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U6TnydCzEAmsAQsvY2fa5OND6GOThAdzERhJoP8Db+KWIIzY+vodbioMjuFtqWgErk
         1vYYvbba8q079AJ+Yni+BD3qSSyMX6JCPRZmOHGcKJBXo7+odCP/tdEjCZyqzPHk5JEO
         Uk4bc1ObvzYTzbxY+3w9O1FN8eneWMp5IpVnE=
From: Francis Galiegue <fgaliegue@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Francis Galiegue <fgaliegue@gmail.com>
Subject: [PATCH] Documentation/: it's -> its where appropriate
Date: Thu, 22 Apr 2010 23:12:45 +0200
Message-Id: <1271970765-11856-2-git-send-email-fgaliegue@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>
References: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix obvious cases of "it's" being used when "its" was meant.

Signed-off-by: Francis Galiegue <fgaliegue@gmail.com>
---
 Documentation/ABI/testing/sysfs-devices-memory     |    2 +-
 Documentation/DMA-API-HOWTO.txt                    |    2 +-
 Documentation/DocBook/libata.tmpl                  |    2 +-
 Documentation/PCI/pci-error-recovery.txt           |    4 ++--
 Documentation/Smack.txt                            |    2 +-
 Documentation/arm/SA1100/ADSBitsy                  |    2 +-
 Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen     |    2 +-
 Documentation/atomic_ops.txt                       |    2 +-
 Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
 Documentation/cachetlb.txt                         |    6 +++---
 Documentation/cgroups/memcg_test.txt               |    2 +-
 Documentation/cgroups/memory.txt                   |    2 +-
 Documentation/connector/connector.txt              |    2 +-
 Documentation/dvb/ci.txt                           |    2 +-
 Documentation/dvb/contributors.txt                 |    2 +-
 .../filesystems/autofs4-mount-control.txt          |    2 +-
 Documentation/filesystems/ceph.txt                 |    2 +-
 Documentation/filesystems/dlmfs.txt                |    2 +-
 Documentation/filesystems/fiemap.txt               |   12 ++++++------
 Documentation/filesystems/fuse.txt                 |    4 ++--
 Documentation/filesystems/hpfs.txt                 |    2 +-
 Documentation/filesystems/nfs/rpc-cache.txt        |    2 +-
 Documentation/filesystems/proc.txt                 |    4 ++--
 Documentation/filesystems/smbfs.txt                |    2 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 Documentation/hwmon/lm85                           |    2 +-
 Documentation/input/joystick.txt                   |    2 +-
 Documentation/intel_txt.txt                        |    2 +-
 Documentation/kbuild/kconfig-language.txt          |    2 +-
 Documentation/kernel-docs.txt                      |   10 +++++-----
 Documentation/kprobes.txt                          |    2 +-
 Documentation/laptops/laptop-mode.txt              |    2 +-
 Documentation/lguest/lguest.c                      |    2 +-
 Documentation/md.txt                               |    2 +-
 Documentation/netlabel/lsm_interface.txt           |    2 +-
 Documentation/networking/ifenslave.c               |    2 +-
 Documentation/networking/packet_mmap.txt           |    4 ++--
 Documentation/power/regulator/consumer.txt         |   10 +++++-----
 Documentation/power/regulator/machine.txt          |    2 +-
 Documentation/power/regulator/overview.txt         |    6 +++---
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 Documentation/powerpc/phyp-assisted-dump.txt       |    2 +-
 Documentation/rt-mutex-design.txt                  |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |    4 ++--
 Documentation/scsi/FlashPoint.txt                  |    2 +-
 Documentation/scsi/dtc3x80.txt                     |    2 +-
 Documentation/scsi/ncr53c8xx.txt                   |    2 +-
 Documentation/scsi/osst.txt                        |    2 +-
 Documentation/scsi/scsi_fc_transport.txt           |    4 ++--
 Documentation/scsi/sym53c8xx_2.txt                 |    2 +-
 Documentation/sound/alsa/soc/dapm.txt              |    4 ++--
 Documentation/sound/alsa/soc/machine.txt           |    2 +-
 Documentation/sound/alsa/soc/overview.txt          |    2 +-
 Documentation/usb/WUSB-Design-overview.txt         |    2 +-
 Documentation/vm/numa_memory_policy.txt            |    4 ++--
 Documentation/w1/w1.generic                        |    2 +-
 56 files changed, 81 insertions(+), 81 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
index bf1627b..aba7d98 100644
--- a/Documentation/ABI/testing/sysfs-devices-memory
+++ b/Documentation/ABI/testing/sysfs-devices-memory
@@ -43,7 +43,7 @@ Date:		September 2008
 Contact:	Badari Pulavarty <pbadari@us.ibm.com>
 Description:
 		The file /sys/devices/system/memory/memoryX/state
-		is read-write.  When read, it's contents show the
+		is read-write.  When read, its contents show the
 		online/offline state of the memory section.  When written,
 		root can toggle the the online/offline state of a removable
 		memory section (see removable file description above)
diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 52618ab..2e435ad 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -742,7 +742,7 @@ failure can be determined by:
 
 			   Closing
 
-This document, and the API itself, would not be in it's current
+This document, and the API itself, would not be in its current
 form without the feedback and suggestions from numerous individuals.
 We would like to specifically mention, in no particular order, the
 following people:
diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index ba99757..261b57b 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -490,7 +490,7 @@ void (*host_stop) (struct ata_host_set *host_set);
 	allocates space for a legacy IDE PRD table and returns.
 	</para>
 	<para>
-	->port_stop() is called after ->host_stop().  It's sole function
+	->port_stop() is called after ->host_stop().  Its sole function
 	is to release DMA/memory resources, now that they are no longer
 	actively being used.  Many drivers also free driver-private
 	data from port at this time.
diff --git a/Documentation/PCI/pci-error-recovery.txt b/Documentation/PCI/pci-error-recovery.txt
index e83f2ea..898ded2 100644
--- a/Documentation/PCI/pci-error-recovery.txt
+++ b/Documentation/PCI/pci-error-recovery.txt
@@ -216,7 +216,7 @@ The driver should return one of the following result codes:
 
 		- PCI_ERS_RESULT_NEED_RESET
 		  Driver returns this if it thinks the device is not
-		  recoverable in it's current state and it needs a slot
+		  recoverable in its current state and it needs a slot
 		  reset to proceed.
 
 		- PCI_ERS_RESULT_DISCONNECT
@@ -241,7 +241,7 @@ in working condition.
 
 The driver is not supposed to restart normal driver I/O operations
 at this point.  It should limit itself to "probing" the device to
-check it's recoverability status. If all is right, then the platform
+check its recoverability status. If all is right, then the platform
 will call resume() once all drivers have ack'd link_reset().
 
 	Result codes:
diff --git a/Documentation/Smack.txt b/Documentation/Smack.txt
index 34614b4..e9dab41 100644
--- a/Documentation/Smack.txt
+++ b/Documentation/Smack.txt
@@ -73,7 +73,7 @@ NOTE: Smack labels are limited to 23 characters. The attr command
 If you don't do anything special all users will get the floor ("_")
 label when they log in. If you do want to log in via the hacked ssh
 at other labels use the attr command to set the smack value on the
-home directory and it's contents.
+home directory and its contents.
 
 You can add access rules in /etc/smack/accesses. They take the form:
 
diff --git a/Documentation/arm/SA1100/ADSBitsy b/Documentation/arm/SA1100/ADSBitsy
index 7197a9e..f9f62e8 100644
--- a/Documentation/arm/SA1100/ADSBitsy
+++ b/Documentation/arm/SA1100/ADSBitsy
@@ -32,7 +32,7 @@ Notes:
 
 - The flash on board is divided into 3 partitions.
   You should be careful to use flash on board.
-  It's partition is different from GraphicsClient Plus and GraphicsMaster
+  Its partition is different from GraphicsClient Plus and GraphicsMaster
 
 - 16bpp mode requires a different cable than what ships with the board.
   Contact ADS or look through the manual to wire your own. Currently,
diff --git a/Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen b/Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
index 1e6a23f..dc460f0 100644
--- a/Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
+++ b/Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
@@ -7,7 +7,7 @@ The driver only implements a four-wire touch panel protocol.
 
 The touchscreen driver is maintenance free except for the pen-down or
 touch threshold.  Some resistive displays and board combinations may
-require tuning of this threshold.  The driver exposes some of it's
+require tuning of this threshold.  The driver exposes some of its
 internal state in the sys filesystem.  If the kernel is configured
 with it, CONFIG_SYSFS, and sysfs is mounted at /sys, there will be a
 directory
diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 396bec3..ac4d471 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -320,7 +320,7 @@ counter decrement would not become globally visible until the
 obj->active update does.
 
 As a historical note, 32-bit Sparc used to only allow usage of
-24-bits of it's atomic_t type.  This was because it used 8 bits
+24-bits of its atomic_t type.  This was because it used 8 bits
 as a spinlock for SMP safety.  Sparc32 lacked a "compare and swap"
 type instruction.  However, 32-bit Sparc has since been moved over
 to a "hash table of spinlocks" scheme, that allows the full 32-bit
diff --git a/Documentation/blackfin/bfin-gpio-notes.txt b/Documentation/blackfin/bfin-gpio-notes.txt
index 9898c7d..f731c1e 100644
--- a/Documentation/blackfin/bfin-gpio-notes.txt
+++ b/Documentation/blackfin/bfin-gpio-notes.txt
@@ -43,7 +43,7 @@
 	void bfin_gpio_irq_free(unsigned gpio);
 
     The request functions will record the function state for a certain pin,
-    the free functions will clear it's function state.
+    the free functions will clear its function state.
     Once a pin is requested, it can't be requested again before it is freed by
     previous caller, otherwise kernel will dump stacks, and the request
     function fail.
diff --git a/Documentation/cachetlb.txt b/Documentation/cachetlb.txt
index 2b5f823..9164ae3 100644
--- a/Documentation/cachetlb.txt
+++ b/Documentation/cachetlb.txt
@@ -5,7 +5,7 @@
 
 This document describes the cache/tlb flushing interfaces called
 by the Linux VM subsystem.  It enumerates over each interface,
-describes it's intended purpose, and what side effect is expected
+describes its intended purpose, and what side effect is expected
 after the interface is invoked.
 
 The side effects described below are stated for a uniprocessor
@@ -231,7 +231,7 @@ require a whole different set of interfaces to handle properly.
 The biggest problem is that of virtual aliasing in the data cache
 of a processor.
 
-Is your port susceptible to virtual aliasing in it's D-cache?
+Is your port susceptible to virtual aliasing in its D-cache?
 Well, if your D-cache is virtually indexed, is larger in size than
 PAGE_SIZE, and does not prevent multiple cache lines for the same
 physical address from existing at once, you have this problem.
@@ -249,7 +249,7 @@ one way to solve this (in particular SPARC_FLAG_MMAPSHARED).
 Next, you have to solve the D-cache aliasing issue for all
 other cases.  Please keep in mind that fact that, for a given page
 mapped into some user address space, there is always at least one more
-mapping, that of the kernel in it's linear mapping starting at
+mapping, that of the kernel in its linear mapping starting at
 PAGE_OFFSET.  So immediately, once the first user maps a given
 physical page into its address space, by implication the D-cache
 aliasing problem has the potential to exist since the kernel already
diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index f7f68b2..b7eecec 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -244,7 +244,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	  we have to check if OLDPAGE/NEWPAGE is a valid page after commit().
 
 8. LRU
-        Each memcg has its own private LRU. Now, it's handling is under global
+        Each memcg has its own private LRU. Now, its handling is under global
 	VM's control (means that it's handled under global zone->lru_lock).
 	Almost all routines around memcg's LRU is called by global LRU's
 	list management functions under zone->lru_lock().
diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 3a6aecd..6cab1f2 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -263,7 +263,7 @@ some of the pages cached in the cgroup (page cache pages).
 
 4.2 Task migration
 
-When a task migrates from one cgroup to another, it's charge is not
+When a task migrates from one cgroup to another, its charge is not
 carried forward by default. The pages allocated from the original cgroup still
 remain charged to it, the charge is dropped when the page is freed or
 reclaimed.
diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
index 78c9466..e5c5f5e 100644
--- a/Documentation/connector/connector.txt
+++ b/Documentation/connector/connector.txt
@@ -88,7 +88,7 @@ int cn_netlink_send(struct cn_msg *msg, u32 __groups, int gfp_mask);
  int gfp_mask			- GFP mask.
 
  Note: When registering new callback user, connector core assigns
- netlink group to the user which is equal to it's id.idx.
+ netlink group to the user which is equal to its id.idx.
 
 /*****************************************/
 Protocol description.
diff --git a/Documentation/dvb/ci.txt b/Documentation/dvb/ci.txt
index 2ecd834..4a0c2b5 100644
--- a/Documentation/dvb/ci.txt
+++ b/Documentation/dvb/ci.txt
@@ -41,7 +41,7 @@ This application requires the following to function properly as of now.
 
 * Cards that fall in this category
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-At present the cards that fall in this category are the Twinhan and it's
+At present the cards that fall in this category are the Twinhan and its
 clones, these cards are available as VVMER, Tomato, Hercules, Orange and
 so on.
 
diff --git a/Documentation/dvb/contributors.txt b/Documentation/dvb/contributors.txt
index 4865add..47c3009 100644
--- a/Documentation/dvb/contributors.txt
+++ b/Documentation/dvb/contributors.txt
@@ -1,7 +1,7 @@
 Thanks go to the following people for patches and contributions:
 
 Michael Hunold <m.hunold@gmx.de>
-  for the initial saa7146 driver and it's recent overhaul
+  for the initial saa7146 driver and its recent overhaul
 
 Christian Theiss
   for his work on the initial Linux DVB driver
diff --git a/Documentation/filesystems/autofs4-mount-control.txt b/Documentation/filesystems/autofs4-mount-control.txt
index 8f78ded..51986bf 100644
--- a/Documentation/filesystems/autofs4-mount-control.txt
+++ b/Documentation/filesystems/autofs4-mount-control.txt
@@ -146,7 +146,7 @@ found to be inadequate, in this case. The Generic Netlink system was
 used for this as raw Netlink would lead to a significant increase in
 complexity. There's no question that the Generic Netlink system is an
 elegant solution for common case ioctl functions but it's not a complete
-replacement probably because it's primary purpose in life is to be a
+replacement probably because its primary purpose in life is to be a
 message bus implementation rather than specifically an ioctl replacement.
 While it would be possible to work around this there is one concern
 that lead to the decision to not use it. This is that the autofs
diff --git a/Documentation/filesystems/ceph.txt b/Documentation/filesystems/ceph.txt
index 0660c9f..763d8eb 100644
--- a/Documentation/filesystems/ceph.txt
+++ b/Documentation/filesystems/ceph.txt
@@ -90,7 +90,7 @@ Mount Options
 	Specify the IP and/or port the client should bind to locally.
 	There is normally not much reason to do this.  If the IP is not
 	specified, the client's IP address is determined by looking at the
-	address it's connection to the monitor originates from.
+	address its connection to the monitor originates from.
 
   wsize=X
 	Specify the maximum write size in bytes.  By default there is no
diff --git a/Documentation/filesystems/dlmfs.txt b/Documentation/filesystems/dlmfs.txt
index c50bbb2..1b528b2 100644
--- a/Documentation/filesystems/dlmfs.txt
+++ b/Documentation/filesystems/dlmfs.txt
@@ -47,7 +47,7 @@ You'll want to start heartbeating on a volume which all the nodes in
 your lockspace can access. The easiest way to do this is via
 ocfs2_hb_ctl (distributed with ocfs2-tools). Right now it requires
 that an OCFS2 file system be in place so that it can automatically
-find it's heartbeat area, though it will eventually support heartbeat
+find its heartbeat area, though it will eventually support heartbeat
 against raw disks.
 
 Please see the ocfs2_hb_ctl and mkfs.ocfs2 manual pages distributed
diff --git a/Documentation/filesystems/fiemap.txt b/Documentation/filesystems/fiemap.txt
index 606233c..1b805a0 100644
--- a/Documentation/filesystems/fiemap.txt
+++ b/Documentation/filesystems/fiemap.txt
@@ -38,7 +38,7 @@ flags, it will return EBADR and the contents of fm_flags will contain
 the set of flags which caused the error. If the kernel is compatible
 with all flags passed, the contents of fm_flags will be unmodified.
 It is up to userspace to determine whether rejection of a particular
-flag is fatal to it's operation. This scheme is intended to allow the
+flag is fatal to its operation. This scheme is intended to allow the
 fiemap interface to grow in the future but without losing
 compatibility with old software.
 
@@ -56,7 +56,7 @@ If this flag is set, the kernel will sync the file before mapping extents.
 
 * FIEMAP_FLAG_XATTR
 If this flag is set, the extents returned will describe the inodes
-extended attribute lookup tree, instead of it's data tree.
+extended attribute lookup tree, instead of its data tree.
 
 
 Extent Mapping
@@ -89,7 +89,7 @@ struct fiemap_extent {
 };
 
 All offsets and lengths are in bytes and mirror those on disk.  It is valid
-for an extents logical offset to start before the request or it's logical
+for an extents logical offset to start before the request or its logical
 length to extend past the request.  Unless FIEMAP_EXTENT_NOT_ALIGNED is
 returned, fe_logical, fe_physical, and fe_length will be aligned to the
 block size of the file system.  With the exception of extents flagged as
@@ -125,7 +125,7 @@ been allocated for the file yet.
 
 * FIEMAP_EXTENT_DELALLOC
   - This will also set FIEMAP_EXTENT_UNKNOWN.
-Delayed allocation - while there is data for this extent, it's
+Delayed allocation - while there is data for this extent, its
 physical location has not been allocated yet.
 
 * FIEMAP_EXTENT_ENCODED
@@ -159,7 +159,7 @@ Data is located within a meta data block.
 Data is packed into a block with data from other files.
 
 * FIEMAP_EXTENT_UNWRITTEN
-Unwritten extent - the extent is allocated but it's data has not been
+Unwritten extent - the extent is allocated but its data has not been
 initialized.  This indicates the extent's data will be all zero if read
 through the filesystem but the contents are undefined if read directly from
 the device.
@@ -176,7 +176,7 @@ VFS -> File System Implementation
 
 File systems wishing to support fiemap must implement a ->fiemap callback on
 their inode_operations structure. The fs ->fiemap call is responsible for
-defining it's set of supported fiemap flags, and calling a helper function on
+defining its set of supported fiemap flags, and calling a helper function on
 each discovered extent:
 
 struct inode_operations {
diff --git a/Documentation/filesystems/fuse.txt b/Documentation/filesystems/fuse.txt
index 397a41a..13af4a4 100644
--- a/Documentation/filesystems/fuse.txt
+++ b/Documentation/filesystems/fuse.txt
@@ -91,7 +91,7 @@ Mount options
 'default_permissions'
 
   By default FUSE doesn't check file access permissions, the
-  filesystem is free to implement it's access policy or leave it to
+  filesystem is free to implement its access policy or leave it to
   the underlying file access mechanism (e.g. in case of network
   filesystems).  This option enables permission checking, restricting
   access based on file mode.  It is usually useful together with the
@@ -171,7 +171,7 @@ or may honor them by sending a reply to the _original_ request, with
 the error set to EINTR.
 
 It is also possible that there's a race between processing the
-original request and it's INTERRUPT request.  There are two possibilities:
+original request and its INTERRUPT request.  There are two possibilities:
 
   1) The INTERRUPT request is processed before the original request is
      processed
diff --git a/Documentation/filesystems/hpfs.txt b/Documentation/filesystems/hpfs.txt
index fa45c3b..74630bd 100644
--- a/Documentation/filesystems/hpfs.txt
+++ b/Documentation/filesystems/hpfs.txt
@@ -103,7 +103,7 @@ to analyze or change OS2SYS.INI.
 Codepages
 
 HPFS can contain several uppercasing tables for several codepages and each
-file has a pointer to codepage it's name is in. However OS/2 was created in
+file has a pointer to codepage its name is in. However OS/2 was created in
 America where people don't care much about codepages and so multiple codepages
 support is quite buggy. I have Czech OS/2 working in codepage 852 on my disk.
 Once I booted English OS/2 working in cp 850 and I created a file on my 852
diff --git a/Documentation/filesystems/nfs/rpc-cache.txt b/Documentation/filesystems/nfs/rpc-cache.txt
index 8a382be..ebcaaee 100644
--- a/Documentation/filesystems/nfs/rpc-cache.txt
+++ b/Documentation/filesystems/nfs/rpc-cache.txt
@@ -185,7 +185,7 @@ failed lookup meant a definite 'no'.
 request/response format
 -----------------------
 
-While each cache is free to use it's own format for requests
+While each cache is free to use its own format for requests
 and responses over channel, the following is recommended as
 appropriate and support routines are available to help:
 Each request or response record should be printable ASCII
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a4f30fa..944be87 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -965,7 +965,7 @@ your system and how much traffic was routed over those devices:
   ...] 1375103    17405    0    0    0     0       0          0 
   ...] 1703981     5535    0    0    0     3       0          0 
 
-In addition, each Channel Bond interface has it's own directory.  For
+In addition, each Channel Bond interface has its own directory.  For
 example, the bond0 device will have a directory called /proc/net/bond0/.
 It will contain information that is specific to that bond, such as the
 current slaves of the bond, the link status of the slaves, and how
@@ -1362,7 +1362,7 @@ been accounted as having caused 1MB of write.
 In other words: The number of bytes which this process caused to not happen,
 by truncating pagecache. A task can cause "negative" IO too. If this task
 truncates some dirty pagecache, some IO which another task has been accounted
-for (in it's write_bytes) will not be happening. We _could_ just subtract that
+for (in its write_bytes) will not be happening. We _could_ just subtract that
 from the truncating task's write_bytes, but there is information loss in doing
 that.
 
diff --git a/Documentation/filesystems/smbfs.txt b/Documentation/filesystems/smbfs.txt
index f673ef0..194fb0d 100644
--- a/Documentation/filesystems/smbfs.txt
+++ b/Documentation/filesystems/smbfs.txt
@@ -3,6 +3,6 @@ protocol used by Windows for Workgroups, Windows 95 and Windows NT.
 Smbfs was inspired by Samba, the program written by Andrew Tridgell
 that turns any Unix host into a file server for DOS or Windows clients.
 
-Smbfs is a SMB client, but uses parts of samba for it's operation. For
+Smbfs is a SMB client, but uses parts of samba for its operation. For
 more info on samba, including documentation, please go to
 http://www.samba.org/ and then on to your nearest mirror.
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3de2f32..b668585 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -72,7 +72,7 @@ structure (this is the kernel-side implementation of file
 descriptors). The freshly allocated file structure is initialized with
 a pointer to the dentry and a set of file operation member functions.
 These are taken from the inode data. The open() file method is then
-called so the specific filesystem implementation can do it's work. You
+called so the specific filesystem implementation can do its work. You
 can see that this is another switch performed by the VFS. The file
 structure is placed into the file descriptor table for the process.
 
diff --git a/Documentation/hwmon/lm85 b/Documentation/hwmon/lm85
index a136808..a76aefe 100644
--- a/Documentation/hwmon/lm85
+++ b/Documentation/hwmon/lm85
@@ -157,7 +157,7 @@ temperature configuration points:
 
 There are three PWM outputs. The LM85 datasheet suggests that the
 pwm3 output control both fan3 and fan4. Each PWM can be individually
-configured and assigned to a zone for it's control value. Each PWM can be
+configured and assigned to a zone for its control value. Each PWM can be
 configured individually according to the following options.
 
 * pwm#_auto_pwm_min - this specifies the PWM value for temp#_auto_temp_off
diff --git a/Documentation/input/joystick.txt b/Documentation/input/joystick.txt
index 154d767..8007b7c 100644
--- a/Documentation/input/joystick.txt
+++ b/Documentation/input/joystick.txt
@@ -402,7 +402,7 @@ for the port of the SoundFusion is supported by the cs461x.c module.
 ~~~~~~~~~~~~~~~~~~~~~~~~
   The Live! has a special PCI gameport, which, although it doesn't provide
 any "Enhanced" stuff like 4DWave and friends, is quite a bit faster than
-it's ISA counterparts. It also requires special support, hence the
+its ISA counterparts. It also requires special support, hence the
 emu10k1-gp.c module for it instead of the normal ns558.c one.
 
 3.15 SoundBlaster 64 and 128 - ES1370 and ES1371, ESS Solo1 and S3 SonicVibes
diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
index f40a1f0..1423bcc 100644
--- a/Documentation/intel_txt.txt
+++ b/Documentation/intel_txt.txt
@@ -126,7 +126,7 @@ o  Tboot then applies an (optional) user-defined launch policy to
 o  Tboot adjusts the e820 table provided by the bootloader to reserve
    its own location in memory as well as to reserve certain other
    TXT-related regions.
-o  As part of it's launch, tboot DMA protects all of RAM (using the
+o  As part of its launch, tboot DMA protects all of RAM (using the
    VT-d PMRs).  Thus, the kernel must be booted with 'intel_iommu=on'
    in order to remove this blanket protection and use VT-d's
    page-level protection.
diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index c412c24..b472e4e 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -181,7 +181,7 @@ Expressions are listed in decreasing order of precedence.
 (7) Returns the result of max(/expr/, /expr/).
 
 An expression can have a value of 'n', 'm' or 'y' (or 0, 1, 2
-respectively for calculations). A menu entry becomes visible when it's
+respectively for calculations). A menu entry becomes visible when its
 expression evaluates to 'm' or 'y'.
 
 There are two types of symbols: constant and non-constant symbols.
diff --git a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
index 28cdc2a..ec8d31e 100644
--- a/Documentation/kernel-docs.txt
+++ b/Documentation/kernel-docs.txt
@@ -116,7 +116,7 @@
        Author: Ingo Molnar, Gadi Oxman and Miguel de Icaza.
        URL: http://www.linuxjournal.com/article.php?sid=2391
        Keywords: RAID, MD driver.
-       Description: Linux Journal Kernel Korner article. Here is it's
+       Description: Linux Journal Kernel Korner article. Here is its
        abstract: "A description of the implementation of the RAID-1,
        RAID-4 and RAID-5 personalities of the MD device driver in the
        Linux kernel, providing users with high performance and reliable,
@@ -127,7 +127,7 @@
        URL: http://www.linuxjournal.com/article.php?sid=1219
        Keywords: device driver, module, loading/unloading modules,
        allocating resources.
-       Description: Linux Journal Kernel Korner article. Here is it's
+       Description: Linux Journal Kernel Korner article. Here is its
        abstract: "This is the first of a series of four articles
        co-authored by Alessandro Rubini and Georg Zezchwitz which present
        a practical approach to writing Linux device drivers as kernel
@@ -141,7 +141,7 @@
        Keywords: character driver, init_module, clean_up module,
        autodetection, mayor number, minor number, file operations,
        open(), close().
-       Description: Linux Journal Kernel Korner article. Here is it's
+       Description: Linux Journal Kernel Korner article. Here is its
        abstract: "This article, the second of four, introduces part of
        the actual code to create custom module implementing a character
        device driver. It describes the code for module initialization and
@@ -152,7 +152,7 @@
        URL: http://www.linuxjournal.com/article.php?sid=1221
        Keywords: read(), write(), select(), ioctl(), blocking/non
        blocking mode, interrupt handler.
-       Description: Linux Journal Kernel Korner article. Here is it's
+       Description: Linux Journal Kernel Korner article. Here is its
        abstract: "This article, the third of four on writing character
        device drivers, introduces concepts of reading, writing, and using
        ioctl-calls".
@@ -161,7 +161,7 @@
        Author: Alessandro Rubini and Georg v. Zezschwitz.
        URL: http://www.linuxjournal.com/article.php?sid=1222
        Keywords: interrupts, irqs, DMA, bottom halves, task queues.
-       Description: Linux Journal Kernel Korner article. Here is it's
+       Description: Linux Journal Kernel Korner article. Here is its
        abstract: "This is the fourth in a series of articles about
        writing character device drivers as loadable kernel modules. This
        month, we further investigate the field of interrupt handling.
diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 2f9115c..51ec634 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -332,7 +332,7 @@ occurs during execution of kp->pre_handler or kp->post_handler,
 or during single-stepping of the probed instruction, Kprobes calls
 kp->fault_handler.  Any or all handlers can be NULL. If kp->flags
 is set KPROBE_FLAG_DISABLED, that kp will be registered but disabled,
-so, it's handlers aren't hit until calling enable_kprobe(kp).
+so, its handlers aren't hit until calling enable_kprobe(kp).
 
 NOTE:
 1. With the introduction of the "symbol_name" field to struct kprobe,
diff --git a/Documentation/laptops/laptop-mode.txt b/Documentation/laptops/laptop-mode.txt
index 2c3c350..0bf25ee 100644
--- a/Documentation/laptops/laptop-mode.txt
+++ b/Documentation/laptops/laptop-mode.txt
@@ -207,7 +207,7 @@ Tips & Tricks
 * Drew Scott Daniels observed: "I don't know why, but when I decrease the number
   of colours that my display uses it consumes less battery power. I've seen
   this on powerbooks too. I hope that this is a piece of information that
-  might be useful to the Laptop Mode patch or it's users."
+  might be useful to the Laptop Mode patch or its users."
 
 * In syslog.conf, you can prefix entries with a dash ``-'' to omit syncing the
   file after every logging. When you're using laptop-mode and your disk doesn't
diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 3119f5d..e9ce3c5 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -263,7 +263,7 @@ static u8 *get_feature_bits(struct device *dev)
  * Launcher virtual with an offset.
  *
  * This can be tough to get your head around, but usually it just means that we
- * use these trivial conversion functions when the Guest gives us it's
+ * use these trivial conversion functions when the Guest gives us its
  * "physical" addresses:
  */
 static void *from_guest_phys(unsigned long addr)
diff --git a/Documentation/md.txt b/Documentation/md.txt
index 188f476..e4e893e 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -136,7 +136,7 @@ raid_disks != 0.
 
 Then uninitialized devices can be added with ADD_NEW_DISK.  The
 structure passed to ADD_NEW_DISK must specify the state of the device
-and it's role in the array.
+and its role in the array.
 
 Once started with RUN_ARRAY, uninitialized spares can be added with
 HOT_ADD_DISK.
diff --git a/Documentation/netlabel/lsm_interface.txt b/Documentation/netlabel/lsm_interface.txt
index 98dd9f7..638c74f 100644
--- a/Documentation/netlabel/lsm_interface.txt
+++ b/Documentation/netlabel/lsm_interface.txt
@@ -38,7 +38,7 @@ Depending on the exact configuration, translation between the network packet
 label and the internal LSM security identifier can be time consuming.  The
 NetLabel label mapping cache is a caching mechanism which can be used to
 sidestep much of this overhead once a mapping has been established.  Once the
-LSM has received a packet, used NetLabel to decode it's security attributes,
+LSM has received a packet, used NetLabel to decode its security attributes,
 and translated the security attributes into a LSM internal identifier the LSM
 can use the NetLabel caching functions to associate the LSM internal
 identifier with the network packet's label.  This means that in the future
diff --git a/Documentation/networking/ifenslave.c b/Documentation/networking/ifenslave.c
index 1b96ccd..2bac961 100644
--- a/Documentation/networking/ifenslave.c
+++ b/Documentation/networking/ifenslave.c
@@ -756,7 +756,7 @@ static int enslave(char *master_ifname, char *slave_ifname)
 		 */
 		if (abi_ver < 1) {
 			/* For old ABI, the master needs to be
-			 * down before setting it's hwaddr
+			 * down before setting its hwaddr
 			 */
 			res = set_if_down(master_ifname, master_flags.ifr_flags);
 			if (res) {
diff --git a/Documentation/networking/packet_mmap.txt b/Documentation/networking/packet_mmap.txt
index 09ab0d2..98f71a5 100644
--- a/Documentation/networking/packet_mmap.txt
+++ b/Documentation/networking/packet_mmap.txt
@@ -100,7 +100,7 @@ by the kernel.
 The destruction of the socket and all associated resources
 is done by a simple call to close(fd).
 
-Next I will describe PACKET_MMAP settings and it's constraints,
+Next I will describe PACKET_MMAP settings and its constraints,
 also the mapping of the circular buffer in the user process and 
 the use of this buffer.
 
@@ -432,7 +432,7 @@ TP_STATUS_LOSING      : indicates there were packet drops from last time
                         the PACKET_STATISTICS option.
 
 TP_STATUS_CSUMNOTREADY: currently it's used for outgoing IP packets which 
-                        it's checksum will be done in hardware. So while 
+                        its checksum will be done in hardware. So while
                         reading the packet we should not try to check the 
                         checksum. 
 
diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
index cdebb51..55c4175 100644
--- a/Documentation/power/regulator/consumer.txt
+++ b/Documentation/power/regulator/consumer.txt
@@ -8,11 +8,11 @@ Please see overview.txt for a description of the terms used in this text.
 1. Consumer Regulator Access (static & dynamic drivers)
 =======================================================
 
-A consumer driver can get access to it's supply regulator by calling :-
+A consumer driver can get access to its supply regulator by calling :-
 
 regulator = regulator_get(dev, "Vcc");
 
-The consumer passes in it's struct device pointer and power supply ID. The core
+The consumer passes in its struct device pointer and power supply ID. The core
 then finds the correct regulator by consulting a machine specific lookup table.
 If the lookup is successful then this call will return a pointer to the struct
 regulator that supplies this consumer.
@@ -34,7 +34,7 @@ usually be called in your device drivers probe() and remove() respectively.
 2. Regulator Output Enable & Disable (static & dynamic drivers)
 ====================================================================
 
-A consumer can enable it's power supply by calling:-
+A consumer can enable its power supply by calling:-
 
 int regulator_enable(regulator);
 
@@ -49,7 +49,7 @@ int regulator_is_enabled(regulator);
 This will return > zero when the regulator is enabled.
 
 
-A consumer can disable it's supply when no longer needed by calling :-
+A consumer can disable its supply when no longer needed by calling :-
 
 int regulator_disable(regulator);
 
@@ -140,7 +140,7 @@ by calling :-
 int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);
 
 This will cause the core to recalculate the total load on the regulator (based
-on all it's consumers) and change operating mode (if necessary and permitted)
+on all its consumers) and change operating mode (if necessary and permitted)
 to best match the current operating load.
 
 The load_uA value can be determined from the consumers datasheet. e.g.most
diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
index 63728fe..bdec39b 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.txt
@@ -52,7 +52,7 @@ static struct regulator_init_data regulator1_data = {
 };
 
 Regulator-1 supplies power to Regulator-2. This relationship must be registered
-with the core so that Regulator-1 is also enabled when Consumer A enables it's
+with the core so that Regulator-1 is also enabled when Consumer A enables its
 supply (Regulator-2). The supply regulator is set by the supply_regulator_dev
 field below:-
 
diff --git a/Documentation/power/regulator/overview.txt b/Documentation/power/regulator/overview.txt
index ffd185b..9363e05 100644
--- a/Documentation/power/regulator/overview.txt
+++ b/Documentation/power/regulator/overview.txt
@@ -35,16 +35,16 @@ Some terms used in this document:-
   o Consumer     - Electronic device that is supplied power by a regulator.
                    Consumers can be classified into two types:-
 
-                   Static: consumer does not change it's supply voltage or
+                   Static: consumer does not change its supply voltage or
                    current limit. It only needs to enable or disable it's
-                   power supply. It's supply voltage is set by the hardware,
+                   power supply. Its supply voltage is set by the hardware,
                    bootloader, firmware or kernel board initialisation code.
 
                    Dynamic: consumer needs to change it's supply voltage or
                    current limit to meet operation demands.
 
 
-  o Power Domain - Electronic circuit that is supplied it's input power by the
+  o Power Domain - Electronic circuit that is supplied its input power by the
                    output power of a regulator, switch or by another power
                    domain.
 
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 79f533f..46d2210 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1289,7 +1289,7 @@ link between a device node and its interrupt parent in
 the interrupt tree.  The value of interrupt-parent is the
 phandle of the parent node.
 
-If the interrupt-parent property is not defined for a node, it's
+If the interrupt-parent property is not defined for a node, its
 interrupt parent is assumed to be an ancestor in the node's
 _device tree_ hierarchy.
 
diff --git a/Documentation/powerpc/phyp-assisted-dump.txt b/Documentation/powerpc/phyp-assisted-dump.txt
index c4682b9..ad34020 100644
--- a/Documentation/powerpc/phyp-assisted-dump.txt
+++ b/Documentation/powerpc/phyp-assisted-dump.txt
@@ -19,7 +19,7 @@ dump offers several strong, practical advantages:
    immediately available to the system for normal use.
 -- After the dump is completed, no further reboots are
    required; the system will be fully usable, and running
-   in it's normal, production mode on it normal kernel.
+   in its normal, production mode on its normal kernel.
 
 The above can only be accomplished by coordination with,
 and assistance from the hypervisor. The procedure is
diff --git a/Documentation/rt-mutex-design.txt b/Documentation/rt-mutex-design.txt
index 4b736d2..8df0b78 100644
--- a/Documentation/rt-mutex-design.txt
+++ b/Documentation/rt-mutex-design.txt
@@ -657,7 +657,7 @@ here.
 
 The waiter structure has a "task" field that points to the task that is blocked
 on the mutex.  This field can be NULL the first time it goes through the loop
-or if the task is a pending owner and had it's mutex stolen.  If the "task"
+or if the task is a pending owner and had its mutex stolen.  If the "task"
 field is NULL then we need to set up the accounting for it.
 
 Task blocks on mutex
diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index 2ffc114..e759e92 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -707,7 +707,7 @@ Changes from 20040920 to 20041018
 	* Integrate patches from Christoph Hellwig: two new helpers common
 	  to lpfc_sli_resume_iocb and lpfc_sli_issue_iocb - singificant
 	  cleanup of those two functions - the unused SLI_IOCB_USE_TXQ is
-	  gone - lpfc_sli_issue_iocb_wait loses it's flags argument
+	  gone - lpfc_sli_issue_iocb_wait loses its flags argument
 	  totally.
 	* Fix in lpfc_sli.c: we can not store a 5 bit value in a 4-bit
 	  field.
@@ -1028,7 +1028,7 @@ Changes from 20040614 to 20040709
 	* Remove the need for buf_tmo.
 	* Changed ULP_BDE64 to struct ulp_bde64.
 	* Changed ULP_BDE to struct ulp_bde.
-	* Cleanup lpfc_os_return_scsi_cmd() and it's call path.
+	* Cleanup lpfc_os_return_scsi_cmd() and its call path.
 	* Removed lpfc_no_device_delay.
 	* Consolidating lpfc_hba_put_event() into lpfc_put_event().
 	* Removed following attributes and their functionality:
diff --git a/Documentation/scsi/FlashPoint.txt b/Documentation/scsi/FlashPoint.txt
index d5acaa3..1540a92 100644
--- a/Documentation/scsi/FlashPoint.txt
+++ b/Documentation/scsi/FlashPoint.txt
@@ -71,7 +71,7 @@ peters@mylex.com
 
 Ever since its introduction last October, the BusLogic FlashPoint LT has
 been problematic for members of the Linux community, in that no Linux
-drivers have been available for this new Ultra SCSI product.  Despite it's
+drivers have been available for this new Ultra SCSI product.  Despite its
 officially being positioned as a desktop workstation product, and not being
 particularly well suited for a high performance multitasking operating
 system like Linux, the FlashPoint LT has been touted by computer system
diff --git a/Documentation/scsi/dtc3x80.txt b/Documentation/scsi/dtc3x80.txt
index e8ae623..1d7af9f 100644
--- a/Documentation/scsi/dtc3x80.txt
+++ b/Documentation/scsi/dtc3x80.txt
@@ -12,7 +12,7 @@ The 3180 does not.  Otherwise, they are identical.
 The DTC3x80 does not support DMA but it does have Pseudo-DMA which is
 supported by the driver.
 
-It's DTC406 scsi chip is supposedly compatible with the NCR 53C400.
+Its DTC406 scsi chip is supposedly compatible with the NCR 53C400.
 It is memory mapped, uses an IRQ, but no dma or io-port.  There is
 internal DMA, between SCSI bus and an on-chip 128-byte buffer.  Double
 buffering is done automagically by the chip.  Data is transferred
diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index 08e2b4d..cda5f8f 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -1479,7 +1479,7 @@ Wide16 SCSI.
 Enabling serial NVRAM support enables detection of the serial NVRAM included
 on Symbios and some Symbios compatible host adaptors, and Tekram boards. The 
 serial NVRAM is used by Symbios and Tekram to hold set up parameters for the 
-host adaptor and it's attached drives.
+host adaptor and its attached drives.
 
 The Symbios NVRAM also holds data on the boot order of host adaptors in a
 system with more than one host adaptor. This enables the order of scanning
diff --git a/Documentation/scsi/osst.txt b/Documentation/scsi/osst.txt
index f536907..2b21890 100644
--- a/Documentation/scsi/osst.txt
+++ b/Documentation/scsi/osst.txt
@@ -40,7 +40,7 @@ behavior looks very much the same as st to the userspace applications.
 
 History
 -------
-In the first place, osst shared it's identity very much with st. That meant
+In the first place, osst shared its identity very much with st. That meant
 that it used the same kernel structures and the same device node as st.
 So you could only have either of them being present in the kernel. This has
 been fixed by registering an own device, now.
diff --git a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
index aec6549..e00192d 100644
--- a/Documentation/scsi/scsi_fc_transport.txt
+++ b/Documentation/scsi/scsi_fc_transport.txt
@@ -70,7 +70,7 @@ Overview:
     up to an administrative entity controlling the vport. For example,
     if vports are to be associated with virtual machines, a XEN mgmt
     utility would be responsible for creating wwpn/wwnn's for the vport,
-    using it's own naming authority and OUI. (Note: it already does this
+    using its own naming authority and OUI. (Note: it already does this
     for virtual MAC addresses).
 
 
@@ -81,7 +81,7 @@ Device Trees and Vport Objects:
   with rports and scsi target objects underneath it. Currently the FC
   transport creates the vport object and places it under the scsi_host
   object corresponding to the physical adapter.  The LLDD will allocate
-  a new scsi_host for the vport and link it's object under the vport.
+  a new scsi_host for the vport and link its object under the vport.
   The remainder of the tree under the vports scsi_host is the same
   as the non-NPIV case. The transport is written currently to easily
   allow the parent of the vport to be something other than the scsi_host.
diff --git a/Documentation/scsi/sym53c8xx_2.txt b/Documentation/scsi/sym53c8xx_2.txt
index eb9a7b9..6f63b79 100644
--- a/Documentation/scsi/sym53c8xx_2.txt
+++ b/Documentation/scsi/sym53c8xx_2.txt
@@ -687,7 +687,7 @@ maintain the driver code.
 Enabling serial NVRAM support enables detection of the serial NVRAM included
 on Symbios and some Symbios compatible host adaptors, and Tekram boards. The 
 serial NVRAM is used by Symbios and Tekram to hold set up parameters for the 
-host adaptor and it's attached drives.
+host adaptor and its attached drives.
 
 The Symbios NVRAM also holds data on the boot order of host adaptors in a
 system with more than one host adaptor.  This information is no longer used
diff --git a/Documentation/sound/alsa/soc/dapm.txt b/Documentation/sound/alsa/soc/dapm.txt
index 9ac842b..05bf5a0 100644
--- a/Documentation/sound/alsa/soc/dapm.txt
+++ b/Documentation/sound/alsa/soc/dapm.txt
@@ -188,8 +188,8 @@ The WM8731 output mixer has 3 inputs (sources)
  3. Mic Sidetone Input
 
 Each input in this example has a kcontrol associated with it (defined in example
-above) and is connected to the output mixer via it's kcontrol name. We can now
-connect the destination widget (wrt audio signal) with it's source widgets.
+above) and is connected to the output mixer via its kcontrol name. We can now
+connect the destination widget (wrt audio signal) with its source widgets.
 
 	/* output mixer */
 	{"Output Mixer", "Line Bypass Switch", "Line Input"},
diff --git a/Documentation/sound/alsa/soc/machine.txt b/Documentation/sound/alsa/soc/machine.txt
index bab7711..2524c75 100644
--- a/Documentation/sound/alsa/soc/machine.txt
+++ b/Documentation/sound/alsa/soc/machine.txt
@@ -67,7 +67,7 @@ static struct snd_soc_dai_link corgi_dai = {
 	.ops = &corgi_ops,
 };
 
-struct snd_soc_card then sets up the machine with it's DAIs. e.g.
+struct snd_soc_card then sets up the machine with its DAIs. e.g.
 
 /* corgi audio machine driver */
 static struct snd_soc_card snd_soc_corgi = {
diff --git a/Documentation/sound/alsa/soc/overview.txt b/Documentation/sound/alsa/soc/overview.txt
index 1e4c6d3..138ac88 100644
--- a/Documentation/sound/alsa/soc/overview.txt
+++ b/Documentation/sound/alsa/soc/overview.txt
@@ -33,7 +33,7 @@ features :-
     and machines.
 
   * Easy I2S/PCM audio interface setup between codec and SoC. Each SoC
-    interface and codec registers it's audio interface capabilities with the
+    interface and codec registers its audio interface capabilities with the
     core and are subsequently matched and configured when the application
     hardware parameters are known.
 
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/usb/WUSB-Design-overview.txt
index c480e9c..4c5e379 100644
--- a/Documentation/usb/WUSB-Design-overview.txt
+++ b/Documentation/usb/WUSB-Design-overview.txt
@@ -381,7 +381,7 @@ descriptor that gives us the status of the transfer, its identification
 we issue another URB to read into the destination buffer the chunk of
 data coming out of the remote endpoint. Done, wait for the next guy. The
 callbacks for the URBs issued from here are the ones that will declare
-the xfer complete at some point and call it's callback.
+the xfer complete at some point and call its callback.
 
 Seems simple, but the implementation is not trivial.
 
diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
index be45dbb..6690fc3 100644
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -45,7 +45,7 @@ most general to most specific:
 	to establish the task policy for a child task exec()'d from an
 	executable image that has no awareness of memory policy.  See the
 	MEMORY POLICY APIS section, below, for an overview of the system call
-	that a task may use to set/change it's task/process policy.
+	that a task may use to set/change its task/process policy.
 
 	In a multi-threaded task, task policies apply only to the thread
 	[Linux kernel task] that installs the policy and any threads
@@ -301,7 +301,7 @@ decrement this reference count, respectively.  mpol_put() will only free
 the structure back to the mempolicy kmem cache when the reference count
 goes to zero.
 
-When a new memory policy is allocated, it's reference count is initialized
+When a new memory policy is allocated, its reference count is initialized
 to '1', representing the reference held by the task that is installing the
 new policy.  When a pointer to a memory policy structure is stored in another
 structure, another reference is added, as the task's reference will be dropped
diff --git a/Documentation/w1/w1.generic b/Documentation/w1/w1.generic
index e3333ee..212f4ac 100644
--- a/Documentation/w1/w1.generic
+++ b/Documentation/w1/w1.generic
@@ -25,7 +25,7 @@ When a w1 master driver registers with the w1 subsystem, the following occurs:
  - sysfs entries for that w1 master are created
  - the w1 bus is periodically searched for new slave devices
 
-When a device is found on the bus, w1 core checks if driver for it's family is
+When a device is found on the bus, w1 core checks if driver for its family is
 loaded. If so, the family driver is attached to the slave.
 If there is no driver for the family, default one is assigned, which allows to perform
 almost any kind of operations. Each logical operation is a transaction
-- 
1.7.0.4

