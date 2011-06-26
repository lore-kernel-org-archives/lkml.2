Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1FZSLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 14:11:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:60494 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1FZSJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 14:09:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, lwn@lwn.net,
        stable@kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [ANNOUNCE] Linux 2.6.34.10 has been released
Date: Sun, 26 Jun 2011 14:09:38 -0400
Message-Id: <1309111778-7493-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new longterm 2.6.34.10 kernel has been released. This release contains
security fixes and all 2.6.34 users are encouraged to update. This
continues the 2.6.34 stable series under the new "longterm" name.

Git:
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.34.y.git

Gitweb:
http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.34.y.git

Tarballs/patches:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.34/


Aaro Koskinen (1):
  procfs: fix /proc/<pid>/maps heap check

Al Viro (1):
  MIPS: secure_computing, syscall audit: syscall number should in r2,
    not r0.

Alan Stern (11):
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

Alex Deucher (5):
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

Alexander van Heukelum (1):
  x86, binutils, xen: Fix another wrong size directive

Amir Goldstein (1):
  ext3: skip orphan cleanup on rocompat fs

Amitkumar Karwar (1):
  ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Andreas Herrmann (2):
  x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
  x86, quirk: Fix SB600 revision check

Andrey Vagin (1):
  x86/mm: Handle mm_fault_error() in kernel space

Anton Blanchard (6):
  kernel/smp.c: fix smp_call_function_many() SMP race
  RxRPC: Fix v1 keys
  powerpc/kdump: CPUs assume the context of the oopsing CPU
  powerpc/kdump: Use chip->shutdown to disable IRQs
  powerpc: Use more accurate limit for first segment memory allocations
  perf, powerpc: Handle events that raise an exception without
    overflowing

Arvid Ephraim Picciani (1):
  USB: cdc-acm: Adding second ACM channel support for Nokia N8

Axel Lin (1):
  mtd: add "platform:" prefix for platform modalias

Ben Hutchings (2):
  bonding/vlan: Avoid mangled NAs on slaves without VLAN tag insertion
  PCI: sysfs: Fix failure path for addition of "vpd" attribute

Benjamin Herrenschmidt (1):
  powerpc: Fix some 6xx/7xxx CPU setup functions

Bjørn Mork (1):
  USB: io_edgeport: fix the reported firmware major and minor

Brandeburg, Jesse (1):
  PCI: remove quirk for pre-production systems

Bruce Allan (1):
  e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup
    instead

Chris Wilson (1):
  drm/i915: Add dependency on CONFIG_TMPFS

Christian Lamparter (3):
  p54: fix sequence no. accounting off-by-one error
  p54pci: update receive dma buffers before and after processing
  p54usb: add Senao NUB-350 usbid

Christoph Hellwig (1):
  xfs: always use iget in bulkstat

Chuck Lever (1):
  NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (1):
  ALSA: hrtimer: handle delayed timer interrupts

Craig Shelley (2):
  USB: CP210x Add two device IDs
  USB: CP210x Removed incorrect device ID

Dan Carpenter (2):
  sched: Remove some dead code
  keyboard: integer underflow bug

Dan Rosenberg (4):
  mpt2sas: prevent heap overflows and unchecked reads
  irda: prevent integer underflow in IRLMP_ENUMDEVICES
  CAN: Use inode instead of kernel address for /proc file
  xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1

Dario Lombardo (1):
  drivers: update to pl2303 usb-serial to support Motorola cables

Dave Chinner (4):
  xfs: validate untrusted inode numbers during lookup
  xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
  xfs: remove block number from inode lookup code
  xfs: fix untrusted inode number lookup

David Henningsson (2):
  ALSA: HDA: Fix dmesg output of HDMI supported bits
  ALSA: HDA: Add position_fix quirk for an Asus device

David Howells (1):
  CRED: Fix get_task_cred() and task_state() to not resurrect dead
    credentials

