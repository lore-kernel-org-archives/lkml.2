Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab1DNRpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:37041 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230Ab1DNRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 000/209] v2.6.34.9 longterm review
Date: Thu, 14 Apr 2011 13:40:30 -0400
Message-Id: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the v2.6.34.9 release.
There are 209 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Reponses should be made within 72 hours.

Al Viro (1):
  Fix sget() race with failing mount

Alan Stern (1):
  USB: EHCI: fix obscure race in ehci_endpoint_disable

Alex Deucher (2):
  drm/radeon/kms: handle the case of no active displays properly in the
    bandwidth code
  drm/kms: remove spaces from connector names (v2)

Alexander Shishkin (1):
  crypto: testmgr - add an option to disable cryptoalgos' self-tests

Alexey Starikovskiy (1):
  ACPI: EC: Add another dmi match entry for MSI hardware

Antonio Ospite (2):
  HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
  HID: hidraw, fix a NULL pointer dereference in hidraw_write

Apollon Oikonomopoulos (1):
  x25: decrement netdev reference counts on unload

Avi Kivity (1):
  KVM: VMX: Fix host userspace gsbase corruption

Ben Hutchings (2):
  net: NETIF_F_HW_CSUM does not imply FCoE CRC offload
  niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL

Bob Moore (1):
  Subject: [PATCH] ACPICA: Fix Scope() op in module level code

Borislav Petkov (1):
  amd64_edac: Fix interleaving check

Changli Gao (2):
  act_nat: use stack variable
  ifb: goto resched directly if error happens and dp->tq isn't empty

Chris Wilson (1):
  drm/i915: Unset cursor if out-of-bounds upon mode change (v4)

Christian Lamparter (1):
  p54usb: add 5 more USBIDs

Chuck Lever (1):
  NFS: Fix panic after nfs_umount()

Clemens Ladisch (3):
  hpet: fix unwanted interrupt due to stale irq status bit
  firewire: ohci: fix buffer overflow in AR split packet handling
  firewire: ohci: fix race in AR split packet handling

Dan Carpenter (2):
  IB/uverbs: Handle large number of entries in poll CQ
  av7110: check for negative array offset

Dan Rosenberg (9):
  ipc: initialize structure memory to zero for compat functions
  sys_semctl: fix kernel stack leakage
  DECnet: don't leak uninitialized stack byte
  V4L/DVB: ivtvfb: prevent reading uninitialized stack memory
  x25: Prevent crashing when parsing bad X.25 facilities
  rds: Integer overflow in RDS cmsg handling
  Fix pktcdvd ioctl dev_minor range check
  sound: Prevent buffer overflow in OSS load_mixer_volumes
  sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()

Dan Williams (1):
  ioat2: catch and recover from broken vtd configurations v6

Daniel Klaffenbach (1):
  ssb: b43-pci-bridge: Add new vendor for BCM4318

Daniel T Chen (4):
  ALSA: ac97: Apply quirk for Dell Latitude D610 binding Master and
    Headphone controls
  ALSA: hda: Use "alienware" model quirk for another SSID
  ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback
    and capture
  ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120

Darrick J. Wong (1):
  PCI: fix offset check for sysfs mmapped files

Dave Airlie (1):
  drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

Dave Hansen (1):
  mm/vfs: revalidate page->mapping in do_generic_file_read()

Dave Jones (1):
  ACPI: debugfs custom_method open to non-root

David Henningsson (1):
  ALSA: HDA: Add an extra DAC for Realtek ALC887-VD

David Howells (1):
  CRED: Fix RCU warning due to previous patch fixing __task_cred()'s
    checks

David Kilroy (2):
  orinoco: fix TKIP countermeasure behaviour
  orinoco: clear countermeasure setting on commit

David S. Miller (10):
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

Dmitry Torokhov (1):
  Input: i8042 - add Sony VAIO VPCZ122GX to nomux list

Eduardo Costa (1):
  p54usb: New USB ID for Gemtek WUBI-100GW

