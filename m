Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1DWQVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:21:31 -0400
Received: from glenfiddich.ikibiki.org ([88.191.124.82]:32808 "EHLO
	glenfiddich.ikibiki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1DWQV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:21:29 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Apr 2011 12:21:29 EDT
From: Cyril Brulebois <kibi@debian.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Cyril Brulebois <kibi@debian.org>
Subject: [PATCH 4/4] Documentation/00-INDEX: update with new top-level files
Date: Sat, 23 Apr 2011 18:15:44 +0200
Message-Id: <1303575344-10403-4-git-send-email-kibi@debian.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303575344-10403-1-git-send-email-kibi@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyril Brulebois <kibi@debian.org>
---
 Documentation/00-INDEX |   66 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 1c089cf..0147d05 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -24,10 +24,14 @@ CodingStyle
 development-process/
 	- An extended tutorial on how to work with the kernel development
 	  process.
+DMA-API-HOWTO.txt
+	- guide about the dynamic DMA mapping for device driver writers.
 DMA-API.txt
 	- DMA API, pci_ API & extensions for non-consistent memory machines.
 DMA-ISA-LPC.txt
 	- How to do DMA with ISA (and LPC) devices.
+DMA-attributes.txt
+	- documentation on the semantics of the DMA attributes.
 DocBook/
 	- directory with DocBook templates etc. for kernel documentation.
 HOWTO
@@ -38,16 +42,22 @@ IRQ-affinity.txt
 	- how to select which CPU(s) handle which interrupt events on SMP.
 IRQ.txt
 	- description of what an IRQ is.
+Intel-IOMMU.txt
+	- documentation on some Intel virtualization technologies.
 ManagementStyle
 	- how to (attempt to) manage kernel hackers.
 RCU/
 	- directory with info on RCU (read-copy update).
 SAK.txt
 	- info on Secure Attention Keys.
+SELinux.txt
+	- how to get started with the SELinux security enhancement.
 SM501.txt
 	- Silicon Motion SM501 multimedia companion chip
 SecurityBugs
 	- procedure for reporting security bugs found in the kernel.
+Smack.txt
+	- documentation on the Smack Linux Security Module.
 SubmitChecklist
 	- Linux kernel patch submission checklist.
 SubmittingDrivers
@@ -62,6 +72,8 @@ acpi/
 	- info on ACPI-specific hooks in the kernel.
 aoe/
 	- description of AoE (ATA over Ethernet) along with config examples.
+apparmor.txt
+	- documentation on the AppArmor security extension.
 applying-patches.txt
 	- description of various trees and how to apply their patches.
 arm/
@@ -70,6 +82,8 @@ atomic_ops.txt
 	- semantics and behavior of atomic and bitmask operations.
 auxdisplay/
 	- misc. LCD driver documentation (cfag12864b, ks0108).
+bad_memory.txt
+	- info on how to deal with bad memory (as reported by memtest86+).
 basic_profiling.txt
 	- basic instructions for those who want to profile Linux kernel.
 binfmt_misc.txt
@@ -80,6 +94,10 @@ block/
 	- info on the Block I/O (BIO) layer.
 blockdev/
 	- info on block devices & drivers
+braille-console.txt
+	- info on getting early boot messages on a braille device.
+bt8xxgpio.txt
+	- info on the driver for BT8xx based PCI GPIO-cards.
 btmrvl.txt
 	- info on Marvell Bluetooth driver usage.
 bus-virt-phys-mapping.txt
@@ -90,6 +108,10 @@ cdrom/
 	- directory with information on the CD-ROM drivers that Linux has.
 cgroups/
 	- cgroups features, including cpusets and memory controller.
+circular-buffers.txt
+	- info on measuring circular buffers, and using memory barriers.
+coccinelle.txt
+	- info on getting and using Coccinelle on the Linux kernel.
 connector/
 	- docs on the netlink based userspace<->kernel space communication mod.
 console/
@@ -104,6 +126,8 @@ cpuidle/
 	- info on CPU_IDLE, CPU idle state management subsystem.
 cputopology.txt
 	- documentation on how CPU topology info is exported via sysfs.
+credentials.txt
+	- documentation about credentials in Linux.
 cris/
 	- directory with info about Linux on CRIS architecture.
 crypto/
@@ -112,24 +136,32 @@ dcdbas.txt
 	- information on the Dell Systems Management Base Driver.
 debugging-modules.txt
 	- some notes on debugging modules after Linux 2.6.3.
+debugging-via-ohci1394.txt
+	- info on debugging using physical DMA provided by FireWire controllers.
 dell_rbu.txt
 	- document demonstrating the use of the Dell Remote BIOS Update driver.
 device-mapper/
 	- directory with info on Device Mapper.
 devices.txt
 	- plain ASCII listing of all the nodes in /dev/ with major minor #'s.
+dmaengine.txt
+	- placeholder for/link to Documentation/crypto/async-tx-api.txt
 dontdiff
 	- file containing a list of files that should never be diff'ed.
 driver-model/
 	- directory with info about Linux driver model.
 dvb/
 	- info on Linux Digital Video Broadcast (DVB) subsystem.
+dynamic-debug-howto.txt
+	- documentation on how to use the dynamic debug feature.
 early-userspace/
 	- info about initramfs, klibc, and userspace early during boot.
 edac.txt
 	- information on EDAC - Error Detection And Correction
 eisa.txt
 	- info on EISA bus support.
+email-clients.txt
+	- mail client hints for the Linux mailing lists.
 fault-injection/
 	- dir with docs about the fault injection capabilities infrastructure.
 fb/
@@ -140,8 +172,14 @@ filesystems/
 	- info on the vfs and the various filesystems that Linux supports.
 firmware_class/
 	- request_firmware() hotplug interface info.
+flexible-arrays.txt
+	- documentation on using flexible arrays in the kernel.
 frv/
 	- Fujitsu FR-V Linux documentation.
+futex-requeue-pi.txt
+	- documentation on futex requeuing and priority inheritance.
+gcov.txt
+	- how to use GCC's coverage testing tool with the Linux kernel.
 gpio.txt
 	- overview of GPIO (General Purpose Input/Output) access conventions.
 highuid.txt
@@ -152,6 +190,8 @@ hw_random.txt
 	- info on Linux support for random number generator in i8xx chipsets.
 hwmon/
 	- directory with docs on various hardware monitoring drivers.
+hwspinlock.txt
+	- documentation about hardware spinlock modules.
 i2c/
 	- directory with info about the I2C bus/protocol (2 wire, kHz speed).
 i2o/
@@ -164,8 +204,12 @@ infiniband/
 	- directory with documents concerning Linux InfiniBand support.
 initrd.txt
 	- how to use the RAM disk as an initial/temporary root filesystem.
+init.txt
+	- explanations about the "no init found" boot hang message.
 input/
 	- info on Linux input device support.
+intel_txt.txt
+	- documentation on Intel's Trusted Execution Technology (TXT).
 io-mapping.txt
 	- description of io_mapping functions in linux/io-mapping.h
 io_ordering.txt
@@ -194,8 +238,14 @@ kernel-parameters.txt
 	- summary listing of command line / boot prompt args for the kernel.
 keys-request-key.txt
 	- description of the kernel key request service.
+keys-trusted-encrypted.txt
+	- info on the Trusted and Encrypted keys in the kernel key ring service.
 keys.txt
 	- description of the kernel key retention service.
+kmemcheck.txt
+	- documentation on the kernel-side memory checker.
+kmemleak.txt
+	- documentation on the kernel memory leak detector.
 kobject.txt
 	- info of the kobject infrastructure of the Linux kernel.
 kprobes.txt
@@ -212,6 +262,8 @@ local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
 	- documentation on the runtime locking correctness validator.
+lockstat.txt
+	- documentation about statistics on locks.
 logo.gif
 	- full colour GIF image of Linux logo (penguin - Tux).
 logo.txt
@@ -224,6 +276,8 @@ mca.txt
 	- info on supporting Micro Channel Architecture (e.g. PS/2) systems.
 md.txt
 	- info on boot arguments for the multiple devices driver.
+media-framework.txt
+	- info on the kernel-side implementation of the media framework.
 memory-barriers.txt
 	- info on Linux kernel memory barriers.
 memory-hotplug.txt
@@ -278,6 +332,8 @@ prio_tree.txt
 	- info on radix-priority-search-tree use for indexing vmas.
 rbtree.txt
 	- info on what red-black trees are and what they are for.
+rfkill.txt
+	- info on the subsystem allowing to disable any radio transmitter.
 robust-futex-ABI.txt
 	- documentation of the robust futex ABI.
 robust-futexes.txt
@@ -328,14 +384,20 @@ sysrq.txt
 	- info on the magic SysRq key.
 telephony/
 	- directory with info on telephony (e.g. voice over IP) support.
+tomoyo.txt
+	- documentation on the TOMOYO Linux Security Module.
 uml/
 	- directory with information about User Mode Linux.
+unaligned-memory-access.txt
+	- documentation on unaligned accesses, and how to avoid them.
 unicode.txt
 	- info on the Unicode character/font mapping used in Linux.
 unshare.txt
 	- description of the Linux unshare system call.
 usb/
 	- directory with info regarding the Universal Serial Bus.
+vgaarbiter.txt
+	- documentation on how to deal with legacy VGA devices.
 video-output.txt
 	- sysfs class driver interface to enable/disable a video output device.
 video4linux/
@@ -348,7 +410,11 @@ w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
 	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
+workqueue.txt
+	- documentation on concurrency managed workqueues.
 x86/x86_64/
 	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
+xz.txt
+	- documentation on XZ data compression in Linux.
 zorro.txt
 	- info on writing drivers for Zorro bus devices found on Amigas.
-- 
1.7.4.4