David Miller (1):
  klist: Fix object alignment on 64-bit.

Davide Libenzi (1):
  epoll: prevent creating circular epoll structures

Dimitris Papastamos (1):
  ASoC: WM8990: msleep() takes milliseconds not jiffies

Don Fry (1):
  iwlagn: Re-enable RF_KILL interrupt when down

Don Skidmore (1):
  ixgbe: fix for 82599 erratum on Header Splitting

Don Zickus (1):
  x86: Use u32 instead of long to set reset vector back to 0

Edgar (gimli) Hucek (1):
  input: bcm5974: Add support for MacBookAir3

Eric Paris (2):
  SELinux: define permissions for DCB netlink messages
  SELinux: do not compute transition labels on mountpoint labeled
    filesystems

Eric Sandeen (1):
  ext3: Always set dx_node's fake_dirent explicitly.

Felipe Balbi (1):
  usb: musb: core: set has_tt flag

Florian Fainelli (1):
  MIPS: MTX-1: Make au1000_eth probe all PHY addresses

Geert Uytterhoeven (1):
  radio-aimslab.c needs #include <linux/delay.h>

Gerrit Renker (1):
  dccp: fix oops on Reset after close

Greg Kroah-Hartman (1):
  rt2x00: add device id for windy31 usb device

Guy Martin (1):
  parisc : Remove broken line wrapping handling pdc_iodc_print()

Haiyang Zhang (1):
  staging: hv: Enable sending GARP packet after live migration

Hans de Goede (1):
  hwmon/f71882fg: Set platform drvdata to NULL later

Henry Nestler (1):
  fbcon: Bugfix soft cursor detection in Tile Blitting

Herbert Xu (1):
  udp: Fix bogus UFO packet generation

Hugh Dickins (1):
  mm: fix possible cause of a page_mapped BUG

Ian Abbott (1):
  staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ian Campbell (1):
  arp_notify: unconditionally send gratuitous ARP for
    NETDEV_NOTIFY_PEERS.

Igor Mammedov (1):
  Input: xen-kbdfront - fix mouse getting stuck after save/restore

Ionut Nicu (1):
  USB: ti_usb: fix module removal

Ivan Vecera (1):
  r8169: use RxFIFO overflow workaround for 8168c chipset.

James Bottomley (2):
  fix medium error problems with some arrays which can cause data
    corruption
  libsas: fix runaway error handler problem

Jan Engelhardt (1):
  netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Jean Delvare (2):
  hwmon: (via686a) Initialize fan_div values
  i2c: Unregister dummy devices last on adapter removal

Jean-Christophe PLAGNIOL-VILLARD (1):
  USB: ftdi_sio: add ST Micro Connect Lite uart support

Jeremy Fitzhardinge (1):
  x86/pvclock: Zero last_value on resume

Jiri Kosina (1):
  Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Jiri Slaby (3):
  USB: serial/kobil_sct, fix potential tty NULL dereference
  PCI: add more checking to ICH region quirks
  PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Jochen Friedrich (1):
  mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Johan Hovold (4):
  usb: musb: omap2430: fix kernel panic on reboot
  USB: cdc-acm: fix potential null-pointer dereference on disconnect
  USB: cdc-acm: fix potential null-pointer dereference
  USB: cdc-acm: fix memory corruption / panic

Jon Thomas (1):
  sierra: add new ID for Airprime/Sierra USB IP modem

Josef Bacik (1):
  fs: call security_d_instantiate in d_obtain_alias V2

Josh Hunt (1):
  ext2: Fix link count corruption under heavy link+rename load

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

Kees Cook (2):
  usb: iowarrior: don't trust report_size for buffer size
  proc: protect mm start_code/end_code in /proc/pid/stat

Knut Petersen (1):
  drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive
    LVDS

Konstantin Khorenko (1):
  NFSD: memory corruption due to writing beyond the stat array

Kulikov Vasiliy (1):
  net: tipc: fix information leak to userland

