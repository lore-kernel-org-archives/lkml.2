Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab2EOCQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:16:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:48896 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785Ab2EOCP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:15:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 000/179] v2.6.34.12 longterm review
Date: Mon, 14 May 2012 22:11:36 -0400
Message-ID: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the v2.6.34.12 release.
There are 179 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

The full queue can be found at:
  http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git

Please try to get reponses made within 72 hours, or it may be too late.

Thanks,
Paul.
---

Alan Cox (3):
  tty: Make tiocgicount a handler
  tty: icount changeover for other main devices
  nozomi: Fix warning from the previous TIOCGCOUNT changes

Alan Stern (4):
  USB: don't let errors prevent system sleep
  USB: don't let the hub driver prevent system sleep
  USB: OHCI: fix another regression for NVIDIA controllers
  EHCI: fix direction handling for interrupt data toggles

Alasdair G Kergon (1):
  dm: fix idr leak on module removal

Andrea Arcangeli (1):
  migrate: don't account swapcache as shmem

Andres Salomon (1):
  tty: fix warning in synclink driver

Andrew Barry (1):
  mm/page_alloc.c: prevent unending loop in __alloc_pages_slowpath()

Andy Adamson (1):
  NFSv4.1: update nfs4_fattr_bitmap_maxsz

Anton Blanchard (3):
  powerpc/pseries/hvconsole: Fix dropped console output
  powerpc: Fix device tree claim code
  powerpc: pseries: Fix kexec on machines with more than 4TB of RAM

Arnd Bergmann (1):
  6pack,mkiss: fix lock inconsistency

Artem Bityutskiy (3):
  UBIFS: fix a rare memory leak in ro to rw remounting path
  UBIFS: fix shrinker object count reports
  UBIFS: fix memory leak on error path

Ben Greear (1):
  SUNRPC: Fix use of static variable in rpcb_getport_async

Benedek László (1):
  USB: serial: ftdi_sio: adding support for TavIR STK500

Carolyn Wyborny (1):
  igb: Fix lack of flush after register write and before delay

Catalin Marinas (1):
  kmemleak: Do not return a pointer to an object that kmemleak did not
    get

Chas Williams (1):
  atm: br2864: sent packets truncated in VC routed mode

Chris Wright (1):
  PCI: ARI is a PCIe v2 feature

Christian Lamparter (1):
  p54usb: add zoom 4410 usbid

Clemens Ladisch (1):
  mm: fix wrong vmap address calculations with odd NR_CPUS values

Craig Shelley (1):
  USB: CP210x Add 4 Device IDs for AC-Services Devices

Dan Carpenter (1):
  xen: off by one errors in multicalls.c

Dan Rosenberg (4):
  pmcraid: reject negative request size
  xtensa: prevent arbitrary read in ptrace
  alpha: fix several security issues
  score: fix off-by-one index into syscall table

Dan Williams (1):
  atm: expose ATM device index in sysfs

Daniel Haid (1):
  drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

Daniel J Blueman (1):
  x86: Make Dell Latitude E5420 use reboot=pci

Daniel Mack (3):
  ALSA: snd-usb-caiaq: Fix keymap for RigKontrol3
  ALSA: snd-usb-caiaq: Correct offset fields of outbound iso_frame_desc
  ALSA: snd_usb_caiaq: track submitted output urbs

Daniel T Chen (1):
  ALSA: ac97: Add HP Compaq dc5100 SFF(PT003AW) to Headphone Jack Sense
    whitelist

Dave Jones (1):
  Remove cpufreq_stats sysfs entries on module unload.

David Chang (1):
  staging: usbip: fix wrong endian conversion

David Henningsson (1):
  ALSA: HDA: Use one dmic only for Dell Studio 1558

David S. Miller (2):
  crypto: Move md5_transform to lib/md5.c
  net: Compute protocol sequence numbers and fragment IDs using MD5.

Dmitry Torokhov (1):
  USB: xhci - fix interval calculation for FS isoc endpoints

