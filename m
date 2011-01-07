Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1AGBip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:38:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:42663 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1AGBin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:38:43 -0500
Date: Thu, 6 Jan 2011 20:38:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, lwn@lwn.net,
        stable@kernel.org
Subject: [ANNOUNCE] Linux 2.6.34.8 has been released
Message-ID: <20110107013831.GI20843@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jan 2011 01:38:33.0418 (UTC) FILETIME=[985B3AA0:01CBAE0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new longterm 2.6.34.8 kernel has been released. This release contains
security fixes and all 2.6.34 users are encouraged to update. This
continues the 2.6.34 stable series under the new "longterm" name.

Git:
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.34.y.git

Gitweb:
http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.34.y.git

Tarballs/patches:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.34/


Al Viro (1):
      arm: fix really nasty sigreturn bug

Alan Cox (1):
      bluetooth: Fix missing NULL check

Alan Stern (3):
      USB: fix bug in initialization of interface minor numbers
      USB: disable endpoints after unbinding interfaces, not before
      USB: accept some invalid ep0-maxpacket values

Alexey Kuznetsov (1):
      tcp: Prevent overzealous packetization by SWS logic.

Alok Kataria (1):
      x86, kexec: Make sure to stop all CPUs before exiting the kernel

Alon Ziv (1):
      USB: opticon: Fix long-standing bugs in opticon driver

Anders Larsen (1):
      USB: cp210x: Add WAGO 750-923 Service Cable device ID

Andre Przywara (1):
      x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit

Andreas Herrmann (2):
      hwmon: (k8temp) Differentiate between AM2 and ASB1
      x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs

Andrew Morton (1):
      drivers/pci/intel-iommu.c: fix build with older gcc's

Andy Gospodarek (1):
      bonding: correctly process non-linear skbs

Anton Vorontsov (1):
      apm_power: Add missing break statement

Avi Kivity (2):
      KVM: VMX: Fix host GDT.LIMIT corruption
      KVM: Fix fs/gs reload oops with invalid ldt

Ben Hutchings (7):
      ext4: Conditionally define compat ioctl numbers
      ext4: Fix compat EXT4_IOC_ADD_GROUP
      PCI: MSI: Remove unsafe and unnecessary hardware access
      PCI: MSI: Restore read_msi_msg_desc(); add get_cached_msi_msg_desc()
      tun: Don't add sysfs attributes to devices without sysfs directories
      MIPS: Set io_map_base for several PCI bridges lacking it
      sis-agp: Remove SIS 760, handled by amd64-agp

Borislav Petkov (1):
      x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order

Chris Wilson (2):
      drm/i915: Prevent double dpms on
      drm: Only decouple the old_fb from the crtc is we call mode_set*

Chris Wright (1):
      tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread

Christian Borntraeger (1):
      ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode

Christian Lamparter (3):
      p54: fix tx feedback status flag check
      p54usb: fix off-by-one on !CONFIG_PM
      p54usb: add five more USBIDs

Christof Schmitt (1):
      Fix race when removing SCSI devices

Christoph Lameter (1):
      mm: page allocator: calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake

Clemens Ladisch (1):
      ALSA: rawmidi: fix oops (use after free) when unloading a driver module

Cliff Wickman (2):
      mm, x86: Saving vmcore with non-lazy freeing of vmas
      x86, kdump: Change copy_oldmem_page() to use cached addressing

Colin Ian King (1):
      ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume

Craig Shelley (1):
      USB: CP210x Add new device ID

Curt Wohlgemuth (2):
      ext4: Remove extraneous newlines in ext4_msg() calls
      ext4: check for a good block group before loading buddy pages

DJ Delorie (1):
      USB: cp210x: Add Renesas RX-Stick device ID

Dan Carpenter (9):
      KEYS: Return more accurate error codes
      USB: ehci-ppc-of: problems in unwind
      sysfs: checking for NULL instead of ERR_PTR
      irda: off by one
      i915: return -EFAULT if copy_to_user fails
      i915: return -EFAULT if copy_to_user fails
      Staging: vt6655: fix buffer overflow
      net/llc: make opt unsigned in llc_ui_setsockopt()
      gdth: integer overflow in ioctl

Dan Rosenberg (9):
      USB: serial/mos*: prevent reading uninitialized stack memory
      drivers/net/usb/hso.c: prevent reading uninitialized memory
      drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized stack memory
      drivers/net/eql.c: prevent reading uninitialized stack memory
      drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
      xfs: prevent reading uninitialized stack memory
      drivers/video/via/ioctl.c: prevent reading uninitialized stack memory
      ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
      ALSA: prevent heap corruption in snd_ctl_new()

Daniel J Blueman (2):
      rcu: apply RCU protection to wake_affine()
      Fix unprotected access to task credentials in waitid()

Daniel Suchy (1):
      USB: ftdi_sio: new VID/PIDs for various Papouch devices

Darren Hart (1):
      futex: Fix errors in nested key ref-counting

Dave Airlie (1):
      drm/radeon: fix PCI ID 5657 to be an RV410

Dave Ludlow (2):
      usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
      usb: serial: mos7840: Add USB IDs to support more B&B USB/RS485 converters.

David Daney (1):
      MIPS: Quit using undefined behavior of ADDU in 64-bit atomic operations.

David Henningsson (1):
      ALSA: hda - Rename iMic to Int Mic on Lenovo NB0763

David Howells (3):
      CIFS: Remove __exit mark from cifs_exit_dns_resolver()
      KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
      KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring

David Milburn (1):
      libsas: fix NCQ mixing with non-NCQ

David S. Miller (6):
      irda: Correctly clean up self->ias_obj on irda_bind() failure.
      tcp: Combat per-cpu skew in orphan tests.
      bridge: Clear INET control block of SKBs passed into ip_fragment().
      sparc64: Get rid of indirect p1275 PROM call buffer.
      tcp: Fix >4GB writes on 64-bit.
      rose: Fix signedness issues wrt. digi count.

Dmitry Monakhov (8):
      ext4: check missed return value in ext4_sync_file()
      ext4: fix quota accounting in case of fallocate
      ext4: Do not zero out uninitialized extents beyond i_size
      ext4: clean up inode bitmaps manipulation in ext4_free_inode
      ext4: init statistics after journal recovery
      ext4: Use bitops to read/modify i_flags in struct ext4_inode_info
      ext4: restart ext4_ext_remove_space() after transaction restart
      ext4: Fix remaining racy updates of EXT4_I(inode)->i_flags

Dmitry Torokhov (1):
      Input: i8042 - fix device removal on unload

Eric Dumazet (5):
      gro: fix different skb headrooms
      tcp: fix three tcp sysctls tuning
      rds: fix a leak of kernel memory
      ip: fix truesize mismatch in ip fragmentation
      netxen: dont set skb->truesize

Eric Paris (2):
      inotify: send IN_UNMOUNT events
      inotify: fix inotify oneshot support

Eric Sandeen (4):
      ext4: don't return to userspace after freezing the fs with a mutex held
      ext4: stop issuing discards if not supported by device
      ext4: don't scan/accumulate more pages than mballoc will allocate
      ext4: fix freeze deadlock under IO

Erik J. Staab (1):
      ALSA: oxygen: fix analog capture on Claro halo cards

FUJITA Tomonori (1):
      bsg: fix incorrect device_status value

Frank Mayhar (1):
      ext4: Make fsync sync new parent directories in no-journal mode

Frederic Weisbecker (1):
      perf: Initialize callchains roots's childen hits

Gary King (1):
      bounce: call flush_dcache_page() after bounce_copy_vec()

Greg Kroah-Hartman (1):
      USB: ftdi_sio: add device ids for ScienceScope

Guennadi Liakhovetski (1):
      mmc: fix the use of kunmap_atomic() in tmio_mmc.h

Guillem Jover (2):
      hwmon: (f75375s) Shift control mode to the correct bit position
      hwmon: (f75375s) Do not overwrite values read from registers

H. Peter Anvin (3):
      x86-64, compat: Test %rax for the syscall number, not %eax
      compat: Make compat_alloc_user_space() incorporate the access_ok()
      x86, cpu: After uncapping CPUID, re-run CPU feature detection

Haiyang Zhang (2):
      staging: hv: Fix missing functions for net_device_ops
      staging: hv: Fixed the value of the 64bit-hole inside ring buffer

Hank Janssen (3):
      staging: hv: Fixed bounce kmap problem by using correct index
      staging: hv: Increased storvsc ringbuffer and max_io_requests
      staging: hv: Fixed lockup problem with bounce_buffer scatter list

Herbert Xu (1):
      bridge: Clear IPCB before possible entry into IP stack

Jacob Pan (1):
      x86: detect scattered cpuid features earlier

Jan Kara (2):
      ext4: Show journal_checksum option
      char: Mark /dev/zero and /dev/kmem as not capable of writeback

Jan Sembera (1):
      binfmt_misc: fix binfmt_misc priority

Jarek Poplawski (1):
      gro: Re-fix different skb headrooms

Jason Detring (1):
      USB: cp210x: Add B&G H3000 link cable ID

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled

Jeff Moyer (1):
      aio: check for multiplication overflow in do_io_submit

Jeremy Fitzhardinge (3):
      xen: handle events as edge-triggered
      xen: use percpu interrupts for IPIs and VIRQs
      tracing/x86: Don't use mcount in pvclock.c

Jerome Marchand (1):
      kernel/groups.c: fix integer overflow in groups_search

Jianzhao Wang (1):
      net: blackhole route should always be recalculated

Jing Zhang (3):
      ext4: fix memory leaks in error path handling of ext4_ext_zeroout()
      ext4: Remove unnecessary call to ext4_get_group_desc() in mballoc
      ext4: rename ext4_mb_release_desc() to ext4_mb_unload_buddy()

Jiri Olsa (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 29

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

Joerg Roedel (3):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Fix rounding-bug in __unmap_single
      x86/amd-iommu: Work around S3 BIOS bug

Johannes Berg (2):
      wireless extensions: fix kernel heap content leak
      wext: fix potential private ioctl memory content leak

John W. Linville (2):
      ath5k: check return value of ieee80211_get_tx_rate
      hostap_pci: set dev->base_addr during probe

Josh Wu (1):
      USB: gadget: AT91: fix typo in atmel_usba_udc driver

Julia Lawall (1):
      drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure

KAMEZAWA Hiroyuki (1):
      memory hotplug: fix next block calculation in is_removable

KOSAKI Motohiro (1):
      tcp: select(writefds) don't hang up when a peer close connection

Kees Cook (1):
      net: clear heap allocations for privileged ethtool actions

Kenneth Waters (1):
      Input: joydev - fix JSIOCSAXMAP ioctl

Kumar Sanghvi (1):
      Phonet: Correct header retrieval after pskb_may_pull

Len Brown (3):
      intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
      ACPI: delete ZEPTO idle=nomwait DMI quirk

Li Zefan (1):
      tracing: Fix a race in function profile

Linus Torvalds (2):
      v4l1: fix 32-bit compat microcode loading translation
      De-pessimize rds_page_copy_user

Luca Tettamanti (1):
      atl1: fix resume

Luis R. Rodriguez (2):
      ath5k: drop warning on jumbo frames
      ath9k_hw: fix parsing of HT40 5 GHz CTLs

Luke Lowrey (1):
      USB: ftdi_sio: Added custom PIDs for ChamSys products

Luke Yelavich (1):
      ALSA: hda - Add Dell Latitude E6400 model quirk

Maciej Żenczykowski (1):
      net: Fix IPv6 PMTU disc. w/ asymmetric routes

Marek Szyprowski (1):
      mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove

Mark Lord (1):
      sata_mv: fix broken DSM/TRIM support (v2)

Mathieu Desnoyers (1):
      sched: Fix string comparison in /proc/sched_features

Matt Evans (1):
      powerpc: Initialise paca->kstack before early_setup_secondary

Mauro Carvalho Chehab (2):
      V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)
      USB: option: Add more ZTE modem USB id's

Max Vozeler (2):
      staging: usbip: Notify usb core of port status changes
      staging: usbip: Process event flags without delay

Maxim Osipov (1):
      USB: Fix kernel oops with g_ether and Windows

Mel Gorman (2):
      mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
      mm: page allocator: update free page counters after pages are placed on the free list

Michael Cree (1):
      alpha: Fix printk format errors

Michael Neuling (1):
      powerpc: Don't use kernel stack with translation off

Michael Reed (1):
      sd name space exhaustion causes system hang

Mike Christie (1):
      Fix regressions in scsi_internal_device_block

Mike Galbraith (1):
      sched: Fix select_idle_sibling()

Miklos Szeredi (1):
      fuse: flush background queue on connection close

Ming Lei (1):
      usb: musb: gadget: fix kernel panic if using out ep with FIFO_TXRX style

Nagendra Tomar (1):
      net: Fix the condition passed to sk_wait_event()

Nicolas Ferre (1):
      AT91: change dma resource index

Nicolas Kaiser (1):
      pipe: fix failure to return error code on ->confirm()

Nikanth Karthikesan (1):
      ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate

Oleg Nesterov (6):
      sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code
      sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
      sched: move_task_off_dead_cpu(): Remove retry logic
      sched: sched_exec(): Remove the select_fallback_rq() logic
      sched: _cpu_down(): Don't play with current->cpus_allowed
      sched: Make select_fallback_rq() cpuset friendly

Patrick Simmons (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)

Paul E. McKenney (1):
      pid: make setpgid() system call use RCU read-side critical section

Paul Fertser (1):
      b44: fix carrier detection on bind

Paul Fox (1):
      x86, olpc: Don't retry EC commands forever

Paul Gortmaker (1):
      Linux 2.6.34.8

Paul Mackerras (1):
      powerpc/perf: Fix sampling enable for PPC970

Peter Oberparleiter (2):
      gcov: fix null-pointer dereference for certain module types
      dasd: use correct label location for diag fba disks

Peter Zijlstra (6):
      x86, tsc: Fix a preemption leak in restore_sched_clock_state()
      sched: Fix TASK_WAKING vs fork deadlock
      sched: Optimize task_rq_lock()
      sched: Fix nr_uninterruptible count
      sched: Fix rq->clock synchronization when migrating tasks
      sched: Pre-compute cpumask_weight(sched_domain_span(sd))

Petr Tesarik (1):
      Optimize ticket spinlocks in fsys_rt_sigprocmask

Philippe Corbes (1):
      USB: cdc-acm: Add pseudo modem without AT command capabilities

Przemo Firszt (1):
      USB: Expose vendor-specific ACM channel on Nokia 5230

Rainer Keller (1):
      USB: add PID for FTDI based OpenDCC hardware

Rich Mattes (1):
      USB: ftdi_sio: Add PID for accesio products

Robert Richter (3):
      oprofile: fix crash when accessing freed task structs
      oprofile, x86: fix init_sysfs error handling
      oprofile, x86: fix init_sysfs() function stub

Robin Holt (1):
      sgi-xp: incoming XPC channel messages can come in after the channel's partition structures have been torn down

Roland McGrath (4):
      x86-64, compat: Retruncate rax after ia32 syscall entry tracing
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments

Ryan Kuester (1):
      mptsas: fix hangs caused by ATA pass-through

Salman Qazi (1):
      hrtimer: Preserve timer state in remove_hrtimer()

Sergei Shtylyov (2):
      usb: musb: gadget: restart request on clearing endpoint halt
      usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

Stanislaw Gruszka (3):
      sched: Fix user time incorrectly accounted as system time on 32-bit
      skge: add quirk to limit DMA
      r8169: allocate with GFP_KERNEL flag when able to sleep

Stefan Bader (1):
      mm: Move vma_stack_continue into mm.h

Steve Wise (1):
      RDMA/cxgb3: Turn off RX coalescing for iWARP connections

Steven Rostedt (3):
      tracing: Do not allow llseek to set_ftrace_filter
      tracing/x86: Don't use mcount in kvmclock.c
      ring-buffer: Fix typo of time extends per page

Sunil Mushran (1):
      ocfs2: Fix incorrect checksum validation error

Suresh Siddha (3):
      x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states
      sched: Fix select_idle_sibling() logic in select_task_rq_fair()
      x86, intr-remap: Set redirection hint in the IRTE

Takashi Iwai (3):
      ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
      ALSA: hda - Handle missing NID 0x1b on ALC259 codec
      ALSA: hda - Handle pin NID 0x1a on ALC259/269

Tejun Heo (3):
      libata: skip EH autopsy and recovery during suspend
      percpu: fix pcpu_last_unit_cpu
      ubd: fix incorrect sector handling during request restart

Tetsuo Handa (1):
      UNIX: Do not loop forever at unix_autobind().

Theodore Ts'o (2):
      ext4: Avoid crashing on NULL ptr dereference on a filesystem error
      ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted

Thomas Gleixner (2):
      x86, hpet: Fix bogus error check in hpet_assign_irq()
      x86, irq: Plug memory leak in sparse irq

Toby Gray (2):
      USB: cdc-acm: Adding second ACM channel support for various Nokia and one Samsung phones
      USB: cdc-acm: Fixing crash when ACM probing interfaces with no endpoint descriptors.

Tom Marshall (1):
      tcp: Fix race in tcp_poll

Tony Luck (2):
      fix siglock
      guard page for stacks that grow upwards

Trond Myklebust (2):
      NFS: Fix a typo in nfs_sockaddr_match_ipaddr6
      SUNRPC: Fix race corrupting rpc upcall

Ulrich Weber (1):
      xfrm4: strip ECN bits from tos field

Vasiliy Kulikov (1):
      pcmcia: synclink_cs: fix information leak to userland

Vlad Yasevich (1):
      sctp: Do not reset the packet during sctp_packet_config().

Wei Yongjun (1):
      sctp: fix append error cause to ERROR chunk correctly

Xiao Guangrong (2):
      KVM: MMU: fix direct sp's access corrupted
      KVM: MMU: fix conflict access permissions in direct sp

Yegor Yefremov (1):
      i2c-pca: Fix waitforcompletion() return value

Yusuke Goda (1):
      tmio_mmc: don't clear unhandled pending interrupts

Zachary Amsden (2):
      KVM: x86: Fix SVM VMCB reset
      KVM: x86: Move TSC reset out of vmcb_init

Zhang Rui (1):
      ACPI: Disable Windows Vista compatibility for Toshiba P305D


 Makefile                                    |    2 
 arch/alpha/kernel/err_marvel.c              |    6 
 arch/arm/kernel/entry-common.S              |    2 
 arch/arm/mach-at91/at91sam9g45_devices.c    |    2 
 arch/ia64/include/asm/compat.h              |    2 
 arch/ia64/kernel/fsys.S                     |   30 +-
 arch/ia64/kernel/msi_ia64.c                 |    2 
 arch/ia64/sn/kernel/msi_sn.c                |    2 
 arch/mips/include/asm/atomic.h              |   24 +-
 arch/mips/include/asm/compat.h              |    2 
 arch/mips/mti-malta/malta-pci.c             |    2 
 arch/mips/nxp/pnx8550/common/pci.c          |    1 
 arch/mips/nxp/pnx8550/common/setup.c        |    2 
 arch/mips/pci/ops-pmcmsp.c                  |    1 
 arch/mips/pci/pci-yosemite.c                |    1 
 arch/parisc/include/asm/compat.h            |    2 
 arch/powerpc/include/asm/compat.h           |    2 
 arch/powerpc/kernel/head_64.S               |   18 +
 arch/powerpc/kernel/ppc970-pmu.c            |    2 
 arch/s390/include/asm/compat.h              |    2 
 arch/sparc/include/asm/compat.h             |    2 
 arch/sparc/include/asm/oplib_64.h           |   27 --
 arch/sparc/prom/cif.S                       |   16 -
 arch/sparc/prom/console_64.c                |   48 +++-
 arch/sparc/prom/devops_64.c                 |   36 ++-
 arch/sparc/prom/misc_64.c                   |  314 +++++++++++++++++++---------
 arch/sparc/prom/p1275.c                     |  102 ---------
 arch/sparc/prom/tree_64.c                   |  210 +++++++++++++-----
 arch/um/drivers/ubd_kern.c                  |    9 
 arch/x86/ia32/ia32entry.S                   |   22 +
 arch/x86/include/asm/amd_iommu_proto.h      |    6 
 arch/x86/include/asm/amd_iommu_types.h      |   12 +
 arch/x86/include/asm/compat.h               |    2 
 arch/x86/include/asm/cpufeature.h           |    2 
 arch/x86/include/asm/io.h                   |    1 
 arch/x86/include/asm/kvm_host.h             |   24 --
 arch/x86/include/asm/smp.h                  |    9 
 arch/x86/include/asm/tsc.h                  |    2 
 arch/x86/kernel/Makefile                    |    2 
 arch/x86/kernel/amd_iommu.c                 |    4 
 arch/x86/kernel/amd_iommu_init.c            |   67 ++++-
 arch/x86/kernel/apic/io_apic.c              |   15 -
 arch/x86/kernel/cpu/common.c                |    4 
 arch/x86/kernel/cpu/cpu.h                   |    1 
 arch/x86/kernel/cpu/intel.c                 |    1 
 arch/x86/kernel/cpu/mcheck/mce_amd.c        |    9 
 arch/x86/kernel/cpu/mtrr/cleanup.c          |    2 
 arch/x86/kernel/crash_dump_64.c             |    3 
 arch/x86/kernel/hpet.c                      |    2 
 arch/x86/kernel/olpc.c                      |    5 
 arch/x86/kernel/reboot.c                    |    2 
 arch/x86/kernel/smp.c                       |   15 -
 arch/x86/kernel/tsc.c                       |   38 +++
 arch/x86/kvm/paging_tmpl.h                  |   30 ++
 arch/x86/kvm/svm.c                          |   17 -
 arch/x86/kvm/vmx.c                          |   28 +-
 arch/x86/kvm/x86.c                          |    2 
 arch/x86/oprofile/nmi_int.c                 |   27 +-
 arch/x86/power/cpu.c                        |    2 
 arch/x86/xen/enlighten.c                    |    2 
 arch/x86/xen/smp.c                          |    6 
 block/bsg.c                                 |    2 
 drivers/acpi/acpica/aclocal.h               |    1 
 drivers/acpi/blacklist.c                    |   16 +
 drivers/acpi/processor_core.c               |    6 
 drivers/ata/libata-core.c                   |   14 +
 drivers/ata/libata-eh.c                     |    4 
 drivers/ata/sata_mv.c                       |   44 +++
 drivers/bluetooth/hci_ldisc.c               |    7 
 drivers/char/agp/sis-agp.c                  |    8 
 drivers/char/mem.c                          |    3 
 drivers/char/pcmcia/synclink_cs.c           |    2 
 drivers/dma/mv_xor.c                        |    2 
 drivers/gpu/drm/drm_crtc_helper.c           |    4 
 drivers/gpu/drm/i915/i915_dma.c             |   12 -
 drivers/gpu/drm/i915/i915_gem.c             |    1 
 drivers/gpu/drm/i915/intel_display.c        |    5 
 drivers/hwmon/f75375s.c                     |    6 
 drivers/hwmon/k8temp.c                      |   35 ++-
 drivers/i2c/busses/i2c-pca-isa.c            |   12 -
 drivers/i2c/busses/i2c-pca-platform.c       |   11 
 drivers/infiniband/hw/cxgb3/iwch_cm.c       |    6 
 drivers/input/joydev.c                      |    3 
 drivers/input/serio/i8042.c                 |    2 
 drivers/media/video/cx231xx/cx231xx-cards.c |   14 -
 drivers/media/video/v4l2-compat-ioctl32.c   |   32 +-
 drivers/message/fusion/mptscsih.c           |    2 
 drivers/misc/sgi-xp/xpc_uv.c                |   17 +
 drivers/mmc/host/sdhci-s3c.c                |    6 
 drivers/mmc/host/tmio_mmc.c                 |    7 
 drivers/mmc/host/tmio_mmc.h                 |   13 -
 drivers/net/atlx/atl1.c                     |    5 
 drivers/net/b44.c                           |    4 
 drivers/net/bonding/bond_3ad.c              |    3 
 drivers/net/bonding/bond_alb.c              |    3 
 drivers/net/cxgb3/cxgb3_main.c              |    2 
 drivers/net/eql.c                           |    2 
 drivers/net/netxen/netxen_nic_init.c        |    3 
 drivers/net/r8169.c                         |   12 -
 drivers/net/skge.c                          |   18 +
 drivers/net/tun.c                           |    3 
 drivers/net/usb/hso.c                       |    2 
 drivers/net/wireless/ath/ath5k/base.c       |   11 
 drivers/net/wireless/ath/ath9k/eeprom.h     |    2 
 drivers/net/wireless/ath/regd.h             |    1 
 drivers/net/wireless/hostap/hostap_pci.c    |    1 
 drivers/net/wireless/p54/eeprom.c           |    4 
 drivers/net/wireless/p54/p54usb.c           |   15 +
 drivers/net/wireless/p54/txrx.c             |    2 
 drivers/oprofile/buffer_sync.c              |   27 +-
 drivers/oprofile/cpu_buffer.c               |    2 
 drivers/pci/intel-iommu.c                   |   90 +++-----
 drivers/pci/msi.c                           |   27 ++
 drivers/pci/quirks.c                        |   20 +
 drivers/power/apm_power.c                   |    1 
 drivers/scsi/gdth.c                         |    8 
 drivers/scsi/libsas/sas_ata.c               |    1 
 drivers/scsi/scsi_lib.c                     |    3 
 drivers/scsi/scsi_sysfs.c                   |    3 
 drivers/scsi/sd.c                           |   15 -
 drivers/staging/hv/RingBuffer.c             |    3 
 drivers/staging/hv/StorVscApi.h             |    4 
 drivers/staging/hv/netvsc_drv.c             |    3 
 drivers/staging/hv/storvsc_drv.c            |    9 
 drivers/staging/usbip/usbip_event.c         |   16 -
 drivers/staging/usbip/vhci_hcd.c            |    2 
 drivers/staging/vt6655/wpactl.c             |   11 
 drivers/usb/class/cdc-acm.c                 |   24 ++
 drivers/usb/core/file.c                     |   35 +--
 drivers/usb/core/hub.c                      |    9 
 drivers/usb/core/message.c                  |   15 -
 drivers/usb/gadget/atmel_usba_udc.c         |    3 
 drivers/usb/gadget/rndis.c                  |   10 
 drivers/usb/host/ehci-ppc-of.c              |   12 -
 drivers/usb/musb/blackfin.c                 |    4 
 drivers/usb/musb/musb_gadget.c              |   22 +
 drivers/usb/musb/musb_gadget.h              |    2 
 drivers/usb/musb/musb_gadget_ep0.c          |    9 
 drivers/usb/serial/cp210x.c                 |   12 -
 drivers/usb/serial/ftdi_sio.c               |   43 +++
 drivers/usb/serial/ftdi_sio_ids.h           |   51 ++++
 drivers/usb/serial/mos7720.c                |    3 
 drivers/usb/serial/mos7840.c                |   35 ++-
 drivers/usb/serial/opticon.c                |    6 
 drivers/usb/serial/option.c                 |   23 +-
 drivers/video/sis/sis_main.c                |    3 
 drivers/video/via/ioctl.c                   |    2 
 drivers/xen/events.c                        |   21 +
 fs/aio.c                                    |    3 
 fs/binfmt_misc.c                            |    2 
 fs/char_dev.c                               |    4 
 fs/cifs/dns_resolve.c                       |    2 
 fs/cifs/dns_resolve.h                       |    2 
 fs/exec.c                                   |   14 +
 fs/ext4/dir.c                               |    4 
 fs/ext4/ext4.h                              |  129 ++++++++++-
 fs/ext4/ext4_jbd2.h                         |    8 
 fs/ext4/extents.c                           |  140 ++++++++----
 fs/ext4/file.c                              |    2 
 fs/ext4/fsync.c                             |   33 ++
 fs/ext4/ialloc.c                            |   89 +++----
 fs/ext4/inode.c                             |   88 ++++---
 fs/ext4/ioctl.c                             |   25 ++
 fs/ext4/mballoc.c                           |  108 ++++++---
 fs/ext4/migrate.c                           |    2 
 fs/ext4/move_extent.c                       |    4 
 fs/ext4/namei.c                             |   12 -
 fs/ext4/super.c                             |   65 ++---
 fs/ext4/xattr.c                             |    4 
 fs/fuse/dev.c                               |   16 +
 fs/nfs/client.c                             |    2 
 fs/notify/inotify/inotify_fsnotify.c        |    3 
 fs/notify/inotify/inotify_user.c            |    7 
 fs/ocfs2/inode.c                            |    6 
 fs/ocfs2/symlink.c                          |    2 
 fs/partitions/ibm.c                         |   13 +
 fs/pipe.c                                   |    2 
 fs/proc/task_mmu.c                          |    3 
 fs/sysfs/file.c                             |    2 
 fs/xfs/linux-2.6/xfs_ioctl.c                |    2 
 include/drm/drm_pciids.h                    |    2 
 include/linux/compat.h                      |    3 
 include/linux/cpuset.h                      |   16 -
 include/linux/libata.h                      |    1 
 include/linux/mm.h                          |   14 +
 include/linux/mmzone.h                      |   13 +
 include/linux/msi.h                         |    2 
 include/linux/pci_ids.h                     |    3 
 include/linux/sched.h                       |    5 
 include/linux/socket.h                      |    2 
 include/linux/vmstat.h                      |   22 +
 include/net/tcp.h                           |   36 ++-
 kernel/compat.c                             |   21 +
 kernel/cpu.c                                |   18 -
 kernel/cpuset.c                             |   67 +++--
 kernel/exit.c                               |    5 
 kernel/futex.c                              |   31 +-
 kernel/gcov/fs.c                            |  244 ++++++++++++++++-----
 kernel/groups.c                             |    5 
 kernel/hrtimer.c                            |   13 -
 kernel/sched.c                              |  180 +++++++---------
 kernel/sched_fair.c                         |  106 +++++----
 kernel/sched_idletask.c                     |    3 
 kernel/sched_rt.c                           |    5 
 kernel/sys.c                                |    2 
 kernel/trace/ftrace.c                       |   19 +
 kernel/trace/ring_buffer.c                  |    2 
 mm/bounce.c                                 |    2 
 mm/memory.c                                 |   15 -
 mm/memory_hotplug.c                         |   16 -
 mm/mlock.c                                  |    6 
 mm/mmap.c                                   |    3 
 mm/mmzone.c                                 |   21 +
 mm/page_alloc.c                             |   33 ++
 mm/percpu.c                                 |    2 
 mm/vmalloc.c                                |    9 
 mm/vmstat.c                                 |   15 +
 net/bridge/br_netfilter.c                   |    9 
 net/core/ethtool.c                          |    4 
 net/core/iovec.c                            |    5 
 net/core/skbuff.c                           |    6 
 net/core/stream.c                           |    8 
 net/ipv4/ip_output.c                        |   19 +
 net/ipv4/route.c                            |    7 
 net/ipv4/tcp.c                              |   41 +--
 net/ipv4/tcp_input.c                        |    2 
 net/ipv4/tcp_timer.c                        |    8 
 net/ipv4/xfrm4_policy.c                     |    2 
 net/ipv6/ip6_output.c                       |   18 +
 net/ipv6/route.c                            |   28 ++
 net/irda/af_irda.c                          |    4 
 net/irda/irlan/irlan_common.c               |    2 
 net/llc/af_llc.c                            |    3 
 net/phonet/pep.c                            |    3 
 net/rds/page.c                              |   27 --
 net/rds/recv.c                              |    2 
 net/rose/af_rose.c                          |    4 
 net/sctp/output.c                           |    1 
 net/sctp/sm_make_chunk.c                    |    4 
 net/sunrpc/auth_gss/auth_gss.c              |    9 
 net/sunrpc/rpc_pipe.c                       |    6 
 net/unix/af_unix.c                          |   15 +
 net/wireless/wext-compat.c                  |    3 
 net/wireless/wext-core.c                    |   16 +
 net/wireless/wext-priv.c                    |    2 
 security/keys/keyctl.c                      |    6 
 security/keys/process_keys.c                |    6 
 sound/core/control.c                        |    5 
 sound/core/rawmidi.c                        |    4 
 sound/core/seq/oss/seq_oss_init.c           |    9 
 sound/pci/hda/patch_analog.c                |    1 
 sound/pci/hda/patch_realtek.c               |    8 
 sound/pci/oxygen/oxygen.c                   |    4 
 sound/pci/rme9652/hdsp.c                    |    1 
 sound/pci/rme9652/hdspm.c                   |    1 
 tools/perf/util/callchain.h                 |    1 
 256 files changed, 2862 insertions(+), 1416 deletions(-)
