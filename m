Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0GESpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:45:16 -0400
Received: from kroah.org ([198.145.64.141]:35221 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab0GESoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:44:20 -0400
Date: Mon, 5 Jul 2010 11:41:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.6
Message-ID: <20100705184159.GG31678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.6 kernel.

All users of the 2.6.33 kernel series should upgrade.

There will only be one more .33-stable release after this one.  Everyone
using the .33 series should be looking into moving to the .34 kernel
tree at this point in time.  Yeah, I said that for the last .33 release,
but this time I really mean it :)

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/hwmon/ltc4245                     |    4 
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
 arch/powerpc/kvm/book3s.c                       |   10 +
 arch/powerpc/kvm/booke.c                        |   15 +
 arch/powerpc/kvm/powerpc.c                      |    3 
 arch/powerpc/lib/string.S                       |    4 
 arch/powerpc/oprofile/op_model_cell.c           |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   30 ---
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    8 
 arch/powerpc/platforms/pseries/smp.c            |   28 ++
 arch/s390/kvm/kvm-s390.c                        |    4 
 arch/x86/include/asm/kvm_host.h                 |    3 
 arch/x86/include/asm/msr-index.h                |    5 
 arch/x86/kernel/amd_iommu.c                     |   16 -
 arch/x86/kernel/amd_iommu_init.c                |   20 +-
 arch/x86/kernel/cpu/perf_event.c                |    5 
 arch/x86/kernel/pvclock.c                       |   24 ++
 arch/x86/kernel/setup.c                         |   11 +
 arch/x86/kernel/tboot.c                         |    1 
 arch/x86/kvm/mmu.c                              |   12 +
 arch/x86/kvm/svm.c                              |  164 +++++++++++------
 arch/x86/kvm/vmx.c                              |   37 ++-
 arch/x86/kvm/x86.c                              |   58 +++---
 arch/x86/oprofile/nmi_int.c                     |   10 -
 arch/x86/xen/suspend.c                          |    4 
 arch/xtensa/include/asm/cache.h                 |    1 
 block/cfq-iosched.c                             |   20 +-
 drivers/acpi/video_detect.c                     |    2 
 drivers/ata/libata-core.c                       |    7 
 drivers/ata/libata-sff.c                        |    2 
 drivers/ata/sata_nv.c                           |    5 
 drivers/ata/sata_via.c                          |   13 +
 drivers/base/cpu.c                              |    2 
 drivers/char/ipmi/ipmi_si_intf.c                |   11 -
 drivers/clocksource/sh_cmt.c                    |   21 +-
 drivers/clocksource/sh_tmu.c                    |   20 +-
 drivers/firewire/core-card.c                    |   24 ++
 drivers/gpu/drm/drm_edid.c                      |    2 
 drivers/gpu/drm/i915/i915_drv.c                 |    5 
 drivers/gpu/drm/i915/i915_drv.h                 |    3 
 drivers/gpu/drm/i915/i915_gem.c                 |   19 ++
 drivers/gpu/drm/radeon/radeon_atombios.c        |    7 
 drivers/gpu/drm/radeon/radeon_cp.c              |    1 
 drivers/gpu/drm/radeon/radeon_drv.h             |    2 
 drivers/gpu/drm/radeon/radeon_state.c           |    7 
 drivers/hid/hid-core.c                          |    1 
 drivers/hid/hid-gyration.c                      |    1 
 drivers/hid/hid-ids.h                           |    1 
 drivers/hwmon/ltc4245.c                         |   18 -
 drivers/input/mouse/psmouse-base.c              |   14 +
 drivers/md/linear.c                             |    1 
 drivers/md/md.c                                 |   99 +++++++++-
 drivers/md/md.h                                 |    1 
 drivers/md/raid1.c                              |    9 
 drivers/md/raid10.c                             |    2 
 drivers/md/raid5.c                              |    7 
 drivers/media/video/gspca/stv06xx/stv06xx.c     |    2 
 drivers/net/arcnet/com20020-pci.c               |    4 
 drivers/net/can/sja1000/sja1000.c               |   20 +-
 drivers/net/can/sja1000/sja1000.h               |    1 
 drivers/net/mlx4/icm.c                          |    3 
 drivers/net/pppol2tp.c                          |    3 
 drivers/net/wireless/ath/ar9170/hw.h            |    1 
 drivers/net/wireless/ath/ar9170/main.c          |    2 
 drivers/net/wireless/ath/ar9170/usb.c           |   10 +
 drivers/net/wireless/ath/ath5k/base.c           |   11 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   10 -
 drivers/net/wireless/iwlwifi/iwl-agn.c          |    8 
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    7 
 drivers/net/wireless/p54/p54usb.c               |    1 
 drivers/net/wireless/rtl818x/rtl8180_dev.c      |    1 
 drivers/net/wireless/wl12xx/wl1251_sdio.c       |    1 
 drivers/oprofile/cpu_buffer.c                   |   63 +-----
 drivers/pci/quirks.c                            |   14 +
 drivers/platform/x86/eeepc-laptop.c             |   18 +
 drivers/rtc/rtc-cmos.c                          |    5 
 drivers/rtc/rtc-s3c.c                           |    5 
 drivers/scsi/qla2xxx/qla_isr.c                  |   28 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c      |    2 
 drivers/staging/rt2860/usb_main_dev.c           |    1 
 drivers/staging/rtl8192su/r8192U_core.c         |    1 
 drivers/staging/vt6655/device_main.c            |    2 
 drivers/usb/class/cdc-acm.c                     |    6 
 drivers/usb/gadget/fsl_udc_core.c               |    2 
 drivers/usb/host/ehci-hub.c                     |   17 +
 drivers/usb/host/fhci.h                         |    9 
 drivers/usb/host/xhci-hcd.c                     |   54 ++++-
 drivers/usb/host/xhci-pci.c                     |    2 
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
 fs/ext4/move_extent.c                           |    3 
 fs/ext4/resize.c                                |    3 
 fs/fs-writeback.c                               |   14 +
 fs/gfs2/file.c                                  |    7 
 fs/libfs.c                                      |    3 
 fs/namespace.c                                  |    9 
 fs/nfsd/nfssvc.c                                |    2 
 include/linux/fs.h                              |    4 
 include/linux/pci_ids.h                         |    1 
 include/linux/swap.h                            |   10 -
 include/linux/tboot.h                           |    1 
 include/net/sctp/structs.h                      |    1 
 include/trace/events/signal.h                   |    3 
 kernel/compat.c                                 |   25 +-
 kernel/mutex.c                                  |    7 
 kernel/perf_event.c                             |   45 ++--
 kernel/posix-timers.c                           |   11 -
 kernel/signal.c                                 |    6 
 kernel/trace/trace.c                            |  136 ++++++++++----
 mm/filemap.c                                    |   10 -
 net/mac80211/Kconfig                            |    9 
 net/mac80211/cfg.c                              |    7 
 net/mac80211/rx.c                               |    3 
 net/mac80211/tx.c                               |    5 
 net/sctp/sm_make_chunk.c                        |   62 ++++++
 net/wireless/core.h                             |    2 
 net/wireless/nl80211.c                          |   37 ---
 net/wireless/util.c                             |   33 +++
 net/wireless/wext-compat.c                      |    5 
 scripts/kconfig/Makefile                        |    2 
 security/keys/keyring.c                         |   18 -
 security/keys/process_keys.c                    |    6 
 sound/pci/hda/hda_intel.c                       |    9 
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/pci/hda/patch_sigmatel.c                  |    2 
 sound/soc/codecs/wm8350.c                       |    4 
 sound/soc/codecs/wm8400.c                       |   18 -
 sound/soc/codecs/wm8990.c                       |   18 -
 155 files changed, 1492 insertions(+), 562 deletions(-)