Eric Dumazet (11):
  udp: add rehash on connect()
  numa: fix slab_node(MPOL_BIND)
  netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get highmem
    pages
  net: avoid limits overflow
  sysctl: min/max bounds are optional
  sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
  net sched: fix some kernel memory leaks
  tcp: avoid a possible divide by zero
  af_unix: limit unix_tot_inflight
  af_unix: limit recursion level
  filter: fix sk_filter rcu handling

Felix Fietkau (2):
  ath9k: fix retry count for A-MPDU rate control status reports
  ath9k_hw: fix antenna diversity on AR9285

Florian Faber (1):
  USB: ftdi_sio: Add D.O.Tec PID

Florian Tobias Schandinat (1):
  viafb: use proper register for colour when doing fill ops

Francisco Jerez (1):
  drm/ttm: Clear the ghost cpu_writers flag on
    ttm_buffer_object_transfer.

Gabriele Gorla (2):
  hwmon: (adm1026) Allow 1 as a valid divider value
  hwmon: (adm1026) Fix setting fan_div

Graham Gower (1):
  drivers/char/vt_ioctl.c: fix VT_OPENQRY error value

Greg Kroah-Hartman (12):
  Staging: asus_oled: fix up some sysfs attribute permissions
  Staging: asus_oled: fix up my fixup for some sysfs attribute
    permissions
  Staging: line6: fix up some sysfs attribute permissions
  Staging: line6: fix up my fixup for some sysfs attribute permissions
  USB: storage: sierra_ms: fix sysfs file attribute
  USB: atm: ueagle-atm: fix up some permissions on the sysfs files
  USB: misc: cypress_cy7c63: fix up some sysfs attribute permissions
  USB: misc: usbled: fix up some sysfs attribute permissions
  USB: misc: trancevibrator: fix up a sysfs attribute permission
  USB: misc: usbsevseg: fix up some sysfs attribute permissions
  Staging: frontier: fix up some sysfs attribute permissions
  Staging: frontier: fix up my fixup for some sysfs attribute
    permissions

Guenter Roeck (1):
  hwmon: (w83627ehf) Fix max_output and step_output readings

Guo-Fu Tseng (1):
  jme: Fix PHY power-off error

H. Peter Anvin (6):
  x86-32: Fix dummy trampoline-related inline stubs
  x86, mwait: Move mwait constants to a common header file
  x86, hotplug: Use mwait to offline a processor, fix the legacy case
  x86, hotplug: Move WBINVD back outside the play_dead loop
  x86, hotplug: In the MWAIT case of play_dead, CLFLUSH the cache line
  x86, gcc-4.6: Use gcc -m options when building vdso

Heiko Carstens (3):
  nmi: fix clock comparator revalidation
  nohz: Fix printk_needs_cpu() return value on offline cpus
  nohz: Fix get_next_timer_interrupt() vs cpu hotplug

Herbert Xu (1):
  crypto: padlock - Fix AES-CBC handling on odd-block-sized input

Hillf Danton (1):
  bonding: Fix slave selection bug.

Hugh Dickins (1):
  x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline

Ian Campbell (1):
  xen: ensure that all event channels start off bound to VCPU 0

Jack Steiner (2):
  x86, UV: Delete unneeded boot messages
  x86, UV: Fix initialization of max_pnode

Jacques Viviers (1):
  USB: serial: ftdi_sio: Vardaan USB RS422/485 converter PID added

James Jones (1):
  ARM: 6482/2: Fix find_next_zero_bit and related assembly

Jarek Poplawski (1):
  gianfar: Fix crashes on RX path (Was Re: [Bugme-new] [Bug 19692] New:
    linux-2.6.36-rc5 crash with gianfar ethernet at full line rate
    traffic)

Jean Delvare (1):
  hwmon: (lm85) Fix ADT7468 frequency table

Jeff Kirsher (1):
  e100/e1000*/igb*/ixgb*: Add missing read memory barrier

Jeff Mahoney (1):
  net sched: fix kernel leak in act_police

Jens Axboe (4):
  block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
  block: take care not to overflow when calculating total iov length
  block: check for proper length of iov entries in
    blk_rq_map_user_iov()
  bio: take care not overflow page count when mapping/copying user data

Jeremy Fitzhardinge (1):
  xen: don't bother to stop other cpus on shutdown/reboot

