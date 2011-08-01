Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1HAV7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:59:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:24982 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1HAV7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:59:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,302,1309762800"; 
   d="scan'208";a="34407784"
Date: Mon, 1 Aug 2011 14:59:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org, lwn@lwn.net, stable@kernel.org
Subject: [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
Message-ID: <20110801215908.GA11448@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The longterm Linux kernel 2.6.35.14 is released.

A note on the 2.6.35.13 git tags & branches: when releasing 2.6.35.13 I made
a mistake which resulted in the v2.6.35.13 tag being on a different
branch than the master tree.  I decided the continue on the branch,
not the tag, so you have to delete the v2.6.35.13 tag -- if you're
using that -- and refetch the new tag. If you just use the "master" branch
or the released patches/tarballs you don't need to do anything. Sorry about that.

This release contains security fixes and everyone using 2.6.35 is encouraged
to update. 

Thanks to all contributors.

-Andi

Full tarball
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/linux-2.6.35.14.tar.gz
SHA1: 710e0fa653e8a7b60b8bd2f2698d7088a88f3187

Patch against 2.6.35:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/patch-2.6.35.14.gz
SHA1: fba694a4f4d3351113c2edb8bb37cd0b4d493ddd

Patch against 2.6.35.13
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/incr/patch-2.6.35.13-14.gz
SHA1: 88e53290e99ea6afa1868f35ffd0f1811ccfacca

Full Changelog against 2.6.35.13
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/ChangeLog-2.6.35.14
SHA1: f93e92f78ab7e722b0b6b1e2a5c620e0a8131c76

Git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git

Ajay Kumar Gupta (1):
      usb: musb: restore INDEX register in resume path

Alan Stern (7):
      USB: fix regression in usbip by setting has_tt flag
      USB: teach "devices" file about Wireless and SuperSpeed USB
      OHCI: work around for nVidia shutdown problem
      OHCI: fix regression caused by nVidia shutdown workaround
      USB: don't let errors prevent system sleep
      USB: don't let the hub driver prevent system sleep
      USB: OHCI: fix another regression for NVIDIA controllers

Andi Kleen (3):
      maintainer
      Drop -Werror in perf
      release 2.6.35.14

Andrea Arcangeli (1):
      migrate: don't account swapcache as shmem

Andrew Barry (1):
      mm/page_alloc.c: prevent unending loop in __alloc_pages_slowpath()

Andy Chittenden (1):
      SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)

Anton Blanchard (1):
      powerpc/pseries/hvconsole: Fix dropped console output

Arnd Bergmann (1):
      6pack,mkiss: fix lock inconsistency

Artem Bityutskiy (3):
      UBIFS: fix a rare memory leak in ro to rw remounting path
      UBIFS: fix shrinker object count reports
      UBIFS: fix memory leak on error path

Ben Dooks (1):
      mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Ben Greear (1):
      SUNRPC: Fix use of static variable in rpcb_getport_async

Ben Hutchings (7):
      Staging: rtl8192su: Clean up in case of an error in module initialisation
      Staging: rtl8192su: Fix procfs code for interfaces not named wlan0
      ALSA: emux: Add trivial compat ioctl handler
      btrfs: Require CAP_SYS_ADMIN for filesystem rebalance
      niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL
      powerpc/boot/dts: Install dts from the right directory
      netxen: Remove references to unified firmware file

Benedek László (1):
      USB: serial: ftdi_sio: adding support for TavIR STK500

Benjamin Herrenschmidt (1):
      mm/futex: fix futex writes on archs with SW tracking of

Bjørn Mork (1):
      megaraid_sas: Sanity check user supplied length before passing it to dma_alloc_coherent()

Bob Liu (1):
      mm/nommu.c: fix remap_pfn_range()

Boris Ostrovsky (1):
      x86, amd: Do not enable ARAT feature on AMD processors below family 0x12

Borislav Petkov (1):
      x86, AMD: Fix ARAT feature setting again

Bruce Rogers (1):
      virtio_net: Add schedule check to napi_enable call

Catalin Marinas (1):
      kmemleak: Do not return a pointer to an object that kmemleak did not get

Chris Ball (2):
      mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
      mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Christian Lamparter (1):
      p54usb: add zoom 4410 usbid

Craig Shelley (1):
      USB: CP210x Add 4 Device IDs for AC-Services Devices

Dan Carpenter (1):
      xen: off by one errors in multicalls.c

