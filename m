Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1BFUbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:31:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34503 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1BFUbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:31:21 -0500
Date: Sun, 6 Feb 2011 21:31:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [ANNOUNCEMENT] Linux 2.6.35.11 longterm has been released
Message-ID: <20110206203117.GA22318@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Linux 2.6.35.11 longterm kernel has been released. This continues
the 2.6.35 stable series. All users of 2.6.35 are encouraged to upgrade.

Thanks to all contributors.

-Andi

Full tarball
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/linux-2.6.35.11.tar.gz
SHA1: 0bab8be42abffd7ac5988f39f9110ad533f45fee

Patch against 2.6.35:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/patch-2.6.35.11.gz
SHA1: 8e00ec13f6966cdd955528475433f939486e4552

Patch against 2.6.35.10
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/incr/patch-2.6.35.10-.gz
SHA1: d7317a4e7ab13c707990ff8fd9cdbd712d9f8e5a

Git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git

Ahmed S. Darwish (1):
      RAMOOPS: Don't overflow over non-allocated regions

Alex Deucher (6):
      drm/radeon/kms: don't apply 7xx HDP flush workaround on AGP
      drm/kms: remove spaces from connector names (v2)
      drm/radeon/kms: fix vram base calculation on rs780/rs880
      drm/radeon/kms/evergreen: reset the grbm blocks at resume and init
      drm/radeon/kms: fix evergreen asic reset
      drm/radeon/kms: reorder display resume to avoid problems

Alexey Starikovskiy (1):
      ACPI: EC: Add another dmi match entry for MSI hardware

Andi Kleen (1):
      Release 2.6.35.11

Andreas Herrmann (1):
      x86, amd: Fix panic on AMD CPU family 0x15

Andres Salomon (2):
      cs5535-gpio: don't apply errata #36 to edge detect GPIOs
      cs5535-gpio: handle GPIO regs where higher (clear) bits are set

Andrew Vasquez (1):
      qla2xxx: Correct issue where NPIV-config data was not being allocated for 82xx parts.

Andy Lutomirski (1):
      nouveau: Acknowledge HPD irq in handler, not bottom half

Apollon Oikonomopoulos (1):
      x25: decrement netdev reference counts on unload

Ben Hutchings (1):
      tehuti: Firmware filename is tehuti/bdx.bin

Bob Moore (1):
      ACPICA: Fix Scope() op in module level code

Borislav Petkov (2):
      EDAC: Fix workqueue-related crashes
      amd64_edac: Fix interleaving check

Changli Gao (1):
      ifb: goto resched directly if error happens and dp->tq isn't empty

Christian Lamparter (1):
      p54usb: add 5 more USBIDs

Chuck Lever (1):
      NFS: Fix panic after nfs_umount()

Dan Carpenter (1):
      IB/uverbs: Handle large number of entries in poll CQ

Dan Rosenberg (1):
      sound: Prevent buffer overflow in OSS load_mixer_volumes

Daniel Hellstrom (1):
      SPARC/LEON: removed constant timer initialization as if HZ=100, now it reflects the value of HZ

Daniel T Chen (3):
      ALSA: hda: Use position_fix=1 for Acer Aspire 5538 to enable capture on internal mic
      ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
      ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120

David Flynn (1):
      drm/i915/dp: Fix I2C/EDID handling with active DisplayPort to DVI converter

David Henningsson (1):
      ALSA: HDA: Quirk for Dell Vostro 320 to make microphone work

David Kilroy (2):
      orinoco: fix TKIP countermeasure behaviour
      orinoco: clear countermeasure setting on commit

David S. Miller (14):
      sparc64: Delete prom_puts() unused.
      sparc: Remove prom_pathtoinode()
      sparc: Kill prom devops_{32,64}.c
      sparc64: Unexport prom_service_exists().
      sparc64: Delete prom_setcallback().
      sparc: Do not export prom_nb{get,put}char().
      sparc: Pass buffer pointer all the way down to prom_{get,put}char().
      sparc: Delete prom_*getchar().
      sparc: Write to prom console using indirect buffer.
      tcp: Don't change unlocked socket state in tcp_v4_err().
      tcp: Increase TCP_MAXSEG socket option minimum.
      tcp: Make TCP_MAXSEG minimum more correct.
      net: Export cred_to_ucred to modules.
      econet: Fix crash in aun_incoming().

