Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2FDTso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:48:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42794 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab2FDTsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:48:40 -0400
Message-ID: <1338839308.21665.2.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.19
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Mon, 04 Jun 2012 20:48:28 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-L1DEcrcpxHXlnNj5yLE1"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L1DEcrcpxHXlnNj5yLE1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.19 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/HOWTO                            |   32 +-
 Makefile                                       |   11 +-
 arch/arm/include/asm/cacheflush.h              |    2 +-
 arch/arm/kernel/traps.c                        |    4 +-
 arch/ia64/kvm/kvm-ia64.c                       |    5 +
 arch/parisc/include/asm/prefetch.h             |    7 +-
 arch/parisc/kernel/entry.S                     |    4 +
 arch/parisc/kernel/pacache.S                   |   38 +-
 arch/s390/kvm/intercept.c                      |   20 +-
 arch/s390/kvm/kvm-s390.c                       |    2 +-
 arch/s390/mm/fault.c                           |   14 +-
 arch/sparc/Kconfig                             |    3 +
 arch/sparc/kernel/systbls_64.S                 |    2 +-
 arch/tile/Kconfig                              |    3 +-
 arch/tile/include/asm/bitops.h                 |   12 +-
 arch/um/include/asm/pgtable.h                  |   10 +-
 arch/x86/Makefile                              |    4 +
 arch/x86/boot/compressed/Makefile              |    9 +-
 arch/x86/boot/compressed/relocs.c              |  680 --------------------
 arch/x86/kernel/cpu/mcheck/mce-severity.c      |   16 +-
 arch/x86/kernel/cpu/mcheck/mce.c               |    8 +
 arch/x86/kernel/cpu/perf_event_amd.c           |   11 +-
 arch/x86/kvm/vmx.c                             |    4 +-
 arch/x86/kvm/x86.c                             |    8 +
 arch/x86/pci/xen.c                             |    4 +
 arch/x86/tools/.gitignore                      |    1 +
 arch/x86/tools/Makefile                        |    3 +
 arch/x86/tools/relocs.c                        |  820 ++++++++++++++++++++=
++++
 block/genhd.c                                  |   10 +-
 drivers/acpi/sleep.c                           |    8 +
 drivers/ata/ahci.c                             |    2 +
 drivers/gpio/gpio-mpc8xxx.c                    |    3 +-
 drivers/gpu/drm/i915/i915_irq.c                |    9 +-
 drivers/gpu/drm/i915/i915_reg.h                |   15 +
 drivers/gpu/drm/i915/intel_display.c           |   19 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c           |    2 +-
 drivers/hid/hid-logitech-dj.c                  |    5 +-
 drivers/hid/hid-wiimote.c                      |   16 +-
 drivers/i2c/busses/i2c-davinci.c               |    2 +-
 drivers/i2c/busses/i2c-eg20t.c                 |    2 +-
 drivers/i2c/busses/i2c-tegra.c                 |   13 +-
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c               |   11 +-
 drivers/input/tablet/wacom_wac.c               |    7 +-
 drivers/iommu/dmar.c                           |    4 +-
 drivers/iommu/intel-iommu.c                    |   17 +-
 drivers/isdn/gigaset/capi.c                    |   26 +-
 drivers/isdn/gigaset/ev-layer.c                |    4 +-
 drivers/md/md.c                                |    2 +-
 drivers/media/dvb/siano/smsusb.c               |    2 +
 drivers/media/video/uvc/uvc_v4l2.c             |    2 +-
 drivers/mmc/core/sdio.c                        |    2 +-
 drivers/mmc/core/sdio_irq.c                    |   11 +-
 drivers/mtd/sm_ftl.c                           |    2 +-
 drivers/net/ethernet/dlink/dl2k.c              |   52 +-
 drivers/net/ethernet/dlink/dl2k.h              |    7 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c |    6 +-
 drivers/net/wireless/b43legacy/main.c          |    2 -
 drivers/net/wireless/rtlwifi/usb.c             |   34 +-
 drivers/net/wireless/rtlwifi/wifi.h            |    6 +-
 drivers/platform/x86/sony-laptop.c             |    2 +-
 drivers/regulator/core.c                       |    2 +
 drivers/rtc/rtc-pl031.c                        |   18 +
 drivers/scsi/hpsa.c                            |   38 +-
 drivers/scsi/isci/init.c                       |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c            |    6 +-
 drivers/spi/spi-fsl-spi.c                      |    2 +-
 drivers/staging/comedi/comedi_fops.c           |    2 +-
 drivers/tty/serial/8250.c                      |    9 +-
 drivers/tty/serial/8250_pci.c                  |   18 +
 drivers/tty/serial/mxs-auart.c                 |    2 +
 drivers/tty/serial/serial_core.c               |    1 +
 drivers/usb/class/cdc-wdm.c                    |   21 +-
 drivers/usb/core/devio.c                       |   33 +-
 drivers/usb/core/hub.c                         |    4 +
 drivers/usb/core/quirks.c                      |    3 +
 drivers/usb/core/usb.h                         |   14 -
 drivers/usb/gadget/fsl_udc_core.c              |    2 +
 drivers/usb/host/ehci-pci.c                    |    4 +-
 drivers/usb/host/ohci-at91.c                   |   11 +-
 drivers/usb/host/pci-quirks.c                  |   32 +-
 drivers/usb/host/xhci-mem.c                    |   27 +
 drivers/usb/host/xhci-pci.c                    |    1 +
 drivers/usb/host/xhci-ring.c                   |   21 +-
 drivers/usb/host/xhci.h                        |    1 +
 drivers/usb/misc/usbtest.c                     |   17 +-
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    8 +
 drivers/usb/serial/ti_usb_3410_5052.c          |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.h          |    1 +
 drivers/usb/storage/unusual_devs.h             |    7 +
 drivers/video/omap2/dss/venc.c                 |    5 +
 drivers/xen/events.c                           |    5 +-
 fs/aio.c                                       |   30 +-
 fs/bio.c                                       |    9 +-
 fs/block_dev.c                                 |    6 +-
 fs/buffer.c                                    |    4 +-
 fs/cifs/cifsfs.c                               |    2 +-
 fs/ext3/ialloc.c                               |    8 +-
 fs/ext4/ialloc.c                               |    8 +-
 fs/nfs/nfs4proc.c                              |   30 +-
 fs/nfs/nfs4xdr.c                               |   18 +-
 fs/super.c                                     |    2 +
 include/linux/fs.h                             |    1 +
 include/linux/genhd.h                          |    6 -
 include/linux/kvm_host.h                       |    7 +
 include/linux/mmc/host.h                       |    2 +
 include/linux/usb.h                            |   13 +
 include/xen/events.h                           |    3 +
 init/do_mounts.c                               |    2 +-
 init/main.c                                    |    7 +-
 kernel/compat.c                                |   63 +-
 kernel/workqueue.c                             |    9 +-
 mm/memcontrol.c                                |    6 +
 mm/swapfile.c                                  |    2 +-
 net/core/ethtool.c                             |    2 +
 net/wireless/reg.c                             |   10 +
 scripts/Makefile                               |    2 +
 security/selinux/selinuxfs.c                   |    1 +
 tools/usb/ffs-test.c                           |    2 +-
 virt/kvm/iommu.c                               |   23 +-
 virt/kvm/kvm_main.c                            |   23 +-
 122 files changed, 1588 insertions(+), 1081 deletions(-)

