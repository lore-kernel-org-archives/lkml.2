Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3ADBR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 20:17:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57183 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675Ab3ADBRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 20:17:51 -0500
Message-ID: <1357262262.31299.63.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.36
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 04 Jan 2013 01:17:42 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pelL9SIbOOCTxK3M5jKK"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pelL9SIbOOCTxK3M5jKK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.36 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/hwmon/coretemp                       |   12 +-
 Makefile                                           |    2 +-
 arch/arm/include/asm/hwcap.h                       |    3 +-
 arch/arm/include/asm/vfpmacros.h                   |   12 +-
 arch/arm/kernel/swp_emulate.c                      |    2 +
 arch/arm/mm/mmu.c                                  |    2 +-
 arch/arm/vfp/vfpmodule.c                           |    9 +-
 arch/cris/include/asm/io.h                         |   39 ++-
 arch/mips/kernel/process.c                         |    4 +-
 arch/powerpc/kernel/head_64.S                      |    2 +-
 arch/powerpc/kvm/44x_emulate.c                     |    2 +
 arch/powerpc/platforms/embedded6xx/wii.c           |    6 +-
 arch/s390/kvm/kvm-s390.c                           |    2 +-
 arch/x86/kernel/hpet.c                             |    4 +-
 arch/x86/kvm/x86.c                                 |    6 +
 drivers/acpi/battery.c                             |   77 +++++
 drivers/acpi/processor_driver.c                    |    1 +
 drivers/acpi/sleep.c                               |  340 ++++++++++------=