David Stevens (1):
      bridge: fix IPv6 queries for bridge multicast snooping

Dmitry Artamonow (1):
      ASoC: fix deemphasis control in wm8904/55/60 codecs

Eduardo Costa (1):
      p54usb: New USB ID for Gemtek WUBI-100GW

Eric Dumazet (7):
      llc: fix a device refcount imbalance
      tcp: avoid a possible divide by zero
      tcp: protect sysctl_tcp_cookie_size reads
      af_unix: limit unix_tot_inflight
      af_unix: limit recursion level
      filter: fix sk_filter rcu handling
      net/dst: dst_dev_event() called after other notifiers

Eric Paris (1):
      inotify: stop kernel memory leak on file creation failure

Eric W. Biederman (4):
      scm: Capture the full credentials of the scm sender.
      af_unix: Allow credentials to work across user and pid namespaces.
      user_ns: Introduce user_nsmap_uid and user_ns_map_gid.
      sock: Introduce cred_to_ucred

Felix Fietkau (1):
      mac80211: fix initialization of skb->cb in ieee80211_subif_start_xmit

Florian Faber (1):
      USB: ftdi_sio: Add D.O.Tec PID

Florian Fainelli (2):
      gpio: Fix null pointer dereference while accessing rdc321x platform_data
      watchdog: Fix null pointer dereference while accessing rdc321x platform_data

Gabriele Gorla (2):
      hwmon: (adm1026) Allow 1 as a valid divider value
      hwmon: (adm1026) Fix setting fan_div

Greg Kroah-Hartman (1):
      Revert "USB: gadget: Allow function access to device ID data during bind()"

H. Peter Anvin (2):
      x86, hotplug: Use mwait to offline a processor, fix the legacy case
      x86, gcc-4.6: Use gcc -m options when building vdso

Heiko Carstens (3):
      nohz: Fix printk_needs_cpu() return value on offline cpus
      nohz: Fix get_next_timer_interrupt() vs cpu hotplug
      printk: Fix wake_up_klogd() vs cpu hotplug

Helmut Schaa (1):
      mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs

Herbert Xu (1):
      cls_cgroup: Fix crash on module unload

Hillf Danton (2):
      bonding: Fix slave selection bug.
      fix freeing user_struct in user cache

Ivo van Doorn (1):
      rt2x00: Fix max TX power settings

Jean-Francois Moine (2):
      gspca - sonixj: Set the flag for some devices
      gspca - sonixj: Add a flag in the driver_info table

Jeremy Fitzhardinge (1):
      xen: Provide a variant of __RING_SIZE() that is an integer constant expression

Jesper Juhl (1):
      x86/microcode: Fix double vfree() and remove redundant pointer checks before vfree()

Jiri Kosina (1):
      Input: i8042 - introduce 'notimeout' blacklist for Dell Vostro V13

Joe Jin (1):
      driver/net/benet: fix be_cmd_multicast_set() memcpy bug

Johannes Berg (1):
      mac80211: fix mesh forwarding

Ken Mills (2):
      n_gsm: Fix message length handling when building header
      n_gsm: gsm_data_alloc buffer allocation could fail and it is not being checked

Kenji Kaneshige (2):
      x86: Enable the intr-remap fault handling after local APIC setup
      x86, vt-d: Fix the vt-d fault handling irq migration in the x2apic mode

Manoj Iyer (1):
      ALSA: hda - Enable jack sense for Thinkpad Edge 11

Mariusz Kozlowski (1):
      net: Fix header size check for GSO case in recvmsg (af_packet)

Mark Brown (2):
      mfd: Support additional parent IDs for wm831x
      mfd: Supply IRQ base for WM832x devices

Martin K. Petersen (1):
      block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead

Matteo Croce (1):
      ath9k: fix bug in tx power

Michal Marek (1):
      l2tp: Fix modalias of l2tp_ip

Mike Galbraith (1):
      Sched: fix skip_clock_update optimization

Mike Hernandez (1):
      qla2xxx: Populate Command Type 6 LUN field properly.

Miklos Szeredi (2):
      fuse: verify ioctl retries
      fuse: fix ioctl when server is 32bit

Milton Miller (1):
      mac80211: fix mesh forwarding when ratelimited too

Mimi Zohar (1):
      ima: fix add LSM rule bug

Nandita Dukkipati (1):
      tcp: Bug fix in initialization of receive window.