Alan Cox (1):
      tty: Allow uart_register/unregister/register

Alan Stern (1):
      usb-storage: unusual_devs entry for Yarvik PMP400 MP4 player

Alex Williamson (1):
      KVM: lock slots_lock around device assignment

Andi Kleen (1):
      MCE: Fix vm86 handling for 32bit mce handler

Andiry Xu (1):
      usbcore: enable USB2 LPM if port suspend fails

Arnaud Patard (1):
      8250_pci: fix pch uart matching

Avi Kivity (1):
      KVM: Ensure all vcpus are consistent with in-kernel irqchip settings

Ben Hutchings (2):
      ethtool: Null-terminate filename passed to ethtool_ops::flash_device
      Linux 3.2.19

Ben Widawsky (1):
      drm/i915: [GEN7] Use HW scheduler for fixed function shaders

Bernd Schubert (1):
      bio allocation failure due to bio_get_nr_vecs()

Bj=C3=B8rn Mork (3):
      USB: cdc-wdm: poll must return POLLHUP if device is gone
      USB: cdc-wdm: add debug messages on cleanup
      USB: cdc-wdm: cannot use dev_printk when device is gone

Chris Bagwell (1):
      Input: wacom - relax Bamboo stylus ID check

Chris Metcalf (3):
      arch/tile/Kconfig: remove pointless "!M386" test.
      tilegx: enable SYSCALL_WRAPPERS support
      tile: fix bug where fls(0) was not returning 0

Chris Wilson (1):
      drm/i915: Avoid a double-read of PCH_IIR during interrupt handling

Christian Borntraeger (1):
      KVM: s390: Sanitize fpc registers for KVM_SET_FPU

Christian Melki (1):
      8250.c: less than 2400 baud fix.

Dan Carpenter (2):
      iommu: Fix off by one in dmar_get_fault_reason()
      cifs: fix revalidation test in cifs_llseek()

Dan Williams (1):
      isci: fix oem parameter validation on single controller skus

Daniel Vetter (1):
      drm/i915: don't clobber the pipe param in sanitize_modesetting