----
 drivers/acpi/video.c                               |   14 +
 drivers/acpi/video_detect.c                        |   37 +++
 drivers/ata/libata-core.c                          |    1 +
 drivers/ata/libata-eh.c                            |    1 +
 drivers/ata/libata-scsi.c                          |    6 +-
 drivers/ata/sata_promise.c                         |   15 +-
 drivers/ata/sata_svw.c                             |   35 ++
 drivers/atm/solos-pci.c                            |    5 +-
 drivers/base/regmap/regmap-debugfs.c               |    2 +-
 drivers/bcma/driver_mips.c                         |    2 +-
 drivers/bluetooth/ath3k.c                          |    1 +
 drivers/bluetooth/btusb.c                          |    3 +
 drivers/char/agp/intel-agp.h                       |    1 +
 drivers/char/agp/intel-gtt.c                       |    2 +
 drivers/char/ramoops.c                             |    4 +-
 drivers/edac/i7300_edac.c                          |    8 +-
 drivers/edac/i82975x_edac.c                        |   11 +-
 drivers/firewire/net.c                             |   13 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |    4 +-
 drivers/gpu/drm/drm_edid.c                         |    5 +
 drivers/gpu/drm/i915/i915_debugfs.c                |    4 +-
 drivers/gpu/drm/i915/i915_drv.c                    |    1 +
 drivers/gpu/drm/i915/i915_gem.c                    |    5 +
 drivers/gpu/drm/i915/i915_irq.c                    |    4 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    2 +
 drivers/gpu/drm/i915/intel_bios.c                  |   11 +-
 drivers/gpu/drm/i915/intel_display.c               |   95 +++---
 drivers/gpu/drm/i915/intel_drv.h                   |    5 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   16 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |    5 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |    4 +-
 drivers/hid/hid-apple.c                            |    3 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-magicmouse.c                       |    2 +
 drivers/hwmon/coretemp.c                           |   34 +-
 drivers/hwmon/fam15h_power.c                       |    4 +
 drivers/input/joystick/walkera0701.c               |    7 +-
 drivers/input/serio/i8042-x86ia64io.h              |    9 +
 drivers/iommu/intel-iommu.c                        |   11 +-
 drivers/leds/leds-lp5521.c                         |   16 +-
 drivers/md/dm-ioctl.c                              |    8 +
 drivers/md/persistent-data/dm-btree-internal.h     |   16 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   50 +--
 drivers/md/persistent-data/dm-btree-spine.c        |    6 +-
 drivers/md/persistent-data/dm-btree.c              |   22 +-
 drivers/mfd/mfd-core.c                             |   15 +-
 drivers/misc/hpilo.c                               |   11 +-
 drivers/misc/sgi-xp/xpc_main.c                     |   34 +-
 drivers/mmc/host/sh_mmcif.c                        |    4 -
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |    9 +
 drivers/net/bonding/bond_main.c                    |    7 +
 drivers/net/bonding/bond_sysfs.c                   |    2 +
 drivers/net/can/dev.c                              |    3 +-
 drivers/net/ethernet/8390/ne.c                     |    1 +
 drivers/net/irda/sir_dev.c                         |    2 +-
 drivers/net/usb/ipheth.c                           |    5 +
 drivers/net/wimax/i2400m/i2400m-usb.h              |    3 +
 drivers/net/wimax/i2400m/usb.c                     |    6 +
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  172 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   11 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    1 +
 drivers/net/wireless/ath/ath9k/calib.h             |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   |   35 +-
 drivers/pnp/pnpacpi/core.c                         |    5 +-
 drivers/regulator/wm831x-dcdc.c                    |    2 +-
 drivers/s390/cio/device_pgid.c                     |   10 +-
 drivers/scsi/aha152x.c                             |    4 +-
 drivers/scsi/hpsa.c                                |   32 +-
 drivers/scsi/mvsas/mv_94xx.h                       |   14 +-
 drivers/scsi/mvsas/mv_sas.h                        |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    4 +-
 drivers/scsi/scsi_sysfs.c                          |   11 +-
 drivers/staging/bcm/InterfaceInit.c                |    4 +-
 drivers/staging/bcm/InterfaceInit.h                |    5 +-
 drivers/staging/vt6656/dpc.c                       |    4 +-
 drivers/staging/vt6656/key.c                       |   53 ++-
 drivers/staging/vt6656/key.h                       |    8 +-
 drivers/staging/vt6656/mac.c                       |    6 +-
 drivers/staging/vt6656/rf.c                        |    3 +
 drivers/staging/vt6656/rxtx.c                      |   18 +-
 drivers/staging/vt6656/ttype.h                     |   16 +-
 drivers/staging/vt6656/wcmd.c                      |   20 +-
 drivers/staging/vt6656/wpa2.h                      |    4 +-
 drivers/target/iscsi/iscsi_target.c                |    2 +-
 drivers/target/iscsi/iscsi_target_login.c          |    8 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   10 +-
 drivers/target/target_core_file.c                  |    9 +-
 drivers/target/tcm_fc/tfc_sess.c                   |    2 +-
 drivers/telephony/ixj.c                            |   24 +-
 drivers/usb/class/cdc-wdm.c                        |    4 +-
 drivers/usb/core/message.c                         |   53 +--
 drivers/usb/gadget/f_ecm.c                         |    4 +-
 drivers/usb/gadget/f_eem.c                         |    5 +-
 drivers/usb/gadget/f_midi.c                        |    1 +
 drivers/usb/gadget/f_ncm.c                         |    4 +-
 drivers/usb/gadget/f_phonet.c                      |    8 +-
 drivers/usb/gadget/f_rndis.c                       |    4 +-
 drivers/usb/gadget/f_subset.c                      |    4 +-
 drivers/usb/gadget/f_uvc.c                         |   39 +--
 drivers/usb/host/ehci-pci.c                        |    3 +-
 drivers/usb/host/ehci-q.c                          |   16 +-
 drivers/usb/host/ehci-sched.c                      |    4 +-
 drivers/usb/host/ohci-q.c                          |   19 ++
 drivers/usb/host/pci-quirks.c                      |    4 +-
 drivers/usb/host/xhci-mem.c                        |   11 +-
 drivers/usb/host/xhci-pci.c                        |    7 +-
 drivers/usb/host/xhci-ring.c                       |   32 +-
 drivers/usb/host/xhci.c                            |    4 +-
 drivers/usb/musb/cppi_dma.c                        |    1 +
 drivers/usb/serial/cp210x.c                        |    1 +
 drivers/usb/serial/ftdi_sio.c                      |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/option.c                        |   25 ++
 drivers/usb/storage/Kconfig                        |    2 +-
 drivers/virtio/virtio_ring.c                       |    7 +
 fs/binfmt_misc.c                                   |    5 +-
 fs/binfmt_script.c                                 |    4 +-
 fs/dcache.c                                        |    2 +-
 fs/exec.c                                          |   18 +-
 fs/ext4/acl.c                                      |    6 +-
 fs/ext4/inode.c                                    |    1 +
 fs/nfs/client.c                                    |    3 +-
 fs/nfs/nfs4proc.c                                  |   21 +-
 fs/nfsd/nfs4proc.c                                 |    8 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/nfsd/nfs4xdr.c                                  |   11 +-
 fs/nfsd/nfssvc.c                                   |    2 +-
 fs/nfsd/vfs.c                                      |   10 +-
 fs/proc/array.c                                    |    2 +-
 fs/udf/inode.c                                     |    4 +
 include/linux/binfmts.h                            |    1 +
 include/linux/cgroup.h                             |    1 -
 include/linux/freezer.h                            |   51 ++-
 include/linux/highmem.h                            |    7 +
 include/linux/mempolicy.h                          |   16 -
 include/linux/pci_ids.h                            |    1 +
 kernel/cgroup.c                                    |   52 ++-
 kernel/cgroup_freezer.c                            |   13 +-
 kernel/fork.c                                      |    9 +-
 kernel/irq/manage.c                                |   23 +-
 kernel/rcutree.c                                   |   14 +-
 kernel/sched_autogroup.c                           |    4 -
 kernel/sched_autogroup.h                           |    5 -
 kernel/sys.c                                       |    2 +-
 kernel/trace/ftrace.c                              |    2 +-
 kernel/trace/ring_buffer.c                         |    7 +-
 kernel/workqueue.c                                 |    4 +-
 mm/dmapool.c                                       |   31 +-
 mm/highmem.c                                       |   13 +
 mm/huge_memory.c                                   |    3 +
 mm/memory.c                                        |   18 +-
 mm/mempolicy.c                                     |   22 --
 mm/shmem.c                                         |   26 +-
 mm/vmscan.c                                        |   27 +-
 net/9p/trans_virtio.c                              |    3 +-
 net/bluetooth/rfcomm/sock.c                        |    4 +-
 net/ipv4/ip_fragment.c                             |   19 +-
 net/sctp/chunk.c                                   |   20 +-
 net/sctp/socket.c                                  |    4 +-
 security/device_cgroup.c                           |    6 +-
 sound/pci/hda/hda_intel.c                          |    5 +
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_hdmi.c                         |   20 +-
 sound/pci/hda/patch_realtek.c                      |    5 +-
 sound/pci/hda/patch_sigmatel.c                     |    2 +-
 sound/usb/midi.c                                   |   91 ++++--
 187 files changed, 1628 insertions(+), 923 deletions(-)

