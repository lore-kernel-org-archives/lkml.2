Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1KIDVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 22:21:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:56983 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1KIDVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 22:21:01 -0500
Date: Tue, 8 Nov 2011 22:20:37 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <greg@kroah.com>
CC: "George G. Davis" <gdavis@mvista.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@kernel.org>,
        <jason.wessel@windriver.com>, Andi Kleen <andi@firstfloor.org>,
        <lwn@lwn.net>
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20111109032036.GF1354@windriver.com>
References: <20101203210719.GB21223@windriver.com>
 <ADA45A9A-E9A4-4B4C-80FF-711340F931BB@mvista.com>
 <4EB9B731.9040804@windriver.com>
 <20111108235256.GB9866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111108235256.GB9866@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: Announcement: Plans for v2.6.34-longterm] On 08/11/2011 (Tue 15:52) Greg KH wrote:

[...]

> Also, I would like to populate the linux-stable.git tree with the
> missing .34-longterm releases that you have already done, care to
> provide a git tree that I can pull from for those now?

Hi Greg,

The below pull rq should get your repo caught up on the .34
content for my tags 8 --> 10.  You should be able to use the
"git verify-tag v2.6.34.10" on this older content without issue
as a double check on things.

Thanks,
Paul.

---

The following changes since commit f42346985c7721798c577606cb4d0f719940d33e:

  Linux 2.6.34.7 (2010-09-13 09:54:58 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-stable.git linux-2.6.34.y

Aaro Koskinen (1):
      procfs: fix /proc/<pid>/maps heap check

Al Viro (3):
      arm: fix really nasty sigreturn bug
      Fix sget() race with failing mount
      MIPS: secure_computing, syscall audit: syscall number should in r2, not r0.

Alan Cox (1):
      bluetooth: Fix missing NULL check

Alan Stern (15):
      USB: fix bug in initialization of interface minor numbers
      USB: disable endpoints after unbinding interfaces, not before
      USB: accept some invalid ep0-maxpacket values
      USB: EHCI: fix obscure race in ehci_endpoint_disable
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: usb-storage: unusual_devs entry for Coby MP3 player
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in module parameter definitions
      USB: prevent buggy hubs from crashing the USB stack
      USB: fix regression in usbip by setting has_tt flag
      USB: dummy-hcd needs the has_tt flag
      OHCI: work around for nVidia shutdown problem
      OHCI: fix regression caused by nVidia shutdown workaround
      USB: add quirks entry for Keytouch QWERTY Panel
      ehci-hcd: Bug fix: don't set a QH's Halt bit

Alex Deucher (7):
      drm/radeon/kms: handle the case of no active displays properly in the bandwidth code
      drm/kms: remove spaces from connector names (v2)
      drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: add pll debugging output
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms: fix s/r issues with bios scratch regs

Alex Elder (1):
      xfs: zero proper structure size for geometry calls

Alex He (2):
      USB: EHCI: ASPM quirk of ISOC on AMD SB800
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Alexander Shishkin (1):
      crypto: testmgr - add an option to disable cryptoalgos' self-tests

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Alexey Kuznetsov (1):
      tcp: Prevent overzealous packetization by SWS logic.

Alexey Starikovskiy (1):
      ACPI: EC: Add another dmi match entry for MSI hardware

Alok Kataria (1):
      x86, kexec: Make sure to stop all CPUs before exiting the kernel

Alon Ziv (1):
      USB: opticon: Fix long-standing bugs in opticon driver

Amir Goldstein (1):
      ext3: skip orphan cleanup on rocompat fs

Amitkumar Karwar (1):
      ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Anders Larsen (1):
      USB: cp210x: Add WAGO 750-923 Service Cable device ID

Andre Przywara (1):
      x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit

Andreas Herrmann (4):
      hwmon: (k8temp) Differentiate between AM2 and ASB1
      x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs
      x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
      x86, quirk: Fix SB600 revision check

Andrew Morton (1):
      drivers/pci/intel-iommu.c: fix build with older gcc's

Andrey Vagin (1):
      x86/mm: Handle mm_fault_error() in kernel space

Andy Gospodarek (1):
      bonding: correctly process non-linear skbs

Anton Blanchard (6):
      kernel/smp.c: fix smp_call_function_many() SMP race
      RxRPC: Fix v1 keys
      powerpc/kdump: CPUs assume the context of the oopsing CPU
      powerpc/kdump: Use chip->shutdown to disable IRQs
      powerpc: Use more accurate limit for first segment memory allocations
      perf, powerpc: Handle events that raise an exception without overflowing

Anton Vorontsov (1):
      apm_power: Add missing break statement

Antonio Ospite (2):
      HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
      HID: hidraw, fix a NULL pointer dereference in hidraw_write

Apollon Oikonomopoulos (1):
      x25: decrement netdev reference counts on unload

Arvid Ephraim Picciani (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia N8

Avi Kivity (3):
      KVM: VMX: Fix host GDT.LIMIT corruption
      KVM: Fix fs/gs reload oops with invalid ldt
      KVM: VMX: Fix host userspace gsbase corruption

Axel Lin (1):
      mtd: add "platform:" prefix for platform modalias

Ben Hutchings (11):
      ext4: Conditionally define compat ioctl numbers
      ext4: Fix compat EXT4_IOC_ADD_GROUP
      PCI: MSI: Remove unsafe and unnecessary hardware access
      PCI: MSI: Restore read_msi_msg_desc(); add get_cached_msi_msg_desc()
      tun: Don't add sysfs attributes to devices without sysfs directories
      MIPS: Set io_map_base for several PCI bridges lacking it
      sis-agp: Remove SIS 760, handled by amd64-agp
      net: NETIF_F_HW_CSUM does not imply FCoE CRC offload
      niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL
      bonding/vlan: Avoid mangled NAs on slaves without VLAN tag insertion
      PCI: sysfs: Fix failure path for addition of "vpd" attribute

Benjamin Herrenschmidt (1):
      powerpc: Fix some 6xx/7xxx CPU setup functions

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Bob Moore (1):
      Subject: [PATCH] ACPICA: Fix Scope() op in module level code

Borislav Petkov (2):
      x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order
      amd64_edac: Fix interleaving check

Brandeburg, Jesse (1):
      PCI: remove quirk for pre-production systems

Bruce Allan (1):
      e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead

Changli Gao (2):
      act_nat: use stack variable
      ifb: goto resched directly if error happens and dp->tq isn't empty

Chris Wilson (4):
      drm/i915: Prevent double dpms on
      drm: Only decouple the old_fb from the crtc is we call mode_set*
      drm/i915: Unset cursor if out-of-bounds upon mode change (v4)
      drm/i915: Add dependency on CONFIG_TMPFS

Chris Wright (1):
      tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread

Christian Borntraeger (1):
      ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode

Christian Lamparter (7):
      p54: fix tx feedback status flag check
      p54usb: fix off-by-one on !CONFIG_PM
      p54usb: add five more USBIDs
      p54usb: add 5 more USBIDs
      p54: fix sequence no. accounting off-by-one error
      p54pci: update receive dma buffers before and after processing
      p54usb: add Senao NUB-350 usbid

Christof Schmitt (1):
      Fix race when removing SCSI devices

Christoph Hellwig (1):
      xfs: always use iget in bulkstat

Christoph Lameter (1):
      mm: page allocator: calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake

Chuck Lever (2):
      NFS: Fix panic after nfs_umount()
      NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (5):
      ALSA: rawmidi: fix oops (use after free) when unloading a driver module
      hpet: fix unwanted interrupt due to stale irq status bit
      firewire: ohci: fix buffer overflow in AR split packet handling
      firewire: ohci: fix race in AR split packet handling
      ALSA: hrtimer: handle delayed timer interrupts

Cliff Wickman (2):
      mm, x86: Saving vmcore with non-lazy freeing of vmas
      x86, kdump: Change copy_oldmem_page() to use cached addressing

Colin Ian King (1):
      ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume

Craig Shelley (3):
      USB: CP210x Add new device ID
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

Curt Wohlgemuth (2):
      ext4: Remove extraneous newlines in ext4_msg() calls
      ext4: check for a good block group before loading buddy pages

DJ Delorie (1):
      USB: cp210x: Add Renesas RX-Stick device ID

Dan Carpenter (13):
      KEYS: Return more accurate error codes
      USB: ehci-ppc-of: problems in unwind
      sysfs: checking for NULL instead of ERR_PTR
      irda: off by one
      i915: return -EFAULT if copy_to_user fails
      i915: return -EFAULT if copy_to_user fails
      Staging: vt6655: fix buffer overflow
      net/llc: make opt unsigned in llc_ui_setsockopt()
      gdth: integer overflow in ioctl
      IB/uverbs: Handle large number of entries in poll CQ
      av7110: check for negative array offset
      sched: Remove some dead code
      keyboard: integer underflow bug

Dan Rosenberg (22):
      USB: serial/mos*: prevent reading uninitialized stack memory
      drivers/net/usb/hso.c: prevent reading uninitialized memory
      drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized stack memory
      drivers/net/eql.c: prevent reading uninitialized stack memory
      drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
      xfs: prevent reading uninitialized stack memory
      drivers/video/via/ioctl.c: prevent reading uninitialized stack memory
      ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
      ALSA: prevent heap corruption in snd_ctl_new()
      ipc: initialize structure memory to zero for compat functions
      sys_semctl: fix kernel stack leakage
      DECnet: don't leak uninitialized stack byte
      V4L/DVB: ivtvfb: prevent reading uninitialized stack memory
      x25: Prevent crashing when parsing bad X.25 facilities
      rds: Integer overflow in RDS cmsg handling
      Fix pktcdvd ioctl dev_minor range check
      sound: Prevent buffer overflow in OSS load_mixer_volumes
      sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
      mpt2sas: prevent heap overflows and unchecked reads
      irda: prevent integer underflow in IRLMP_ENUMDEVICES
      CAN: Use inode instead of kernel address for /proc file
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1

Dan Williams (1):
      ioat2: catch and recover from broken vtd configurations v6

Daniel J Blueman (2):
      rcu: apply RCU protection to wake_affine()
      Fix unprotected access to task credentials in waitid()

Daniel Klaffenbach (1):
      ssb: b43-pci-bridge: Add new vendor for BCM4318

Daniel Suchy (1):
      USB: ftdi_sio: new VID/PIDs for various Papouch devices

Daniel T Chen (4):
      ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and Headphone controls
      ALSA: hda: Use "alienware" model quirk for another SSID
      ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
      ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

Darren Hart (1):
      futex: Fix errors in nested key ref-counting

Darrick J. Wong (1):
      PCI: fix offset check for sysfs mmapped files

Dave Airlie (2):
      drm/radeon: fix PCI ID 5657 to be an RV410
      drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

Dave Chinner (4):
      xfs: validate untrusted inode numbers during lookup
      xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
      xfs: remove block number from inode lookup code
      xfs: fix untrusted inode number lookup

Dave Hansen (1):
      mm/vfs: revalidate page->mapping in do_generic_file_read()

Dave Jones (1):
      ACPI: debugfs custom_method open to non-root

Dave Ludlow (2):
      usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
      usb: serial: mos7840: Add USB IDs to support more B&B USB/RS485 converters.

David Daney (1):
      MIPS: Quit using undefined behavior of ADDU in 64-bit atomic operations.

David Henningsson (4):
      ALSA: hda - Rename iMic to Int Mic on Lenovo NB0763
      ALSA: HDA: Add an extra DAC for Realtek ALC887-VD
      ALSA: HDA: Fix dmesg output of HDMI supported bits
      ALSA: HDA: Add position_fix quirk for an Asus device

David Howells (5):
      CIFS: Remove __exit mark from cifs_exit_dns_resolver()
      KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
      KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring
      CRED: Fix RCU warning due to previous patch fixing __task_cred()'s checks
      CRED: Fix get_task_cred() and task_state() to not resurrect dead credentials

David Kilroy (2):
      orinoco: fix TKIP countermeasure behaviour
      orinoco: clear countermeasure setting on commit

David Milburn (1):
      libsas: fix NCQ mixing with non-NCQ

David Miller (1):
      klist: Fix object alignment on 64-bit.

David S. Miller (16):
      irda: Correctly clean up self->ias_obj on irda_bind() failure.
      tcp: Combat per-cpu skew in orphan tests.
      bridge: Clear INET control block of SKBs passed into ip_fragment().
      sparc64: Get rid of indirect p1275 PROM call buffer.
      tcp: Fix >4GB writes on 64-bit.
      rose: Fix signedness issues wrt. digi count.
      sparc64: Fix race in signal instruction flushing.
      sparc: Don't mask signal when we can't setup signal frame.
      sparc: Prevent no-handler signal syscall restart recursion.
      net: Limit socket I/O iovec total length to INT_MAX.
      filter: make sure filters dont read uninitialized memory
      tcp: Don't change unlocked socket state in tcp_v4_err().
      tcp: Increase TCP_MAXSEG socket option minimum.
      tcp: Make TCP_MAXSEG minimum more correct.
      econet: Fix crash in aun_incoming().
      x25: Do not reference freed memory.

Davide Libenzi (1):
      epoll: prevent creating circular epoll structures

Dimitris Papastamos (1):
      ASoC: WM8990: msleep() takes milliseconds not jiffies

Dmitry Monakhov (8):
      ext4: check missed return value in ext4_sync_file()
      ext4: fix quota accounting in case of fallocate
      ext4: Do not zero out uninitialized extents beyond i_size
      ext4: clean up inode bitmaps manipulation in ext4_free_inode
      ext4: init statistics after journal recovery
      ext4: Use bitops to read/modify i_flags in struct ext4_inode_info
      ext4: restart ext4_ext_remove_space() after transaction restart
      ext4: Fix remaining racy updates of EXT4_I(inode)->i_flags

Dmitry Torokhov (2):
      Input: i8042 - fix device removal on unload
      Input: i8042 - add Sony VAIO VPCZ122GX to nomux list

Don Fry (1):
      iwlagn: Re-enable RF_KILL interrupt when down

Don Skidmore (1):
      ixgbe: fix for 82599 erratum on Header Splitting

Don Zickus (1):
      x86: Use u32 instead of long to set reset vector back to 0

Edgar (gimli) Hucek (1):
      input: bcm5974: Add support for MacBookAir3

Eduardo Costa (1):
      p54usb: New USB ID for Gemtek WUBI-100GW

Eric Dumazet (16):
      gro: fix different skb headrooms
      tcp: fix three tcp sysctls tuning
      rds: fix a leak of kernel memory
      ip: fix truesize mismatch in ip fragmentation
      netxen: dont set skb->truesize
      udp: add rehash on connect()
      numa: fix slab_node(MPOL_BIND)
      netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get highmem pages
      net: avoid limits overflow
      sysctl: min/max bounds are optional
      sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
      net sched: fix some kernel memory leaks
      tcp: avoid a possible divide by zero
      af_unix: limit unix_tot_inflight
      af_unix: limit recursion level
      filter: fix sk_filter rcu handling

Eric Paris (4):
      inotify: send IN_UNMOUNT events
      inotify: fix inotify oneshot support
      SELinux: define permissions for DCB netlink messages
      SELinux: do not compute transition labels on mountpoint labeled filesystems

Eric Sandeen (5):
      ext4: don't return to userspace after freezing the fs with a mutex held
      ext4: stop issuing discards if not supported by device
      ext4: don't scan/accumulate more pages than mballoc will allocate
      ext4: fix freeze deadlock under IO
      ext3: Always set dx_node's fake_dirent explicitly.

Erik J. Staab (1):
      ALSA: oxygen: fix analog capture on Claro halo cards

FUJITA Tomonori (1):
      bsg: fix incorrect device_status value

Felipe Balbi (1):
      usb: musb: core: set has_tt flag

Felix Fietkau (2):
      ath9k: fix retry count for A-MPDU rate control status reports
      ath9k_hw: fix antenna diversity on AR9285

Florian Faber (1):
      USB: ftdi_sio: Add D.O.Tec PID

Florian Fainelli (1):
      MIPS: MTX-1: Make au1000_eth probe all PHY addresses

Florian Tobias Schandinat (1):
      viafb: use proper register for colour when doing fill ops

Francisco Jerez (1):
      drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.

Frank Mayhar (1):
      ext4: Make fsync sync new parent directories in no-journal mode

Frederic Weisbecker (1):
      perf: Initialize callchains roots's childen hits

Gabriele Gorla (2):
      hwmon: (adm1026) Allow 1 as a valid divider value
      hwmon: (adm1026) Fix setting fan_div

Gary King (1):
      bounce: call flush_dcache_page() after bounce_copy_vec()

Geert Uytterhoeven (1):
      radio-aimslab.c needs #include <linux/delay.h>

Gerrit Renker (1):
      dccp: fix oops on Reset after close

Graham Gower (1):
      drivers/char/vt_ioctl.c: fix VT_OPENQRY error value

Greg Kroah-Hartman (14):
      USB: ftdi_sio: add device ids for ScienceScope
      Staging: asus_oled: fix up some sysfs attribute permissions
      Staging: asus_oled: fix up my fixup for some sysfs attribute permissions
      Staging: line6: fix up some sysfs attribute permissions
      Staging: line6: fix up my fixup for some sysfs attribute permissions
      USB: storage: sierra_ms: fix sysfs file attribute
      USB: atm: ueagle-atm: fix up some permissions on the sysfs files
      USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
      USB: misc: usbled: fix up some sysfs attribute permissions
      USB: misc: trancevibrator: fix up a sysfs attribute permission
      USB: misc: usbsevseg: fix up some sysfs attribute permissions
      Staging: frontier: fix up some sysfs attribute permissions
      Staging: frontier: fix up my fixup for some sysfs attribute permissions
      rt2x00: add device id for windy31 usb device

Guennadi Liakhovetski (1):
      mmc: fix the use of kunmap_atomic() in tmio_mmc.h

Guenter Roeck (1):
      hwmon: (w83627ehf) Fix max_output and step_output readings

Guillem Jover (2):
      hwmon: (f75375s) Shift control mode to the correct bit position
      hwmon: (f75375s) Do not overwrite values read from registers

Guo-Fu Tseng (1):
      jme: Fix PHY power-off error

Guy Martin (1):
      parisc : Remove broken line wrapping handling pdc_iodc_print()

H. Peter Anvin (9):
      x86-64, compat: Test %rax for the syscall number, not %eax
      compat: Make compat_alloc_user_space() incorporate the access_ok()
      x86, cpu: After uncapping CPUID, re-run CPU feature detection
      x86-32: Fix dummy trampoline-related inline stubs
      x86, mwait: Move mwait constants to a common header file
      x86, hotplug: Use mwait to offline a processor, fix the legacy case
      x86, hotplug: Move WBINVD back outside the play_dead loop
      x86, hotplug: In the MWAIT case of play_dead, CLFLUSH the cache line
      x86, gcc-4.6: Use gcc -m options when building vdso

Haiyang Zhang (3):
      staging: hv: Fix missing functions for net_device_ops
      staging: hv: Fixed the value of the 64bit-hole inside ring buffer
      staging: hv: Enable sending GARP packet after live migration

Hank Janssen (3):
      staging: hv: Fixed bounce kmap problem by using correct index
      staging: hv: Increased storvsc ringbuffer and max_io_requests
      staging: hv: Fixed lockup problem with bounce_buffer scatter list

Hans de Goede (1):
      hwmon/f71882fg: Set platform drvdata to NULL later

Heiko Carstens (3):
      nmi: fix clock comparator revalidation
      nohz: Fix printk_needs_cpu() return value on offline cpus
      nohz: Fix get_next_timer_interrupt() vs cpu hotplug

Henry Nestler (1):
      fbcon: Bugfix soft cursor detection in Tile Blitting

Herbert Xu (3):
      bridge: Clear IPCB before possible entry into IP stack
      crypto: padlock - Fix AES-CBC handling on odd-block-sized input
      udp: Fix bogus UFO packet generation

Hillf Danton (1):
      bonding: Fix slave selection bug.

Hugh Dickins (2):
      x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
      mm: fix possible cause of a page_mapped BUG

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ian Campbell (2):
      xen: ensure that all event channels start off bound to VCPU 0
      arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.

Igor Mammedov (1):
      Input: xen-kbdfront - fix mouse getting stuck after save/restore

Ionut Nicu (1):
      USB: ti_usb: fix module removal

Ivan Vecera (1):
      r8169: use RxFIFO overflow workaround for 8168c chipset.

Jack Steiner (2):
      x86, UV: Delete unneeded boot messages
      x86, UV: Fix initialization of max_pnode

Jacob Pan (1):
      x86: detect scattered cpuid features earlier

Jacques Viviers (1):
      USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      libsas: fix runaway error handler problem

James Jones (1):
      ARM: 6482/2: Fix find_next_zero_bit and related assembly

Jan Engelhardt (1):
      netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Jan Kara (2):
      ext4: Show journal_checksum option
      char: Mark /dev/zero and /dev/kmem as not capable of writeback

Jan Sembera (1):
      binfmt_misc: fix binfmt_misc priority

Jarek Poplawski (2):
      gro: Re-fix different skb headrooms
      gianfar: Fix crashes on RX path (Was Re: [Bugme-new] [Bug 19692] New: linux-2.6.36-rc5 crash with gianfar ethernet at full line rate traffic)

Jason Detring (1):
      USB: cp210x: Add B&G H3000 link cable ID

Jean Delvare (3):
      hwmon: (lm85) Fix ADT7468 frequency table
      hwmon: (via686a) Initialize fan_div values
      i2c: Unregister dummy devices last on adapter removal

Jean-Christophe PLAGNIOL-VILLARD (2):
      USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled
      USB: ftdi_sio: add ST Micro Connect Lite uart support

Jeff Kirsher (1):
      e100/e1000*/igb*/ixgb*: Add missing read memory barrier

Jeff Mahoney (1):
      net sched: fix kernel leak in act_police

Jeff Moyer (1):
      aio: check for multiplication overflow in do_io_submit

Jens Axboe (4):
      block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
      block: take care not to overflow when calculating total iov length
      block: check for proper length of iov entries in blk_rq_map_user_iov()
      bio: take care not overflow page count when mapping/copying user data

Jeremy Fitzhardinge (5):
      xen: handle events as edge-triggered
      xen: use percpu interrupts for IPIs and VIRQs
      tracing/x86: Don't use mcount in pvclock.c
      xen: don't bother to stop other cpus on shutdown/reboot
      x86/pvclock: Zero last_value on resume

Jerome Marchand (1):
      kernel/groups.c: fix integer overflow in groups_search

Jianzhao Wang (1):
      net: blackhole route should always be recalculated

Jing Zhang (3):
      ext4: fix memory leaks in error path handling of ext4_ext_zeroout()
      ext4: Remove unnecessary call to ext4_get_group_desc() in mballoc
      ext4: rename ext4_mb_release_desc() to ext4_mb_unload_buddy()

Jiri Kosina (1):
      Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Jiri Olsa (2):
      oprofile: Add Support for Intel CPU Family 6 / Model 29
      tty: prevent DOS in the flush_to_ldisc

Jiri Slaby (8):
      hpet: unmap unused I/O space
      TTY: restore tty_ldisc_wait_idle
      TTY: ldisc, fix open flag handling
      TTY: don't allow reopen when ldisc is changing
      HID: hidraw: fix window in hidraw_release
      USB: serial/kobil_sct, fix potential tty NULL dereference
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Joe Jin (1):
      driver/net/benet: fix be_cmd_multicast_set() memcpy bug

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

Joerg Roedel (4):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Fix rounding-bug in __unmap_single
      x86/amd-iommu: Work around S3 BIOS bug
      x86-32: Separate 1:1 pagetables from swapper_pg_dir

Johan Hovold (5):
      USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"
      usb: musb: omap2430: fix kernel panic on reboot
      USB: cdc-acm: fix potential null-pointer dereference on disconnect
      USB: cdc-acm: fix potential null-pointer dereference
      USB: cdc-acm: fix memory corruption / panic

Johannes Berg (2):
      wireless extensions: fix kernel heap content leak
      wext: fix potential private ioctl memory content leak

John W. Linville (2):
      ath5k: check return value of ieee80211_get_tx_rate
      hostap_pci: set dev->base_addr during probe

Jon Thomas (1):
      sierra: add new ID for Airprime/Sierra USB IP modem

Josef Bacik (1):
      fs: call security_d_instantiate in d_obtain_alias V2

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

Josh Wu (1):
      USB: gadget: AT91: fix typo in atmel_usba_udc driver

Julia Lawall (1):
      drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure

Julien Tinnes (1):
      Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code

Justin Maggard (1):
      md: fix return value of rdev_size_change()

KAMEZAWA Hiroyuki (3):
      memory hotplug: fix next block calculation in is_removable
      mm: fix return value of scan_lru_pages in memory unplug
      mm: fix is_mem_section_removable() page_order BUG_ON check

KOSAKI Motohiro (1):
      tcp: select(writefds) don't hang up when a peer close connection

Kamal Mostafa (2):
      x86: Fix panic when handling "mem={invalid}" param
      x86: Emit "mem=nopentium ignored" warning when not supported

Karsten Wiese (1):
      ALSA: snd-usb-us122l: Fix missing NULL checks

Kashyap, Desai (5):
      mpt2sas: Fix device removal handshake for zoned devices
      mpt2sas: Correct resizing calculation for max_queue_depth
      mpt2sas: Kernel Panic during Large Topology discovery
      mptfusion: mptctl_release is required in mptctl.c
      mptfusion: Fix Incorrect return value in mptscsih_dev_reset

Kees Cook (4):
      net: clear heap allocations for privileged ethtool actions
      net: clear heap allocation for ETHTOOL_GRXCLSRLALL
      usb: iowarrior: don't trust report_size for buffer size
      proc: protect mm start_code/end_code in /proc/pid/stat

Ken Chen (1):
      latencytop: fix per task accumulator

Ken Sumrall (1):
      fuse: fix attributes after open(O_TRUNC)

Kenji Kaneshige (2):
      x86: Enable the intr-remap fault handling after local APIC setup
      x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode

Kenneth Waters (1):
      Input: joydev - fix JSIOCSAXMAP ioctl

Knut Petersen (1):
      drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

Konstantin Khorenko (1):
      NFSD: memory corruption due to writing beyond the stat array

Krishna Gudipati (1):
      bfa: fix system crash when reading sysfs fc_host statistics

Kulikov Vasiliy (1):
      net: tipc: fix information leak to userland

Kumar Sanghvi (1):
      Phonet: Correct header retrieval after pskb_may_pull

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Larry Finger (1):
      staging: rtl8187se: Change panic to warn when RF switch turned off

Len Brown (3):
      intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
      ACPI: delete ZEPTO idle=nomwait DMI quirk

Li Zefan (4):
      tracing: Fix a race in function profile
      sunrpc/cache: fix module refcnt leak in a failure path
      sched: Remove remaining USER_SCHED code
      cpuset: add a missing unlock in cpuset_write_resmask()

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Linus Torvalds (4):
      v4l1: fix 32-bit compat microcode loading translation
      De-pessimize rds_page_copy_user
      net: Truncate recvfrom and sendto length to INT_MAX.
      net: fix rds_iovec page count overflow

Luca Tettamanti (1):
      atl1: fix resume

Luis R. Rodriguez (2):
      ath5k: drop warning on jumbo frames
      ath9k_hw: fix parsing of HT40 5 GHz CTLs

Luke Lowrey (1):
      USB: ftdi_sio: Added custom PIDs for ChamSys products

Luke Macken (1):
      efifb: support the EFI framebuffer on more Apple hardware

Luke Yelavich (1):
      ALSA: hda - Add Dell Latitude E6400 model quirk

Lytochkin Boris (1):
      serial: add support for OX16PCI958 card

Maciej Szmigiero (2):
      USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
      USB: Add quirk for Samsung Android phone modem

Maciej Żenczykowski (1):
      net: Fix IPv6 PMTU disc. w/ asymmetric routes

Marek Szyprowski (1):
      mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove

Mark Lord (1):
      sata_mv: fix broken DSM/TRIM support (v2)

Martin K. Petersen (2):
      block: Ensure physical block size is unsigned int
      block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead

Martin Schwidefsky (1):
      s390: remove task_show_regs

Martin Wilck (1):
      PCI: fix size checks for mmap() on /proc/bus/pci files

Masanori ITOH (1):
      percpu: fix list_head init bug in __percpu_counter_init()

Mathieu Desnoyers (1):
      sched: Fix string comparison in /proc/sched_features

Matt Evans (2):
      powerpc: Initialise paca->kstack before early_setup_secondary
      powerpc/kexec: Fix orphaned offline CPUs across kexec

Matthew Garrett (1):
      acer-wmi: Fix capitalisation of GUID

Mauro Carvalho Chehab (4):
      V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)
      USB: option: Add more ZTE modem USB id's
      radio-aimslab.c: Fix gcc 4.5+ bug
      em28xx: Fix audio input for Terratec Grabby

Max Vozeler (6):
      staging: usbip: Notify usb core of port status changes
      staging: usbip: Process event flags without delay
      staging: usbip: vhci: update reference count for usb_device
      staging: usbip: vhci: give back URBs from in-flight unlink requests
      staging: usbip: vhci: refuse to enqueue for dead connections
      staging: usbip: vhci: use urb->dev->portnum to find port

Maxim Osipov (1):
      USB: Fix kernel oops with g_ether and Windows

Maxim Uvarov (1):
      powerpc/crashdump: Do not fail on NULL pointer dereferencing

Mel Gorman (2):
      mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
      mm: page allocator: update free page counters after pages are placed on the free list

Mi Jinlong (2):
      nfsd: wrong index used in inner loop
      nfsd41: modify the members value of nfsd4_op_flags

Michael Cree (1):
      alpha: Fix printk format errors

Michael Neuling (5):
      powerpc: Don't use kernel stack with translation off
      powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
      powerpc/kexec: Speedup kexec hash PTE tear down
      powerpc/kexec: Fix race in kexec shutdown
      powerpc/kdump: Fix race in kdump shutdown

Michael Reed (1):
      sd name space exhaustion causes system hang

Michael Stuermer (1):
      USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable

Michael Williamson (1):
      USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph

Michal Schmidt (1):
      PCI: return correct value when writing to the "reset" attribute

Michel Dänzer (1):
      drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.

Mike Christie (1):
      Fix regressions in scsi_internal_device_block

Mike Frysinger (1):
      ASoC: Blackfin AC97: fix build error after multi-component update

Mike Galbraith (1):
      sched: Fix select_idle_sibling()

Mike Snitzer (2):
      dm: dont take i_mutex to change device size
      dm mpath: disable blk_abort_queue

Miklos Szeredi (4):
      fuse: flush background queue on connection close
      fuse: verify ioctl retries
      fuse: fix ioctl when server is 32bit
      fuse: fix hang of single threaded fuseblk filesystem

Milton Miller (5):
      virtio: remove virtio-pci root device
      call_function_many: fix list delete vs add race
      call_function_many: add missing ordering
      smp_call_function_many: handle concurrent clearing of mask
      powerpc: rtas_flash needs to use rtas_data_buf

Mimi Zohar (1):
      ima: fix add LSM rule bug

Ming Lei (1):
      usb: musb: gadget: fix kernel panic if using out ep with FIFO_TXRX style

Márton Németh (1):
      staging: usbip: remove double giveback of URB

Nagendra Tomar (1):
      net: Fix the condition passed to sk_wait_event()

Nandita Dukkipati (1):
      tcp: Bug fix in initialization of receive window.

Neil Brown (1):
      nfsd: Fix possible BUG_ON firing in set_change_info

NeilBrown (7):
      md: fix another deadlock with removing sysfs attributes.
      md/raid1: really fix recovery looping when single good device fails.
      sunrpc: prevent use-after-free on clearing XPT_BUSY
      md: fix bug with re-adding of partially recovered device.
      md: fix regression with re-adding devices to arrays with no metadata
      nfsd: correctly handle return value from nfsd_map_name_to_*
      md: correctly handle probe of an 'mdp' device.

Nelson Elhage (4):
      do_exit(): make sure that we run with get_fs() == USER_DS
      econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.
      inet_diag: Make sure we actually run the same bytecode we audited.
      netlink: Make nlmsg_find_attr take a const nlmsghdr*.

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolas Ferre (1):
      AT91: change dma resource index

Nicolas Kaiser (1):
      pipe: fix failure to return error code on ->confirm()

Nicolaus Colberg (1):
      USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Nikanth Karthikesan (1):
      ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate

Nobuhiro Iwamatsu (1):
      i2c-pca-platform: Change device name of request_irq

Olaf Hering (1):
      Input: xen-kbdfront - advertise either absolute or relative coordinates

Oleg Nesterov (8):
      sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code
      sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
      sched: move_task_off_dead_cpu(): Remove retry logic
      sched: sched_exec(): Remove the select_fallback_rq() logic
      sched: _cpu_down(): Don't play with current->cpus_allowed
      sched: Make select_fallback_rq() cpuset friendly
      exec: make argv/envp memory visible to oom-killer
      posix-cpu-timers: workaround to suppress the problems with mt exec

Oliver Hartkopp (1):
      can-bcm: fix minor heap overflow

Patrick Simmons (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)

Paul E. McKenney (3):
      pid: make setpgid() system call use RCU read-side critical section
      sched: suppress RCU lockdep splat in task_fork_fair
      powerpc: Fix default_machine_crash_shutdown #ifdef botch

Paul Fertser (1):
      b44: fix carrier detection on bind

Paul Fox (2):
      x86, olpc: Don't retry EC commands forever
      rtc-cmos: fix suspend/resume

Paul Gortmaker (3):
      Linux 2.6.34.8
      Linux 2.6.34.9
      Linux 2.6.34.10

Paul Mackerras (1):
      powerpc/perf: Fix sampling enable for PPC970

Paul Zimmerman (4):
      xhci: Avoid BUG() in interrupt context
      xhci: Clarify some expressions in the TRB math
      xhci: Fix errors in the running total calculations in the TRB math
      xhci: Fix an error in count_sg_trbs_needed()

Pavel Machek (1):
      serial: unbreak billionton CF card

Pavel Shilovsky (1):
      CIFS: Fix oplock break handling (try #2)

Pekka Enberg (1):
      perf_events: Fix perf_counter_mmap() hook in mprotect()

Peter Holik (1):
      USB: uss720 fixup refcount position

Peter Jones (1):
      efifb: check that the base address is plausible on pci systems

Peter Oberparleiter (2):
      gcov: fix null-pointer dereference for certain module types
      dasd: use correct label location for diag fba disks

Peter Zijlstra (9):
      x86, tsc: Fix a preemption leak in restore_sched_clock_state()
      sched: Fix TASK_WAKING vs fork deadlock
      sched: Optimize task_rq_lock()
      sched: Fix nr_uninterruptible count
      sched: Fix rq->clock synchronization when migrating tasks
      sched: Pre-compute cpumask_weight(sched_domain_span(sd))
      sched: fix RCU lockdep splat from task_group()
      sched, cgroup: Fixup broken cgroup movement
      sched: Fix wake_affine() vs RT tasks

Petr Tesarik (1):
      Optimize ticket spinlocks in fsys_rt_sigprocmask

Phil Blundell (3):
      econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
      econet: fix CVE-2010-3850
      econet: fix CVE-2010-3848

Philipp Reisner (1):
      drbd: Initialize all members of sync_conf to their defaults [Bugz 315]

Philippe Corbes (1):
      USB: cdc-acm: Add pseudo modem without AT command capabilities

Philippe Rétornaz (1):
      tty_ldisc: Fix BUG() on hangup

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Przemo Firszt (1):
      USB: Expose vendor-specific ACM channel on Nokia 5230

Przemyslaw Bruski (3):
      ALSA: ctxfi - Fix incorrect SPDIF status bit mask
      ALSA: ctxfi - Fix SPDIF status retrieval
      ALSA: ctxfi - Clear input settings before initialization

Rainer Keller (1):
      USB: add PID for FTDI based OpenDCC hardware

Rajiv Andrade (1):
      TPM: Long default timeout fix

Randy Dunlap (1):
      PCI: sysfs: fix printk warnings

Raymond Yau (1):
      ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Rich Mattes (1):
      USB: ftdi_sio: Add PID for accesio products

Richard A. Smith (1):
      olpc_battery: Fix endian neutral breakage for s16 values

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure

Richard Weinberger (2):
      um: remove PAGE_SIZE alignment in linker script causing kernel segfault.
      um: fix global timer issue when using CONFIG_NO_HZ

Robert Richter (3):
      oprofile: fix crash when accessing freed task structs
      oprofile, x86: fix init_sysfs error handling
      oprofile, x86: fix init_sysfs() function stub

Robin Holt (2):
      sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down
      epoll: convert max_user_watches to long

Robin@sgi.com (1):
      sgi-xpc: XPC fails to discover partitions with all nasids above 128

Roland Dreier (1):
      Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo

Roland McGrath (4):
      x86-64, compat: Retruncate rax after ia32 syscall entry tracing
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments

Roman Fietze (1):
      i2c: Fix typo in instantiating-devices document

Ruben Smits (1):
      staging: comedi: add support for newer jr3 1-channel pci board

Russell King (1):
      ARM: Ensure predictable endian state on signal handler entry

Ryan Kuester (1):
      mptsas: fix hangs caused by ATA pass-through

Saeed Bishara (1):
      mv_xor: fix race in tasklet function

Salman Qazi (1):
      hrtimer: Preserve timer state in remove_hrtimer()

Samuel Ortiz (2):
      irda: Fix parameter extraction stack overflow
      irda: Fix heap memory corruption in iriap.c

Sarah Sharp (2):
      usb: Realloc xHCI structures after a hub is verified.
      xhci: Fix cycle bit calculation during stall handling.

Sean Hefty (2):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback

Sebastien Bourdeauducq (1):
      USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial

Senthil Balasubramanian (1):
      ath9k_hw: Fix incorrect macversion and macrev checks

Sergei Shtylyov (2):
      usb: musb: gadget: restart request on clearing endpoint halt
      usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()

Sergey Vlasov (1):
      NFS: Fix fcntl F_GETLK not reporting some conflicts

Seth Heasley (3):
      ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing

Stanislaw Gruszka (7):
      sched: Fix user time incorrectly accounted as system time on 32-bit
      skge: add quirk to limit DMA
      r8169: allocate with GFP_KERNEL flag when able to sleep
      iwlagn: enable only rfkill interrupt when device is down
      hostap_cs: fix sleeping function called from invalid context
      PM / Hibernate: Return error code when alloc_image_page() fails
      r8169: disable ASPM

Stefan Bader (1):
      mm: Move vma_stack_continue into mm.h

Stefan Nilsson XK (1):
      mmc: sdio: remember new card RCA when redetecting card

Stephan Lachowsky (1):
      uvcvideo: Fix uvc_fixup_video_ctrl() format search

Steve Wise (1):
      RDMA/cxgb3: Turn off RX coalescing for iWARP connections

Steven J. Magnani (1):
      nommu: yield CPU while disposing VM

Steven Rostedt (4):
      tracing: Do not allow llseek to set_ftrace_filter
      tracing/x86: Don't use mcount in kvmclock.c
      ring-buffer: Fix typo of time extends per page
      ftrace: Fix memory leak with function graph and cpu hotplug

Stuart Hayes (1):
      dcdbas: force SMI to happen when expected

Sunil Mushran (1):
      ocfs2: Fix incorrect checksum validation error

Suresh Siddha (8):
      x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states
      sched: Fix select_idle_sibling() logic in select_task_rq_fair()
      x86, intr-remap: Set redirection hint in the IRTE
      x86, vt-d: Handle previous faults after enabling fault handling
      x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
      x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm
      sched: Move sched_avg_update() to update_cpu_load()

Sven Neumann (1):
      ds2760_battery: Fix calculation of time_to_empty_now

Takashi Iwai (6):
      ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
      ALSA: hda - Handle missing NID 0x1b on ALC259 codec
      ALSA: hda - Handle pin NID 0x1a on ALC259/269
      PM / Hibernate: Fix PM_POST_* notification with user-space suspend
      ALSA: caiaq - Fix possible string-buffer overflow
      ALSA: hda - Fix memory leaks in conexant jack arrays

Tavis Ormandy (1):
      install_special_mapping skips security_file_mmap check.

Tejun Heo (8):
      libata: skip EH autopsy and recovery during suspend
      percpu: fix pcpu_last_unit_cpu
      ubd: fix incorrect sector handling during request restart
      libata: fix NULL sdev dereference race in atapi_qc_complete()
      PCI: pci-stub: ignore zero-length id parameters
      ptrace: use safer wake up on ptrace_detach()
      pata_mpc52xx: inherit from ata_bmdma_port_ops
      libata: no special completion processing for EH commands

Tetsuo Handa (4):
      UNIX: Do not loop forever at unix_autobind().
      CRED: Fix kernel panic upon security_file_alloc() failure.
      CRED: Fix BUG() upon security_cred_alloc_blank() failure
      CRED: Fix memory and refcount leaks upon security_prepare_creds() failure

Theodore Ts'o (2):
      ext4: Avoid crashing on NULL ptr dereference on a filesystem error
      ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted

Thomas Backlund (1):
      microblaze: Fix build with make 3.82

Thomas Gleixner (6):
      x86, hpet: Fix bogus error check in hpet_assign_irq()
      x86, irq: Plug memory leak in sparse irq
      isdn: hisax: Replace the bogus access to irq stats
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
      clockevents: Prevent oneshot mode when broadcast device is periodic
      fix per-cpu flag problem in the cpu affinity checkers

Thomas Sailer (1):
      USB: misc: uss720.c: add another vendor/product ID

Thomas Taranowski (1):
      rapidio: fix hang on RapidIO doorbell queue full condition

Tilman Schmidt (1):
      isdn: avoid calling tty_ldisc_flush() in atomic context

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Timo Warns (4):
      fs/partitions: Validate map_count in Mac partition tables
      ldm: corrupted partition table can cause kernel oops
      fs/partitions/ldm.c: fix oops caused by corrupted partition table
      Fix for buffer overflow in ldm_frag_add not sufficient

Toby Gray (2):
      USB: cdc-acm: Adding second ACM channel support for various Nokia and one Samsung phones
      USB: cdc-acm: Fixing crash when ACM probing interfaces with no endpoint descriptors.

Tom Marshall (1):
      tcp: Fix race in tcp_poll

Tony Luck (2):
      fix siglock
      guard page for stacks that grow upwards

Tristan Ye (1):
      Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.

Trond Myklebust (4):
      NFS: Fix a typo in nfs_sockaddr_match_ipaddr6
      SUNRPC: Fix race corrupting rpc upcall
      SUNRPC: Ensure we always run the tk_callback before tk_action
      SUNRPC: Never reuse the socket port after an xs_close()

Tyler Hicks (2):
      eCryptfs: Clear LOOKUP_OPEN flag when creating lower file
      eCryptfs: Copy up lower inode attrs in getattr

Ulrich Weber (1):
      xfrm4: strip ECN bits from tos field

Uwe Kleine-König (1):
      backlight: grab ops_lock before testing bd->ops

Vasanthakumar Thiagarajan (1):
      ath9k: Fix bug in delimiter padding computation

Vasiliy Kulikov (21):
      pcmcia: synclink_cs: fix information leak to userland
      ipc: shm: fix information leak to userland
      KVM: x86: fix information leak to userland
      usb: misc: sisusbvga: fix information leak to userland
      usb: misc: iowarrior: fix information leak to userland
      usb: core: fix information leak to userland
      net: packet: fix information leak to userland
      net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules
      platform: x86: acer-wmi: world-writable sysfs threeg file
      platform: x86: asus_acpi: world-writable procfs files
      platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
      agp: fix arbitrary kernel memory writes
      agp: fix OOM and buffer overflow
      net: ax25: fix information leak to userland
      Bluetooth: sco: fix information leak to userspace
      Bluetooth: bnep: fix buffer overflow
      bridge: netfilter: fix information leak
      netfilter: arp_tables: fix infoleak to userspace
      netfilter: ip_tables: fix infoleak to userspace
      ipv6: netfilter: ip6_tables: fix infoleak to userspace
      econet: 4 byte infoleak to the network

Vitaliy Kulikov (1):
      ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs

Vitaly Kuznetsov (1):
      USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

Vivien Didelot (1):
      hwmon: (sht15) Fix integer overflow in humidity calculation

Vlad Yasevich (1):
      sctp: Do not reset the packet during sctp_packet_config().

Wei Yongjun (1):
      sctp: fix append error cause to ERROR chunk correctly

Will Deacon (1):
      ARM: 6489/1: thumb2: fix incorrect optimisation in usracc

Will Newton (1):
      uml: disable winch irq before freeing handler data

Xiao Guangrong (2):
      KVM: MMU: fix direct sp's access corrupted
      KVM: MMU: fix conflict access permissions in direct sp

Xiaotian Feng (1):
      block: check for proper length of iov entries earlier in blk_rq_map_user_iov()

Yegor Yefremov (1):
      i2c-pca: Fix waitforcompletion() return value

Yusuke Goda (1):
      tmio_mmc: don't clear unhandled pending interrupts

Zachary Amsden (2):
      KVM: x86: Fix SVM VMCB reset
      KVM: x86: Move TSC reset out of vmcb_init

Zhang Rui (2):
      ACPI: Disable Windows Vista compatibility for Toshiba P305D
      acpi-cpufreq: fix a memleak when unloading driver

andrew hendry (1):
      memory corruption in X.25 facilities parsing

dann frazier (1):
      ocfs2_connection_find() returns pointer to bad structure

ma rui (1):
      USB: option: fix when the driver is loaded incorrectly for some Huawei devices.

roel (1):
      nfsd: wrong index used in inner loop

stephen hemminger (1):
      ip6ip6: autoload ip6 tunnel

wangyanqing (1):
      USB: serial: ch341: add new id

 Documentation/i2c/instantiating-devices         |    2 +-
 Documentation/kernel-parameters.txt             |    1 +
 MAINTAINERS                                     |    6 +
 Makefile                                        |    2 +-
 arch/alpha/kernel/err_marvel.c                  |    6 +-
 arch/arm/include/asm/assembler.h                |    2 +-
 arch/arm/kernel/entry-common.S                  |    2 +
 arch/arm/kernel/signal.c                        |    4 +-
 arch/arm/lib/findbit.S                          |    6 +-
 arch/arm/mach-at91/at91sam9g45_devices.c        |    2 +-
 arch/ia64/include/asm/compat.h                  |    2 +-
 arch/ia64/kernel/fsys.S                         |   30 ++-
 arch/ia64/kernel/msi_ia64.c                     |    2 +-
 arch/ia64/sn/kernel/msi_sn.c                    |    2 +-
 arch/microblaze/Makefile                        |    8 +-
 arch/mips/alchemy/mtx-1/platform.c              |    9 +
 arch/mips/include/asm/atomic.h                  |   24 +-
 arch/mips/include/asm/compat.h                  |    2 +-
 arch/mips/kernel/ptrace.c                       |    4 +-
 arch/mips/mti-malta/malta-pci.c                 |    2 +
 arch/mips/nxp/pnx8550/common/pci.c              |    1 +
 arch/mips/nxp/pnx8550/common/setup.c            |    2 +-
 arch/mips/pci/ops-pmcmsp.c                      |    1 +
 arch/mips/pci/pci-yosemite.c                    |    1 +
 arch/parisc/include/asm/compat.h                |    2 +-
 arch/parisc/kernel/firmware.c                   |   13 +-
 arch/parisc/kernel/irq.c                        |    2 +-
 arch/powerpc/include/asm/compat.h               |    2 +-
 arch/powerpc/include/asm/hvcall.h               |    1 +
 arch/powerpc/include/asm/kexec.h                |    4 +
 arch/powerpc/include/asm/paca.h                 |    1 +
 arch/powerpc/include/asm/reg.h                  |    1 +
 arch/powerpc/kernel/asm-offsets.c               |    1 +
 arch/powerpc/kernel/cpu_setup_6xx.S             |   40 ++--
 arch/powerpc/kernel/crash.c                     |   42 +++-
 arch/powerpc/kernel/head_64.S                   |   18 +-
 arch/powerpc/kernel/machine_kexec_64.c          |   73 +++++-
 arch/powerpc/kernel/misc_64.S                   |    8 +-
 arch/powerpc/kernel/paca.c                      |    2 +
 arch/powerpc/kernel/perf_event.c                |   24 ++-
 arch/powerpc/kernel/ppc970-pmu.c                |    2 +
 arch/powerpc/kernel/rtas_flash.c                |   39 ++--
 arch/powerpc/kernel/setup_64.c                  |   17 +-
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++
 arch/powerpc/platforms/pseries/lpar.c           |   33 ++-
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 ++
 arch/powerpc/sysdev/fsl_rio.c                   |    1 -
 arch/s390/include/asm/compat.h                  |    2 +-
 arch/s390/include/asm/processor.h               |    5 -
 arch/s390/kernel/nmi.c                          |   10 +-
 arch/s390/kernel/traps.c                        |   37 ---
 arch/s390/lib/delay.c                           |   14 +-
 arch/sparc/include/asm/compat.h                 |    2 +-
 arch/sparc/include/asm/oplib_64.h               |   27 +--
 arch/sparc/kernel/signal32.c                    |  161 +++++++-----
 arch/sparc/kernel/signal_32.c                   |   55 +++--
 arch/sparc/kernel/signal_64.c                   |   45 ++--
 arch/sparc/prom/cif.S                           |   16 +-
 arch/sparc/prom/console_64.c                    |   48 +++-
 arch/sparc/prom/devops_64.c                     |   36 +++-
 arch/sparc/prom/misc_64.c                       |  314 ++++++++++++++++-------
 arch/sparc/prom/p1275.c                         |  102 +-------
 arch/sparc/prom/tree_64.c                       |  210 +++++++++++----
 arch/um/drivers/line.c                          |    5 +-
 arch/um/drivers/ubd_kern.c                      |    9 +-
 arch/um/kernel/uml.lds.S                        |    2 +-
 arch/um/os-Linux/time.c                         |    2 +-
 arch/x86/ia32/ia32entry.S                       |   22 +-
 arch/x86/include/asm/acpi.h                     |    1 +
 arch/x86/include/asm/amd_iommu_proto.h          |    6 +
 arch/x86/include/asm/amd_iommu_types.h          |   12 +
 arch/x86/include/asm/compat.h                   |    2 +-
 arch/x86/include/asm/cpufeature.h               |    2 +-
 arch/x86/include/asm/io.h                       |    1 +
 arch/x86/include/asm/kvm_host.h                 |   24 --
 arch/x86/include/asm/mmu_context.h              |    5 +-
 arch/x86/include/asm/mwait.h                    |   15 +
 arch/x86/include/asm/pgtable-3level.h           |   11 +-
 arch/x86/include/asm/pgtable_32.h               |    1 +
 arch/x86/include/asm/processor.h                |   23 --
 arch/x86/include/asm/pvclock.h                  |    1 +
 arch/x86/include/asm/smp.h                      |    9 +-
 arch/x86/include/asm/smpboot_hooks.h            |    2 +-
 arch/x86/include/asm/trampoline.h               |    5 +-
 arch/x86/include/asm/tsc.h                      |    2 +
 arch/x86/kernel/Makefile                        |    2 +
 arch/x86/kernel/acpi/boot.c                     |   14 +-
 arch/x86/kernel/acpi/cstate.c                   |   11 +-
 arch/x86/kernel/amd_iommu.c                     |    4 +-
 arch/x86/kernel/amd_iommu_init.c                |   67 ++++--
 arch/x86/kernel/apic/apic.c                     |    8 +
 arch/x86/kernel/apic/io_apic.c                  |   16 +-
 arch/x86/kernel/apic/probe_64.c                 |    7 -
 arch/x86/kernel/apic/x2apic_uv_x.c              |    9 +-
 arch/x86/kernel/cpu/common.c                    |    4 +-
 arch/x86/kernel/cpu/cpu.h                       |    1 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c      |    1 +
 arch/x86/kernel/cpu/intel.c                     |    1 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c            |    9 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c              |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c                 |   10 +-
 arch/x86/kernel/crash_dump_64.c                 |    3 +-
 arch/x86/kernel/e820.c                          |   10 +-
 arch/x86/kernel/early-quirks.c                  |   21 +-
 arch/x86/kernel/entry_64.S                      |    2 +-
 arch/x86/kernel/head_32.S                       |    8 +-
 arch/x86/kernel/hpet.c                          |    2 +-
 arch/x86/kernel/olpc.c                          |    5 +-
 arch/x86/kernel/pvclock.c                       |    5 +
 arch/x86/kernel/reboot.c                        |    2 +-
 arch/x86/kernel/setup.c                         |    2 +
 arch/x86/kernel/smp.c                           |   15 +-
 arch/x86/kernel/smpboot.c                       |  112 +++++++--
 arch/x86/kernel/trampoline.c                    |   17 ++
 arch/x86/kernel/tsc.c                           |   38 +++
 arch/x86/kvm/paging_tmpl.h                      |   30 ++-
 arch/x86/kvm/svm.c                              |   17 +-
 arch/x86/kvm/vmx.c                              |   41 ++--
 arch/x86/kvm/x86.c                              |    7 +-
 arch/x86/mm/fault.c                             |    7 +
 arch/x86/mm/pgtable.c                           |    3 +-
 arch/x86/oprofile/nmi_int.c                     |   27 ++-
 arch/x86/power/cpu.c                            |    2 +
 arch/x86/vdso/Makefile                          |    4 +-
 arch/x86/xen/enlighten.c                        |    4 -
 arch/x86/xen/smp.c                              |    6 +-
 arch/x86/xen/time.c                             |    2 +
 block/blk-map.c                                 |    3 +
 block/blk-merge.c                               |    6 +-
 block/blk-settings.c                            |   27 +--
 block/blk-sysfs.c                               |    2 +-
 block/bsg.c                                     |    2 +-
 block/scsi_ioctl.c                              |   34 ++-
 crypto/Kconfig                                  |    8 +
 crypto/algboss.c                                |    4 +
 crypto/testmgr.c                                |   14 +
 drivers/acpi/acpi_pad.c                         |    7 +-
 drivers/acpi/acpica/aclocal.h                   |    1 +
 drivers/acpi/acpica/dswexec.c                   |   19 ++-
 drivers/acpi/blacklist.c                        |   16 ++
 drivers/acpi/debug.c                            |    2 +-
 drivers/acpi/ec.c                               |    3 +
 drivers/acpi/processor_core.c                   |    6 -
 drivers/ata/ahci.c                              |    5 +
 drivers/ata/libata-core.c                       |   38 ++-
 drivers/ata/libata-eh.c                         |    4 +
 drivers/ata/libata-scsi.c                       |    5 +-
 drivers/ata/pata_mpc52xx.c                      |    2 +-
 drivers/ata/sata_mv.c                           |   44 +++-
 drivers/block/drbd/drbd_main.c                  |   17 +-
 drivers/block/pktcdvd.c                         |    2 +-
 drivers/bluetooth/hci_ldisc.c                   |    7 +
 drivers/char/agp/generic.c                      |   19 +-
 drivers/char/agp/sis-agp.c                      |    8 -
 drivers/char/hpet.c                             |   17 ++
 drivers/char/mem.c                              |    3 +-
 drivers/char/pcmcia/synclink_cs.c               |    2 +
 drivers/char/tpm/tpm.c                          |   10 +-
 drivers/char/tty_buffer.c                       |   14 +-
 drivers/char/tty_io.c                           |    3 +-
 drivers/char/tty_ldisc.c                        |   51 ++++-
 drivers/char/vt_ioctl.c                         |   11 +-
 drivers/crypto/padlock-aes.c                    |    2 +-
 drivers/dma/ioat/dma.h                          |    1 +
 drivers/dma/ioat/dma_v2.c                       |   24 ++-
 drivers/dma/ioat/dma_v3.c                       |    5 +-
 drivers/dma/mv_xor.c                            |    4 +-
 drivers/edac/amd64_edac.c                       |    2 +-
 drivers/firewire/ohci.c                         |   60 ++++-
 drivers/firmware/dcdbas.c                       |    4 +-
 drivers/gpu/drm/Kconfig                         |    3 +
 drivers/gpu/drm/drm_crtc.c                      |   10 +-
 drivers/gpu/drm/drm_crtc_helper.c               |    4 +-
 drivers/gpu/drm/drm_irq.c                       |    3 +-
 drivers/gpu/drm/i915/i915_dma.c                 |   12 +-
 drivers/gpu/drm/i915/i915_gem.c                 |    1 +
 drivers/gpu/drm/i915/intel_display.c            |  149 +++++++----
 drivers/gpu/drm/i915/intel_drv.h                |    8 +-
 drivers/gpu/drm/i915/intel_lvds.c               |    8 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |   16 +-
 drivers/gpu/drm/radeon/radeon_display.c         |    4 +
 drivers/gpu/drm/radeon/radeon_object.c          |   27 ++-
 drivers/gpu/drm/radeon/rs690.c                  |   27 +--
 drivers/gpu/drm/radeon/rv515.c                  |   23 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c               |    1 +
 drivers/hid/hidraw.c                            |   27 ++-
 drivers/hwmon/adm1026.c                         |   20 +-
 drivers/hwmon/f71882fg.c                        |    2 +-
 drivers/hwmon/f75375s.c                         |    6 +-
 drivers/hwmon/k8temp.c                          |   35 +++-
 drivers/hwmon/lm85.c                            |    1 +
 drivers/hwmon/sht15.c                           |    4 +-
 drivers/hwmon/via686a.c                         |   14 +-
 drivers/hwmon/w83627ehf.c                       |   13 +-
 drivers/i2c/busses/i2c-pca-isa.c                |   12 +-
 drivers/i2c/busses/i2c-pca-platform.c           |   13 +-
 drivers/i2c/i2c-core.c                          |   14 +-
 drivers/infiniband/core/cm.c                    |    1 +
 drivers/infiniband/core/cma.c                   |   15 +
 drivers/infiniband/core/uverbs_cmd.c            |   99 ++++---
 drivers/infiniband/hw/cxgb3/iwch_cm.c           |    6 +-
 drivers/input/joydev.c                          |    3 +
 drivers/input/mouse/bcm5974.c                   |   40 +++
 drivers/input/serio/i8042-x86ia64io.h           |   28 ++
 drivers/input/serio/i8042.c                     |    8 +-
 drivers/input/xen-kbdfront.c                    |   36 ++-
 drivers/isdn/hisax/config.c                     |   18 +-
 drivers/isdn/hisax/hisax.h                      |    1 +
 drivers/isdn/i4l/isdn_tty.c                     |    6 -
 drivers/md/dm-mpath.c                           |   12 -
 drivers/md/dm-table.c                           |    5 -
 drivers/md/dm.c                                 |    5 +-
 drivers/md/md.c                                 |   53 +++--
 drivers/md/md.h                                 |    4 +
 drivers/md/raid1.c                              |    1 +
 drivers/media/dvb/ttpci/av7110_ca.c             |    2 +-
 drivers/media/radio/radio-aimslab.c             |   24 +--
 drivers/media/video/cx231xx/cx231xx-cards.c     |   14 +-
 drivers/media/video/em28xx/em28xx-cards.c       |    4 +-
 drivers/media/video/ivtv/ivtvfb.c               |    2 +
 drivers/media/video/uvc/uvc_video.c             |   14 +-
 drivers/media/video/v4l2-compat-ioctl32.c       |   32 ++-
 drivers/message/fusion/mptctl.c                 |    8 +
 drivers/message/fusion/mptscsih.c               |    9 +-
 drivers/mfd/ucb1x00-ts.c                        |   12 +-
 drivers/misc/sgi-xp/xpc_partition.c             |   25 +-
 drivers/misc/sgi-xp/xpc_uv.c                    |   17 ++
 drivers/mmc/core/sdio.c                         |    8 +
 drivers/mmc/host/sdhci-s3c.c                    |    6 +-
 drivers/mmc/host/tmio_mmc.c                     |    7 +-
 drivers/mmc/host/tmio_mmc.h                     |   13 +-
 drivers/mtd/nand/omap2.c                        |    2 +-
 drivers/mtd/onenand/generic.c                   |    2 +-
 drivers/mtd/onenand/omap2.c                     |    2 +-
 drivers/net/atlx/atl1.c                         |    5 +-
 drivers/net/b44.c                               |    4 +-
 drivers/net/benet/be_cmds.c                     |    2 +-
 drivers/net/bonding/bond_3ad.c                  |    3 +
 drivers/net/bonding/bond_alb.c                  |    3 +
 drivers/net/bonding/bond_ipv6.c                 |    9 +-
 drivers/net/bonding/bonding.h                   |    4 +-
 drivers/net/cxgb3/cxgb3_main.c                  |    2 +
 drivers/net/e100.c                              |    2 +
 drivers/net/e1000/e1000_main.c                  |    3 +
 drivers/net/e1000e/netdev.c                     |    7 +-
 drivers/net/eql.c                               |    2 +
 drivers/net/gianfar.c                           |    6 +-
 drivers/net/ifb.c                               |    2 +
 drivers/net/igb/igb_main.c                      |    2 +
 drivers/net/igbvf/netdev.c                      |    2 +
 drivers/net/ixgb/ixgb_main.c                    |    2 +
 drivers/net/ixgbe/ixgbe_main.c                  |   12 +-
 drivers/net/ixgbevf/ixgbevf_main.c              |    2 +
 drivers/net/jme.c                               |   22 ++-
 drivers/net/netxen/netxen_nic_init.c            |    3 -
 drivers/net/niu.c                               |   16 +-
 drivers/net/r8169.c                             |   24 ++-
 drivers/net/skge.c                              |   18 ++-
 drivers/net/tun.c                               |    3 +-
 drivers/net/usb/hso.c                           |    2 +
 drivers/net/wireless/ath/ath5k/base.c           |   11 +-
 drivers/net/wireless/ath/ath9k/ath9k.h          |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom.h         |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c      |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c    |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c     |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c             |    4 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |   10 +-
 drivers/net/wireless/ath/regd.h                 |    1 -
 drivers/net/wireless/hostap/hostap_cs.c         |   15 +-
 drivers/net/wireless/hostap/hostap_pci.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c          |   15 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h      |    6 +
 drivers/net/wireless/orinoco/main.c             |    6 +
 drivers/net/wireless/orinoco/wext.c             |    4 +-
 drivers/net/wireless/p54/eeprom.c               |    4 +-
 drivers/net/wireless/p54/p54pci.c               |   14 +-
 drivers/net/wireless/p54/p54usb.c               |   22 ++-
 drivers/net/wireless/p54/txrx.c                 |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 +
 drivers/oprofile/buffer_sync.c                  |   27 +-
 drivers/oprofile/cpu_buffer.c                   |    2 -
 drivers/pci/dmar.c                              |    5 +
 drivers/pci/intel-iommu.c                       |  117 +++++----
 drivers/pci/msi.c                               |   27 ++-
 drivers/pci/pci-stub.c                          |    3 +
 drivers/pci/pci-sysfs.c                         |   32 ++-
 drivers/pci/pci.h                               |    7 +-
 drivers/pci/proc.c                              |    2 +-
 drivers/pci/quirks.c                            |  156 +++++++-----
 drivers/platform/x86/acer-wmi.c                 |    4 +-
 drivers/platform/x86/asus_acpi.c                |    8 +-
 drivers/platform/x86/tc1100-wmi.c               |    2 +-
 drivers/power/apm_power.c                       |    1 +
 drivers/power/ds2760_battery.c                  |    2 +-
 drivers/power/olpc_battery.c                    |    8 +-
 drivers/rtc/rtc-cmos.c                          |   16 +-
 drivers/s390/char/keyboard.c                    |    3 +-
 drivers/scsi/bfa/bfa_core.c                     |   22 ++
 drivers/scsi/gdth.c                             |    8 +
 drivers/scsi/libsas/sas_ata.c                   |    1 +
 drivers/scsi/libsas/sas_scsi_host.c             |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c             |   19 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c              |   23 ++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c            |    3 -
 drivers/scsi/scsi_lib.c                         |    6 +-
 drivers/scsi/scsi_sysfs.c                       |    3 +-
 drivers/scsi/sd.c                               |   24 ++-
 drivers/serial/8250.c                           |    3 +-
 drivers/serial/8250_pci.c                       |   13 +
 drivers/ssb/b43_pci_bridge.c                    |    1 +
 drivers/staging/asus_oled/asus_oled.c           |    8 +-
 drivers/staging/comedi/drivers/jr3_pci.c        |    7 +
 drivers/staging/comedi/drivers/ni_labpc.c       |    3 +-
 drivers/staging/frontier/tranzport.c            |    2 +-
 drivers/staging/hv/RingBuffer.c                 |    3 +-
 drivers/staging/hv/StorVscApi.h                 |    4 +-
 drivers/staging/hv/blkvsc_drv.c                 |    1 +
 drivers/staging/hv/netvsc_drv.c                 |    4 +
 drivers/staging/hv/storvsc_drv.c                |    9 +-
 drivers/staging/line6/control.c                 |  204 ++++++++--------
 drivers/staging/line6/midi.c                    |    4 +-
 drivers/staging/line6/pod.c                     |   32 ++--
 drivers/staging/line6/toneport.c                |    4 +-
 drivers/staging/line6/variax.c                  |   12 +-
 drivers/staging/rtl8187se/r8185b_init.c         |   30 ++-
 drivers/staging/usbip/usbip_event.c             |   16 +-
 drivers/staging/usbip/vhci.h                    |    6 +-
 drivers/staging/usbip/vhci_hcd.c                |   72 ++++--
 drivers/staging/usbip/vhci_rx.c                 |   15 +-
 drivers/staging/vt6655/wpactl.c                 |   11 +-
 drivers/usb/atm/ueagle-atm.c                    |    6 +-
 drivers/usb/class/cdc-acm.c                     |   32 +++-
 drivers/usb/core/devio.c                        |    7 +-
 drivers/usb/core/file.c                         |   35 ++--
 drivers/usb/core/hcd-pci.c                      |    4 +-
 drivers/usb/core/hub.c                          |   35 +++-
 drivers/usb/core/message.c                      |   15 +-
 drivers/usb/core/quirks.c                       |    8 +
 drivers/usb/gadget/atmel_usba_udc.c             |    3 +
 drivers/usb/gadget/dummy_hcd.c                  |    1 +
 drivers/usb/gadget/printer.c                    |   14 +-
 drivers/usb/gadget/rndis.c                      |   10 +-
 drivers/usb/host/ehci-hcd.c                     |   37 ++-
 drivers/usb/host/ehci-pci.c                     |   39 +++
 drivers/usb/host/ehci-ppc-of.c                  |   12 +-
 drivers/usb/host/ehci-q.c                       |   12 -
 drivers/usb/host/ehci-sched.c                   |   79 ++++++
 drivers/usb/host/ehci.h                         |    1 +
 drivers/usb/host/ohci-hcd.c                     |    9 +-
 drivers/usb/host/ohci-pci.c                     |   26 ++
 drivers/usb/host/ohci.h                         |    1 +
 drivers/usb/host/pci-quirks.c                   |   18 +-
 drivers/usb/host/xhci-ring.c                    |   50 +++-
 drivers/usb/misc/cypress_cy7c63.c               |    6 +-
 drivers/usb/misc/iowarrior.c                    |    3 +-
 drivers/usb/misc/sisusbvga/sisusb.c             |    1 +
 drivers/usb/misc/trancevibrator.c               |    2 +-
 drivers/usb/misc/usbled.c                       |    2 +-
 drivers/usb/misc/usbsevseg.c                    |   10 +-
 drivers/usb/misc/uss720.c                       |   11 +-
 drivers/usb/musb/blackfin.c                     |    4 +-
 drivers/usb/musb/musb_core.c                    |    1 +
 drivers/usb/musb/musb_gadget.c                  |   22 ++-
 drivers/usb/musb/musb_gadget.h                  |    2 +
 drivers/usb/musb/musb_gadget_ep0.c              |    9 +
 drivers/usb/musb/omap2430.c                     |    1 +
 drivers/usb/serial/ch341.c                      |   11 +
 drivers/usb/serial/cp210x.c                     |   28 +--
 drivers/usb/serial/digi_acceleport.c            |   10 -
 drivers/usb/serial/ftdi_sio.c                   |   91 ++++++-
 drivers/usb/serial/ftdi_sio_ids.h               |   98 +++++++-
 drivers/usb/serial/generic.c                    |   20 ++
 drivers/usb/serial/io_edgeport.c                |    4 +-
 drivers/usb/serial/keyspan_pda.c                |   17 --
 drivers/usb/serial/kobil_sct.c                  |    2 +-
 drivers/usb/serial/mos7720.c                    |    3 +
 drivers/usb/serial/mos7840.c                    |   35 ++-
 drivers/usb/serial/opticon.c                    |    6 +-
 drivers/usb/serial/option.c                     |   48 +++-
 drivers/usb/serial/pl2303.c                     |   12 +
 drivers/usb/serial/pl2303.h                     |    1 +
 drivers/usb/serial/sierra.c                     |    3 +
 drivers/usb/serial/spcp8x5.c                    |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 +-
 drivers/usb/serial/visor.c                      |   12 +
 drivers/usb/storage/sierra_ms.c                 |    2 +-
 drivers/usb/storage/unusual_cypress.h           |    5 +
 drivers/usb/storage/unusual_devs.h              |   39 +++
 drivers/video/backlight/backlight.c             |   12 +-
 drivers/video/console/tileblit.c                |    2 +-
 drivers/video/efifb.c                           |  103 +++++++-
 drivers/video/sis/sis_main.c                    |    3 +
 drivers/video/via/accel.c                       |    7 +-
 drivers/video/via/ioctl.c                       |    2 +
 drivers/virtio/virtio_pci.c                     |   20 +--
 drivers/xen/events.c                            |   23 ++-
 fs/aio.c                                        |    3 +
 fs/binfmt_misc.c                                |    2 +-
 fs/bio.c                                        |   23 ++-
 fs/char_dev.c                                   |    4 +-
 fs/cifs/cifsproto.h                             |    2 +-
 fs/cifs/cifssmb.c                               |    4 +-
 fs/cifs/dns_resolve.c                           |    2 +-
 fs/cifs/dns_resolve.h                           |    2 +-
 fs/cifs/file.c                                  |   21 +-
 fs/dcache.c                                     |    3 +
 fs/ecryptfs/inode.c                             |    6 +
 fs/eventpoll.c                                  |  115 ++++++++-
 fs/exec.c                                       |   47 ++++-
 fs/ext2/namei.c                                 |    9 +-
 fs/ext3/namei.c                                 |    2 +-
 fs/ext3/super.c                                 |    7 +
 fs/ext4/dir.c                                   |    4 +-
 fs/ext4/ext4.h                                  |  129 ++++++++-
 fs/ext4/ext4_jbd2.h                             |    8 +-
 fs/ext4/extents.c                               |  140 +++++++---
 fs/ext4/file.c                                  |    2 +-
 fs/ext4/fsync.c                                 |   33 +++-
 fs/ext4/ialloc.c                                |   89 +++----
 fs/ext4/inode.c                                 |   88 ++++---
 fs/ext4/ioctl.c                                 |   25 ++-
 fs/ext4/mballoc.c                               |  108 ++++++---
 fs/ext4/migrate.c                               |    2 +-
 fs/ext4/move_extent.c                           |    4 +-
 fs/ext4/namei.c                                 |   12 +-
 fs/ext4/super.c                                 |   65 +++---
 fs/ext4/xattr.c                                 |    4 +-
 fs/file_table.c                                 |    2 +-
 fs/fuse/dev.c                                   |   16 +-
 fs/fuse/file.c                                  |  134 +++++++++-
 fs/fuse/fuse_i.h                                |    6 +-
 fs/namespace.c                                  |    2 +-
 fs/nfs/client.c                                 |    2 +-
 fs/nfs/direct.c                                 |   34 ++-
 fs/nfs/file.c                                   |    2 +
 fs/nfs/mount_clnt.c                             |    4 +-
 fs/nfsd/nfs3xdr.c                               |    6 +-
 fs/nfsd/nfs4proc.c                              |    4 +-
 fs/nfsd/nfs4xdr.c                               |   11 +-
 fs/nfsd/vfs.c                                   |    2 +-
 fs/nfsd/xdr4.h                                  |   21 +-
 fs/notify/inotify/inotify_fsnotify.c            |    3 +
 fs/notify/inotify/inotify_user.c                |    7 +-
 fs/ocfs2/inode.c                                |    6 +-
 fs/ocfs2/refcounttree.c                         |    7 +-
 fs/ocfs2/stack_user.c                           |    2 +-
 fs/ocfs2/symlink.c                              |    2 +-
 fs/partitions/ibm.c                             |   13 +-
 fs/partitions/ldm.c                             |   26 ++-
 fs/partitions/mac.c                             |   17 +-
 fs/pipe.c                                       |    2 +-
 fs/proc/array.c                                 |    9 +-
 fs/proc/task_mmu.c                              |    7 +-
 fs/super.c                                      |    6 +
 fs/sysfs/file.c                                 |    2 +-
 fs/xfs/linux-2.6/xfs_export.c                   |   11 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                    |   20 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c                  |   15 +-
 fs/xfs/quota/xfs_qm.c                           |   18 +-
 fs/xfs/quota/xfs_qm_syscalls.c                  |   27 +-
 fs/xfs/xfs_fsops.c                              |    3 +
 fs/xfs/xfs_ialloc.c                             |  146 ++++++-----
 fs/xfs/xfs_iget.c                               |   10 +-
 fs/xfs/xfs_inode.c                              |    5 +-
 fs/xfs/xfs_inode.h                              |    6 +-
 fs/xfs/xfs_itable.c                             |  285 +++------------------
 fs/xfs/xfs_itable.h                             |   17 --
 fs/xfs/xfs_log_recover.c                        |    2 +-
 fs/xfs/xfs_mount.c                              |    2 +-
 fs/xfs/xfs_rtalloc.c                            |    4 +-
 fs/xfs/xfs_trans_inode.c                        |    2 +-
 fs/xfs/xfs_vnodeops.c                           |    2 +-
 include/drm/drmP.h                              |    2 +-
 include/drm/drm_pciids.h                        |    3 +-
 include/keys/rxrpc-type.h                       |    1 -
 include/linux/binfmts.h                         |    1 +
 include/linux/blkdev.h                          |   13 +-
 include/linux/compat.h                          |    3 +
 include/linux/cpuset.h                          |   16 +-
 include/linux/cred.h                            |   21 +--
 include/linux/fs.h                              |    1 +
 include/linux/ftrace.h                          |    2 +
 include/linux/ieee80211.h                       |    2 +-
 include/linux/klist.h                           |    2 +-
 include/linux/libata.h                          |    1 +
 include/linux/mm.h                              |   14 +-
 include/linux/mmzone.h                          |   13 +
 include/linux/msi.h                             |    2 +
 include/linux/netdevice.h                       |    3 +
 include/linux/pci_ids.h                         |    4 +
 include/linux/sched.h                           |    9 +-
 include/linux/usb/serial.h                      |    3 +
 include/linux/vmstat.h                          |   22 ++
 include/net/af_unix.h                           |    2 +
 include/net/dn.h                                |    2 +-
 include/net/netlink.h                           |    2 +-
 include/net/sock.h                              |    9 +-
 include/net/tcp.h                               |   40 +++-
 include/net/udp.h                               |    5 +-
 init/Kconfig                                    |    3 +-
 init/calibrate.c                                |    6 +-
 ipc/compat.c                                    |    6 +
 ipc/compat_mq.c                                 |    5 +
 ipc/sem.c                                       |    2 +
 ipc/shm.c                                       |    1 +
 kernel/capability.c                             |    1 -
 kernel/compat.c                                 |   21 ++
 kernel/cpu.c                                    |   18 +-
 kernel/cpuset.c                                 |   74 ++++--
 kernel/cred-internals.h                         |   21 --
 kernel/cred.c                                   |   44 +++-
 kernel/exit.c                                   |   23 ++-
 kernel/futex.c                                  |   31 ++-
 kernel/gcov/fs.c                                |  244 +++++++++++++-----
 kernel/groups.c                                 |    5 +-
 kernel/hrtimer.c                                |   13 +-
 kernel/irq/manage.c                             |    2 +-
 kernel/latencytop.c                             |   17 +-
 kernel/power/snapshot.c                         |    7 +-
 kernel/power/user.c                             |    2 +-
 kernel/printk.c                                 |    2 +
 kernel/ptrace.c                                 |    2 +-
 kernel/sched.c                                  |  232 ++++++++---------
 kernel/sched_debug.c                            |    5 -
 kernel/sched_fair.c                             |  161 +++++++-----
 kernel/sched_idletask.c                         |    3 +-
 kernel/sched_rt.c                               |    5 +-
 kernel/signal.c                                 |   25 ++-
 kernel/smp.c                                    |   69 +++++-
 kernel/sys.c                                    |    2 +
 kernel/sysctl.c                                 |    2 +-
 kernel/sysctl_check.c                           |    9 -
 kernel/time/tick-broadcast.c                    |   10 +
 kernel/time/tick-common.c                       |    6 +-
 kernel/time/tick-internal.h                     |    3 +
 kernel/timer.c                                  |    6 +
 kernel/trace/ftrace.c                           |   71 +++++-
 kernel/trace/ring_buffer.c                      |    2 +-
 kernel/trace/trace.c                            |   10 +-
 kernel/user.c                                   |   12 +-
 lib/percpu_counter.c                            |    1 +
 mm/bounce.c                                     |    2 +-
 mm/filemap.c                                    |    3 +
 mm/internal.h                                   |    2 +-
 mm/memory.c                                     |   15 +-
 mm/memory_hotplug.c                             |   18 +-
 mm/mempolicy.c                                  |    2 +-
 mm/mlock.c                                      |    6 -
 mm/mmap.c                                       |   19 +-
 mm/mmzone.c                                     |   21 ++
 mm/mprotect.c                                   |    2 +-
 mm/mremap.c                                     |    4 +-
 mm/nommu.c                                      |    1 +
 mm/page_alloc.c                                 |   33 ++-
 mm/percpu.c                                     |    2 +-
 mm/vmalloc.c                                    |    9 +
 mm/vmstat.c                                     |   15 +-
 net/ax25/af_ax25.c                              |    2 +-
 net/bluetooth/bnep/sock.c                       |    1 +
 net/bluetooth/sco.c                             |    1 +
 net/bridge/br_netfilter.c                       |    9 +-
 net/bridge/netfilter/ebtables.c                 |    2 +
 net/can/bcm.c                                   |    4 +-
 net/compat.c                                    |   10 +-
 net/core/dev.c                                  |   18 +-
 net/core/ethtool.c                              |    6 +-
 net/core/filter.c                               |   83 +++---
 net/core/iovec.c                                |   17 +-
 net/core/skbuff.c                               |    6 +-
 net/core/sock.c                                 |   14 +-
 net/core/stream.c                               |    8 +-
 net/dccp/input.c                                |    7 +-
 net/decnet/af_decnet.c                          |    4 +-
 net/decnet/sysctl_net_decnet.c                  |    4 +-
 net/econet/af_econet.c                          |  101 ++++----
 net/ipv4/datagram.c                             |    5 +-
 net/ipv4/devinet.c                              |   30 ++-
 net/ipv4/inet_diag.c                            |   27 ++-
 net/ipv4/ip_gre.c                               |    1 +
 net/ipv4/ip_output.c                            |   28 ++-
 net/ipv4/ipip.c                                 |    1 +
 net/ipv4/netfilter/arp_tables.c                 |    3 +
 net/ipv4/netfilter/ip_tables.c                  |    3 +
 net/ipv4/proc.c                                 |    8 +-
 net/ipv4/route.c                                |    7 +-
 net/ipv4/sysctl_net_ipv4.c                      |    5 +-
 net/ipv4/tcp.c                                  |   47 ++--
 net/ipv4/tcp_input.c                            |   13 +-
 net/ipv4/tcp_ipv4.c                             |    8 +-
 net/ipv4/tcp_output.c                           |   15 +-
 net/ipv4/tcp_timer.c                            |    8 +-
 net/ipv4/udp.c                                  |   48 ++++-
 net/ipv4/xfrm4_policy.c                         |    2 +-
 net/ipv6/datagram.c                             |    7 +-
 net/ipv6/ip6_output.c                           |   18 +-
 net/ipv6/ip6_tunnel.c                           |    1 +
 net/ipv6/netfilter/ip6_tables.c                 |    3 +
 net/ipv6/route.c                                |   28 ++-
 net/ipv6/sit.c                                  |    2 +-
 net/ipv6/udp.c                                  |   10 +
 net/irda/af_irda.c                              |   20 +-
 net/irda/iriap.c                                |    3 +-
 net/irda/irlan/irlan_common.c                   |    2 +-
 net/irda/parameters.c                           |    4 +-
 net/llc/af_llc.c                                |    3 +-
 net/netfilter/nf_conntrack_core.c               |    3 +-
 net/netfilter/nf_log.c                          |    4 +
 net/packet/af_packet.c                          |    3 +-
 net/phonet/pep.c                                |    3 +-
 net/rds/page.c                                  |   27 +--
 net/rds/rdma.c                                  |   11 +-
 net/rds/recv.c                                  |    2 +-
 net/rose/af_rose.c                              |    4 +-
 net/sched/act_gact.c                            |   21 +-
 net/sched/act_mirred.c                          |   15 +-
 net/sched/act_nat.c                             |   35 +--
 net/sched/act_police.c                          |   21 +-
 net/sched/act_simple.c                          |   11 +-
 net/sched/act_skbedit.c                         |   11 +-
 net/sctp/auth.c                                 |    8 +-
 net/sctp/output.c                               |    1 -
 net/sctp/protocol.c                             |    2 +-
 net/sctp/sm_make_chunk.c                        |    4 +-
 net/sctp/socket.c                               |    4 +-
 net/sctp/sysctl.c                               |    4 +-
 net/socket.c                                    |    4 +
 net/sunrpc/auth_gss/auth_gss.c                  |    9 +-
 net/sunrpc/cache.c                              |    4 +-
 net/sunrpc/rpc_pipe.c                           |    6 +-
 net/sunrpc/sched.c                              |   14 +-
 net/sunrpc/svc_xprt.c                           |    9 +-
 net/sunrpc/xprtsock.c                           |    2 +
 net/tipc/socket.c                               |    1 +
 net/unix/af_unix.c                              |   52 ++++-
 net/unix/garbage.c                              |    9 +-
 net/wireless/wext-compat.c                      |    3 +
 net/wireless/wext-core.c                        |   16 ++
 net/wireless/wext-priv.c                        |    2 +-
 net/x25/x25_facilities.c                        |   20 +-
 net/x25/x25_in.c                                |    2 +
 net/x25/x25_link.c                              |    4 +
 security/integrity/ima/ima_policy.c             |    2 +
 security/keys/keyctl.c                          |    6 +-
 security/keys/process_keys.c                    |    6 +-
 security/selinux/hooks.c                        |   11 +-
 security/selinux/nlmsgtab.c                     |    2 +
 sound/core/control.c                            |    5 +
 sound/core/hrtimer.c                            |    5 +-
 sound/core/rawmidi.c                            |    4 +-
 sound/core/seq/oss/seq_oss_init.c               |    9 +-
 sound/oss/soundcard.c                           |    4 +-
 sound/pci/au88x0/au88x0_pcm.c                   |   24 ++-
 sound/pci/ctxfi/ctatc.c                         |    2 +-
 sound/pci/ctxfi/ctdaio.c                        |    2 +
 sound/pci/ctxfi/ctmixer.c                       |   19 +-
 sound/pci/hda/hda_eld.c                         |    2 +-
 sound/pci/hda/hda_intel.c                       |    2 +
 sound/pci/hda/patch_analog.c                    |    1 +
 sound/pci/hda/patch_conexant.c                  |    8 +-
 sound/pci/hda/patch_realtek.c                   |   13 +-
 sound/pci/hda/patch_sigmatel.c                  |   13 +-
 sound/pci/intel8x0.c                            |    6 +
 sound/pci/oxygen/oxygen.c                       |    4 +
 sound/pci/rme9652/hdsp.c                        |    1 +
 sound/pci/rme9652/hdspm.c                       |    1 +
 sound/soc/blackfin/bf5xx-ac97.c                 |    4 +-
 sound/soc/codecs/wm8990.c                       |   10 +-
 sound/usb/caiaq/audio.c                         |    2 +-
 sound/usb/caiaq/midi.c                          |    2 +-
 sound/usb/usx2y/us122l.c                        |   41 ++--
 tools/perf/util/callchain.h                     |    1 +
 672 files changed, 7208 insertions(+), 3722 deletions(-)
 create mode 100644 arch/x86/include/asm/mwait.h
 delete mode 100644 kernel/cred-internals.h