Jiri Olsa (1):
  tty: prevent DOS in the flush_to_ldisc

Jiri Slaby (5):
  hpet: unmap unused I/O space
  TTY: restore tty_ldisc_wait_idle
  TTY: ldisc, fix open flag handling
  TTY: don't allow reopen when ldisc is changing
  HID: hidraw: fix window in hidraw_release

Joe Jin (1):
  driver/net/benet: fix be_cmd_multicast_set() memcpy bug

Joerg Roedel (1):
  x86-32: Separate 1:1 pagetables from swapper_pg_dir

Johan Hovold (1):
  USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"

Julien Tinnes (1):
  Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the
    signal code

Justin Maggard (1):
  md: fix return value of rdev_size_change()

KAMEZAWA Hiroyuki (2):
  mm: fix return value of scan_lru_pages in memory unplug
  mm: fix is_mem_section_removable() page_order BUG_ON check

Kees Cook (1):
  net: clear heap allocation for ETHTOOL_GRXCLSRLALL

Ken Chen (1):
  latencytop: fix per task accumulator

Ken Sumrall (1):
  fuse: fix attributes after open(O_TRUNC)

Kenji Kaneshige (2):
  x86: Enable the intr-remap fault handling after local APIC setup
  x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic
    mode

Krishna Gudipati (1):
  bfa: fix system crash when reading sysfs fc_host statistics

Larry Finger (1):
  staging: rtl8187se: Change panic to warn when RF switch turned off

Li Zefan (1):
  sunrpc/cache: fix module refcnt leak in a failure path

Linus Torvalds (1):
  net: Truncate recvfrom and sendto length to INT_MAX.

Luke Macken (1):
  efifb: support the EFI framebuffer on more Apple hardware

Lytochkin Boris (1):
  serial: add support for OX16PCI958 card

Martin K. Petersen (2):
  block: Ensure physical block size is unsigned int
  block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead

Martin Wilck (1):
  PCI: fix size checks for mmap() on /proc/bus/pci files

Masanori ITOH (1):
  percpu: fix list_head init bug in __percpu_counter_init()

Michael Stuermer (1):
  USB: ftdi_sio: Add ID for RT Systems USB-29B radio cable

Michel Dänzer (1):
  drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.

Miklos Szeredi (2):
  fuse: verify ioctl retries
  fuse: fix ioctl when server is 32bit

Mimi Zohar (1):
  ima: fix add LSM rule bug

Nandita Dukkipati (1):
  tcp: Bug fix in initialization of receive window.

Neil Brown (1):
  nfsd: Fix possible BUG_ON firing in set_change_info

NeilBrown (5):
  md: fix another deadlock with removing sysfs attributes.
  md/raid1: really fix recovery looping when single good device fails.
  sunrpc: prevent use-after-free on clearing XPT_BUSY
  md: fix bug with re-adding of partially recovered device.
  md: fix regression with re-adding devices to arrays with no metadata

Nelson Elhage (2):
  do_exit(): make sure that we run with get_fs() == USER_DS
  econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.

Nobuhiro Iwamatsu (1):
  i2c-pca-platform: Change device name of request_irq

Oleg Nesterov (2):
  exec: make argv/envp memory visible to oom-killer
  posix-cpu-timers: workaround to suppress the problems with mt exec

Oliver Hartkopp (1):
  can-bcm: fix minor heap overflow

Pekka Enberg (1):
  perf_events: Fix perf_counter_mmap() hook in mprotect()

Peter Jones (1):
  efifb: check that the base address is plausible on pci systems

Phil Blundell (3):
  econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
  econet: fix CVE-2010-3850
  econet: fix CVE-2010-3848

Philipp Reisner (1):
  drbd: Initialize all members of sync_conf to their defaults [Bugz
    315]

Philippe Rétornaz (1):
  tty_ldisc: Fix BUG() on hangup

Randy Dunlap (1):
  PCI: sysfs: fix printk warnings

Richard A. Smith (1):
  olpc_battery: Fix endian neutral breakage for s16 values

Richard Weinberger (2):
  um: remove PAGE_SIZE alignment in linker script causing kernel
    segfault.
  um: fix global timer issue when using CONFIG_NO_HZ