Aaron Lu (1):
      libata: set dma_mode to 0xff in reset

Al Viro (1):
      ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Alan Cox (3):
      ACPI: missing break
      pnpacpi: fix incorrect TEST_ALPHA() test
      ne2000: add the right platform device

Alan Stern (3):
      USB: fix endpoint-disabling for failed config changes
      USB: EHCI: bugfix: urb->hcpriv should not be NULL
      USB: OHCI: workaround for hardware bug: retired TDs not added to the =
Done Queue

Alasdair G Kergon (1):
      dm ioctl: prevent unsafe change to dm_ioctl data_size

Alex Deucher (4):
      drm: fix documentation for drm_crtc_set_mode()
      drm/radeon/kms: use frac fb div on APUs
      drm/radeon/dce32+: use fractional fb dividers for high clocks
      drm/radeon: fix eDP clk and lane setup for scaled modes

Alexander Graf (1):
      KVM: PPC: 44x: fix DCR read/write

Alexander Shiyan (1):
      irda: sir_dev: Fix copy/paste typo

Alexander Stein (1):
      can: Do not call dev_put if restart timer is running upon close

Alexey Kaminsky (1):
      HID: apple: Add Apple wireless keyboard 2011 ANSI PID

Alexis R. Cortes (1):
      usb: host: xhci: Stricter conditional for Z1 system models for Compli=
ance Mode Patch

Anton Blanchard (1):
      powerpc: Fix CONFIG_RELOCATABLE=3Dy CONFIG_CRASH_DUMP=3Dn build

Artem Bityutskiy (1):
      proc: pid/status: show all supplementary groups

Ben Hutchings (5):
      Revert "device_cgroup: fix RCU usage"
      mm: add kmap_to_page()
      HID: Add Apple wireless keyboard 2011 ANSI to special driver list
      Revert "mm: vmscan: fix endless loop in kswapd balancing"
      Linux 3.2.36