Danny Kukawka (1):
      OMAPDSS: VENC: fix NULL pointer dereference in DSS2 VENC sysfs debug =
attr on OMAP4

Darren Hart (1):
      USB: serial: ti_usb_3410_5052: Add support for the FRI2 serial consol=
e

Dave Airlie (1):
      nouveau: nouveau_set_bo_placement takes TTM flags

David Herrmann (1):
      HID: wiimote: Fix IR data parser

David Howells (1):
      KEYS: Use the compat keyctl() syscall wrapper on Sparc64 for Sparc32 =
compat

David Woodhouse (1):
      intel-iommu: Add device info into list before doing context mapping

Dima Zavin (2):
      ARM: 7365/1: drop unused parameter from flush_cache_user_range
      ARM: 7409/1: Do not call flush_cache_user_range with mmap_sem held

Eric Paris (1):
      SELinux: if sel_make_bools errors don't leave inconsistent state

H. Peter Anvin (5):
      x86, realmode: 16-bit real-mode code support for relocs tool
      x86, relocs: Workaround for binutils 2.22.52.0.1 section bug
      x86, relocs: When printing an error, say relative or absolute
      x86-32, relocs: Whitelist more symbols for ld bug workaround
      x86, relocs: Add jiffies and jiffies_64 to the relative whitelist

Hans de Goede (1):
      usb-xhci: Handle COMP_TX_ERR for isoc tds

Heiko Carstens (1):
      s390/pfault: fix task state race

Herton Ronaldo Krzesinski (1):
      spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control

Huajun Li (1):
      USB: Remove races in devio.c

James Bottomley (2):
      fix PA1.1 oops on boot
      fix panic on prefetch(NULL) on PA7300LC

Jan Kara (2):
      ext3: Fix error handling on inode bitmap corruption
      ext4: fix error handling on inode bitmap corruption

Jan Kiszka (1):
      compat: Fix RT signal mask corruption via sigprocmask

Jarkko Sakkinen (1):
      x86, relocs: Build clean fix

Jeff Mahoney (1):
      dl2k: Clean up rio_ioctl

Jeff Moyer (1):
      block: don't mark buffers beyond end of disk as mapped

Jens Freimann (1):
      KVM: s390: do store status after handling STOP_ON_STOP bit

Johan Hovold (1):
      USB: move usb_translate_errors to linux/usb.h

John David Anglin (1):
      fix crash in flush_icache_page_asm on PA1.1

Jonathan Nieder (1):
      HID: logitech: read all 32 bits of report type bitfield

Josh Boyer (1):
      sony-laptop: Enable keyboard backlight by default

Julia Lawall (1):
      drivers/staging/comedi/comedi_fops.c: add missing vfree

Kazuya Mio (1):
      wake up s_wait_unfrozen when ->freeze_fs fails

Kees Cook (1):
      docs: update HOWTO for 2.6.x -> 3.x versioning

Kent Overstreet (1):
      bio: don't overflow in bio_get_nr_vecs()

Lan Tianyu (1):
      ACPI / PM: Add Sony Vaio VPCCW29FX to nonvs blacklist.

Larry Finger (2):
      b43legacy: Fix error due to MMIO access with SSB unpowered
      rtlwifi: Preallocate USB read buffers and eliminate kalloc in read ro=
utine

Laurent Pinchart (1):
      uvcvideo: Fix ENUMINPUT handling

Laxman Dewangan (1):
      i2c: tegra: notify transfer-complete after clearing status.

Linus Torvalds (2):
      Fix blocking allocations called very early during bootup
      vfs: make AIO use the proper rw_verify_area() area helpers

Lothar Wa=C3=9Fmann (1):
      Add missing call to uart_update_timeout()

Luis R. Rodriguez (1):
      cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB

Marcelo Tosatti (1):
      KVM: VMX: vmx_set_cr0 expects kvm->srcu locked

Marcus Folkesson (1):
      i2c: davinci: Free requested IRQ in remove

Mark Brown (1):
      regulator: core: Release regulator-regulator supplies on error

Matt Johnson (1):
      ahci: Detect Marvell 88SE9172 SATA controller

Matthias Fend (1):
      USB: ffs-test: fix length argument of out function call

Maxim Levitsky (1):
      mtd: sm_ftl: fix typo in major number.

Michael Krufky (1):
      smsusb: add autodetection support for USB ID 2040:c0a0

Nadav Har'El (1):
      KVM: nVMX: Fix erroneous exception bitmap check

Nicolas Ferre (1):
      USB: ohci-at91: add a reset function to fix race condition

Nicolas Pitre (1):
      mmc: sdio: avoid spurious calls to interrupt handlers

Oliver Neukum (3):
      USB: cdc-wdm: sanitize error returns
      USB: cdc-wdm: fix memory leak
      USB: fix resource leak in xhci power loss path

