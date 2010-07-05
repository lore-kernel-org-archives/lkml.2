Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0GESo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 14:44:29 -0400
Received: from kroah.org ([198.145.64.141]:35230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab0GESoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 14:44:24 -0400
Date: Mon, 5 Jul 2010 11:43:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.34.1
Message-ID: <20100705184339.GI31678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.1 kernel.

All users of the 2.6.34 kernel series should upgrade.

The updated 2.6.34.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.34.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/hwmon/ltc4245                     |    4 
 Makefile                                        |    2 
 arch/arm/common/sa1111.c                        |    9 
 arch/arm/mach-mx2/devices.c                     |    4 
 arch/arm/mm/cache-v7.S                          |    4 
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
 arch/powerpc/kernel/asm-offsets.c               |    8 
 arch/powerpc/kernel/head_fsl_booke.S            |   13 -
 arch/powerpc/kvm/book3s.c                       |   10 
 arch/powerpc/kvm/booke.c                        |   15 +
 arch/powerpc/kvm/powerpc.c                      |    3 
 arch/powerpc/lib/string.S                       |    4 
 arch/powerpc/mm/fsl_booke_mmu.c                 |   25 --
 arch/powerpc/mm/mmu_decl.h                      |   10 
 arch/powerpc/mm/pgtable_32.c                    |    8 
 arch/powerpc/mm/pgtable_64.c                    |    8 
 arch/powerpc/mm/tlb_nohash_low.S                |   28 ++
 arch/powerpc/oprofile/op_model_cell.c           |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   30 --
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    8 
 arch/powerpc/platforms/pseries/smp.c            |   28 ++
 arch/s390/kvm/kvm-s390.c                        |    4 
 arch/x86/include/asm/kvm_host.h                 |    3 
 arch/x86/include/asm/msr-index.h                |    5 
 arch/x86/kernel/amd_iommu.c                     |   16 -
 arch/x86/kernel/amd_iommu_init.c                |   20 +
 arch/x86/kernel/cpu/perf_event.c                |    5 
 arch/x86/kernel/pvclock.c                       |   24 +
 arch/x86/kernel/setup.c                         |   11 
 arch/x86/kernel/tboot.c                         |    1 
 arch/x86/kvm/mmu.c                              |   10 
 arch/x86/kvm/svm.c                              |  163 ++++++++-----
 arch/x86/kvm/vmx.c                              |   38 ++-
 arch/x86/kvm/x86.c                              |   58 ++--
 arch/x86/oprofile/nmi_int.c                     |   10 
 arch/x86/xen/suspend.c                          |    4 
 arch/xtensa/include/asm/cache.h                 |    1 
 block/cfq-iosched.c                             |   20 +
 drivers/acpi/video_detect.c                     |    2 
 drivers/ata/libata-core.c                       |    7 
 drivers/ata/libata-sff.c                        |    2 
 drivers/ata/sata_nv.c                           |    5 
 drivers/ata/sata_via.c                          |   13 +
 drivers/base/cpu.c                              |    2 
 drivers/char/ipmi/ipmi_si_intf.c                |   11 
 drivers/clocksource/sh_cmt.c                    |   21 -
 drivers/clocksource/sh_tmu.c                    |   20 -
 drivers/firewire/core-card.c                    |   24 +
 drivers/gpu/drm/drm_edid.c                      |    2 
 drivers/gpu/drm/i915/i915_gem.c                 |   19 +
 drivers/gpu/drm/i915/intel_display.c            |    6 
 drivers/gpu/drm/i915/intel_dp.c                 |   10 
 drivers/gpu/drm/radeon/radeon.h                 |    1 
 drivers/gpu/drm/radeon/radeon_agp.c             |    5 
 drivers/gpu/drm/radeon/radeon_atombios.c        |    7 
 drivers/gpu/drm/radeon/radeon_device.c          |    2 
 drivers/gpu/drm/radeon/radeon_display.c         |    5 
 drivers/gpu/drm/radeon/radeon_state.c           |    5 
 drivers/hid/hid-core.c                          |    1 
 drivers/hid/hid-gyration.c                      |    1 
 drivers/hid/hid-ids.h                           |    1 
 drivers/hwmon/ltc4245.c                         |   18 -
 drivers/md/linear.c                             |    1 
 drivers/md/md.c                                 |   99 ++++++-
 drivers/md/md.h                                 |    1 
 drivers/md/raid1.c                              |    9 
 drivers/md/raid10.c                             |    2 
 drivers/md/raid5.c                              |    7 
 drivers/media/video/uvc/uvc_ctrl.c              |    2 
 drivers/misc/vmware_balloon.c                   |   18 +
 drivers/net/arcnet/com20020-pci.c               |    4 
 drivers/net/can/sja1000/sja1000.c               |   20 +
 drivers/net/can/sja1000/sja1000.h               |    1 
 drivers/net/mlx4/icm.c                          |    3 
 drivers/net/wireless/ath/ar9170/hw.h            |    1 
 drivers/net/wireless/ath/ar9170/main.c          |    2 
 drivers/net/wireless/ath/ar9170/usb.c           |   10 
 drivers/net/wireless/ath/ath5k/base.c           |   11 
 drivers/net/wireless/ath/ath9k/hw.c             |    4 
 drivers/net/wireless/ath/ath9k/init.c           |    3 
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c       |   10 
 drivers/net/wireless/iwlwifi/iwl-scan.c         |   21 +
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    2 
 drivers/net/wireless/p54/p54usb.c               |    1 
 drivers/net/wireless/rtl818x/rtl8180_dev.c      |    1 
 drivers/net/wireless/wl12xx/wl1251_sdio.c       |    1 
 drivers/oprofile/cpu_buffer.c                   |   63 +----
 drivers/pci/quirks.c                            |   13 -
 drivers/pcmcia/ds.c                             |    1 
 drivers/pcmcia/yenta_socket.c                   |    5 
 drivers/platform/x86/Kconfig                    |    1 
 drivers/rtc/rtc-cmos.c                          |    5 
 drivers/rtc/rtc-s3c.c                           |    5 
 drivers/scsi/libsas/sas_ata.c                   |    5 
 drivers/scsi/libsas/sas_scsi_host.c             |   16 -
 drivers/serial/68328serial.c                    |    2 
 drivers/staging/batman-adv/proc.c               |   51 ++--
 drivers/staging/batman-adv/vis.c                |  235 ++++++++++++------
 drivers/staging/batman-adv/vis.h                |    8 
 drivers/staging/comedi/drivers/ni_mio_cs.c      |    2 
 drivers/staging/rt2860/usb_main_dev.c           |    1 
 drivers/staging/vt6655/device_main.c            |    2 
 drivers/usb/class/cdc-acm.c                     |    6 
 drivers/usb/core/driver.c                       |    2 
 drivers/usb/core/hcd.c                          |  169 ++++++++-----
 drivers/usb/core/message.c                      |   45 ---
 drivers/usb/core/urb.c                          |    9 
 drivers/usb/core/usb.c                          |    4 
 drivers/usb/gadget/fsl_udc_core.c               |    2 
 drivers/usb/host/ehci-au1xxx.c                  |   16 -
 drivers/usb/host/ehci-fsl.c                     |    2 
 drivers/usb/host/ehci-hub.c                     |  158 ++++++++++--
 drivers/usb/host/ehci-pci.c                     |   15 -
 drivers/usb/host/ehci.h                         |   10 
 drivers/usb/host/fhci.h                         |    9 
 drivers/usb/host/whci/qset.c                    |    2 
 drivers/usb/host/xhci-pci.c                     |    2 
 drivers/usb/host/xhci-ring.c                    |   39 ++-
 drivers/usb/host/xhci.c                         |   54 +++-
 drivers/usb/mon/mon_bin.c                       |    2 
 drivers/usb/mon/mon_text.c                      |    4 
 drivers/usb/serial/cp210x.c                     |   11 
 drivers/usb/serial/cypress_m8.c                 |    2 
 drivers/usb/serial/digi_acceleport.c            |    4 
 drivers/usb/serial/ftdi_sio.c                   |    4 
 drivers/usb/serial/ir-usb.c                     |    2 
 drivers/usb/serial/kl5kusb105.c                 |    1 
 drivers/usb/serial/kobil_sct.c                  |    3 
 drivers/usb/serial/mos7840.c                    |    1 
 drivers/usb/serial/option.c                     |  180 ++++++++++++++
 drivers/usb/serial/qcaux.c                      |    5 
 drivers/usb/serial/spcp8x5.c                    |    4 
 drivers/usb/serial/visor.c                      |    1 
 drivers/usb/storage/unusual_devs.h              |   15 +
 drivers/vhost/net.c                             |    2 
 drivers/video/arcfb.c                           |    8 
 drivers/video/hgafb.c                           |   10 
 drivers/video/vfb.c                             |    4 
 drivers/video/vga16fb.c                         |   10 
 drivers/video/w100fb.c                          |   10 
 drivers/xen/xenbus/xenbus_xs.c                  |    2 
 fs/aio.c                                        |   65 +++--
 fs/btrfs/acl.c                                  |    3 
 fs/cifs/cifsproto.h                             |    6 
 fs/cifs/dir.c                                   |   20 -
 fs/cifs/file.c                                  |   11 
 fs/compat.c                                     |  132 ++++++----
 fs/dcache.c                                     |    1 
 fs/exofs/dir.c                                  |    2 
 fs/ext4/move_extent.c                           |    3 
 fs/ext4/resize.c                                |    3 
 fs/fs-writeback.c                               |   14 -
 fs/gfs2/file.c                                  |    7 
 fs/libfs.c                                      |    3 
 fs/namei.c                                      |    2 
 fs/nfs/write.c                                  |   20 +
 fs/nfsd/nfssvc.c                                |    2 
 fs/nfsd/vfs.c                                   |   11 
 fs/nfsd/vfs.h                                   |    1 
 include/linux/aio.h                             |    5 
 include/linux/compat.h                          |    4 
 include/linux/fs.h                              |    2 
 include/linux/miscdevice.h                      |    7 
 include/linux/pci_ids.h                         |    1 
 include/linux/perf_event.h                      |    5 
 include/linux/slub_def.h                        |   11 
 include/linux/swap.h                            |   10 
 include/linux/tboot.h                           |    1 
 include/linux/usb.h                             |    9 
 include/trace/events/signal.h                   |    3 
 kernel/cgroup.c                                 |    2 
 kernel/compat.c                                 |   25 --
 kernel/mutex.c                                  |    7 
 kernel/perf_event.c                             |  299 ++++++++++++++----------
 kernel/posix-timers.c                           |   11 
 kernel/signal.c                                 |    6 
 lib/idr.c                                       |    5 
 mm/filemap.c                                    |   10 
 mm/slub.c                                       |   33 --
 net/mac80211/Kconfig                            |    9 
 net/mac80211/cfg.c                              |    7 
 net/mac80211/mlme.c                             |   40 +++
 net/mac80211/rx.c                               |    3 
 net/mac80211/tx.c                               |    5 
 scripts/kconfig/Makefile                        |    2 
 sound/core/pcm_lib.c                            |   13 -
 sound/core/pcm_native.c                         |   39 ---
 sound/pci/hda/hda_intel.c                       |    9 
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/pci/hda/patch_sigmatel.c                  |    2 
 sound/soc/codecs/wm8350.c                       |    4 
 sound/soc/codecs/wm8400.c                       |   18 -
 sound/soc/codecs/wm8990.c                       |   18 -
 sound/soc/imx/imx-pcm-dma-mx2.c                 |    7 
 tools/perf/bench/mem-memcpy.c                   |    2 
 tools/perf/bench/sched-messaging.c              |    4 
 tools/perf/builtin-annotate.c                   |    8 
 tools/perf/builtin-buildid-cache.c              |    2 
 tools/perf/builtin-buildid-list.c               |    4 
 tools/perf/builtin-diff.c                       |    4 
 tools/perf/builtin-help.c                       |    2 
 tools/perf/builtin-lock.c                       |    2 
 tools/perf/builtin-probe.c                      |    2 
 tools/perf/builtin-record.c                     |   24 -
 tools/perf/builtin-report.c                     |    6 
 tools/perf/builtin-sched.c                      |    6 
 tools/perf/builtin-stat.c                       |   10 
 tools/perf/builtin-timechart.c                  |    2 
 tools/perf/builtin-top.c                        |   47 ++-
 tools/perf/builtin-trace.c                      |    2 
 tools/perf/util/debug.c                         |    2 
 tools/perf/util/debug.h                         |    3 
 tools/perf/util/parse-options.c                 |    6 
 tools/perf/util/parse-options.h                 |    4 
 tools/perf/util/symbol.c                        |   25 --
 tools/perf/util/symbol.h                        |   15 +
 tools/perf/util/trace-event-parse.c             |    2 
 tools/perf/util/trace-event.h                   |    3 
 229 files changed, 2312 insertions(+), 1134 deletions(-)

Adam Jackson (1):
      drm/edid: Fix 1024x768@85Hz

Al Viro (2):
      Fix racy use of anon_inode_getfd() in perf_event.c
      clean DCACHE_CANT_MOUNT in d_delete()

Alan Cox (1):
      misc: Fix allocation 'borrowed' by vhost_net

Alan Stern (3):
      USB: fix usbmon and DMA mapping for scatter-gather URBs
      USB: EHCI: fix controller wakeup flag settings during suspend
      USB: unbind all interfaces before rebinding them

Alek Du (1):
      USB: EHCI: clear PHCD before resuming

Alex Deucher (4):
      PCI quirks: disable msi on AMD rs4xx internal gfx bridges
      drm/radeon/kms: don't default display priority to high on rs4xx
      drm/radeon/kms: reset ddc_bus in object header parsing
      drm/radeon/kms/atom: fix typo in LVDS panel info parsing

Alexander Duyck (1):
      slub: move kmem_cache_node into it's own cacheline

Andi Kleen (1):
      oprofile: remove double ring buffering

Andiry Xu (1):
      USB: xHCI: Fix wrong usage of macro TRB_TYPE

Andreas Bombe (1):
      ARCNET: Limit com20020 PCI ID matches for SOHARD cards

Andres Salomon (1):
      mac80211: give warning if building w/out rate ctrl algorithm

Andrew Lunn (1):
      Staging: batman-adv: don't have interrupts disabled while sending.

Andrey Vagin (1):
      posix_timer: Fix error path in timer_create

Anfei (1):
      ARM: 6166/1: Proper prefetch abort handling on pre-ARMv6

Anton Vorontsov (1):
      USB: FHCI: cq_get() should check kfifo_out()'s return value

Arnaldo Carvalho de Melo (1):
      perf top: Properly notify the user that vmlinux is missing

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

Ben Hutchings (1):
      PCI: Disable MSI for MCP55 on P5N32-E SLI

Benjamin Herrenschmidt (1):
      powerpc: Fix ioremap_flags() with book3e pte definition

Bob Copeland (1):
      ath5k: retain promiscuous setting

Bruno Randolf (1):
      ath5k: consistently use rx_bufsize for RX DMA

Chris Wilson (3):
      drm/i915: Reject bind_to_gtt() early if object > aperture
      drm/i915: Rebind bo if currently bound with incorrect alignment.
      drm/i915: Kill dangerous pending-flip debugging

Christian Lamparter (2):
      ar9170usb: add a couple more USB IDs
      ar9170usb: fix panic triggered by undersized rxstream buffer

Christoph Hellwig (1):
      nfsd: nfsd_setattr needs to call commit_metadata

Christoph Lameter (1):
      SLUB: Allow full duplication of kmalloc array for 390

Clemens Ladisch (2):
      ALSA: pcm: fix delta calculation at boundary wraparound
      ALSA: pcm: fix the fix of the runtime->boundary calculation

Cory Maccarrone (1):
      HID: Add the GYR4101US USB ID to hid-gyration

Craig Shelley (1):
      USB: CP210x New Device IDs 11 New device IDs

Dan Carpenter (2):
      exofs: confusion between kmap() and kmap_atomic() api
      rtc-cmos: do dev_set_drvdata() earlier in the initialization

Dan Williams (2):
      USB: qcaux: add Samsung U520 device ID
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

Dave Airlie (1):
      drm/radeon: fix the r100/r200 ums block 0 page fix

Denis Kirjanov (1):
      powerpc/oprofile: fix potential buffer overrun in op_model_cell.c

Dinh Nguyen (1):
      USB: mxc: gadget: Fix bitfield for calculating maximum packet size

Dmitry Torokhov (1):
      vmware balloon: clamp number of collected non-balloonable pages

Dominik Brodowski (2):
      pcmcia: only keep saved I365_CSCINT flag if there is no PCI irq
      pcmcia: avoid validate_cis failure on CIS override

Eric Sandeen (1):
      ext4: check s_log_groups_per_flex in online resize code

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

Greg Kroah-Hartman (1):
      Linux 2.6.34.1

Greg Thelen (1):
      cgroups: alloc_css_id() increments hierarchy depth

Greg Ungerer (1):
      m68knommu: fix broken use of BUAD_TABLE_SIZE in 68328serial driver

Hans de Goede (1):
      USB: unusual-dev: Add bad sense flag for Appotech ax203 based picture frames

Heiko Carstens (1):
      fs/compat_rw_copy_check_uvector: add missing compat_ptr call

Helge Deller (1):
      parisc: clear floating point exception flag on SIGFPE signal

Henrik Kretzschmar (5):
      fbdev: section cleanup in hgafb
      fbdev: section cleanup in vfb
      fbdev: section cleanup in vga16fb
      fbdev: section cleanup in arcfb
      fbdev: section cleanup in w100fb

Ian Campbell (2):
      xen: ensure timer tick is resumed even on CPU driving the resume
      xen: avoid allocation causing potential swap activity on the resume path

Ian Munsie (1):
      perf: Fix endianness argument compatibility with OPT_BOOLEAN() and introduce OPT_INCR()

Imre Deak (1):
      idr: fix backtrack logic in idr_remove_all

Ira W. Snyder (1):
      hwmon: (ltc4245) Read only one GPIO pin

James Bottomley (1):
      libsas: fix deref before check in commit 70b25f890ce

Jan Beulich (1):
      drivers/base/cpu.c: fix the output from /sys/devices/system/cpu/offline

Jason Dravet (1):
      p54usb: Add device ID for Dell WLA3310 USB

Jeff Layton (1):
      nfsd: don't break lease while servicing a COMMIT

Jeff Mahoney (1):
      powerpc: Fix handling of strncmp with zero len

Jeff Moyer (3):
      aio: fix the compat vectored operations
      compat: factor out compat_rw_copy_check_uvector from compat_do_readv_writev
      do_generic_file_read: clear page errors when issuing a fresh read of the page

Jens Axboe (1):
      writeback: disable periodic old data writeback for !dirty_writeback_centisecs

Jerome Glisse (1):
      drm/radeon/kms: release AGP bridge at suspend

Jiri Kosina (1):
      ipmi: handle run_to_completion properly in deliver_recv_msg()

Joerg Roedel (12):
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
      KVM: x86: Inject #GP with the right rip on efer writes
      KVM: SVM: Don't allow nested guest to VMMCALL into host

Johan Hovold (6):
      USB: visor: fix memory leak
      USB: kobil: fix memory leak
      USB: tty: fix incorrect use of tty_insert_flip_string_fixed_flag
      USB: ir-usb: fix double free
      USB: kl5usb105: fix memory leak
      USB: mos7840: fix null-pointer dereference

Johannes Berg (2):
      mac80211: fix deauth before assoc
      iwlwifi: add missing rcu_read_lock

John W. Linville (1):
      rtl8180: fix tx status reporting

Jouni Malinen (1):
      mac80211: Fix robust management frame handling (MFP)

Julia Lawall (1):
      arch/x86/kernel: Add missing spin_unlock

KOSAKI Motohiro (2):
      cpumask: fix compat getaffinity
      tmpfs: insert tmpfs cache pages to inactive list at first

Kamal Mostafa (1):
      ACPI: video: fix acpi_backlight=video

Karsten Wiese (1):
      drm/i915: Don't touch PORT_HOTPLUG_EN in intel_dp_detect()

Khem Raj (1):
      ARM: 6164/1: Add kto and kfrom to input operands list.

Kumar Gala (1):
      powerpc/fsl-booke: Move loadcam_entry back to asm code to fix SMP ftrace

Larry Finger (1):
      staging: vt6655: Fix kernel BUG on driver wpa initialization

Laurent Pinchart (1):
      V4L/DVB: uvcvideo: Prevent division by 0 when control step value is 0

Li Yang (1):
      powerpc/fsl-booke: Fix InstructionTLBError execute permission check

Linus Lüssing (2):
      Staging: batman-adv: Fix VIS output bug for secondary interfaces
      Staging: batman-adv: Fixing wrap-around bug in vis

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

Maurus Cuelenaere (1):
      rtc: s3c: initialize driver data before using it

Michael Neuling (2):
      powerpc/pseries: Only call start-cpu when a CPU is stopped
      powerpc/pseries: Make query_cpu_stopped callable outside hotplug cpu

Neil Brown (1):
      VFS: fix recent breakage of FS_REVAL_DOT

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

Peter Zijlstra (4):
      perf: Fix exit() vs PERF_FORMAT_GROUP
      perf: Fix exit() vs event-groups
      perf: Fix signed comparison in perf_adjust_period()
      perf_events: Fix races and clean up perf_event and perf_mmap_data interaction

Randy Dunlap (1):
      eeepc-wmi: depends on BACKLIGHT_CLASS_DEVICE

Reinette Chatre (2):
      iwlwifi: fix internal scan race
      iwlwifi: recalculate average tpt if not current

Richard Kennedy (1):
      gconfig: fix build failure on fedora 13

Robert Richter (1):
      oprofile/x86: fix uninitialized counter usage during cpu hotplug

Roberto Sassu (1):
      wrong type for 'magic' argument in simple_fill_super()

Russell King (1):
      ARM: VFP: Fix vfp_put_double() for d16-d31

Santosh Shilimkar (1):
      ARM: 6139/1: ARMv7: Use the Inner Shareable I-cache on MP

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

Stuart Longland (1):
      ASoC: Update Freescale i.MX SSI driver DMA parameter handling

Sujith (1):
      ath9k_hw: fix hardware deinit

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

Trond Myklebust (2):
      NFS: Ensure that we mark the inode as dirty if we exit early from commit
      NFS: Fix another nfs_wb_page() deadlock

Wei Yongjun (2):
      KVM: s390: Fix possible memory leak of in kvm_arch_vcpu_create()
      KVM: PPC: Do not create debugfs if fail to create vcpu

Wolfram Sang (1):
      ARM: 6135/1: mx21/devices: fix USBOTG resource

zhao1980ming (1):
      USB: option: add PID for ZTE product