Bj=C3=B8rn Mork (1):
      USB: option: blacklist network interface on Huawei E173

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors

Bryan Schumaker (1):
      NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()

Calvin Walton (1):
      i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Charles Keepax (1):
      mfd: Only unregister platform devices allocated by the mfd core

Chase Douglas (1):
      HID: hid-magicmouse: Add pointer and buttonpad properties for Magic T=
rackpad

Chris Ball (1):
      Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"

Chris Wilson (2):
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H
      drm/i915: Close race between processing unpin task and queueing the f=
lip

Christian Borntraeger (1):
      s390/kvm: dont announce RRBM support

Corentin Chary (1):
      acpi/video_detect: blacklist samsung x360

Corey Minyard (1):
      CRIS: fix I/O macros

Dan Carpenter (3):
      drivers/leds/leds-lp5521.c: fix lp5521_read() error handling
      ftrace: Clear bits properly in reset_iter_read()
      telephony: ijx: buffer overflow in ixj_write_cid()

Dan Williams (1):
      i2400m: add Intel 6150 device IDs

Daniel Vetter (2):
      drm/i915: drop unnecessary check from fdi_link_train code
      drm/i915: disable cpt phase pointer fdi rx workaround

David Jeffery (1):
      qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

David Milburn (1):
      sata_svw: check DMA start bit before reset

David Rientjes (1):
      thp, memcg: split hugepage for memcg oom on cow

David Woodhouse (1):
      solos-pci: fix double-free of TX skb in DMA mode

Dmitry Rogozhkin (1):
      drm/i915: EBUSY status handling added to i915_gem_fault().

Duncan Roe (1):
      ALSA: hda - Fix missing beep on ASUS X43U notebook

Emmanuel Grumbach (1):
      iwlwifi: don't handle masked interrupt

Eric Dumazet (1):
      rcu: Fix batch-limit size problem

Eric Sandeen (1):
      ext4: init pagevec in ext4_da_block_invalidatepages

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Eugeni Dodonov (2):
      drm: give up on edid retries when i2c bus is not responding
      drm/i915: add Ivy Bridge GT2 Server entries

Felix Fietkau (2):
      Revert "ath9k_hw: Update AR9003 high_power tx gain table"
      ath9k_hw: Fix signal strength / channel noise reporting

Gabor Juhos (1):
      ath9k: ar9003: fix OTP register offsets for AR9340

Greg KH (1):
      USB: mark uas driver as BROKEN

Guenter Roeck (3):
      hwmon: (coretemp) Add support for Atom D2000 and N2000 series CPU mod=
els
      hwmon: (coretemp) Improve support for TjMax detection on Atom CPUs
      hwmon: (coretemp) Add support for Atom CE4110/4150/4170

Gustavo Padovan (1):
      Bluetooth: Add missing lock nesting notation

Herton Ronaldo Krzesinski (1):
      USB: cdc-wdm: fix regression on buffer deallocation

Huacai Chen (1):
      MIPS: Fix poweroff failure when HOTPLUG_CPU configured.

J. Bruce Fields (2):
      nfsd: fix v4 reply caching
      nfsd4: fix oops on unusual readlike compound

Jan Beulich (1):
      x86: hpet: Fix masking of MSI interrupts

Jani Nikula (2):
      drm/i915: do not ignore eDP bpc settings from vbt
      drm/i915: do not default to 18 bpp for eDP if missing from VBT

Jaroslav Resler (1):
      Bluetooth: Add support for BCM20702A0 [04ca, 2003]

Jay Purohit (1):
      usb/ipheth: Add iPhone 5 support

Jean Delvare (2):
      hwmon: (coretemp) Improve support of recent Atom CPU models
      i7300_edac: Fix error flag testing