Robin@sgi.com (1):
  sgi-xpc: XPC fails to discover partitions with all nasids above 128

Roland Dreier (1):
  Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo

Saeed Bishara (1):
  mv_xor: fix race in tasklet function

Samuel Ortiz (2):
  irda: Fix parameter extraction stack overflow
  irda: Fix heap memory corruption in iriap.c

Sebastien Bourdeauducq (1):
  USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial

Sergey Vlasov (1):
  NFS: Fix fcntl F_GETLK not reporting some conflicts

Slava Pestov (1):
  tracing: Fix panic when lseek() called on "trace" opened for writing

Steven J. Magnani (1):
  nommu: yield CPU while disposing VM

Suresh Siddha (2):
  x86, vt-d: Handle previous faults after enabling fault handling
  x86, vt-d: Quirk for masking vtd spec errors to platform error
    handling logic

Takashi Iwai (2):
  PM / Hibernate: Fix PM_POST_* notification with user-space suspend
  ALSA: caiaq - Fix possible string-buffer overflow

Tavis Ormandy (1):
  install_special_mapping skips security_file_mmap check.

Tejun Heo (1):
  libata: fix NULL sdev dereference race in atapi_qc_complete()

Thomas Backlund (1):
  microblaze: Fix build with make 3.82

Thomas Sailer (1):
  USB: misc: uss720.c: add another vendor/product ID

Tyler Hicks (1):
  eCryptfs: Clear LOOKUP_OPEN flag when creating lower file

Uwe Kleine-König (1):
  backlight: grab ops_lock before testing bd->ops

Vasiliy Kulikov (7):
  ipc: shm: fix information leak to userland
  KVM: x86: fix information leak to userland
  usb: misc: sisusbvga: fix information leak to userland
  usb: misc: iowarrior: fix information leak to userland
  usb: core: fix information leak to userland
  net: packet: fix information leak to userland
  net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules

Vitaly Kuznetsov (1):
  USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

Will Deacon (1):
  ARM: 6489/1: thumb2: fix incorrect optimisation in usracc

Will Newton (1):
  uml: disable winch irq before freeing handler data

Xiaotian Feng (1):
  block: check for proper length of iov entries earlier in
    blk_rq_map_user_iov()

Zhang Rui (1):
  acpi-cpufreq: fix a memleak when unloading driver

andrew hendry (1):
  memory corruption in X.25 facilities parsing

ma rui (1):
  USB: option: fix when the driver is loaded incorrectly for some
    Huawei devices.