Adam Jackson (2):
      drm/i915: Fix 82854 PCI ID, and treat it like other 85X
      drm/edid: Fix 1024x768@85Hz

Al Viro (1):
      Fix racy use of anon_inode_getfd() in perf_event.c

Alan Jenkins (1):
      eeepc-laptop: check wireless hotplug events

Alek Du (1):
      USB: EHCI: clear PHCD before resuming

Alex Deucher (3):
      PCI quirks: disable msi on AMD rs4xx internal gfx bridges
      drm/radeon/kms: reset ddc_bus in object header parsing
      drm/radeon/kms/atom: fix typo in LVDS panel info parsing

Andi Kleen (1):
      oprofile: remove double ring buffering

Andiry Xu (1):
      USB: xHCI: Fix wrong usage of macro TRB_TYPE

Andreas Bombe (1):
      ARCNET: Limit com20020 PCI ID matches for SOHARD cards

Andres Salomon (1):
      mac80211: give warning if building w/out rate ctrl algorithm

Andrey Vagin (1):
      posix_timer: Fix error path in timer_create

Anfei (1):
      ARM: 6166/1: Proper prefetch abort handling on pre-ARMv6

Anton Vorontsov (1):
      USB: FHCI: cq_get() should check kfifo_out()'s return value

Aurelien Jarno (1):
      clocksource: sh_tmu: compute mult and shift before registration