Douglas Gilbert (1):
  ses: requesting a fault indication

Elizabeth Jennifer Myers (1):
  USB: moto_modem: Add USB identifier for the Motorola VE240.

Eric B Munson (1):
  powerpc/oprofile: Handle events that raise an exception without
    overflowing

Eric Dumazet (1):
  af_packet: prevent information leak

Eugene A. Shatokhin (1):
  ath5k: fix memory leak when fewer than N_PD_CURVES are in use

Felipe Balbi (1):
  usb: gadget: rndis: don't test against req->length

Felix Radensky (1):
  mtd: mtdconcat: fix NAND OOB write

Fernando Luis Vazquez Cao (2):
  netfilter: IPv6: initialize TOS field in REJECT target module
  netfilter: IPv6: fix DSCP mangle code

Florian Fainelli (1):
  watchdog: mtx1-wdt: request gpio before using it

Frederic Weisbecker (1):
  rcu: Fix unpaired rcu_irq_enter() from locking selftests

Greg Kroah-Hartman (1):
  USB: pl2303.h: checkpatch cleanups

Guo-Fu Tseng (1):
  jme: Fix unmap error (Causing system freeze)

H. Peter Anvin (1):
  x86-32, vdso: On system call restart after SYSENTER, use int $0x80

Hans Verkuil (3):
  v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
  pvrusb2: fix g/s_tuner support
  bttv: fix s_tuner for radio

Hans de Goede (1):
  drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

Hemant Pedanekar (1):
  PCI: Add quirk for setting valid class for TI816X Endpoint

Hermann Kneissel (1):
  USB: gamin_gps: Fix for data transfer problems in native mode

Huang Ying (1):
  kexec, x86: Fix incorrect jump back address if not preserving context

Hugh Dickins (2):
  mm: fix ENOSPC returned by handle_mm_fault()
  ksm: fix NULL pointer dereference in scan_get_next_rmap_item()

Ian Campbell (1):
  xen: events: do not unmask event channels on resume

Igor Grinberg (1):
  ARM: pxa/cm-x300: fix V3020 RTC functionality

J. Bruce Fields (1):
  svcrpc: fix list-corrupting race on nfsd shutdown

Jack Steiner (1):
  x86, UV: Remove UV delay in starting slave cpus

Jacob Shin (1):
  CPU hotplug, re-create sysfs directory and symlinks

James Bottomley (3):
  block: add proper state guards to __elv_next_request
  Fix oops caused by queue refcounting failure
  pata_cm64x: fix boot crash on parisc

Jan Kara (3):
  ext3: Fix fs corruption when make_indexed_dir() fails
  jbd: Fix forever sleeping process in do_get_write_access()
  ext3: Fix oops in ext3_try_to_allocate_with_rsv()

Jean Delvare (1):
  i2c-taos-evm: Fix log messages

Jean-Christophe PLAGNIOL-VILLARD (1):
  usb/gadget: at91sam9g20 fix end point max packet size