Ky Srinivasan (1):
  Staging: hv: fix sysfs symlink on hv block device

Li Zefan (2):
  sched: Remove remaining USER_SCHED code
  cpuset: add a missing unlock in cpuset_write_resmask()

Libor Pechacek (1):
  USB: serial: handle Data Carrier Detect changes

Linus Torvalds (1):
  net: fix rds_iovec page count overflow

Maciej Szmigiero (2):
  USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
  USB: Add quirk for Samsung Android phone modem

Martin Schwidefsky (1):
  s390: remove task_show_regs

Matt Evans (1):
  powerpc/kexec: Fix orphaned offline CPUs across kexec

Matthew Garrett (1):
  acer-wmi: Fix capitalisation of GUID

Mauro Carvalho Chehab (2):
  radio-aimslab.c: Fix gcc 4.5+ bug
  em28xx: Fix audio input for Terratec Grabby

Max Vozeler (4):
  staging: usbip: vhci: update reference count for usb_device
  staging: usbip: vhci: give back URBs from in-flight unlink requests
  staging: usbip: vhci: refuse to enqueue for dead connections
  staging: usbip: vhci: use urb->dev->portnum to find port

Maxim Uvarov (1):
  powerpc/crashdump: Do not fail on NULL pointer dereferencing

Mi Jinlong (2):
  nfsd: wrong index used in inner loop
  nfsd41: modify the members value of nfsd4_op_flags

Michael Neuling (4):
  powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
  powerpc/kexec: Speedup kexec hash PTE tear down
  powerpc/kexec: Fix race in kexec shutdown
  powerpc/kdump: Fix race in kdump shutdown

Michael Williamson (1):
  USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research
    spectrograph

Michal Schmidt (1):
  PCI: return correct value when writing to the "reset" attribute

Mike Frysinger (1):
  ASoC: Blackfin AC97: fix build error after multi-component update

Mike Snitzer (2):
  dm: dont take i_mutex to change device size
  dm mpath: disable blk_abort_queue

Miklos Szeredi (1):
  fuse: fix hang of single threaded fuseblk filesystem

Milton Miller (5):
  virtio: remove virtio-pci root device
  call_function_many: fix list delete vs add race
  call_function_many: add missing ordering
  smp_call_function_many: handle concurrent clearing of mask
  powerpc: rtas_flash needs to use rtas_data_buf

Márton Németh (1):
  staging: usbip: remove double giveback of URB

NeilBrown (2):
  nfsd: correctly handle return value from nfsd_map_name_to_*
  md: correctly handle probe of an 'mdp' device.

Nelson Elhage (2):
  inet_diag: Make sure we actually run the same bytecode we audited.
  netlink: Make nlmsg_find_attr take a const nlmsghdr*.

Nick Holloway (1):
  USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolaus Colberg (1):
  USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Olaf Hering (1):
  Input: xen-kbdfront - advertise either absolute or relative
    coordinates

Paul E. McKenney (2):
  sched: suppress RCU lockdep splat in task_fork_fair
  powerpc: Fix default_machine_crash_shutdown #ifdef botch

Paul Fox (1):
  rtc-cmos: fix suspend/resume

Paul Zimmerman (4):
  xhci: Avoid BUG() in interrupt context
  xhci: Clarify some expressions in the TRB math
  xhci: Fix errors in the running total calculations in the TRB math
  xhci: Fix an error in count_sg_trbs_needed()

Pavel Machek (1):
  serial: unbreak billionton CF card

