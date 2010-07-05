Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0GESoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:44:20 -0400
Received: from kroah.org ([198.145.64.141]:35214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab0GESoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:44:16 -0400
Date: Mon, 5 Jul 2010 11:40:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.16
Message-ID: <20100705184018.GE31678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.16 kernel.

All users of the 2.6.32 kernel series should upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/hwmon/ltc4245                     |    4 
 Documentation/networking/3c509.txt              |   12 -
 Makefile                                        |    2 
 arch/arm/common/sa1111.c                        |    9 
 arch/arm/mm/copypage-feroceon.c                 |    4 
 arch/arm/mm/copypage-v4wb.c                     |    4 
 arch/arm/mm/copypage-v4wt.c                     |    4 
 arch/arm/mm/copypage-xsc3.c                     |    4 
 arch/arm/mm/fault.c                             |    3 
 arch/arm/mm/init.c                              |    6 
 arch/arm/vfp/vfphw.S                            |    2 
 arch/blackfin/include/asm/cache.h               |    2 
 arch/frv/include/asm/cache.h                    |    2 
 arch/m68k/include/asm/cache.h                   |    2 
 arch/mn10300/include/asm/cache.h                |    2 
 arch/parisc/math-emu/decode_exc.c               |    1 
 arch/powerpc/kvm/powerpc.c                      |    3 
 arch/powerpc/lib/string.S                       |    4 
 arch/powerpc/oprofile/op_model_cell.c           |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   30 ---
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    8 
 arch/powerpc/platforms/pseries/smp.c            |   28 ++
 arch/s390/kvm/kvm-s390.c                        |    4 
 arch/x86/include/asm/kvm_host.h                 |    1 
 arch/x86/include/asm/msr-index.h                |    5 
 arch/x86/kernel/amd_iommu.c                     |    2 
 arch/x86/kernel/cpu/perf_event.c                |    5 
 arch/x86/kernel/pvclock.c                       |   24 ++
 arch/x86/kernel/setup.c                         |   11 +
 arch/x86/kernel/tboot.c                         |    1 
 arch/x86/kvm/mmu.c                              |   10 -
 arch/x86/kvm/vmx.c                              |   32 ++-
 arch/x86/kvm/x86.c                              |   55 +++--
 arch/x86/oprofile/nmi_int.c                     |   10 -
 arch/x86/xen/suspend.c                          |    4 
 arch/xtensa/include/asm/cache.h                 |    1 
 drivers/acpi/video_detect.c                     |    2 
 drivers/ata/libata-core.c                       |    7 
 drivers/ata/libata-sff.c                        |    2 
 drivers/ata/sata_nv.c                           |    5 
 drivers/ata/sata_via.c                          |   13 +
 drivers/base/cpu.c                              |    2 
 drivers/char/ipmi/ipmi_si_intf.c                |   11 -
 drivers/clocksource/sh_cmt.c                    |   21 +-
 drivers/firewire/core-card.c                    |   24 ++
 drivers/gpu/drm/drm_edid.c                      |    2 
 drivers/gpu/drm/i915/i915_gem.c                 |   19 ++
 drivers/gpu/drm/i915/intel_lvds.c               |    4 
 drivers/gpu/drm/radeon/radeon_atombios.c        |    2 
 drivers/gpu/drm/radeon/radeon_cp.c              |    1 
 drivers/gpu/drm/radeon/radeon_drv.h             |    2 
 drivers/gpu/drm/radeon/radeon_state.c           |    7 
 drivers/hid/hid-core.c                          |    1 
 drivers/hid/hid-gyration.c                      |    1 
 drivers/hid/hid-ids.h                           |    1 
 drivers/hwmon/ltc4245.c                         |   18 -
 drivers/input/mouse/psmouse-base.c              |   14 +
 drivers/md/dm-exception-store.h                 |    2 
 drivers/md/md.c                                 |   29 +++
 drivers/md/raid1.c                              |    9 
 drivers/md/raid10.c                             |    2 
 drivers/media/video/gspca/stv06xx/stv06xx.c     |    2 
 drivers/net/arcnet/com20020-pci.c               |    4 
 drivers/net/atl1e/atl1e_ethtool.c               |    2 
 drivers/net/can/sja1000/sja1000.c               |   20 +-
 drivers/net/can/sja1000/sja1000.h               |    1 
 drivers/net/ixgbe/ixgbe_main.c                  |    8 
 drivers/net/mlx4/icm.c                          |    3 
 drivers/net/pppol2tp.c                          |    3 
 drivers/net/tulip/Kconfig                       |    4 
 drivers/net/tulip/dmfe.c                        |   21 ++
 drivers/net/tulip/tulip_core.c                  |   32 ++-
 drivers/net/ucc_geth.c                          |   12 -
 drivers/net/via-velocity.c                      |    8 
 drivers/net/virtio_net.c                        |    3 
 drivers/net/wireless/ath/ar9170/hw.h            |    1 
 drivers/net/wireless/ath/ar9170/main.c          |    2 
 drivers/net/wireless/ath/ar9170/usb.c           |   10 +
 drivers/net/wireless/ath/ath5k/base.c           |    4 
 drivers/net/wireless/ath/ath9k/hw.c             |    7 
 drivers/net/wireless/ath/ath9k/hw.h             |    1 
 drivers/net/wireless/ath/ath9k/main.c           |    4 
 drivers/net/wireless/ath/ath9k/pci.c            |    1 
 drivers/net/wireless/iwlwifi/iwl-5000.c         |   23 ++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   24 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c          |   74 ++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h          |    3 
 drivers/net/wireless/iwlwifi/iwl-tx.c           |   18 +
 drivers/net/wireless/p54/p54usb.c               |    1 
 drivers/net/wireless/rtl818x/rtl8180_dev.c      |    1 
 drivers/net/wireless/wl12xx/wl1251_sdio.c       |    1 
 drivers/oprofile/cpu_buffer.c                   |   63 +-----
 drivers/pci/quirks.c                            |   14 +
 drivers/rtc/rtc-cmos.c                          |    5 
 drivers/rtc/rtc-s3c.c                           |    5 
 drivers/scsi/qla2xxx/qla_isr.c                  |   28 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c      |    2 
 drivers/staging/rtl8192su/r8192U_core.c         |    1 
 drivers/staging/vt6655/device_main.c            |    2 
 drivers/usb/class/cdc-acm.c                     |    6 
 drivers/usb/gadget/fsl_udc_core.c               |    2 
 drivers/usb/host/ehci-hub.c                     |   17 +
 drivers/usb/host/xhci-hcd.c                     |   54 ++++-
 drivers/usb/host/xhci-ring.c                    |   37 +++
 drivers/usb/serial/cp210x.c                     |   11 +
 drivers/usb/serial/ftdi_sio.c                   |    4 
 drivers/usb/serial/ir-usb.c                     |    2 
 drivers/usb/serial/kl5kusb105.c                 |    1 
 drivers/usb/serial/kobil_sct.c                  |    3 
 drivers/usb/serial/mos7840.c                    |    1 
 drivers/usb/serial/option.c                     |  226 ++++++++++++++++++++++++
 drivers/usb/serial/visor.c                      |    1 
 drivers/usb/storage/unusual_devs.h              |   15 +
 drivers/xen/xenbus/xenbus_xs.c                  |    2 
 fs/btrfs/acl.c                                  |    3 
 fs/cifs/cifsproto.h                             |    6 
 fs/cifs/dir.c                                   |   20 +-
 fs/cifs/file.c                                  |   11 -
 fs/exofs/dir.c                                  |    2 
 fs/fs-writeback.c                               |   14 +
 fs/gfs2/file.c                                  |    7 
 fs/jbd/journal.c                                |    2 
 fs/jbd2/journal.c                               |    3 
 fs/libfs.c                                      |    3 
 fs/namespace.c                                  |    9 
 fs/nfsd/nfssvc.c                                |    2 
 include/linux/fs.h                              |    4 
 include/linux/pci_ids.h                         |    1 
 include/linux/swap.h                            |   10 -
 include/linux/tboot.h                           |    1 
 include/net/sctp/structs.h                      |    1 
 kernel/compat.c                                 |   25 +-
 kernel/mutex.c                                  |    7 
 kernel/perf_event.c                             |   40 ++--
 kernel/posix-timers.c                           |   11 -
 kernel/signal.c                                 |    6 
 mm/filemap.c                                    |   10 -
 mm/hugetlb.c                                    |    2 
 net/mac80211/Kconfig                            |    9 
 net/mac80211/rx.c                               |    3 
 net/mac80211/tx.c                               |    5 
 net/sctp/sm_make_chunk.c                        |   62 ++++++
 net/tipc/bearer.c                               |   37 ---
 net/tipc/bearer.h                               |    2 
 net/tipc/net.c                                  |   25 --
 net/wireless/core.h                             |    2 
 net/wireless/nl80211.c                          |   37 ---
 net/wireless/util.c                             |   33 +++
 net/wireless/wext-compat.c                      |    5 
 security/keys/keyring.c                         |   18 -
 security/keys/process_keys.c                    |    6 
 sound/pci/hda/hda_intel.c                       |   11 -
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/pci/hda/patch_sigmatel.c                  |    2 
 sound/soc/codecs/wm8350.c                       |    4 
 sound/soc/codecs/wm8400.c                       |   18 -
 sound/soc/codecs/wm8990.c                       |   18 -
 157 files changed, 1286 insertions(+), 516 deletions(-)

Adam Jackson (1):
      drm/edid: Fix 1024x768@85Hz

Al Viro (1):
      Fix racy use of anon_inode_getfd() in perf_event.c

Alek Du (1):
      USB: EHCI: clear PHCD before resuming

Alex Deucher (2):
      PCI quirks: disable msi on AMD rs4xx internal gfx bridges
      drm/radeon/kms/atom: fix typo in LVDS panel info parsing

Andi Kleen (1):
      oprofile: remove double ring buffering

Andiry Xu (1):
      USB: xHCI: Fix wrong usage of macro TRB_TYPE

Andrea Arcangeli (1):
      mm: hugetlb: fix clear_huge_page()

Andreas Bombe (1):
      ARCNET: Limit com20020 PCI ID matches for SOHARD cards

Andres Salomon (1):
      mac80211: give warning if building w/out rate ctrl algorithm

Andrey Vagin (1):
      posix_timer: Fix error path in timer_create

Anfei (1):
      ARM: 6166/1: Proper prefetch abort handling on pre-ARMv6

Anton Vorontsov (2):
      ucc_geth: Fix empty TX queue processing
      ucc_geth: Fix netdev watchdog triggering on link changes

Avi Kivity (5):
      KVM: Don't allow lmsw to clear cr0.pe
      KVM: MMU: Segregate shadow pages with different cr0.wp
      KVM: MMU: Don't read pdptrs with mmu spinlock held in mmu_alloc_roots
      KVM: Fix wallclock version writing race
      KVM: x86: Add missing locking to arch specific vcpu ioctls

Axel Lin (1):
      USB: cdc-acm: fix resource reclaim in error path of acm_probe

Ben Hutchings (6):
      PCI: Disable MSI for MCP55 on P5N32-E SLI
      atl1e: Allow TX checksum offload and TSO to be disabled and reenabled
      via-velocity: Give RX descriptors to the NIC later on open or MTU change
      dmfe/tulip: Let dmfe handle DM910x except for SPARC on-board chips
      Documentation/3c509: document ethtool support
      qla2xxx: Disable MSI on qla24xx chips other than QLA2432.

Bob Copeland (1):
      ath5k: retain promiscuous setting

Chris Wilson (2):
      drm/i915: Reject bind_to_gtt() early if object > aperture
      drm/i915: Rebind bo if currently bound with incorrect alignment.

Christian Lamparter (2):
      ar9170usb: add a couple more USB IDs
      ar9170usb: fix panic triggered by undersized rxstream buffer

Cory Maccarrone (1):
      HID: Add the GYR4101US USB ID to hid-gyration

Craig Shelley (1):
      USB: CP210x New Device IDs 11 New device IDs

Dan Carpenter (3):
      exofs: confusion between kmap() and kmap_atomic() api
      rtc-cmos: do dev_set_drvdata() earlier in the initialization
      KEYS: Return more accurate error codes

Dan Williams (1):
      md: set mddev readonly flag on blkdev BLKROSET ioctl

Daniel Mack (1):
      USB: ftdi_sio: fix DTR/RTS line modes

Daniel T Chen (9):
      ALSA: hda: Fix model quirk for Dell M1730
      ALSA: hda: Use LPIB for Toshiba A100-259
      ALSA: hda: Use LPIB for Acer Aspire 5110
      ALSA: hda: Use LPIB for Sony VPCS11V9E
      ALSA: hda: Use LPIB for a Shuttle device
      ALSA: hda: Use LPIB for an ASUS device
      ALSA: hda: Use mb31 quirk for an iMac model
      ALSA: hda: Use LPIB for another mainboard
      ALSA: hda: Use LPIB for ASUS M2V

Dave Airlie (2):
      drm/radeon: r100/r200 ums: block ability for userspace app to trash 0 page and beyond
      drm/radeon: fix the r100/r200 ums block 0 page fix

Denis Kirjanov (1):
      powerpc/oprofile: fix potential buffer overrun in op_model_cell.c

Dinh Nguyen (1):
      USB: mxc: gadget: Fix bitfield for calculating maximum packet size

Dmitry Torokhov (1):
      Input: psmouse - reset all types of mice before reconnecting

Erik Andrén (1):
      V4L/DVB: gspca - stv06xx: Remove the 046d:08da from the stv06xx driver

FUJITA Tomonori (5):
      mn10300: set ARCH_KMALLOC_MINALIGN
      m68k: set ARCH_KMALLOC_MINALIGN
      frv: set ARCH_KMALLOC_MINALIGN
      xtensa: set ARCH_KMALLOC_MINALIGN
      Blackfin: set ARCH_KMALLOC_MINALIGN

Gabor Gombas (1):
      x86, setup: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012

Glauber Costa (1):
      x86, paravirt: Add a global synchronization point for pvclock

Grazvydas Ignotas (1):
      wl1251: fix a memory leak in probe

Greg Kroah-Hartman (2):
      USB: serial: option: add cinterion device id
      Linux 2.6.32.16

Hans de Goede (1):
      USB: unusual-dev: Add bad sense flag for Appotech ax203 based picture frames

Helge Deller (1):
      parisc: clear floating point exception flag on SIGFPE signal

Herbert Xu (1):
      virtio_net: Make delayed refill more reliable

Ian Campbell (2):
      xen: ensure timer tick is resumed even on CPU driving the resume
      xen: avoid allocation causing potential swap activity on the resume path

Ira W. Snyder (1):
      hwmon: (ltc4245) Read only one GPIO pin

James Chapman (1):
      l2tp: Fix oops in pppol2tp_xmit

Jan Beulich (1):
      drivers/base/cpu.c: fix the output from /sys/devices/system/cpu/offline

Jason Dravet (1):
      p54usb: Add device ID for Dell WLA3310 USB

Jeff Mahoney (1):
      powerpc: Fix handling of strncmp with zero len

Jeff Moyer (1):
      do_generic_file_read: clear page errors when issuing a fresh read of the page

Jens Axboe (1):
      writeback: disable periodic old data writeback for !dirty_writeback_centisecs

Jesse Barnes (1):
      drm/i915: give up on 8xx lid status

Jiajun Wu (1):
      ucc_geth: Fix full TX queue processing

Jiri Kosina (1):
      ipmi: handle run_to_completion properly in deliver_recv_msg()

Joerg Roedel (1):
      x86/amd-iommu: Fix suspend/resume with IOMMU

Johan Hovold (5):
      USB: visor: fix memory leak
      USB: kobil: fix memory leak
      USB: ir-usb: fix double free
      USB: kl5usb105: fix memory leak
      USB: mos7840: fix null-pointer dereference

John W. Linville (2):
      rtl8180: fix tx status reporting
      wireless: report reasonable bitrate for MCS rates through wext

Jouni Malinen (1):
      mac80211: Fix robust management frame handling (MFP)

KOSAKI Motohiro (2):
      cpumask: fix compat getaffinity
      tmpfs: insert tmpfs cache pages to inactive list at first

Kamal Mostafa (1):
      ACPI: video: fix acpi_backlight=video

Khem Raj (1):
      ARM: 6164/1: Add kto and kfrom to input operands list.

Krishna Kumar (1):
      ixgbe: Fix return of invalid txq

Larry Finger (1):
      staging: vt6655: Fix kernel BUG on driver wpa initialization

Linus Walleij (1):
      ARM: 6144/1: TCM memory bug freeing bug

Luis R. Rodriguez (1):
      ath9k: add support for 802.11n bonded out AR2427

Marek Vašut (1):
      ARM: 6146/1: sa1111: Prevent deadlock in resume path

Mark Brown (3):
      ASoC: Fix dB scales for WM835x
      ASoC: Fix dB scales for WM8400
      ASoC: Fix dB scales for WM8990

Martin Homuth-Rosemann (1):
      Staging: comedi - correct parameter gainlkup for DAQCard-6024E in driver ni_mio_cs.c

Matthew Wilcox (1):
      PCI quirk: Disable MSI on VIA K8T890 systems

Maurus Cuelenaere (1):
      rtc: s3c: initialize driver data before using it

Michael Neuling (2):
      powerpc/pseries: Only call start-cpu when a CPU is stopped
      powerpc/pseries: Make query_cpu_stopped callable outside hotplug cpu

Miklos Szeredi (1):
      vfs: add NOFOLLOW flag to umount(2)

Mikulas Patocka (1):
      dm snapshot: simplify sector_to_chunk expression

Neil Horman (2):
      sctp: Fix skb_over_panic resulting from multiple invalid parameter errors (CVE-2010-1173) (v4)
      tipc: Fix oops on send prior to entering networked mode (v3)

NeilBrown (2):
      md/raid1: fix counting of write targets.
      md: Fix read balancing in RAID1 and RAID10 on drives > 2TB

Nils Radtke (1):
      USB: option.c: OLIVETTI OLICARD100 support

Oleg Nesterov (1):
      signals: check_kill_permission(): don't check creds if same_thread_group()

Oliver Hartkopp (1):
      can: Fix SJA1000 command register writes on SMP systems

Paul Mundt (1):
      clocksource: sh_cmt: compute mult and shift before registration

Pavel Emelyanov (1):
      NFSD: don't report compiled-out versions as present

Reinette Chatre (1):
      iwlwifi: recalculate average tpt if not current

Robert Richter (1):
      oprofile/x86: fix uninitialized counter usage during cpu hotplug

Roberto Sassu (1):
      wrong type for 'magic' argument in simple_fill_super()

Rodrigo Linfati (1):
      Staging: add Add Sitecom WL-349 to rtl8192su

Roedel, Joerg (1):
      KVM: x86: Inject #GP with the right rip on efer writes

Russell King (1):
      ARM: VFP: Fix vfp_put_double() for d16-d31

Sarah Sharp (4):
      USB: xhci: Fix issue with set interface after stall.
      USB: xhci: Fix check for room on the ring.
      USB: xhci: Wait for host to start running.
      USB: xhci: Wait for controller to be ready after reset.

Sebastian Andrzej Siewior (1):
      libata: don't flush dcache on slab pages

Sebastien Dugue (1):
      mlx4_core: Fix possible chunk sg list overflow in mlx4_alloc_icm()

Shane Wang (1):
      KVM: VMX: enable VMXON check with SMX enabled (Intel TXT)

Shanyu Zhao (1):
      mac80211: fix rts threshold check

Sheng Yang (1):
      KVM: x86: Check LMA bit before set_efer

Shi Weihua (1):
      Btrfs: should add a permission check for setfacl

Stefan Richter (1):
      firewire: core: check for 1394a compliant IRM, fix inaccessibility of Sony camcorder

Stephane Eranian (1):
      perf_events: Fix resource leak in x86 __hw_perf_event_init()

Steve French (1):
      CIFS: Allow null nd (as nfs server uses) on create

Steven Whitehouse (1):
      GFS2: Fix permissions checking for setflags ioctl()

Tejun Heo (5):
      sata_nv: use ata_pci_sff_activate_host() instead of ata_host_activate()
      libata: disable ATAPI AN by default
      ahci: add pci quirk for JMB362
      sata_nv: don't diddle with nIEN on mcp55
      sata_via: magic vt6421 fix for transmission problems w/ WD drives

Tony Breeds (1):
      mutex: Fix optimistic spinning vs. BKL

Toshiyuki Okajima (1):
      KEYS: find_keyring_by_name() can gain access to a freed keyring

Wei Yongjun (3):
      KVM: s390: Fix possible memory leak of in kvm_arch_vcpu_create()
      KVM: PPC: Do not create debugfs if fail to create vcpu
      sctp: fix append error cause to ERROR chunk correctly

Wey-Yi Guy (2):
      iwlwifi: check for aggregation frame and queue
      iwlwifi: update supported PCI_ID list for 5xx0 series

Yin Kangkai (1):
      jbd: jbd-debug and jbd2-debug should be writable

spark (1):
      USB: option.c: Add Pirelli VID/PID and indicate Pirelli's modem interface is 0xff

zhao1980ming (1):
      USB: option: add PID for ZTE product