stephen hemminger (1):
  ip6ip6: autoload ip6 tunnel

 MAINTAINERS                                  |    6 +
 arch/arm/include/asm/assembler.h             |    2 +-
 arch/arm/lib/findbit.S                       |    6 +-
 arch/microblaze/Makefile                     |    8 +-
 arch/s390/kernel/nmi.c                       |   10 +-
 arch/s390/lib/delay.c                        |   14 +-
 arch/sparc/kernel/signal32.c                 |  161 ++++++++++++--------
 arch/sparc/kernel/signal_32.c                |   55 +++++---
 arch/sparc/kernel/signal_64.c                |   45 ++++--
 arch/um/drivers/line.c                       |    5 +-
 arch/um/kernel/uml.lds.S                     |    2 +-
 arch/um/os-Linux/time.c                      |    2 +-
 arch/x86/include/asm/mwait.h                 |   15 ++
 arch/x86/include/asm/pgtable_32.h            |    1 +
 arch/x86/include/asm/processor.h             |   23 ---
 arch/x86/include/asm/trampoline.h            |    5 +-
 arch/x86/kernel/acpi/cstate.c                |   11 +--
 arch/x86/kernel/apic/apic.c                  |    8 +
 arch/x86/kernel/apic/io_apic.c               |    1 +
 arch/x86/kernel/apic/probe_64.c              |    7 -
 arch/x86/kernel/apic/x2apic_uv_x.c           |    9 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c   |    1 +
 arch/x86/kernel/head_32.S                    |    8 +-
 arch/x86/kernel/setup.c                      |    2 +
 arch/x86/kernel/smpboot.c                    |  112 ++++++++++++---
 arch/x86/kernel/trampoline.c                 |   17 ++
 arch/x86/kvm/vmx.c                           |   15 +-
 arch/x86/kvm/x86.c                           |    5 +
 arch/x86/vdso/Makefile                       |    4 +-
 arch/x86/xen/enlighten.c                     |    4 -
 block/blk-map.c                              |    3 +
 block/blk-merge.c                            |    6 +-
 block/blk-settings.c                         |   27 +---
 block/blk-sysfs.c                            |    2 +-
 block/scsi_ioctl.c                           |   34 +++--
 crypto/Kconfig                               |    8 +
 crypto/algboss.c                             |    4 +
 crypto/testmgr.c                             |   14 ++
 drivers/acpi/acpi_pad.c                      |    7 +-
 drivers/acpi/acpica/dswexec.c                |   19 ++-
 drivers/acpi/debug.c                         |    2 +-
 drivers/acpi/ec.c                            |    3 +
 drivers/ata/libata-scsi.c                    |    5 +-
 drivers/block/drbd/drbd_main.c               |   17 ++-
 drivers/block/pktcdvd.c                      |    2 +-
 drivers/char/hpet.c                          |   17 ++
 drivers/char/tty_buffer.c                    |   14 ++-
 drivers/char/tty_io.c                        |    3 +-
 drivers/char/tty_ldisc.c                     |   51 ++++++-
 drivers/char/vt_ioctl.c                      |   11 +-
 drivers/crypto/padlock-aes.c                 |    2 +-
 drivers/dma/ioat/dma.h                       |    1 +
 drivers/dma/ioat/dma_v2.c                    |   24 +++-
 drivers/dma/ioat/dma_v3.c                    |    5 +-
 drivers/dma/mv_xor.c                         |    2 +-
 drivers/edac/amd64_edac.c                    |    2 +-
 drivers/firewire/ohci.c                      |   64 +++++++--
 drivers/gpu/drm/drm_crtc.c                   |   10 +-
 drivers/gpu/drm/drm_irq.c                    |    3 +-
 drivers/gpu/drm/i915/intel_display.c         |  144 ++++++++++++-------
 drivers/gpu/drm/i915/intel_drv.h             |    8 +-
 drivers/gpu/drm/radeon/radeon_object.c       |   27 +++-
 drivers/gpu/drm/radeon/rs690.c               |   27 +---
 drivers/gpu/drm/radeon/rv515.c               |   23 +--
 drivers/gpu/drm/ttm/ttm_bo_util.c            |    1 +
 drivers/hid/hidraw.c                         |   27 +++-
 drivers/hwmon/adm1026.c                      |   20 ++--
 drivers/hwmon/lm85.c                         |    1 +
 drivers/hwmon/w83627ehf.c                    |   13 ++-
 drivers/i2c/busses/i2c-pca-platform.c        |    2 +-
 drivers/infiniband/core/uverbs_cmd.c         |  101 +++++++------
 drivers/input/serio/i8042-x86ia64io.h        |    7 +
 drivers/md/dm-table.c                        |    5 -
 drivers/md/md.c                              |   50 ++++---
 drivers/md/md.h                              |    4 +
 drivers/md/raid1.c                           |    1 +
 drivers/media/dvb/ttpci/av7110_ca.c          |    2 +-
 drivers/media/video/ivtv/ivtvfb.c            |    2 +
 drivers/misc/sgi-xp/xpc_partition.c          |   25 ++--
 drivers/net/benet/be_cmds.c                  |    2 +-
 drivers/net/bonding/bonding.h                |    4 +-
 drivers/net/e100.c                           |    2 +
 drivers/net/e1000/e1000_main.c               |    3 +
 drivers/net/e1000e/netdev.c                  |    4 +
 drivers/net/gianfar.c                        |    6 +-
 drivers/net/ifb.c                            |    2 +
 drivers/net/igb/igb_main.c                   |    2 +
 drivers/net/igbvf/netdev.c                   |    2 +
 drivers/net/ixgb/ixgb_main.c                 |    2 +
 drivers/net/ixgbe/ixgbe_main.c               |    1 +
 drivers/net/ixgbevf/ixgbevf_main.c           |    2 +
 drivers/net/jme.c                            |   22 +++-
 drivers/net/niu.c                            |   16 +--
 drivers/net/wireless/ath/ath9k/eeprom.h      |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    4 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |   10 +-
 drivers/net/wireless/orinoco/main.c          |    6 +
 drivers/net/wireless/orinoco/wext.c          |    4 +-
 drivers/net/wireless/p54/p54usb.c            |    6 +
 drivers/pci/dmar.c                           |    5 +
 drivers/pci/intel-iommu.c                    |   27 ++++
 drivers/pci/pci-sysfs.c                      |   23 ++-
 drivers/pci/pci.h                            |    7 +-
 drivers/pci/proc.c                           |    2 +-
 drivers/pci/quirks.c                         |   23 +++
 drivers/power/olpc_battery.c                 |    8 +-
 drivers/scsi/bfa/bfa_core.c                  |   22 +++
 drivers/scsi/scsi_lib.c                      |    3 +-
 drivers/serial/8250_pci.c                    |   13 ++
 drivers/ssb/b43_pci_bridge.c                 |    1 +
 drivers/staging/asus_oled/asus_oled.c        |    8 +-
 drivers/staging/frontier/tranzport.c         |    2 +-
 drivers/staging/line6/control.c              |  204 +++++++++++++-------------
 drivers/staging/line6/midi.c                 |    4 +-
 drivers/staging/line6/pod.c                  |   32 ++--
 drivers/staging/line6/toneport.c             |    4 +-
 drivers/staging/line6/variax.c               |   12 +-
 drivers/staging/rtl8187se/r8185b_init.c      |   30 +++-
 drivers/usb/atm/ueagle-atm.c                 |    6 +-
 drivers/usb/core/devio.c                     |    7 +-
 drivers/usb/host/ehci-hcd.c                  |   10 +-
 drivers/usb/misc/cypress_cy7c63.c            |    6 +-
 drivers/usb/misc/iowarrior.c                 |    1 +
 drivers/usb/misc/sisusbvga/sisusb.c          |    1 +
 drivers/usb/misc/trancevibrator.c            |    2 +-
 drivers/usb/misc/usbled.c                    |    2 +-
 drivers/usb/misc/usbsevseg.c                 |   10 +-
 drivers/usb/misc/uss720.c                    |    4 +-
 drivers/usb/serial/ftdi_sio.c                |    9 +-
 drivers/usb/serial/ftdi_sio_ids.h            |   15 ++
 drivers/usb/serial/option.c                  |    2 +-
 drivers/usb/storage/sierra_ms.c              |    2 +-
 drivers/usb/storage/unusual_devs.h           |    7 +
 drivers/video/backlight/backlight.c          |   12 +-
 drivers/video/efifb.c                        |  103 ++++++++++++--
 drivers/video/via/accel.c                    |    7 +-
 drivers/xen/events.c                         |    2 +-
 fs/bio.c                                     |   23 +++-
 fs/ecryptfs/inode.c                          |    4 +
 fs/exec.c                                    |   37 +++++-
 fs/fuse/file.c                               |   82 ++++++++++-
 fs/namespace.c                               |    2 +-
 fs/nfs/file.c                                |    2 +
 fs/nfs/mount_clnt.c                          |    4 +-
 fs/nfsd/nfs3xdr.c                            |    6 +-
 fs/nfsd/xdr4.h                               |   21 ++--
 fs/super.c                                   |    6 +
 include/drm/drmP.h                           |    2 +-
 include/linux/binfmts.h                      |    1 +
 include/linux/blkdev.h                       |   13 +-
 include/linux/fs.h                           |    1 +
 include/linux/netdevice.h                    |    3 +
 include/linux/pci_ids.h                      |    1 +
 include/linux/socket.h                       |    2 +-
 include/net/af_unix.h                        |    2 +
 include/net/dn.h                             |    2 +-
 include/net/sock.h                           |    9 +-
 include/net/tcp.h                            |    6 +-
 include/net/udp.h                            |    5 +-
 ipc/compat.c                                 |    6 +
 ipc/compat_mq.c                              |    5 +
 ipc/sem.c                                    |    2 +
 ipc/shm.c                                    |    1 +
 kernel/exit.c                                |   17 ++
 kernel/latencytop.c                          |   17 +-
 kernel/power/user.c                          |    2 +-
 kernel/printk.c                              |    2 +
 kernel/signal.c                              |   25 +++-
 kernel/sysctl.c                              |    2 +-
 kernel/sysctl_check.c                        |    9 -
 kernel/timer.c                               |    6 +
 kernel/trace/trace.c                         |   10 +-
 lib/percpu_counter.c                         |    1 +
 mm/filemap.c                                 |    3 +
 mm/internal.h                                |    2 +-
 mm/memory_hotplug.c                          |    2 +-
 mm/mempolicy.c                               |    2 +-
 mm/mmap.c                                    |   16 ++-
 mm/mprotect.c                                |    2 +-
 mm/nommu.c                                   |    1 +
 net/can/bcm.c                                |    2 +-
 net/compat.c                                 |   10 +-
 net/core/dev.c                               |   18 ++-
 net/core/ethtool.c                           |    2 +-
 net/core/filter.c                            |   83 +++++------
 net/core/iovec.c                             |   20 +--
 net/core/sock.c                              |   14 +-
 net/decnet/af_decnet.c                       |    4 +-
 net/decnet/sysctl_net_decnet.c               |    4 +-
 net/econet/af_econet.c                       |   99 ++++++-------
 net/ipv4/datagram.c                          |    5 +-
 net/ipv4/ip_gre.c                            |    1 +
 net/ipv4/ipip.c                              |    1 +
 net/ipv4/proc.c                              |    8 +-
 net/ipv4/sysctl_net_ipv4.c                   |    5 +-
 net/ipv4/tcp.c                               |    6 +-
 net/ipv4/tcp_input.c                         |   11 +-
 net/ipv4/tcp_ipv4.c                          |    8 +-
 net/ipv4/tcp_output.c                        |   15 +-
 net/ipv4/udp.c                               |   48 ++++++-
 net/ipv6/datagram.c                          |    7 +-
 net/ipv6/ip6_tunnel.c                        |    1 +
 net/ipv6/sit.c                               |    2 +-
 net/ipv6/udp.c                               |   10 ++
 net/irda/iriap.c                             |    3 +-
 net/irda/parameters.c                        |    4 +-
 net/netfilter/nf_conntrack_core.c            |    3 +-
 net/packet/af_packet.c                       |    3 +-
 net/rds/rdma.c                               |    2 +-
 net/sched/act_gact.c                         |   21 ++-
 net/sched/act_mirred.c                       |   15 +-
 net/sched/act_nat.c                          |   35 ++---
 net/sched/act_police.c                       |   21 +--
 net/sched/act_simple.c                       |   11 +-
 net/sched/act_skbedit.c                      |   11 +-
 net/sctp/auth.c                              |    8 +-
 net/sctp/protocol.c                          |    2 +-
 net/sctp/socket.c                            |    4 +-
 net/sctp/sysctl.c                            |    4 +-
 net/socket.c                                 |    4 +
 net/sunrpc/cache.c                           |    4 +-
 net/sunrpc/svc_xprt.c                        |    9 +-
 net/unix/af_unix.c                           |   37 ++++-
 net/unix/garbage.c                           |    9 +-
 net/x25/x25_facilities.c                     |   20 ++-
 net/x25/x25_in.c                             |    2 +
 net/x25/x25_link.c                           |    4 +
 security/integrity/ima/ima_policy.c          |    2 +
 sound/oss/soundcard.c                        |    4 +-
 sound/pci/hda/hda_intel.c                    |    1 +
 sound/pci/hda/patch_realtek.c                |    5 +-
 sound/pci/hda/patch_sigmatel.c               |    2 +
 sound/pci/intel8x0.c                         |    6 +
 sound/usb/caiaq/audio.c                      |    2 +-
 sound/usb/caiaq/midi.c                       |    2 +-
 237 files changed, 2119 insertions(+), 1056 deletions(-)
 create mode 100644 arch/x86/include/asm/mwait.h

-- 
1.7.4.4