Pavel Shilovsky (1):
  CIFS: Fix oplock break handling (try #2)

Peter Holik (1):
  USB: uss720 fixup refcount position

Peter Zijlstra (3):
  sched: fix RCU lockdep splat from task_group()
  sched, cgroup: Fixup broken cgroup movement
  sched: Fix wake_affine() vs RT tasks

Pieter Maes (1):
  USB: serial: Updated support for ICOM devices

Przemyslaw Bruski (3):
  ALSA: ctxfi - Fix incorrect SPDIF status bit mask
  ALSA: ctxfi - Fix SPDIF status retrieval
  ALSA: ctxfi - Clear input settings before initialization

Rajiv Andrade (1):
  TPM: Long default timeout fix

Raymond Yau (1):
  ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Richard Schütz (2):
  USB: usb-storage: unusual_devs update for Cypress ATACB
  USB: usb-storage: unusual_devs update for TrekStor DataStation maxi
    g.u external hard drive enclosure

Robin Holt (1):
  epoll: convert max_user_watches to long

Roman Fietze (1):
  i2c: Fix typo in instantiating-devices document

Ruben Smits (1):
  staging: comedi: add support for newer jr3 1-channel pci board

Russell King (1):
  ARM: Ensure predictable endian state on signal handler entry

Sarah Sharp (2):
  usb: Realloc xHCI structures after a hub is verified.
  xhci: Fix cycle bit calculation during stall handling.

Sean Hefty (2):
  RDMA/cma: Fix crash in request handlers
  IB/cm: Bump reference count on cm_id before invoking callback

Senthil Balasubramanian (1):
  ath9k_hw: Fix incorrect macversion and macrev checks

Seth Heasley (3):
  ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
  ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
  ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
  x86: Flush TLB if PGD entry is changed in i386 PAE mode

Stanislaw Gruszka (4):
  iwlagn: enable only rfkill interrupt when device is down
  hostap_cs: fix sleeping function called from invalid context
  PM / Hibernate: Return error code when alloc_image_page() fails
  r8169: disable ASPM

Stefan Nilsson XK (1):
  mmc: sdio: remember new card RCA when redetecting card

Stephan Lachowsky (1):
  uvcvideo: Fix uvc_fixup_video_ctrl() format search

Steven Rostedt (1):
  ftrace: Fix memory leak with function graph and cpu hotplug

Stuart Hayes (1):
  dcdbas: force SMI to happen when expected

Suresh Siddha (3):
  x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
  x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask
    after switching mm
  sched: Move sched_avg_update() to update_cpu_load()

Sven Neumann (1):
  ds2760_battery: Fix calculation of time_to_empty_now

Takashi Iwai (1):
  ALSA: hda - Fix memory leaks in conexant jack arrays

Tejun Heo (4):
  PCI: pci-stub: ignore zero-length id parameters
  ptrace: use safer wake up on ptrace_detach()
  pata_mpc52xx: inherit from ata_bmdma_port_ops
  libata: no special completion processing for EH commands

Tetsuo Handa (3):
  CRED: Fix kernel panic upon security_file_alloc() failure.
  CRED: Fix BUG() upon security_cred_alloc_blank() failure
  CRED: Fix memory and refcount leaks upon security_prepare_creds()
    failure

Thomas Gleixner (4):
  isdn: hisax: Replace the bogus access to irq stats
  genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
  clockevents: Prevent oneshot mode when broadcast device is periodic
  fix per-cpu flag problem in the cpu affinity checkers

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

Tristan Ye (1):
  Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters
    in a right number.

Trond Myklebust (2):
  SUNRPC: Ensure we always run the tk_callback before tk_action
  SUNRPC: Never reuse the socket port after an xs_close()

Tyler Hicks (1):
  eCryptfs: Copy up lower inode attrs in getattr

Vasanthakumar Thiagarajan (1):
  ath9k: Fix bug in delimiter padding computation

Vasiliy Kulikov (13):
  platform: x86: acer-wmi: world-writable sysfs threeg file
  platform: x86: asus_acpi: world-writable procfs files
  platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial
    files
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

Vivien Didelot (1):
  hwmon: (sht15) Fix integer overflow in humidity calculation

dann frazier (1):
  ocfs2_connection_find() returns pointer to bad structure

roel (1):
  nfsd: wrong index used in inner loop

wangyanqing (1):
  USB: serial: ch341: add new id

 Documentation/i2c/instantiating-devices         |    2 +-
 Documentation/kernel-parameters.txt             |    1 +
 arch/arm/kernel/signal.c                        |    4 +-
 arch/mips/alchemy/mtx-1/platform.c              |    9 +
 arch/mips/kernel/ptrace.c                       |    4 +-
 arch/parisc/kernel/firmware.c                   |   13 +-
 arch/parisc/kernel/irq.c                        |    2 +-
 arch/powerpc/include/asm/hvcall.h               |    1 +
 arch/powerpc/include/asm/kexec.h                |    4 +
 arch/powerpc/include/asm/paca.h                 |    1 +
 arch/powerpc/include/asm/reg.h                  |    1 +
 arch/powerpc/kernel/asm-offsets.c               |    1 +
 arch/powerpc/kernel/cpu_setup_6xx.S             |   40 ++--
 arch/powerpc/kernel/crash.c                     |   42 ++++-
 arch/powerpc/kernel/machine_kexec_64.c          |   73 +++++--
 arch/powerpc/kernel/misc_64.S                   |    8 +-
 arch/powerpc/kernel/paca.c                      |    2 +
 arch/powerpc/kernel/perf_event.c                |   24 ++-
 arch/powerpc/kernel/rtas_flash.c                |   39 ++--
 arch/powerpc/kernel/setup_64.c                  |   17 +-
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++
 arch/powerpc/platforms/pseries/lpar.c           |   35 ++--
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 ++
 arch/powerpc/sysdev/fsl_rio.c                   |    1 -
 arch/s390/include/asm/processor.h               |    5 -
 arch/s390/kernel/traps.c                        |   37 ---
 arch/x86/include/asm/acpi.h                     |    1 +
 arch/x86/include/asm/mmu_context.h              |    5 +-
 arch/x86/include/asm/pgtable-3level.h           |   11 +-
 arch/x86/include/asm/pvclock.h                  |    1 +
 arch/x86/include/asm/smpboot_hooks.h            |    2 +-
 arch/x86/kernel/acpi/boot.c                     |   14 +-
 arch/x86/kernel/cpu/mtrr/main.c                 |   10 +-
 arch/x86/kernel/e820.c                          |   10 +-
 arch/x86/kernel/early-quirks.c                  |   21 +-
 arch/x86/kernel/entry_64.S                      |    2 +-
 arch/x86/kernel/pvclock.c                       |    5 +
 arch/x86/mm/fault.c                             |    7 +
 arch/x86/mm/pgtable.c                           |    3 +-
 arch/x86/xen/time.c                             |    2 +
 drivers/ata/ahci.c                              |    5 +
 drivers/ata/libata-core.c                       |   24 ++-
 drivers/ata/pata_mpc52xx.c                      |    2 +-
 drivers/char/agp/generic.c                      |   19 ++-
 drivers/char/tpm/tpm.c                          |   10 +-
 drivers/firmware/dcdbas.c                       |    4 +-
 drivers/gpu/drm/Kconfig                         |    3 +
 drivers/gpu/drm/i915/intel_lvds.c               |    8 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |   16 +-
 drivers/gpu/drm/radeon/radeon_display.c         |    4 +
 drivers/hwmon/f71882fg.c                        |    2 +-
 drivers/hwmon/sht15.c                           |    4 +-
 drivers/hwmon/via686a.c                         |   14 +-
 drivers/i2c/i2c-core.c                          |   14 +-
 drivers/infiniband/core/cm.c                    |    1 +
 drivers/infiniband/core/cma.c                   |   15 ++
 drivers/input/mouse/bcm5974.c                   |   40 ++++
 drivers/input/serio/i8042-x86ia64io.h           |   21 ++
 drivers/input/serio/i8042.c                     |    6 +-
 drivers/input/xen-kbdfront.c                    |   36 ++-
 drivers/isdn/hisax/config.c                     |   18 ++-
 drivers/isdn/hisax/hisax.h                      |    1 +
 drivers/isdn/i4l/isdn_tty.c                     |    6 -
 drivers/md/dm-mpath.c                           |   12 -
 drivers/md/dm.c                                 |    5 +-
 drivers/md/md.c                                 |    3 +
 drivers/media/radio/radio-aimslab.c             |   24 +--
 drivers/media/video/em28xx/em28xx-cards.c       |    4 +-
 drivers/media/video/uvc/uvc_video.c             |   14 +-
 drivers/message/fusion/mptctl.c                 |    8 +
 drivers/message/fusion/mptscsih.c               |    7 +-
 drivers/mfd/ucb1x00-ts.c                        |   12 +-
 drivers/mmc/core/sdio.c                         |    8 +
 drivers/mtd/nand/omap2.c                        |    2 +-
 drivers/mtd/onenand/generic.c                   |    2 +-
 drivers/mtd/onenand/omap2.c                     |    2 +-
 drivers/net/bonding/bond_ipv6.c                 |    9 +-
 drivers/net/e1000e/netdev.c                     |    3 +-
 drivers/net/ixgbe/ixgbe_main.c                  |   11 +-
 drivers/net/r8169.c                             |   12 +-
 drivers/net/wireless/ath/ath9k/ath9k.h          |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c             |    4 +-
 drivers/net/wireless/hostap/hostap_cs.c         |   15 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c          |   15 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h      |    6 +
 drivers/net/wireless/p54/p54pci.c               |   14 +-
 drivers/net/wireless/p54/p54usb.c               |    1 +
 drivers/net/wireless/p54/txrx.c                 |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c           |    1 +
 drivers/pci/pci-stub.c                          |    3 +
 drivers/pci/pci-sysfs.c                         |    9 +-
 drivers/pci/quirks.c                            |  113 +++++-----
 drivers/platform/x86/acer-wmi.c                 |    4 +-
 drivers/platform/x86/asus_acpi.c                |    8 +-
 drivers/platform/x86/tc1100-wmi.c               |    2 +-
 drivers/power/ds2760_battery.c                  |    2 +-
 drivers/rtc/rtc-cmos.c                          |   16 +-
 drivers/s390/char/keyboard.c                    |    3 +-
 drivers/scsi/libsas/sas_scsi_host.c             |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c             |   19 ++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c              |   23 ++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c            |    3 -
 drivers/scsi/sd.c                               |    9 +-
 drivers/serial/8250.c                           |    3 +-
 drivers/staging/comedi/drivers/jr3_pci.c        |    7 +
 drivers/staging/comedi/drivers/ni_labpc.c       |    3 +-
 drivers/staging/hv/blkvsc_drv.c                 |    1 +
 drivers/staging/hv/netvsc_drv.c                 |    1 +
 drivers/staging/usbip/vhci.h                    |    6 +-
 drivers/staging/usbip/vhci_hcd.c                |   70 ++++--
 drivers/staging/usbip/vhci_rx.c                 |   15 +-
 drivers/usb/class/cdc-acm.c                     |    8 +-
 drivers/usb/core/hcd-pci.c                      |    4 +-
 drivers/usb/core/hub.c                          |   26 ++
 drivers/usb/core/quirks.c                       |    8 +
 drivers/usb/gadget/dummy_hcd.c                  |    1 +
 drivers/usb/gadget/printer.c                    |   14 +-
 drivers/usb/host/ehci-hcd.c                     |   27 ++-
 drivers/usb/host/ehci-pci.c                     |   39 +++
 drivers/usb/host/ehci-q.c                       |   12 -
 drivers/usb/host/ehci-sched.c                   |   79 +++++++
 drivers/usb/host/ehci.h                         |    1 +
 drivers/usb/host/ohci-hcd.c                     |    9 +-
 drivers/usb/host/ohci-pci.c                     |   26 ++
 drivers/usb/host/ohci.h                         |    1 +
 drivers/usb/host/pci-quirks.c                   |   18 +-
 drivers/usb/host/xhci-ring.c                    |   50 +++--
 drivers/usb/misc/iowarrior.c                    |    2 +-
 drivers/usb/misc/uss720.c                       |    7 +-
 drivers/usb/musb/musb_core.c                    |    1 +
 drivers/usb/musb/omap2430.c                     |    1 +
 drivers/usb/serial/ch341.c                      |   11 +
 drivers/usb/serial/cp210x.c                     |   16 +-
 drivers/usb/serial/digi_acceleport.c            |   10 -
 drivers/usb/serial/ftdi_sio.c                   |   39 +++-
 drivers/usb/serial/ftdi_sio_ids.h               |   32 +++-
 drivers/usb/serial/generic.c                    |   20 ++
 drivers/usb/serial/io_edgeport.c                |    4 +-
 drivers/usb/serial/keyspan_pda.c                |   17 --
 drivers/usb/serial/kobil_sct.c                  |    2 +-
 drivers/usb/serial/option.c                     |   23 ++-
 drivers/usb/serial/pl2303.c                     |   12 +
 drivers/usb/serial/pl2303.h                     |    1 +
 drivers/usb/serial/sierra.c                     |    3 +
 drivers/usb/serial/spcp8x5.c                    |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 +-
 drivers/usb/serial/visor.c                      |   12 +
 drivers/usb/storage/unusual_cypress.h           |    5 +
 drivers/usb/storage/unusual_devs.h              |   32 +++
 drivers/video/console/tileblit.c                |    2 +-
 drivers/virtio/virtio_pci.c                     |   20 +--
 fs/cifs/cifsproto.h                             |    2 +-
 fs/cifs/cifssmb.c                               |    4 +-
 fs/cifs/file.c                                  |   21 +-
 fs/dcache.c                                     |    3 +
 fs/ecryptfs/inode.c                             |    2 +
 fs/eventpoll.c                                  |  115 +++++++++-
 fs/ext2/namei.c                                 |    9 +-
 fs/ext3/namei.c                                 |    2 +-
 fs/ext3/super.c                                 |    7 +
 fs/file_table.c                                 |    2 +-
 fs/fuse/file.c                                  |   52 ++++-
 fs/fuse/fuse_i.h                                |    6 +-
 fs/nfs/direct.c                                 |   34 ++--
 fs/nfsd/nfs4proc.c                              |    4 +-
 fs/nfsd/nfs4xdr.c                               |   11 +-
 fs/nfsd/vfs.c                                   |    2 +-
 fs/ocfs2/refcounttree.c                         |    7 +-
 fs/ocfs2/stack_user.c                           |    2 +-
 fs/partitions/ldm.c                             |   26 ++-
 fs/partitions/mac.c                             |   17 +-
 fs/proc/array.c                                 |    9 +-
 fs/proc/task_mmu.c                              |    4 +-
 fs/xfs/linux-2.6/xfs_export.c                   |   11 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                    |   18 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c                  |   15 +-
 fs/xfs/quota/xfs_qm.c                           |   18 +-
 fs/xfs/quota/xfs_qm_syscalls.c                  |   27 +--
 fs/xfs/xfs_fsops.c                              |    3 +
 fs/xfs/xfs_ialloc.c                             |  146 +++++++-----
 fs/xfs/xfs_iget.c                               |   10 +-
 fs/xfs/xfs_inode.c                              |    5 +-
 fs/xfs/xfs_inode.h                              |    6 +-
 fs/xfs/xfs_itable.c                             |  285 ++++-------------------
 fs/xfs/xfs_itable.h                             |   17 --
 fs/xfs/xfs_log_recover.c                        |    2 +-
 fs/xfs/xfs_mount.c                              |    2 +-
 fs/xfs/xfs_rtalloc.c                            |    4 +-
 fs/xfs/xfs_trans_inode.c                        |    2 +-
 fs/xfs/xfs_vnodeops.c                           |    2 +-
 include/drm/drm_pciids.h                        |    1 -
 include/keys/rxrpc-type.h                       |    1 -
 include/linux/cred.h                            |   21 +--
 include/linux/ftrace.h                          |    2 +
 include/linux/ieee80211.h                       |    2 +-
 include/linux/klist.h                           |    2 +-
 include/linux/sched.h                           |    4 +-
 include/linux/usb/serial.h                      |    3 +
 include/net/netlink.h                           |    2 +-
 init/Kconfig                                    |    3 +-
 init/calibrate.c                                |    6 +-
 kernel/capability.c                             |    1 -
 kernel/cpuset.c                                 |    7 +-
 kernel/cred-internals.h                         |   21 --
 kernel/cred.c                                   |   44 +++-
 kernel/exit.c                                   |    1 -
 kernel/irq/manage.c                             |    2 +-
 kernel/power/snapshot.c                         |    7 +-
 kernel/ptrace.c                                 |    2 +-
 kernel/sched.c                                  |   52 +++--
 kernel/sched_debug.c                            |    5 -
 kernel/sched_fair.c                             |   55 ++++--
 kernel/smp.c                                    |   69 ++++++-
 kernel/time/tick-broadcast.c                    |   10 +
 kernel/time/tick-common.c                       |    6 +-
 kernel/time/tick-internal.h                     |    3 +
 kernel/trace/ftrace.c                           |   52 ++++-
 kernel/user.c                                   |   12 +-
 mm/mremap.c                                     |    4 +-
 net/ax25/af_ax25.c                              |    2 +-
 net/bluetooth/bnep/sock.c                       |    1 +
 net/bluetooth/sco.c                             |    1 +
 net/bridge/netfilter/ebtables.c                 |    2 +
 net/can/bcm.c                                   |    4 +-
 net/dccp/input.c                                |    7 +-
 net/econet/af_econet.c                          |    2 +-
 net/ipv4/devinet.c                              |   30 ++-
 net/ipv4/inet_diag.c                            |   27 ++-
 net/ipv4/ip_output.c                            |    9 +-
 net/ipv4/netfilter/arp_tables.c                 |    3 +
 net/ipv4/netfilter/ip_tables.c                  |    3 +
 net/ipv6/netfilter/ip6_tables.c                 |    3 +
 net/irda/af_irda.c                              |   16 +-
 net/netfilter/nf_log.c                          |    4 +
 net/rds/rdma.c                                  |    9 +
 net/sunrpc/sched.c                              |   14 +-
 net/sunrpc/xprtsock.c                           |    2 +
 net/tipc/socket.c                               |    1 +
 security/selinux/hooks.c                        |   11 +-
 security/selinux/nlmsgtab.c                     |    2 +
 sound/core/hrtimer.c                            |    5 +-
 sound/pci/au88x0/au88x0_pcm.c                   |   24 ++-
 sound/pci/ctxfi/ctatc.c                         |    2 +-
 sound/pci/ctxfi/ctdaio.c                        |    2 +
 sound/pci/ctxfi/ctmixer.c                       |   19 +--
 sound/pci/hda/hda_eld.c                         |    2 +-
 sound/pci/hda/hda_intel.c                       |    1 +
 sound/pci/hda/patch_conexant.c                  |    8 +-
 sound/pci/hda/patch_sigmatel.c                  |   11 +-
 sound/soc/blackfin/bf5xx-ac97.c                 |    4 +-
 sound/soc/codecs/wm8990.c                       |   10 +-
 sound/usb/usx2y/us122l.c                        |   41 ++--
 252 files changed, 2245 insertions(+), 1264 deletions(-)
 delete mode 100644 kernel/cred-internals.h

-- 
1.7.4.4