Paul Zimmerman (1):
      usb: usbtest: two super speed fixes for usbtest

Peng Tao (1):
      NFS4: fix compile warnings in nfs4proc.c

Peter Chen (1):
      usb: gadget: fsl_udc_core: dTD's next dtd pointer need to be updated =
once written

Rajkumar Kasirajan (1):
      drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01

Richard Weinberger (2):
      um: Implement a custom pte_same() function
      um: Fix __swp_type()

Robert Richter (1):
      perf/x86: Update event scheduling constraints for AMD family 15h mode=
ls

Sachin Prabhu (2):
      Avoid reading past buffer when calling GETACL
      Avoid beyond bounds copy while caching ACL

Sarah Sharp (4):
      xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=3Dn
      xhci: Add Lynx Point to list of Intel switchable hosts.
      xhci: Add new short TX quirk for Fresco Logic host.
      xhci: Reset reserved command ring TRBs on cleanup.

Sasha Levin (1):
      init: don't try mounting device as nfs root unless type fully matches

Sha Zhengju (1):
      memcg: free spare array to avoid memory leak

Shaohua Li (2):
      md: using GFP_NOIO to allocate bio for flush request
      swap: don't do discard if no discard option added

Stefano Stabellini (1):
      xen: do not map the same GSI twice in PVHVM guests.

Steffen M=C3=BCller (1):
      usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es

Stephen M. Cameron (2):
      hpsa: Fix problem with MSA2xxx devices
      hpsa: Add IRQF_SHARED back in for the non-MSI(X) interrupt handler

Steve Wise (2):
      RDMA/cxgb4: Always wake up waiters in c4iw_peer_abort_intr()
      RDMA/cxgb4: Drop peer_abort when no endpoint found

Takuya Yoshikawa (1):
      KVM: mmu_notifier: Flush TLBs before releasing mmu_lock

Tejun Heo (2):
      block: fix buffer overflow when printing partition UUIDs
      workqueue: skip nr_running sanity check in worker_enter_idle() if tru=
stee is active

Thomas Gleixner (1):
      gpio: mpc8xxx: Prevent NULL pointer deref in demux handler

Tilman Schmidt (3):
      isdn/gigaset: ratelimit CAPI message dumps
      isdn/gigaset: fix CAPI disconnect B3 handling
      isdn/gigaset: improve error handling querying firmware version

Tomoya MORINAGA (1):
      i2c-eg20t: change timeout value 50msec to 1000msec

Tony Luck (1):
      x86/mce: Fix check for processor context when machine check was taken=
.

Yishai Hadas (1):
      IB/core: Fix mismatch between locked and pinned pages

nagalakshmi.nandigama@lsi.com (1):
      mpt2sas: Fix for panic happening because of improper memory allocatio=
n

=C3=89ric Piel (1):
      USB: ftdi-sio: add support for Physik Instrumente E-861


--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-L1DEcrcpxHXlnNj5yLE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT80RDOe/yOyVhhEJAQpv+g/+LfUvV+8T3nGbkM8xRQG21OqjUbboTiZk
s4xtvZQD9rsdP6k4jbkHQkuu+cNcIsG0P3sdFoGddVHOdfhzog5HcjpD6eVHWdU/
TmQnhMJm7Odfwa9sy/yhhVk54IgPKd6kVwd4JQGCZX6d1gqHOOfIL2eqQJmnnKQQ
0ZU2YRGXmSX31kNIsExVoo8oCjEzKsxaSMS02jU6G14/fDBbk6QP8tzsrLryZdNO
IMrKyX8lqVGa89bVSG2LeluUPhbWg7mJJyypxvFSuBXWYCu5bZJ49dbvkMWM/06C
0qnMQRaIj8ho7+5J3JhAs9YV5MBwvuNTey2S5fRoMAZRhLQftxRW2cKN2NtwSqgh
fPTyqn5HtusrRRn9aNGpW/DvWSEzYs/+BGl59veT21V9KqyGDbv+Ktxd+pySparq
zv+nH+C5r4EZY1B8aOaU3G0aq8QwivkSA8ZgWVSdc3SuQe0bMxa/g9t5l6j6vRFW
VEIXgE4DwoA2rDSURbGYV5OYno/AO5fUJ0GYk8pMZz/KzzofeEzGuFAAHsMiQ7Ea
aN3MMDiBQoZkw6VdwrVwj2lcrRVZF14qr/+a4q9HBlA2f5/j3zzlce2glY9/hw6j
7rw1X6CgV3Eq5mzFxZQE157fVjmwccTBDedswBaNK+UfE3umMZtL3LERzEb6QmkE
uE+6PiYXMsw=
=Z6fm
-----END PGP SIGNATURE-----

--=-L1DEcrcpxHXlnNj5yLE1--