Dan Rosenberg (6):
      mpt2sas: prevent heap overflows and unchecked reads
      pmcraid: reject negative request size
      ARM: 6891/1: prevent heap corruption in OABI semtimedop
      dccp: handle invalid feature options length
      alpha: fix several security issues
      xtensa: prevent arbitrary read in ptrace

Dan Williams (1):
      atm: expose ATM device index in sysfs

Daniel Haid (1):
      drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

Daniel J Blueman (1):
      x86: Make Dell Latitude E5420 use reboot=pci

Daniel T Chen (1):
      ALSA: hda: Fix quirk for Dell Inspiron 910

Dave Jones (3):
      kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0
      can: Add missing socket check in can/bcm release.
      CPUFREQ: Remove cpufreq_stats sysfs entries on module unload.

David Chang (1):
      staging: usbip: fix wrong endian conversion

David Henningsson (1):
      ALSA: HDA: Use one dmic only for Dell Studio 1558

David Rientjes (1):
      set memory ranges in N_NORMAL_MEMORY when onlined

Dmitry Torokhov (1):
      USB: xhci - fix interval calculation for FS isoc endpoints

Edgar (gimli) Hucek (4):
      ALSA: hda - MacBookAir3,1(3,2) alsa support
      Bluetooth: Add MacBookAir3,1(2) support
      backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
      HID: add MacBookAir 3,1 and 3,2 support

Edgar Hucek (1):
      hwmon: (applesmc) Add MacBookAir3,1(3,2) support

Elizabeth Jennifer Myers (1):
      USB: moto_modem: Add USB identifier for the Motorola VE240.

Eric B Munson (1):
      powerpc/oprofile: Handle events that raise an exception without overflowing

Eric Dumazet (2):
      inet_diag: fix inet_diag_bc_audit()
      af_packet: prevent information leak

Eugene A. Shatokhin (1):
      ath5k: fix memory leak when fewer than N_PD_CURVES are in use

Felipe Balbi (2):
      usb: musb: core: set has_tt flag
      usb: gadget: rndis: don't test against req->length

Felix Radensky (1):
      mtd: mtdconcat: fix NAND OOB write

Fernando Luis Vazquez Cao (2):
      netfilter: IPv6: initialize TOS field in REJECT target module
      netfilter: IPv6: fix DSCP mangle code

Fernando Luis Vázquez Cao (2):
      IGMP snooping: set mrouters_only flag for IPv4 traffic
      IGMP snooping: set mrouters_only flag for IPv6 traffic

Florian Fainelli (1):
      watchdog: mtx1-wdt: request gpio before using it

Frederic Weisbecker (1):
      rcu: Fix unpaired rcu_irq_enter() from locking selftests

Geert Uytterhoeven (3):
      ne-h8300: Fix regression caused during net_device_ops conversion
      hydra: Fix regression caused during net_device_ops conversion
      zorro8390: Fix regression caused during net_device_ops conversion

Guo-Fu Tseng (1):
      jme: Fix unmap error (Causing system freeze)

H. Peter Anvin (1):
      x86: Make Dell Latitude E6420 use reboot=pci

Hans Verkuil (3):
      bttv: fix s_tuner for radio
      pvrusb2: fix g/s_tuner support
      v4l2-ioctl.c: prefill tuner type for g_frequency and

Hans de Goede (1):
      drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

Hemant Pedanekar (1):
      PCI: Add quirk for setting valid class for TI816X Endpoint

Hendrik Brueckner (1):
      hvc_console: Improve tty/console put_chars handling

Hermann Kneissel (1):
      USB: gamin_gps: Fix for data transfer problems in native mode

Huang Ying (1):
      kexec, x86: Fix incorrect jump back address if not

Hugh Dickins (2):
      mm: fix ENOSPC returned by handle_mm_fault()
      ksm: fix NULL pointer dereference in scan_get_next_rmap_item()

Ian Campbell (1):
      xen: events: do not unmask event channels on resume

Igor Grinberg (1):
      ARM: pxa/cm-x300: fix V3020 RTC functionality

Igor Mammedov (1):
      Input: xen-kbdfront - fix mouse getting stuck after save/restore

J. Bruce Fields (1):
      svcrpc: fix list-corrupting race on nfsd shutdown

Jacob Shin (1):
      CPU hotplug, re-create sysfs directory and symlinks