Jeff Cook (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Jerome Glisse (1):
      drm/radeon: fix amd afusion gpu setup aka sumo v2

Jiri Slaby (1):
      MISC: hpilo, remove pci_disable_device

Johannes Berg (2):
      ipv4: ip_check_defrag must not modify skb before unsharing
      iwlwifi: handle DMA mapping failures

Julius Werner (1):
      xhci: fix null-pointer dereference when destroying half-built segment=
 rings

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads

Kees Cook (2):
      use clamp_t in UNAME26 fix
      exec: do not leave bprm->interp on stack

Kevin McKinney (2):
      Staging: bcm: Create and initialize new device id in InterfaceInit
      Staging: bcm: Add two products and remove an existing product.

Krzysztof Wilczynski (1):
      scsi: aha152x: Fix sparse warning and make printing pointer address m=
ore portable.

Lan Tianyu (2):
      ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.
      ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist

Malcolm Priestley (6):
      staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
      staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
      staging: vt6656: 64 bit fixes : correct all type sizes
      staging: vt6656: 64 bit fixes: fix long warning messages.
      staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
      staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of=
 timer.

Marco Stornelli (1):
      ramoops: fix use of rounddown_pow_of_two()

Marcos Chaparro (1):
      Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() call=
s

Mark Brown (2):
      regulator: wm831x: Set the new rather than old value for DVS VSEL
      regmap: debugfs: Avoid overflows for very small reads

Markus Becker (1):
      USB: cp210x: add Virtenio Preon32 device id

Martin Teichmann (1):
      USB: ftdi_sio: Add support for Newport AGILIS motor drivers

Masanari Iida (1):
      drivers/leds/leds-lp5521.c: fix typo

Mauro Carvalho Chehab (1):
      i82975x_edac: Fix dimm label initialization

Mel Gorman (1):
      tmpfs: fix shared mempolicy leak

Mikael Pettersson (1):
      sata_promise: fix hardreset lockdep error

Mike Galbraith (1):
      Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Mike Miller (1):
      hpsa: gen8plus Smart Array IDs

Mikulas Patocka (1):
      dm persistent data: rename node to btree_node

Namjae Jeon (1):
      udf: fix memory leak while allocating blocks during write

Neil Brown (1):
      nfsd: avoid permission checks on EXCLUSIVE_CREATE replay

NeilBrown (2):
      NFS: avoid NULL dereference in nfs_destroy_server
      vfs: d_obtain_alias() needs to use "/" as default name.

Oleg Nesterov (1):
      freezer: PF_FREEZER_NOSIG should be cleared along with PF_NOFREEZE

Ondrej Zary (1):
      x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Paul Walmsley (1):
      ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and =
CONFIG_VFPv3 set

Paulo Zanoni (1):
      drm/i915: make the panel fitter work on pipes B and C on IVB

Peter Korsgaard (1):
      usb: ftdi_sio: fixup BeagleBone A5+ quirk

Peter Popovec (1):
      Input: walkera0701 - fix crash on startup

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-=
2012-4461)

Rafael J. Wysocki (1):
      ACPI / PNP: Do not crash due to stale pointer use during system resum=
e

Rafa=C5=82 Mi=C5=82ecki (1):
      bcma: mips: fix clearing device IRQ

Rajkumar Manoharan (1):
      ath9k_hw: Enable hw PLL power save for AR9462

Robin Holt (1):
      SGI-XP: handle non-fatal traps

Roland Dreier (1):
      iscsi-target: Always send a response before terminating iSCSI connect=
ion

Russell Webb (1):
      xhci: Add Lynx Point LP to list of Intel switchable hosts

Sarah Sharp (3):
      xhci: Fix conditional check in bandwidth calculation.
      xHCI: Fix TD Size calculation on 1.0 hosts.
      xhci: Extend Fresco Logic MSI quirk.

Sarveshwar Bandi (1):
      bonding: Bonding driver does not consider the gso_max_size/gso_max_se=
gs setting of slave devices.

Sasha Levin (1):
      prevent stack buffer overflow in host_reset

Sebastian Andrzej Siewior (5):
      usb: gadget: network: fix bind() error path
      usb: gadget: midi: free hs descriptors
      usb: gadget: phonet: free requests in pn_bind()'s error path
      usb: gadget: uvc: fix error path in uvc_function_bind()
      target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping

Sebastian Ott (1):
      s390/cio: fix pgid reserved check

Sergei Shtylyov (1):
      usb: musb: cppi_dma: export cppi_interrupt()

Seth Heasley (1):
      ALSA: hda - Add Lynx Point HD Audio Controller DeviceIDs

Shuah Khan (1):
      powerpc: fix wii_memory_fixups() compile error on 3.0.y tree