Avi Kivity (6):
      KVM: Don't allow lmsw to clear cr0.pe
      KVM: MMU: Segregate shadow pages with different cr0.wp
      KVM: MMU: Don't read pdptrs with mmu spinlock held in mmu_alloc_roots
      KVM: Fix wallclock version writing race
      KVM: PPC: Add missing vcpu_load()/vcpu_put() in vcpu ioctls
      KVM: x86: Add missing locking to arch specific vcpu ioctls

Axel Lin (1):
      USB: cdc-acm: fix resource reclaim in error path of acm_probe

Ben Hutchings (2):
      PCI: Disable MSI for MCP55 on P5N32-E SLI
      qla2xxx: Disable MSI on qla24xx chips other than QLA2432.

Bob Copeland (1):
      ath5k: retain promiscuous setting

Bruno Randolf (1):
      ath5k: consistently use rx_bufsize for RX DMA

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

Eric Sandeen (1):
      ext4: check s_log_groups_per_flex in online resize code

Erik Andrén (1):
      V4L/DVB: gspca - stv06xx: Remove the 046d:08da from the stv06xx driver

FUJITA Tomonori (5):
      mn10300: set ARCH_KMALLOC_MINALIGN
      m68k: set ARCH_KMALLOC_MINALIGN
      frv: set ARCH_KMALLOC_MINALIGN
      xtensa: set ARCH_KMALLOC_MINALIGN
      Blackfin: set ARCH_KMALLOC_MINALIGN

Felix Fietkau (1):
      mac80211: fix handling of 4-address-mode in ieee80211_change_iface

Gabor Gombas (1):
      x86, setup: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012

Glauber Costa (1):
      x86, paravirt: Add a global synchronization point for pvclock

Grazvydas Ignotas (1):
      wl1251: fix a memory leak in probe

Greg Kroah-Hartman (2):
      USB: serial: option: add cinterion device id
      Linux 2.6.33.6

Hans de Goede (1):
      USB: unusual-dev: Add bad sense flag for Appotech ax203 based picture frames

Helge Deller (1):
      parisc: clear floating point exception flag on SIGFPE signal

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

Jiri Kosina (1):
      ipmi: handle run_to_completion properly in deliver_recv_msg()