James Bottomley (5):
      put stricter guards on queue dead checks
      fix oops in scsi_run_queue()
      block: add proper state guards to __elv_next_request
      Fix oops caused by queue refcounting failure
      fix crash in scsi_dispatch_cmd()

Jan Kara (2):
      ext3: Fix fs corruption when make_indexed_dir() fails
      jbd: Fix forever sleeping process in do_get_write_access()

Jean Delvare (1):
      i2c-taos-evm: Fix log messages

Jean-Christophe PLAGNIOL-VILLARD (1):
      usb/gadget: at91sam9g20 fix end point max packet size

Jeff Layton (3):
      nfs: don't lose MS_SYNCHRONOUS on remount of noac mount
      cifs: check for bytes_remaining going to zero in CIFS_SessSetup
      cifs: add fallback in is_path_accessible for old servers

Jens Axboe (2):
      block: export blk_{get,put}_queue()
      cfq-iosched: fix locking around ioc->ioc_data assignment

Jim Bos (2):
      i8k: Tell gcc that *regs gets clobbered
      Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)

Jiri Olsa (1):
      x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit

Jiri Slaby (1):
      USB: serial/usb_wwan, fix tty NULL dereference

Joe Perches (2):
      bug.h: Add WARN_RATELIMIT
      net: filter: Use WARN_RATELIMIT

Joerg Roedel (2):
      x86/amd-iommu: Fix 3 possible endless loops
      iommu/amd: Don't use MSI address range for DMA addresses

Johannes Berg (1):
      mac80211: fix TKIP replay vulnerability

Jon Povey (1):
      davinci: DM365 EVM: fix video input mux bits

Jordan_Hargrave@Dell.com (1):
      PCI: Set PCIE maxpayload for card during hotplug insertion

Jovi Zhang (1):
      nfs: fix compilation warning

Julia Lawall (1):
      x86, mce, AMD: Fix leaving freed data in a list

K. Y. Srinivasan (1):
      Staging: hv: netvsc: Fix a bug in accounting transmit slots

Kasper Pedersen (1):
      time: Compensate for rounding on odd-frequency clocksources

Kleber Sacilotto de Souza (1):
      ehea: fix wrongly reported speed and port

Kuninori Morimoto (1):
      ASoC: ak4642: fixup snd_soc_update_bits mask for PW_MGMT2

Larry Finger (1):
      staging: r8192e_pci: Handle duplicate PCI ID 0x10ec:0x8192

Len Brown (1):
      x86, intel, power: Initialize MSR_IA32_ENERGY_PERF_BIAS

Libor Pechacek (1):
      USB: core: Tolerate protocol stall during hub and port status read

Linus Torvalds (1):
      Increase OSF partition limit from 8 to 18

Luca Tettamanti (2):
      i8k: Avoid lahf in 64-bit code
      hwmon: (asus_atk0110) Fix memory leak

Luciano Coelho (1):
      nl80211: fix check for valid SSID size in scan operations

Manfred Spraul (1):
      ipc/sem.c: fix race with concurrent semtimedop() timeouts

Manoj Iyer (2):
      mmc: Add PCI fixup quirks for Ricoh 1180:e823 reader
      mmc: Added quirks for Ricoh 1180:e823 lower base clock

Marcin Slusarz (1):
      debugobjects: Fix boot crash when kmemleak and debugobjects enabled

Marcus Meissner (1):
      net/ipv4: Check for mistakenly passed in non-IPv4 address

Mark Brown (3):
      ASoC: Ensure output PGA is enabled for line outputs in wm_hubs
      ASoC: Add some missing volume update bit sets for wm_hubs devices
      ASoC: Ensure we delay long enough for WM8994 FLL to lock

Mathias Krause (1):
      exec: delay address limit change until point of no return

Matvejchikov Ilya (1):
      NET: slip, fix ldisc->open retval

Mauro Carvalho Chehab (2):
      Remove the old V4L1 v4lgrab.c file
      si4713-i2c: avoid potential buffer overflow on si4713

Michael Neuling (1):
      powerpc/kdump: Fix timeout in crash_kexec_wait_realmode

Michael Schmitz (1):
      m68k/mm: Set all online nodes in N_NORMAL_MEMORY

Michal Kubecek (1):
      PM: Free memory bitmaps if opening /dev/snapshot fails

Michal Marek (1):
      kbuild: Fix passing -Wno-* options to gcc 4.4+