Neil Brown (1):
      nfsd: Fix possible BUG_ON firing in set_change_info

NeilBrown (3):
      sunrpc: prevent use-after-free on clearing XPT_BUSY
      md: fix bug with re-adding of partially recovered device.
      md: protect against NULL reference when waiting to start a raid10.

Nelson Elhage (1):
      econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.

Nicolas Ferre (1):
      mmc: atmel-mci: fix multiblock SDIO transfers

Oleg Nesterov (1):
      posix-cpu-timers: workaround to suppress the problems with mt exec

Peter Zijlstra (1):
      sched: Cure more NO_HZ load average woes

Rafael J. Wysocki (1):
      PM / Runtime: Fix pm_runtime_suspended()

Rajkumar Manoharan (1):
      ath9k: Disable SWBA interrupt on remove_interface

Robert Richter (1):
      arch/x86/oprofile/op_model_amd.c: Perform initialisation on a single CPU

Saeed Bishara (1):
      mv_xor: fix race in tasklet function

Sarah Sharp (1):
      xhci: Fix issue with port array setup and buggy hosts.

Sergey Vlasov (1):
      NFS: Fix fcntl F_GETLK not reporting some conflicts

Seungwhan Youn (1):
      ASoC: WM8580: Fix R8 initial value

Shan Wei (1):
      8139cp: fix checksum broken

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing

Stanislaw Gruszka (1):
      mac80211: fix hard lockup in sta_addba_resp_timer_expired

Steve Conklin (1):
      revert-drm-radeon-kms-properly-compute-group_size-on-6xx-7xx

Suresh Siddha (4):
      bootmem: Add alloc_bootmem_align()
      x86, xsave: Use alloc_bootmem_align() instead of alloc_bootmem()
      x86, vt-d: Handle previous faults after enabling fault handling
      x86, vt-d: Quirk for masking vtd spec errors to platform error handling logic

Takashi Iwai (2):
      PM / Hibernate: Fix PM_POST_* notification with user-space suspend
      mmc: Fix re-probing with PM_POST_RESTORE notification

Tavis Ormandy (1):
      install_special_mapping skips security_file_mmap check.

Tejun Heo (1):
      libata-sff: fix HSM_ST_ERR handling in __ata_sff_port_intr()

Thomas Sailer (1):
      USB: misc: uss720.c: add another vendor/product ID

Uk Kim (2):
      ASoC: Fix swap of left and right channels for WM8993/4 speaker boost gain
      ASoC: Fix off by one error in WM8994 EQ register bank size

Valentine Barshak (1):
      ARM: 6535/1: V6 MPCore v6_dma_inv_range and v6_dma_flush_range RWFO fix

Vasiliy Kulikov (2):
      net: ax25: fix information leak to userland
      net: packet: fix information leak to userland

Vitaly Kuznetsov (1):
      USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

Wolfram Sang (1):
      rtc: rs5c372: fix buffer size

Yan Li (1):
      Input: synaptics - fix handling of 2-button ClickPads

Yauhen Kharuzhy (1):
      mmc: at91_mci: fix multiblock SDIO transfers