Jeff Layton (3):
  cifs: clean up cifs_find_smb_ses (try #2)
  cifs: fix NULL pointer dereference in cifs_find_smb_ses
  cifs: check for NULL session password

Jens Axboe (2):
  block: export blk_{get,put}_queue()
  cfq-iosched: fix locking around ioc->ioc_data assignment

JiSheng Zhang (1):
  USB: xhci: fix OS want to own HC

Jiri Olsa (1):
  x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace
    address limit

Jiri Slaby (1):
  TTY: ldisc, do not close until there are readers

Joe Perches (2):
  bug.h: Add WARN_RATELIMIT
  net: filter: Use WARN_RATELIMIT

Joerg Roedel (1):
  x86/amd-iommu: Fix 3 possible endless loops

Johannes Weiner (1):
  xfs: properly account for reclaimed inodes

Jon Povey (1):
  davinci: DM365 EVM: fix video input mux bits

Jonathan Nieder (3):
  perf tools: do not look at ./config for configuration
  x86/PCI: use host bridge _CRS info on MSI MS-7253
  x86/PCI: do not tie MSI MS-7253 use_crs quirk to BIOS version

Jordan_Hargrave@Dell.com (1):
  PCI: Set PCIE maxpayload for card during hotplug insertion

Julia Lawall (2):
  ALSA: sound/core/pcm_compat.c: adjust array index
  hwmon: (ibmaem) add missing kfree

Kasper Pedersen (1):
  time: Compensate for rounding on odd-frequency clocksources

Libor Pechacek (1):
  USB: core: Tolerate protocol stall during hub and port status read

Luben Tuikov (1):
  libsas: remove expander from dev list on error

Luca Tettamanti (1):
  i8k: Avoid lahf in 64-bit code

Luciano Coelho (1):
  nl80211: fix check for valid SSID size in scan operations

Marcin Slusarz (2):
  debugobjects: Fix boot crash when kmemleak and debugobjects enabled
  drm/ttm: fix ttm_bo_add_ttm(user) failure path

Marcus Meissner (1):
  net/ipv4: Check for mistakenly passed in non-IPv4 address

Mark Brown (3):
  ASoC: Ensure output PGA is enabled for line outputs in wm_hubs
  ASoC: Add some missing volume update bit sets for wm_hubs devices
  ASoC: Fix Blackfin I2S _pointer() implementation return in bounds
    values

Mathias Krause (1):
  exec: delay address limit change until point of no return

Mauro Carvalho Chehab (1):
  si4713-i2c: avoid potential buffer overflow on si4713

Maxim Nikulin (1):
  USB: assign instead of equal in usbtmc.c

Michael Neuling (1):
  powerpc/kdump: Fix timeout in crash_kexec_wait_realmode

Michal Kubecek (1):
  PM: Free memory bitmaps if opening /dev/snapshot fails

Mike Snitzer (1):
  dm mpath: fix potential NULL pointer in feature arg processing

Miklos Szeredi (2):
  mm: prevent concurrent unmap_mapping_range() on the same inode
  fuse: check size of FUSE_NOTIFY_INVAL_ENTRY message

Milan Broz (1):
  dm table: reject devices without request fns

Milton Miller (2):
  powerpc/kexec: Fix memory corruption from unallocated slaves
  seqlock: Don't smp_rmb in seqlock reader spin loop

Namhyung Kim (8):
  loop: limit 'max_part' module param to DISK_MAX_PARTS
  loop: handle on-demand devices correctly
  brd: limit 'max_part' module param to DISK_MAX_PARTS
  brd: handle on-demand devices correctly
  nbd: limit module parameters to a sane value
  md: check ->hot_remove_disk when removing disk
  md/raid5: fix raid5_set_bi_hw_segments
  md/raid5: fix FUA request handling in ops_run_io()

NeilBrown (1):
  md: avoid endless recovery loop when waiting for fail device to
    complete.

Nick Bowler (1):
  USB: usb-storage: unusual_devs entry for ARM V2M motherboard.

OGAWA Hirofumi (1):
  fat: Fix corrupt inode flags when remove ATTR_SYS flag

Pavel Herrmann (1):
  hwmon: (max1111) Fix race condition causing NULL pointer exception

Peter Zijlstra (1):
  lockdep: Fix lock_is_held() on recursion

Rafael Aquini (1):
  mm: fix negative commitlimit when gigantic hugepages are allocated

Rafael J. Wysocki (2):
  PM / Hibernate: Avoid hitting OOM during preallocation of memory
  PM / Hibernate: Fix free_unnecessary_pages()

Rajkumar Manoharan (1):
  mac80211: Restart STA timers only on associated state

Robert Richter (1):
  oprofile, dcookies: Fix possible circular locking dependency

Roedel, Joerg (1):
  x86, amd: Use _safe() msr access for GartTlbWlk disable code

Roland McGrath (1):
  uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc

Samuel Thibault (1):
  Fix Ultrastor asm snippet

Sarah Sharp (2):
  xhci: Fix full speed bInterval encoding.
  xhci: Reject double add of active endpoints.

Sergei Shtylyov (1):
  EHCI: only power off port if over-current is active

Shaohua Li (1):
  cfq-iosched: fix a rcu warning

Shawn Bohrer (1):
  futex: Fix regression with read only mappings

Sjoerd Simons (1):
  uvcvideo: Remove buffers from the queues when freeing

Stefano Stabellini (1):
  xen: partially revert "xen: set max_pfn_mapped to the last pfn
    mapped"

Steffen Sledz (1):
  USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver

Stephen M. Cameron (1):
  cciss: do not attempt to read from a write-only register

Steven Rostedt (1):
  ftrace: Only update the function code on write to filter files

Takashi Iwai (1):
  ALSA: timer - Fix Oops at closing slave timer

Ted Ts'o (1):
  jbd: fix fsync() tid wraparound bug

Tejun Heo (1):
  libata: fix unexpectedly frozen port after ata_eh_reset()

Tero Kristo (1):
  cpuidle: menu: fixed wrapping timers at 4.294 seconds

Thomas Gleixner (5):
  genirq: Add IRQF_FORCE_RESUME
  xen: Use IRQF_FORCE_RESUME
  clocksource: Make watchdog robust vs. interruption
  x86: Hpet: Avoid the comparator readback penalty
  x86: HPET: Chose a paranoid safe value for the ETIME check

Tian, Kevin (1):
  xen mmu: fix a race window causing leave_mm BUG()

Toby Gray (1):
  USB: cdc-acm: Adding second ACM channel support for Nokia E7 and C7

Trond Myklebust (3):
  SUNRPC: Deal with the lack of a SYN_SENT sk->sk_state_change
    callback...
  SUNRPC: Ensure the RPC client only quits on fatal signals
  SUNRPC: Fix a race between work-queue and rpc_killall_tasks

Tyler Hicks (1):
  eCryptfs: Allow 2 scatterlist entries for encrypted filenames

Vasiliy Kulikov (2):
  staging: comedi: fix infoleak to userspace
  proc: restrict access to /proc/PID/io

Vijay Chavan (1):
  USB: Serial: Added device ID for Qualcomm Modem in Sagemcom's HiLo3G

Werner Fink (1):
  Blacklist Traxdata CDR4120 and IOMEGA Zip drive to avoid lock ups.

Wolfgang Denk (1):
  USB: serial: add IDs for WinChipHead USB->RS232 adapter

Xufeng Zhang (2):
  ipv6/udp: Use the correct variable to determine non-blocking
    condition
  udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet

Yang Ruirui (1):
  ext4: release page cache in ext4_mb_load_buddy error path

stephen hemminger (1):
  bridge: send proper message_age in config BPDU

steven finney (1):
  Fix memory leak in cpufreq_stat

 arch/alpha/kernel/osf_sys.c                |   11 +-
 arch/arm/mach-davinci/board-dm365-evm.c    |    4 +-
 arch/arm/mach-pxa/cm-x300.c                |    8 +-
 arch/ia64/hp/sim/simserial.c               |   12 +-
 arch/powerpc/kernel/crash.c                |    6 +-
 arch/powerpc/kernel/misc_64.S              |   13 +-
 arch/powerpc/kernel/prom_init.c            |    6 +-
 arch/powerpc/oprofile/op_model_power4.c    |   24 +-
 arch/powerpc/platforms/pseries/hvconsole.c |    2 +-
 arch/powerpc/platforms/pseries/lpar.c      |    2 +-
 arch/score/kernel/entry.S                  |    2 +-
 arch/um/kernel/dyn.lds.S                   |   14 +-
 arch/um/kernel/uml.lds.S                   |   17 ++
 arch/x86/include/asm/uaccess.h             |    2 +-
 arch/x86/kernel/amd_iommu_init.c           |    8 +-
 arch/x86/kernel/apic/x2apic_uv_x.c         |    1 -
 arch/x86/kernel/cpu/amd.c                  |    9 +-
 arch/x86/kernel/hpet.c                     |   53 +++--
 arch/x86/kernel/process_32.c               |    1 -
 arch/x86/kernel/process_64.c               |    1 -
 arch/x86/kernel/reboot.c                   |    8 +
 arch/x86/kernel/relocate_kernel_32.S       |    2 +
 arch/x86/kernel/relocate_kernel_64.S       |    2 +
 arch/x86/lib/copy_user_64.S                |    4 +-
 arch/x86/pci/acpi.c                        |   10 +
 arch/x86/vdso/vdso32/sysenter.S            |    2 +-
 arch/x86/xen/mmu.c                         |   11 +-
 arch/x86/xen/multicalls.c                  |   12 +-
 arch/xtensa/kernel/ptrace.c                |    3 +
 block/blk-core.c                           |    2 +
 block/blk.h                                |    3 +-
 block/cfq-iosched.c                        |    8 +-
 crypto/md5.c                               |   92 +-------
 drivers/ata/libata-eh.c                    |   12 +-
 drivers/ata/pata_cmd64x.c                  |   42 +++-
 drivers/block/brd.c                        |   11 +-
 drivers/block/cciss.h                      |    2 +-
 drivers/block/loop.c                       |   11 +-
 drivers/block/nbd.c                        |    6 +
 drivers/char/amiserial.c                   |   56 ++---
 drivers/char/cyclades.c                    |   49 ++--
 drivers/char/i8k.c                         |    4 +-
 drivers/char/ip2/ip2main.c                 |   72 +++---
 drivers/char/mxser.c                       |   62 +++---
 drivers/char/nozomi.c                      |   38 ++--
 drivers/char/pcmcia/synclink_cs.c          |   61 +++--
 drivers/char/random.c                      |  334 +---------------------------
 drivers/char/synclink.c                    |   73 +++---
 drivers/char/synclink_gt.c                 |   56 ++---
 drivers/char/synclinkmp.c                  |   61 +++--
 drivers/char/tty_io.c                      |   21 ++
 drivers/char/tty_ldisc.c                   |    4 +-
 drivers/cpufreq/cpufreq.c                  |   20 +-
 drivers/cpufreq/cpufreq_stats.c            |   22 +-
 drivers/cpuidle/governors/menu.c           |    4 +-
 drivers/gpu/drm/i915/intel_lvds.c          |    8 +
 drivers/gpu/drm/radeon/radeon_device.c     |    1 +
 drivers/gpu/drm/ttm/ttm_bo.c               |    4 +-
 drivers/hwmon/ibmaem.c                     |   15 +-
 drivers/hwmon/max1111.c                    |   11 +
 drivers/i2c/busses/i2c-taos-evm.c          |    8 +-
 drivers/md/dm-mpath.c                      |    5 +
 drivers/md/dm-table.c                      |   17 ++
 drivers/md/dm.c                            |   10 +-
 drivers/md/md.c                            |    3 +-
 drivers/md/raid5.c                         |    8 +-
 drivers/media/radio/si4713-i2c.c           |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    4 +
 drivers/media/video/uvc/uvc_queue.c        |    2 +
 drivers/media/video/v4l2-ioctl.c           |    6 +
 drivers/mtd/mtdconcat.c                    |    4 +-
 drivers/net/hamradio/6pack.c               |    4 +-
 drivers/net/hamradio/mkiss.c               |    4 +-
 drivers/net/igb/e1000_82575.c              |    1 +
 drivers/net/jme.c                          |   20 +-
 drivers/net/wireless/ath/ath5k/eeprom.c    |    8 +-
 drivers/net/wireless/p54/p54usb.c          |    1 +
 drivers/pci/hotplug/pcihp_slot.c           |   45 ++++
 drivers/pci/pci.c                          |    7 +-
 drivers/pci/quirks.c                       |   10 +
 drivers/scsi/libsas/sas_expander.c         |    3 +
 drivers/scsi/pmcraid.c                     |    3 +
 drivers/scsi/scsi_devinfo.c                |    2 +
 drivers/scsi/scsi_scan.c                   |    2 +-
 drivers/scsi/scsi_sysfs.c                  |    1 +
 drivers/scsi/ses.c                         |    6 +-
 drivers/scsi/ultrastor.c                   |    2 +-
 drivers/serial/68360serial.c               |   51 +++--
 drivers/serial/serial_core.c               |   35 ++-
 drivers/staging/comedi/comedi_fops.c       |    4 +-
 drivers/staging/usbip/usbip_common.c       |    2 +-
 drivers/usb/class/cdc-acm.c                |    2 +
 drivers/usb/class/usbtmc.c                 |    2 +-
 drivers/usb/core/driver.c                  |   11 +-
 drivers/usb/core/hub.c                     |   19 +-
 drivers/usb/gadget/at91_udc.c              |    2 +-
 drivers/usb/gadget/f_rndis.c               |    3 +-
 drivers/usb/host/ehci-hub.c                |    3 +-
 drivers/usb/host/ehci-q.c                  |    3 +-
 drivers/usb/host/ehci.h                    |    1 +
 drivers/usb/host/pci-quirks.c              |   30 ++-
 drivers/usb/host/xhci-mem.c                |   18 +-
 drivers/usb/host/xhci.c                    |   22 +-
 drivers/usb/serial/cp210x.c                |    4 +
 drivers/usb/serial/ftdi_sio.c              |    2 +
 drivers/usb/serial/ftdi_sio_ids.h          |    6 +
 drivers/usb/serial/garmin_gps.c            |   20 +-
 drivers/usb/serial/moto_modem.c            |    1 +
 drivers/usb/serial/pl2303.c                |    1 +
 drivers/usb/serial/pl2303.h                |   10 +-
 drivers/usb/serial/qcserial.c              |    1 +
 drivers/usb/serial/usb-serial.c            |   13 ++
 drivers/usb/storage/unusual_devs.h         |   10 +
 drivers/watchdog/mtx-1_wdt.c               |    9 +
 drivers/xen/events.c                       |   10 +-
 fs/cifs/cifsglob.h                         |    2 +-
 fs/cifs/connect.c                          |   28 ++-
 fs/dcookies.c                              |    3 +
 fs/ecryptfs/keystore.c                     |   46 ++--
 fs/exec.c                                  |    5 +-
 fs/ext3/namei.c                            |   15 +-
 fs/ext3/xattr.c                            |   12 +-
 fs/ext4/mballoc.c                          |    2 +
 fs/fat/file.c                              |    2 +-
 fs/fuse/dev.c                              |    4 +
 fs/gfs2/main.c                             |    9 +-
 fs/inode.c                                 |   22 +-
 fs/jbd/commit.c                            |    9 +-
 fs/jbd/journal.c                           |   16 +-
 fs/nfs/nfs4xdr.c                           |    2 +-
 fs/nilfs2/btnode.c                         |   14 --
 fs/nilfs2/btnode.h                         |    1 -
 fs/nilfs2/super.c                          |    2 +-
 fs/proc/base.c                             |    7 +-
 fs/ubifs/journal.c                         |    1 +
 fs/ubifs/sb.c                              |    3 +-
 fs/ubifs/shrinker.c                        |    6 +-
 fs/ubifs/super.c                           |    1 +
 fs/xfs/linux-2.6/xfs_sync.c                |   10 +-
 fs/xfs/linux-2.6/xfs_sync.h                |    2 +
 fs/xfs/xfs_iget.c                          |    1 +
 include/asm-generic/bug.h                  |   16 ++
 include/linux/clocksource.h                |    1 +
 include/linux/cryptohash.h                 |    5 +
 include/linux/fs.h                         |    2 +
 include/linux/if_packet.h                  |    2 +
 include/linux/interrupt.h                  |    3 +-
 include/linux/pci_ids.h                    |    2 +
 include/linux/random.h                     |   11 -
 include/linux/seqlock.h                    |    4 +-
 include/linux/tty_driver.h                 |    9 +
 include/linux/usb/serial.h                 |    2 +
 include/net/secure_seq.h                   |   20 ++
 kernel/futex.c                             |   54 ++++-
 kernel/irq/manage.c                        |   11 +-
 kernel/irq/pm.c                            |    3 -
 kernel/lockdep.c                           |    2 +-
 kernel/power/snapshot.c                    |   89 ++++++--
 kernel/power/user.c                        |    4 +-
 kernel/time/clocksource.c                  |   24 +-
 kernel/time/timekeeping.c                  |    9 +-
 kernel/trace/ftrace.c                      |   12 +-
 lib/Makefile                               |    2 +-
 lib/debugobjects.c                         |    2 +-
 lib/locking-selftest.c                     |    2 +-
 lib/md5.c                                  |   95 ++++++++
 mm/hugetlb.c                               |   12 +-
 mm/kmemleak.c                              |    7 +-
 mm/ksm.c                                   |    6 +
 mm/memory.c                                |    2 +
 mm/migrate.c                               |    2 +-
 mm/page_alloc.c                            |    2 +-
 mm/vmalloc.c                               |    7 +-
 net/atm/atm_sysfs.c                        |   10 +
 net/atm/br2684.c                           |    2 -
 net/bluetooth/rfcomm/tty.c                 |    4 -
 net/bridge/br_private.h                    |    1 +
 net/bridge/br_stp.c                        |    4 +-
 net/core/Makefile                          |    2 +-
 net/core/filter.c                          |    4 +-
 net/core/secure_seq.c                      |  184 +++++++++++++++
 net/dccp/ipv4.c                            |    1 +
 net/dccp/ipv6.c                            |    9 +-
 net/ipv4/af_inet.c                         |    3 +
 net/ipv4/inet_hashtables.c                 |    1 +
 net/ipv4/inetpeer.c                        |    1 +
 net/ipv4/netfilter/nf_nat_proto_common.c   |    1 +
 net/ipv4/route.c                           |    1 +
 net/ipv4/tcp_ipv4.c                        |    1 +
 net/ipv4/udp.c                             |    3 +
 net/ipv6/inet6_hashtables.c                |    1 +
 net/ipv6/netfilter/ip6t_REJECT.c           |    4 +-
 net/ipv6/tcp_ipv6.c                        |    1 +
 net/ipv6/udp.c                             |    5 +-
 net/mac80211/mlme.c                        |    3 +
 net/netfilter/xt_DSCP.c                    |    2 +-
 net/packet/af_packet.c                     |    2 +
 net/sunrpc/auth_gss/auth_gss.c             |    4 +-
 net/sunrpc/clnt.c                          |    2 +-
 net/sunrpc/rpcb_clnt.c                     |    2 +-
 net/sunrpc/sched.c                         |   27 +--
 net/sunrpc/svc_xprt.c                      |   11 +-
 net/sunrpc/xprtsock.c                      |   16 +-
 net/wireless/nl80211.c                     |    2 +-
 sound/core/pcm_compat.c                    |    2 +-
 sound/core/timer.c                         |    2 +
 sound/pci/ac97/ac97_patch.c                |    1 +
 sound/pci/hda/patch_sigmatel.c             |    2 +-
 sound/soc/blackfin/bf5xx-i2s-pcm.c         |   13 +-
 sound/soc/codecs/wm_hubs.c                 |   24 +-
 sound/usb/caiaq/audio.c                    |   37 ++-
 sound/usb/caiaq/device.h                   |    1 +
 sound/usb/caiaq/input.c                    |    2 +-
 tools/perf/util/config.c                   |    7 -
 215 files changed, 1794 insertions(+), 1162 deletions(-)
 create mode 100644 include/net/secure_seq.h
 create mode 100644 lib/md5.c
 create mode 100644 net/core/secure_seq.c

-- 
1.7.9.6