Joerg Roedel (11):
      x86/amd-iommu: Fix crash when request_mem_region fails
      x86/amd-iommu: Fall back to GART if initialization fails
      KVM: SVM: Don't use kmap_atomic in nested_svm_map
      KVM: SVM: Fix schedule-while-atomic on nested exception handling
      KVM: SVM: Sync all control registers on nested vmexit
      KVM: SVM: Fix nested msr intercept handling
      KVM: SVM: Don't sync nested cr8 to lapic and back
      KVM: SVM: Fix wrong interrupt injection in enable_irq_windows
      KVM: x86: Add callback to let modules decide over some supported cpuid bits
      KVM: SVM: Report emulated SVM features to userspace
      KVM: SVM: Don't allow nested guest to VMMCALL into host

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

Julia Lawall (1):
      arch/x86/kernel: Add missing spin_unlock

KOSAKI Motohiro (2):
      cpumask: fix compat getaffinity
      tmpfs: insert tmpfs cache pages to inactive list at first

Kamal Mostafa (1):
      ACPI: video: fix acpi_backlight=video

Khem Raj (1):
      ARM: 6164/1: Add kto and kfrom to input operands list.

Lai Jiangshan (1):
      tracing: Consolidate protection of reader access to the ring buffer

Larry Finger (1):
      staging: vt6655: Fix kernel BUG on driver wpa initialization

Linus Walleij (1):
      ARM: 6144/1: TCM memory bug freeing bug

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

Neil Horman (1):
      sctp: Fix skb_over_panic resulting from multiple invalid parameter errors (CVE-2010-1173) (v4)

NeilBrown (5):
      md/raid1: fix counting of write targets.
      md: Fix read balancing in RAID1 and RAID10 on drives > 2TB
      md/linear: avoid possible oops and array stop
      md: remove unneeded sysfs files more promptly
      md: manage redundancy group in sysfs when changing level.

Nils Radtke (1):
      USB: option.c: OLIVETTI OLICARD100 support

Nobuhiro KUSUNO (1):
      Staging: rt2870: add device ID of MelCo.,Inc. WLI-UC-G301N

Oleg Nesterov (2):
      signals: check_kill_permission(): don't check creds if same_thread_group()
      tracing: Fix null pointer deref with SEND_SIG_FORCED

Oliver Hartkopp (1):
      can: Fix SJA1000 command register writes on SMP systems

Paul Mundt (1):
      clocksource: sh_cmt: compute mult and shift before registration

Pavel Emelyanov (1):
      NFSD: don't report compiled-out versions as present

Peter Zijlstra (1):
      perf: Fix signed comparison in perf_adjust_period()

Reinette Chatre (2):
      iwlwifi: reset card during probe
      iwlwifi: recalculate average tpt if not current

Richard Kennedy (1):
      gconfig: fix build failure on fedora 13

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

Sarah Sharp (5):
      USB: xhci: Fix issue with set interface after stall.
      USB: xhci: Limit bus sg_tablesize to 62 TRBs.
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

Shaohua Li (1):
      cfq-iosched: fix an oops caused by slab leak

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
      libata: disable ATAPI AN by default
      sata_nv: use ata_pci_sff_activate_host() instead of ata_host_activate()
      ahci: add pci quirk for JMB362
      sata_nv: don't diddle with nIEN on mcp55
      sata_via: magic vt6421 fix for transmission problems w/ WD drives

Theodore Ts'o (1):
      ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files

Tony Breeds (1):
      mutex: Fix optimistic spinning vs. BKL

Toshiyuki Okajima (1):
      KEYS: find_keyring_by_name() can gain access to a freed keyring

Wei Yongjun (3):
      KVM: s390: Fix possible memory leak of in kvm_arch_vcpu_create()
      KVM: PPC: Do not create debugfs if fail to create vcpu
      sctp: fix append error cause to ERROR chunk correctly

spark (1):
      USB: option.c: Add Pirelli VID/PID and indicate Pirelli's modem interface is 0xff

zhao1980ming (1):
      USB: option: add PID for ZTE product