françois romieu (1):
      r8169: fix sleeping while holding spinlock.

 Documentation/kernel-parameters.txt         |    1 +
 Documentation/power/runtime_pm.txt          |    4 +-
 Makefile                                    |    2 +-
 arch/arm/mach-at91/include/mach/at91_mci.h  |    2 +
 arch/arm/mm/cache-v6.S                      |   28 ++++--
 arch/sparc/include/asm/openprom.h           |    2 +-
 arch/sparc/include/asm/oplib_32.h           |   35 +------
 arch/sparc/include/asm/oplib_64.h           |   46 +--------
 arch/sparc/kernel/leon_kernel.c             |    4 +-
 arch/sparc/prom/Makefile                    |    1 -
 arch/sparc/prom/console_32.c                |   65 ++---------
 arch/sparc/prom/console_64.c                |   81 +++-----------
 arch/sparc/prom/devops_32.c                 |   87 ---------------
 arch/sparc/prom/devops_64.c                 |   67 ------------
 arch/sparc/prom/misc_64.c                   |   16 +---
 arch/sparc/prom/printf.c                    |   35 +++++-
 arch/sparc/prom/tree_32.c                   |   15 ---
 arch/sparc/prom/tree_64.c                   |   18 ---
 arch/x86/include/asm/processor.h            |   23 ----
 arch/x86/kernel/apic/apic.c                 |    8 ++
 arch/x86/kernel/apic/io_apic.c              |    1 +
 arch/x86/kernel/apic/probe_64.c             |    7 --
 arch/x86/kernel/cpu/amd.c                   |    3 +-
 arch/x86/kernel/microcode_intel.c           |   16 +--
 arch/x86/kernel/smpboot.c                   |   85 ++++++++++++++-
 arch/x86/kernel/xsave.c                     |    3 +-
 arch/x86/oprofile/op_model_amd.c            |   24 +++--
 arch/x86/vdso/Makefile                      |    4 +-
 block/blk-merge.c                           |    6 +-
 block/blk-settings.c                        |   25 +----
 block/blk-sysfs.c                           |    2 +-
 drivers/acpi/acpica/dswexec.c               |   19 +++-
 drivers/acpi/ec.c                           |    3 +
 drivers/ata/libata-sff.c                    |    7 +-
 drivers/block/xen-blkfront.c                |    2 +-
 drivers/char/n_gsm.c                        |    6 +-
 drivers/char/ramoops.c                      |   12 ++-
 drivers/dma/mv_xor.c                        |    2 +-
 drivers/edac/amd64_edac.c                   |    2 +-
 drivers/edac/edac_mc.c                      |   10 +-
 drivers/gpio/cs5535-gpio.c                  |   19 +++-
 drivers/gpio/rdc321x-gpio.c                 |    2 +-
 drivers/gpu/drm/drm_crtc.c                  |   10 +-
 drivers/gpu/drm/i915/intel_dp.c             |   37 +++++--
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    6 +
 drivers/gpu/drm/nouveau/nouveau_irq.c       |    1 +
 drivers/gpu/drm/nouveau/nv50_display.c      |   35 +++++--
 drivers/gpu/drm/radeon/atombios_crtc.c      |    3 +-
 drivers/gpu/drm/radeon/evergreen.c          |   25 ++---
 drivers/gpu/drm/radeon/r600.c               |   24 +++--
 drivers/gpu/drm/radeon/radeon_device.c      |    9 +-
 drivers/gpu/drm/radeon/rv770.c              |    9 +-
 drivers/hwmon/adm1026.c                     |   20 ++--
 drivers/infiniband/core/uverbs_cmd.c        |  101 ++++++++++--------
 drivers/input/mouse/synaptics.h             |    3 +-
 drivers/input/serio/i8042-x86ia64io.h       |   21 ++++
 drivers/input/serio/i8042.c                 |    6 +-
 drivers/md/dm-table.c                       |    5 -
 drivers/md/md.c                             |   15 ++--
 drivers/md/raid10.c                         |    2 +-
 drivers/media/video/gspca/sonixj.c          |   17 +++-
 drivers/mfd/wm831x-core.c                   |    8 +-
 drivers/mmc/core/core.c                     |    1 +
 drivers/mmc/host/at91_mci.c                 |   13 ++-
 drivers/mmc/host/atmel-mci.c                |   18 ++-
 drivers/net/8139cp.c                        |   10 +-
 drivers/net/benet/be_cmds.c                 |    2 +-
 drivers/net/bonding/bonding.h               |    4 +-
 drivers/net/ifb.c                           |    2 +
 drivers/net/r8169.c                         |    4 +-
 drivers/net/tehuti.c                        |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c |   12 ++-
 drivers/net/wireless/ath/ath9k/main.c       |   11 ++-
 drivers/net/wireless/orinoco/main.c         |    6 +
 drivers/net/wireless/orinoco/wext.c         |    4 +-
 drivers/net/wireless/p54/p54usb.c           |    6 +
 drivers/net/wireless/rt2x00/rt2400pci.c     |    6 +-
 drivers/net/wireless/rt2x00/rt2500pci.c     |   12 ++-
 drivers/net/wireless/rt2x00/rt2500usb.c     |   12 ++-
 drivers/net/wireless/rt2x00/rt2800.h        |    7 ++
 drivers/net/wireless/rt2x00/rt2800lib.c     |   59 ++++++----
 drivers/net/wireless/rt2x00/rt2x00.h        |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c       |   12 ++-
 drivers/net/wireless/rt2x00/rt73usb.c       |   12 ++-
 drivers/net/xen-netfront.c                  |    4 +-
 drivers/pci/dmar.c                          |    5 +
 drivers/pci/quirks.c                        |   23 ++++
 drivers/rtc/rtc-rs5c372.c                   |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |    1 +
 drivers/scsi/qla2xxx/qla_nx.c               |    1 +
 drivers/scsi/qla2xxx/qla_os.c               |    1 +
 drivers/scsi/scsi_lib.c                     |    3 +-
 drivers/usb/gadget/composite.c              |   16 ++--
 drivers/usb/host/xhci-mem.c                 |   25 +++--
 drivers/usb/misc/uss720.c                   |    4 +-
 drivers/usb/serial/ftdi_sio.c               |    1 +
 drivers/usb/serial/ftdi_sio_ids.h           |    5 +
 drivers/usb/storage/unusual_devs.h          |    7 ++
 drivers/watchdog/rdc321x_wdt.c              |    2 +-
 fs/exec.c                                   |    5 +
 fs/fuse/file.c                              |   72 +++++++++++-
 fs/nfs/file.c                               |    2 +
 fs/nfs/mount_clnt.c                         |    4 +-
 fs/nfsd/nfs3xdr.c                           |    6 +-
 fs/nfsd/xdr4.h                              |   21 ++--
 fs/notify/inotify/inotify_user.c            |    1 +
 include/linux/blkdev.h                      |    9 +-
 include/linux/bootmem.h                     |    2 +
 include/linux/mfd/wm8994/pdata.h            |    2 +-
 include/linux/pm_runtime.h                  |    3 +-
 include/linux/sched.h                       |    2 +-
 include/linux/socket.h                      |    5 +
 include/linux/user_namespace.h              |   14 +++
 include/net/af_unix.h                       |    6 +-
 include/net/scm.h                           |   28 ++++-
 include/net/sock.h                          |    4 +-
 include/xen/interface/io/ring.h             |   11 ++-
 kernel/exit.c                               |    8 ++
 kernel/fork.c                               |    1 +
 kernel/power/user.c                         |    2 +-
 kernel/printk.c                             |    4 +-
 kernel/sched.c                              |  156 ++++++++++++++++++++++++---
 kernel/timer.c                              |    8 ++-
 kernel/trace/trace.c                        |   10 ++-
 kernel/user.c                               |    1 +
 kernel/user_namespace.c                     |   44 ++++++++
 mm/mmap.c                                   |   16 ++-
 net/ax25/af_ax25.c                          |    2 +-
 net/bridge/br_multicast.c                   |    2 +-
 net/core/dst.c                              |    1 +
 net/core/filter.c                           |   19 +---
 net/core/scm.c                              |   24 ++++
 net/core/sock.c                             |   15 +++
 net/econet/af_econet.c                      |   12 ++-
 net/ipv4/tcp.c                              |    2 +-
 net/ipv4/tcp_ipv4.c                         |    8 +-
 net/ipv4/tcp_output.c                       |   42 ++++----
 net/l2tp/l2tp_ip.c                          |    6 +-
 net/llc/af_llc.c                            |    5 +-
 net/mac80211/agg-tx.c                       |    2 +-
 net/mac80211/rx.c                           |    3 +
 net/mac80211/tx.c                           |   24 ++++-
 net/packet/af_packet.c                      |    7 +-
 net/sched/cls_cgroup.c                      |    2 -
 net/sunrpc/svc_xprt.c                       |    9 ++-
 net/unix/af_unix.c                          |   86 +++++++++++-----
 net/unix/garbage.c                          |    9 ++-
 net/x25/x25_link.c                          |    1 +
 security/integrity/ima/ima_policy.c         |    2 +
 sound/oss/soundcard.c                       |    4 +-
 sound/pci/hda/hda_intel.c                   |    2 +
 sound/pci/hda/patch_conexant.c              |    4 +-
 sound/pci/hda/patch_realtek.c               |    1 +
 sound/soc/codecs/wm8580.c                   |    2 +-
 sound/soc/codecs/wm8904.c                   |    3 +-
 sound/soc/codecs/wm8955.c                   |    3 +-
 sound/soc/codecs/wm_hubs.c                  |    2 +-
 158 files changed, 1325 insertions(+), 907 deletions(-)
 delete mode 100644 arch/sparc/prom/devops_32.c
 delete mode 100644 arch/sparc/prom/devops_64.c
-- 
ak@linux.intel.com -- Speaking for myself only.