Srinidhi KASAGAR (1):
      drivers/leds/leds-lp5521.c: ret may be uninitialized

Stephan Gatzka (1):
      firewire: net: Fix handling of fragmented multicast/broadcast packets=
.

Steven Rostedt (1):
      ring-buffer: Fix NULL pointer if rb_set_head_page() fails

Takashi Iwai (6):
      ALSA: usb-audio: Avoid autopm calls after disconnection
      ALSA: usb-audio: Fix missing autopm for MIDI input
      ALSA: hda - Add stereo-dmic fixup for Acer Aspire One 522
      ALSA: hda - Fix pin configuration of HP Pavilion dv7
      ALSA: hda - Always turn on pins for HDMI/DP
      ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup

Tejun Heo (4):
      workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONC=
E()s
      cgroup: cgroup_subsys->fork() should be called after the task is adde=
d to css_set
      freezer: add missing mb's to freezer_count() and freezer_should_skip(=
)
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Thomas Gleixner (1):
      genirq: Always force thread affinity

Tommi Rantala (2):
      sctp: fix memory leak in sctp_datamsg_from_user() when copy from user=
 space fails
      sctp: fix -ENOMEM result with invalid user space pointer in sendto() =
syscall

Wei Yongjun (1):
      iscsit: use GFP_ATOMIC under spin lock

Will Deacon (4):
      mm: highmem: export kmap_to_page for modules
      virtio: 9p: correctly pass physical address to userspace for high pag=
es
      virtio: force vring descriptors to be allocated from lowmem
      ARM: mm: use pteval_t to represent page protection values

Wolfram Sang (1):
      mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup proble=
ms

Woodhouse, David (1):
      intel-iommu: Free old page tables before creating superpage

Wu Fengguang (1):
      ALSA: hda - add id for Atom Cedar Trail HDMI codec

Xi Wang (1):
      mvsas: fix undefined bit shift

Xiaotian Feng (1):
      fix Null pointer dereference on disk error

Yanchuan Nian (1):
      nfs: fix wrong object type in lockowner_slab

Yi Zou (1):
      target/tcm_fc: fix the lockdep warning due to inconsistent lock state

Zhang Rui (2):
      ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set
      ACPI / video: ignore BIOS initial backlight value for HP Folio 13-200=
0

li.rui27@zte.com.cn (1):
      USB: add new zte 3g-dongle's pid to option.c

nikolay@redhat.com (1):
      bonding: fix race condition in bonding_store_slaves_active


--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-pelL9SIbOOCTxK3M5jKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUOYtt+e/yOyVhhEJAQpDHRAAkxXmDt49HsDDpzl9JTUeMlEtQ6Azq/jC
Kd2XsFA0xik6bPO4TkNgMSxTmq4i7u+GbpDMvBX5nf1cFW+NWOOmnlYV5la722S2
cjZApenipnsgN5dFzz3o2Sp6R2NWBJ2bTbUR+TYK75Q7q1tKGevGrUHNTjBikuB8
3FPrD/gcNLq7fbt+02HnV9fxNJLI58Ba0bniVP5DWTWfaAS8PMIhDgjRBUfFPPap
eihDjpQkh7M3eUfvZqKXbwS0+c1dHNRr36LIBA/RWR0t3DyG2GSHx4/s7y3foJYR
6MXq5PGXns25+c8iZ84H749FqQ+PfzGkba5uWZwkBpQoDVCTvGK95nSt774ks4pN
O7Ktu9gH/9MkwSqQTdK5OougSHiJHsfW489cgSlkCjj4l/XifopR8LcHlQMTqt08
oHa+T876cV7CLEiCGn8RO4yfuBH4lmgMjK6vY4mffvgiiC7wwKlulSjUIXmkWSV1
Y2LbmnRxcloonH4eAaB6x/q+8Llmir91u62f2HRkYWCWtnL8haBXhoyzcZH81pV9
3Ay/84qBeu46GPoCqJ+bGoqNtmDlMrWcmYhvAgMw2H+Za6qvSXkXfCHi8vkMYN8w
VNk2Th04PM6+r5Pt3Vts1B/Ln6WyYohRpHkNNUbfcNoXfHyzminvdymF8jKPspPs
j6kCdbyek9I=
=md//
-----END PGP SIGNATURE-----

--=-pelL9SIbOOCTxK3M5jKK--