Miklos Szeredi (1):
      mm: prevent concurrent unmap_mapping_range() on the same inode

Milan Broz (1):
      dm table: reject devices without request fns

Milton Miller (2):
      powerpc/kexec: Fix memory corruption from unallocated slaves
      seqlock: Don't smp_rmb in seqlock reader spin loop

Namhyung Kim (7):
      loop: limit 'max_part' module param to DISK_MAX_PARTS
      loop: handle on-demand devices correctly
      brd: limit 'max_part' module param to DISK_MAX_PARTS
      brd: handle on-demand devices correctly
      nbd: limit module parameters to a sane value
      md: check ->hot_remove_disk when removing disk
      md/raid5: fix raid5_set_bi_hw_segments

Neil Horman (2):
      nfs4: Ensure that ACL pages sent over NFS were not allocated from the slab (v3)
      bonding: Ensure that we unshare skbs prior to calling pskb_may_pull

NeilBrown (1):
      md: avoid endless recovery loop when waiting for fail device to complete.

Nobuhiro Iwamatsu (2):
      Bluetooth: Add support Bluetooth controller of MacbookPro 6,2
      Bluetooth: Add support Bluetooth controller of MacbookPro 7,1

OGAWA Hirofumi (1):
      fat: Fix corrupt inode flags when remove ATTR_SYS flag

Oliver Hartkopp (1):
      can: add missing socket check in can/raw release

Ondrej Zary (1):
      rt2500usb: fallback to SW encryption for TKIP+AES

Patrick Boettcher (1):
      FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci

Paul Fox (1):
      libertas: fix cmdpendingq locking

Paul Parsons (1):
      ARM: pxa: fix PGSR register address calculation

Pavel Herrmann (1):
      hwmon: (max1111) Fix race condition causing NULL pointer

Pavel Shilovsky (1):
      CIFS: Fix memory over bound bug in cifs_parse_mount_options

Peter Zijlstra (2):
      lockdep: Fix lock_is_held() on recursion
      mm/backing-dev.c: reset bdi min_ratio in bdi_unregister()

Rafael Aquini (1):
      mm: fix negative commitlimit when gigantic hugepages are allocated

Rafael J. Wysocki (1):
      PM / Hibernate: Fix free_unnecessary_pages()

Rajkumar Manoharan (1):
      mac80211: Restart STA timers only on associated state

Ralf Baechle (2):
      MIPS: DMA: Fix computation of DMA flags from device's coherent_dma_mask.
      SERIAL: SC26xx: Fix link error.

Rezwanul Kabir (1):
      dell-laptop: Add another Dell laptop family to the DMI whitelist

Robert Richter (1):
      oprofile, dcookies: Fix possible circular locking dependency

Roedel, Joerg (1):
      x86, amd: Use _safe() msr access for GartTlbWlk disable code

Roland McGrath (1):
      uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc

Romain Francoise (1):
      ipv6: Silence privacy extensions initialization

Rémi Denis-Courmont (1):
      Phonet: device notifier only runs on initial namespace

Sachin Prabhu (1):
      Open with O_CREAT flag set fails to open existing files on non writable directories

Samuel Thibault (1):
      Fix Ultrastor asm snippet

Sarah Sharp (2):
      xhci: Fix full speed bInterval encoding.
      xhci: Reject double add of active endpoints.

Sergei Shtylyov (1):
      EHCI: only power off port if over-current is active

Shaohua Li (1):
      cfq-iosched: fix a rcu warning

Sjoerd Simons (1):
      uvcvideo: Remove buffers from the queues when freeing

Stefan Richter (3):
      firewire: cdev: prevent race between first get_info ioctl
      firewire: cdev: return -ENOTTY for unimplemented ioctls, not
      firewire: ohci: do not bind to Pinnacle cards, avert panic

Stefano Stabellini (1):
      xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"

Steffen Sledz (1):
      USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver

Steven Rostedt (3):
      ftrace: Only update the function code on write to filter files
      tracing: Fix bug when reading system filters on module
      tracing: Have "enable" file use refcounts like the "filter"

Suresh Siddha (1):
      x86, mtrr: lock stop machine during MTRR rendezvous sequence

Takashi Iwai (1):
      ALSA: hda - Add model=mbp55 entry for MacBookPro 7,1

Ted Ts'o (1):
      jbd: fix fsync() tid wraparound bug

Tejun Heo (1):
      libata: set queue DMA alignment to sector size for ATAPI too

Tero Kristo (1):
      cpuidle: menu: fixed wrapping timers at 4.294 seconds

Thomas Gleixner (4):
      tick: Clear broadcast active bit when switching to oneshot
      genirq: Add IRQF_FORCE_RESUME
      xen: Use IRQF_FORCE_RESUME
      clocksource: Make watchdog robust vs. interruption

Thomas Graf (2):
      ipv6: add special mode accept_ra=2 to accept RA while configured as router
      ipv6: add special mode forwarding=2 to send RS while

Thomas Jarosch (1):
      vmxnet3: Fix inconsistent LRO state after initialization

Tian, Kevin (1):
      xen mmu: fix a race window causing leave_mm BUG()

Timo Warns (4):
      fs/partitions/ldm.c: fix oops caused by corrupted partition table
      Fix corrupted OSF partition table parsing
      Validate size of EFI GUID partition entries.
      Fix for buffer overflow in ldm_frag_add not sufficient

Toby Gray (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia E7 and C7

Trond Myklebust (4):
      NFSv4.1: Ensure state manager thread dies on last umount
      SUNRPC: Deal with the lack of a SYN_SENT sk->sk_state_change callback...
      SUNRPC: Ensure the RPC client only quits on fatal signals
      SUNRPC: Fix a race between work-queue and rpc_killall_tasks

Tyler Hicks (1):
      eCryptfs: Allow 2 scatterlist entries for encrypted filenames

Vasiliy Kulikov (5):
      agp: fix arbitrary kernel memory writes
      agp: fix OOM and buffer overflow
      taskstats: don't allow duplicate entries in listener mode
      proc: restrict access to /proc/PID/io
      staging: comedi: fix infoleak to userspace

Venkatesh Pallipadi (1):
      x86: Look for IA32_ENERGY_PERF_BIAS support

Vince Weaver (1):
      ALSA: hda - MacBookPro 5,3 line-in support

Will Deacon (1):
      ARM: 6989/1: perf: do not start the PMU when no events are

Wolfgang Denk (1):
      USB: serial: add IDs for WinChipHead USB->RS232 adapter

Xufeng Zhang (2):
      ipv6/udp: Use the correct variable to determine non-blocking condition
      udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet

Yang Ruirui (1):
      ext4: release page cache in ext4_mb_load_buddy error path

Youquan Song (1):
      x86, apic: Fix spurious error interrupts triggering on all non-boot APs

john stultz (1):
      clocksource: Install completely before selecting

steven finney (1):
      Fix memory leak in cpufreq_stat

Éric Piel (1):
      Input: elantech - discard the first 2 positions on some firmwares

 Documentation/Makefile                     |    2 +-
 Documentation/kbuild/makefiles.txt         |   12 ++
 Documentation/usb/proc_usb_info.txt        |   34 +++--
 Documentation/video4linux/Makefile         |    8 -
 Documentation/video4linux/v4lgrab.c        |  201 ----------------------------
 MAINTAINERS                                |    6 +
 Makefile                                   |    7 +-
 arch/alpha/kernel/osf_sys.c                |   11 +-
 arch/arm/kernel/perf_event.c               |    6 +-
 arch/arm/kernel/sys_oabi-compat.c          |    2 +-
 arch/arm/mach-davinci/board-dm365-evm.c    |    4 +-
 arch/arm/mach-pxa/cm-x300.c                |    8 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c             |    4 +-
 arch/m68k/mm/motorola.c                    |    2 +
 arch/mips/mm/dma-default.c                 |   28 +++-
 arch/parisc/mm/init.c                      |    4 +-
 arch/powerpc/boot/Makefile                 |    2 +-
 arch/powerpc/kernel/crash.c                |    6 +-
 arch/powerpc/kernel/misc_64.S              |   13 +-
 arch/powerpc/oprofile/op_model_power4.c    |   24 +++-
 arch/powerpc/platforms/pseries/hvconsole.c |    2 +-
 arch/um/kernel/dyn.lds.S                   |   14 ++-
 arch/um/kernel/uml.lds.S                   |   17 +++
 arch/x86/include/asm/apicdef.h             |    1 +
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/msr-index.h           |    7 +
 arch/x86/include/asm/uaccess.h             |    2 +-
 arch/x86/kernel/amd_iommu.c                |   16 ++-
 arch/x86/kernel/amd_iommu_init.c           |    8 +-
 arch/x86/kernel/cpu/addon_cpuid_features.c |    1 +
 arch/x86/kernel/cpu/amd.c                  |   16 ++-
 arch/x86/kernel/cpu/intel.c                |   18 +++
 arch/x86/kernel/cpu/mcheck/mce_amd.c       |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |   12 +-
 arch/x86/kernel/cpu/mtrr/main.c            |   23 +++
 arch/x86/kernel/process_32.c               |    1 -
 arch/x86/kernel/process_64.c               |    1 -
 arch/x86/kernel/reboot.c                   |   16 +++
 arch/x86/kernel/relocate_kernel_32.S       |    2 +
 arch/x86/kernel/relocate_kernel_64.S       |    2 +
 arch/x86/lib/copy_user_64.S                |    4 +-
 arch/x86/xen/mmu.c                         |   11 ++-
 arch/x86/xen/multicalls.c                  |   12 +-
 arch/xtensa/kernel/ptrace.c                |    3 +
 block/blk-core.c                           |    5 +
 block/blk-exec.c                           |    7 +
 block/blk.h                                |    3 +-
 block/cfq-iosched.c                        |    8 +-
 drivers/ata/libata-scsi.c                  |   24 +++-
 drivers/block/brd.c                        |   11 +-
 drivers/block/loop.c                       |   11 +-
 drivers/block/nbd.c                        |    6 +
 drivers/bluetooth/btusb.c                  |    9 ++
 drivers/char/agp/generic.c                 |   19 ++-
 drivers/char/hvc_console.c                 |    8 +-
 drivers/char/i8k.c                         |   11 +-
 drivers/cpufreq/cpufreq.c                  |   20 +++-
 drivers/cpufreq/cpufreq_stats.c            |   22 +++-
 drivers/cpuidle/governors/menu.c           |    4 +-
 drivers/firewire/core-cdev.c               |   20 ++--
 drivers/firewire/ohci.c                    |    6 +
 drivers/gpu/drm/i915/intel_lvds.c          |    8 +
 drivers/gpu/drm/radeon/radeon_device.c     |    1 +
 drivers/hid/hid-apple.c                    |   46 ++++++-
 drivers/hid/hid-core.c                     |   12 ++
 drivers/hid/hid-ids.h                      |    6 +
 drivers/hwmon/applesmc.c                   |   10 ++
 drivers/hwmon/asus_atk0110.c               |    1 +
 drivers/hwmon/max1111.c                    |   11 ++
 drivers/i2c/busses/i2c-taos-evm.c          |    8 +-
 drivers/input/mouse/elantech.c             |   26 ++--
 drivers/input/mouse/elantech.h             |    7 +-
 drivers/input/xen-kbdfront.c               |   12 ++-
 drivers/md/dm-table.c                      |   17 +++
 drivers/md/md.c                            |    3 +-
 drivers/md/raid5.c                         |    2 +-
 drivers/media/dvb/b2c2/flexcop-pci.c       |    2 +-
 drivers/media/radio/si4713-i2c.c           |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    4 +
 drivers/media/video/uvc/uvc_queue.c        |    2 +
 drivers/media/video/v4l2-ioctl.c           |    6 +
 drivers/mmc/host/sdhci-pci.c               |    1 +
 drivers/mmc/host/sdhci.c                   |    9 +-
 drivers/mtd/mtdconcat.c                    |    4 +-
 drivers/net/Makefile                       |    6 +-
 drivers/net/bonding/bond_3ad.c             |    4 +
 drivers/net/bonding/bond_alb.c             |    4 +
 drivers/net/bonding/bond_main.c            |    4 +
 drivers/net/ehea/ehea_ethtool.c            |   21 ++-
 drivers/net/hamradio/6pack.c               |    4 +-
 drivers/net/hamradio/mkiss.c               |    4 +-
 drivers/net/hydra.c                        |   14 +-
 drivers/net/jme.c                          |   20 ++-
 drivers/net/ne-h8300.c                     |   16 +-
 drivers/net/netxen/netxen_nic.h            |    1 -
 drivers/net/netxen/netxen_nic_init.c       |    1 -
 drivers/net/netxen/netxen_nic_main.c       |    1 -
 drivers/net/niu.c                          |   16 +--
 drivers/net/slip.c                         |    4 +-
 drivers/net/virtio_net.c                   |   27 +++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c      |    3 +
 drivers/net/wireless/ath/ath5k/eeprom.c    |    8 +-
 drivers/net/wireless/libertas/cmd.c        |    6 +-
 drivers/net/wireless/p54/p54usb.c          |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c    |   10 ++
 drivers/net/zorro8390.c                    |   12 +-
 drivers/pci/hotplug/pcihp_slot.c           |   45 ++++++
 drivers/pci/quirks.c                       |   35 +++++
 drivers/platform/x86/dell-laptop.c         |    7 +
 drivers/scsi/megaraid/megaraid_sas.c       |    3 +
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   23 +++-
 drivers/scsi/pmcraid.c                     |    3 +
 drivers/scsi/scsi_lib.c                    |    9 +-
 drivers/scsi/scsi_scan.c                   |    2 +-
 drivers/scsi/scsi_sysfs.c                  |   17 ++-
 drivers/scsi/ultrastor.c                   |    2 +-
 drivers/serial/Kconfig                     |    2 +-
 drivers/staging/comedi/comedi_fops.c       |    4 +-
 drivers/staging/hv/netvsc_drv.c            |   14 ++-
 drivers/staging/rtl8192e/r8192E_core.c     |    6 +
 drivers/staging/rtl8192su/r8192U_core.c    |   76 +++++++++--
 drivers/staging/usbip/usbip_common.c       |    2 +-
 drivers/staging/usbip/vhci_hcd.c           |    2 +-
 drivers/usb/class/cdc-acm.c                |    2 +
 drivers/usb/core/devices.c                 |   10 +-
 drivers/usb/core/driver.c                  |   11 ++-
 drivers/usb/core/hcd-pci.c                 |    4 +-
 drivers/usb/core/hub.c                     |   19 ++-
 drivers/usb/gadget/at91_udc.c              |    2 +-
 drivers/usb/gadget/f_rndis.c               |    3 +-
 drivers/usb/host/ehci-hub.c                |    3 +-
 drivers/usb/host/ohci-hcd.c                |    9 +-
 drivers/usb/host/ohci-pci.c                |   26 ++++
 drivers/usb/host/ohci.h                    |    1 +
 drivers/usb/host/pci-quirks.c              |   46 ++++++-
 drivers/usb/host/xhci-mem.c                |   18 ++-
 drivers/usb/host/xhci.c                    |   22 +++-
 drivers/usb/musb/musb_core.c               |    2 +
 drivers/usb/serial/cp210x.c                |    4 +
 drivers/usb/serial/ftdi_sio.c              |    2 +
 drivers/usb/serial/ftdi_sio_ids.h          |    6 +
 drivers/usb/serial/garmin_gps.c            |   20 ++-
 drivers/usb/serial/moto_modem.c            |    1 +
 drivers/usb/serial/pl2303.c                |    1 +
 drivers/usb/serial/pl2303.h                |    4 +
 drivers/usb/serial/usb_wwan.c              |   15 ++-
 drivers/video/backlight/mbp_nvidia_bl.c    |   18 +++
 drivers/watchdog/mtx-1_wdt.c               |    8 +
 drivers/xen/events.c                       |    9 +-
 fs/btrfs/volumes.c                         |    4 +
 fs/cifs/connect.c                          |   10 +-
 fs/cifs/sess.c                             |    4 +-
 fs/dcookies.c                              |    3 +
 fs/ecryptfs/keystore.c                     |   46 +++----
 fs/exec.c                                  |    5 +-
 fs/ext3/namei.c                            |   13 ++-
 fs/ext4/mballoc.c                          |    2 +
 fs/fat/file.c                              |    2 +-
 fs/inode.c                                 |   22 ++-
 fs/jbd/commit.c                            |    9 +-
 fs/jbd/journal.c                           |   16 ++-
 fs/nfs/nfs4proc.c                          |   43 ++++++-
 fs/nfs/nfs4state.c                         |    4 +-
 fs/nfs/super.c                             |    9 ++
 fs/nfsd/vfs.c                              |    9 +-
 fs/nilfs2/btnode.c                         |   13 --
 fs/nilfs2/btnode.h                         |    1 -
 fs/nilfs2/super.c                          |    2 +-
 fs/partitions/efi.c                        |    6 +
 fs/partitions/ldm.c                        |   21 +++-
 fs/partitions/osf.c                        |   12 ++-
 fs/proc/base.c                             |    7 +-
 fs/ubifs/journal.c                         |    1 +
 fs/ubifs/sb.c                              |    3 +-
 fs/ubifs/shrinker.c                        |    6 +-
 fs/ubifs/super.c                           |    1 +
 include/asm-generic/bug.h                  |   16 +++
 include/linux/clocksource.h                |    1 +
 include/linux/firewire-cdev.h              |    3 +
 include/linux/fs.h                         |    2 +
 include/linux/if_packet.h                  |    2 +
 include/linux/interrupt.h                  |    3 +-
 include/linux/mm.h                         |    2 +
 include/linux/pci_ids.h                    |    1 +
 include/linux/seqlock.h                    |    4 +-
 include/linux/stop_machine.h               |    2 +
 ipc/sem.c                                  |   13 ++-
 kernel/futex.c                             |    4 +-
 kernel/irq/manage.c                        |   11 ++-
 kernel/irq/pm.c                            |    3 -
 kernel/lockdep.c                           |    2 +-
 kernel/power/snapshot.c                    |    6 +-
 kernel/power/user.c                        |    4 +-
 kernel/stop_machine.c                      |    2 +-
 kernel/taskstats.c                         |   15 ++-
 kernel/time/clocksource.c                  |   26 ++--
 kernel/time/tick-broadcast.c               |   12 ++-
 kernel/time/timekeeping.c                  |    9 +-
 kernel/trace/ftrace.c                      |   12 +-
 kernel/trace/trace.h                       |    1 +
 kernel/trace/trace_events.c                |  113 +++++++++++++---
 kernel/trace/trace_events_filter.c         |    6 +
 lib/debugobjects.c                         |    2 +-
 lib/locking-selftest.c                     |    2 +-
 mm/backing-dev.c                           |    1 +
 mm/hugetlb.c                               |   12 ++-
 mm/kmemleak.c                              |    7 +-
 mm/ksm.c                                   |    6 +
 mm/memory.c                                |   60 ++++++++-
 mm/migrate.c                               |    2 +-
 mm/nommu.c                                 |    9 +-
 mm/page_alloc.c                            |    2 +-
 net/atm/atm_sysfs.c                        |   10 ++
 net/bridge/br_multicast.c                  |    4 +-
 net/can/bcm.c                              |    7 +-
 net/can/raw.c                              |    7 +-
 net/core/filter.c                          |    4 +-
 net/dccp/options.c                         |    2 +
 net/ipv4/af_inet.c                         |    3 +
 net/ipv4/inet_diag.c                       |   14 +-
 net/ipv4/udp.c                             |    3 +
 net/ipv6/addrconf.c                        |    6 +-
 net/ipv6/ndisc.c                           |   18 ++-
 net/ipv6/netfilter/ip6t_REJECT.c           |    4 +-
 net/ipv6/udp.c                             |    5 +-
 net/mac80211/mlme.c                        |    3 +
 net/mac80211/wpa.c                         |   16 ++-
 net/netfilter/xt_DSCP.c                    |    2 +-
 net/packet/af_packet.c                     |    2 +
 net/phonet/pn_dev.c                        |    3 +
 net/sunrpc/auth_gss/auth_gss.c             |    4 +-
 net/sunrpc/clnt.c                          |    2 +-
 net/sunrpc/rpcb_clnt.c                     |    2 +-
 net/sunrpc/sched.c                         |   27 ++---
 net/sunrpc/svc_xprt.c                      |   11 +-
 net/sunrpc/xprtsock.c                      |   44 +++++--
 net/wireless/nl80211.c                     |    2 +-
 scripts/Kbuild.include                     |    5 +
 sound/pci/hda/patch_cirrus.c               |   24 +++-
 sound/pci/hda/patch_realtek.c              |    1 +
 sound/pci/hda/patch_sigmatel.c             |    2 +-
 sound/soc/codecs/ak4642.c                  |    2 +-
 sound/soc/codecs/wm8994.c                  |    2 +
 sound/soc/codecs/wm_hubs.c                 |   24 ++--
 sound/synth/emux/emux_hwdep.c              |    3 +
 tools/perf/Makefile                        |    2 +-
 247 files changed, 1851 insertions(+), 749 deletions(-)
 delete mode 100644 Documentation/video4linux/Makefile
 delete mode 100644 Documentation/video4linux/v4lgrab.c
