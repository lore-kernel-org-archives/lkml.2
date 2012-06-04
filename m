Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2FDSwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:52:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48716 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2FDSwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:52:03 -0400
Date: Mon, 4 Jun 2012 11:51:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.4.1
Message-ID: <20120604185159.GA5455@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.1 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------


 Documentation/HOWTO                       |   32 +++++++--------
 Makefile                                  |    2=20
 arch/arm/boot/dts/tegra-cardhu.dts        |    2=20
 arch/arm/include/asm/cacheflush.h         |    2=20
 arch/arm/kernel/traps.c                   |    4 +
 arch/powerpc/kernel/idle.c                |   14 ++----
 arch/s390/mm/fault.c                      |   14 +++++-
 arch/sparc/Kconfig                        |    3 +
 arch/sparc/kernel/systbls_64.S            |    2=20
 arch/tile/include/asm/bitops.h            |   12 ++---
 arch/um/include/asm/pgtable.h             |   10 +++-
 arch/x86/Makefile                         |    1=20
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 ++++---
 arch/x86/kernel/cpu/mcheck/mce.c          |    8 +++
 arch/x86/kernel/cpu/perf_event_amd.c      |   11 ++++-
 arch/x86/pci/xen.c                        |    4 +
 arch/x86/tools/relocs.c                   |   12 +++++
 drivers/gpio/gpio-mpc8xxx.c               |    3 -
 drivers/gpu/drm/gma500/psb_device.c       |    6 +-
 drivers/gpu/drm/i915/i915_irq.c           |    9 +---
 drivers/gpu/drm/i915/i915_reg.h           |   15 +++++++
 drivers/gpu/drm/i915/intel_display.c      |   19 ++++++++-
 drivers/gpu/drm/nouveau/nouveau_bo.c      |    2=20
 drivers/hid/hid-logitech-dj.c             |    5 +-
 drivers/hid/hid-wiimote-core.c            |   16 ++-----
 drivers/hid/usbhid/hid-core.c             |   61 +++++++++++++++++++++++++=
++---
 drivers/i2c/busses/i2c-davinci.c          |    2=20
 drivers/i2c/busses/i2c-tegra.c            |   13 ++----
 drivers/infiniband/core/umem.c            |    2=20
 drivers/infiniband/hw/cxgb4/cm.c          |   13 +++---
 drivers/iommu/dmar.c                      |    4 -
 drivers/iommu/intel-iommu.c               |   17 +++++---
 drivers/isdn/gigaset/capi.c               |   26 ++++++------
 drivers/isdn/gigaset/ev-layer.c           |    4 +
 drivers/md/md.c                           |    2=20
 drivers/media/dvb/siano/smsusb.c          |    2=20
 drivers/media/video/uvc/uvc_v4l2.c        |    2=20
 drivers/mmc/core/cd-gpio.c                |    3 +
 drivers/mmc/core/sdio.c                   |    2=20
 drivers/mmc/core/sdio_irq.c               |   11 +++--
 drivers/mmc/host/omap_hsmmc.c             |    2=20
 drivers/net/wireless/b43legacy/main.c     |    2=20
 drivers/regulator/core.c                  |    2=20
 drivers/scsi/isci/init.c                  |    2=20
 drivers/scsi/mpt2sas/mpt2sas_base.c       |    6 +-
 drivers/spi/spi-fsl-spi.c                 |    2=20
 drivers/staging/android/persistent_ram.c  |   19 ---------
 drivers/staging/comedi/comedi_fops.c      |    2=20
 drivers/tty/hvc/hvc_xen.c                 |    4 -
 drivers/tty/serial/8250/8250.c            |    9 ++--
 drivers/tty/serial/8250/8250_pci.c        |   18 ++++++++
 drivers/tty/serial/mxs-auart.c            |    2=20
 drivers/tty/serial/serial_core.c          |    1=20
 drivers/usb/class/cdc-wdm.c               |   31 ++++++++++-----
 drivers/usb/core/devio.c                  |   33 ++++++++++++----
 drivers/usb/core/hub.c                    |    4 +
 drivers/usb/core/quirks.c                 |    3 +
 drivers/usb/core/urb.c                    |   21 ++++++++++
 drivers/usb/gadget/fsl_udc_core.c         |    2=20
 drivers/usb/host/ehci-omap.c              |   18 ++++----
 drivers/usb/host/ehci-pci.c               |    4 +
 drivers/usb/host/ehci-platform.c          |    2=20
 drivers/usb/host/ohci-at91.c              |   11 ++++-
 drivers/usb/host/pci-quirks.c             |   32 +++++++++++++++
 drivers/usb/host/xhci-hub.c               |   22 +++++-----
 drivers/usb/host/xhci-mem.c               |   27 +++++++++++++
 drivers/usb/host/xhci-pci.c               |    1=20
 drivers/usb/host/xhci-ring.c              |   22 +++++++++-
 drivers/usb/host/xhci.c                   |   12 ++++-
 drivers/usb/host/xhci.h                   |    3 +
 drivers/usb/misc/usbtest.c                |   17 +++++---
 drivers/usb/otg/gpio_vbus.c               |    8 +--
 drivers/usb/serial/ftdi_sio.c             |    1=20
 drivers/usb/serial/ftdi_sio_ids.h         |    8 +++
 drivers/usb/serial/ti_usb_3410_5052.c     |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.h     |    1=20
 drivers/usb/serial/usb-serial.c           |    9 +++-
 drivers/usb/storage/unusual_devs.h        |    7 +++
 drivers/video/sh_mobile_lcdcfb.c          |    5 +-
 drivers/video/sh_mobile_lcdcfb.h          |    1=20
 drivers/xen/events.c                      |    5 +-
 fs/aio.c                                  |   30 ++++++--------
 include/linux/mmc/host.h                  |    2=20
 include/linux/usb.h                       |    3 +
 include/xen/events.h                      |    3 +
 init/main.c                               |    7 +--
 kernel/workqueue.c                        |    9 +++-
 mm/mempolicy.c                            |   41 ++++++++------------
 net/wireless/reg.c                        |   10 ++++
 security/selinux/selinuxfs.c              |    1=20
 tools/usb/ffs-test.c                      |    2=20
 91 files changed, 620 insertions(+), 263 deletions(-)

Alan Cox (2):
      tty: Allow uart_register/unregister/register
      gma500: Fix Poulsbo suspend/resume crash on devices with SDVO ports

Alan Stern (2):
      usb-serial: ftdi_sio: fix oops during autosuspend
      usb-storage: unusual_devs entry for Yarvik PMP400 MP4 player

Andi Kleen (1):
      MCE: Fix vm86 handling for 32bit mce handler

Andiry Xu (2):
      xHCI: keep track of ports being resumed and indicate in hub_status_da=
ta
      usbcore: enable USB2 LPM if port suspend fails

Anton Vorontsov (1):
      persistent_ram: Fix buffer size clamping during writes

Arnaud Patard (1):
      8250_pci: fix pch uart matching

Ben Widawsky (1):
      drm/i915: [GEN7] Use HW scheduler for fixed function shaders

Bj=F8rn Mork (3):
      USB: cdc-wdm: poll must return POLLHUP if device is gone
      USB: cdc-wdm: cannot use dev_printk when device is gone
      USB: cdc-wdm: remove from device list on disconnect

Chris Metcalf (1):
      tile: fix bug where fls(0) was not returning 0

Chris Wilson (1):
      drm/i915: Avoid a double-read of PCH_IIR during interrupt handling

Christian Melki (1):
      8250.c: less than 2400 baud fix.

Dan Carpenter (2):
      hvc_xen: NULL dereference on allocation failure
      iommu: Fix off by one in dmar_get_fault_reason()

Dan Williams (1):
      isci: fix oem parameter validation on single controller skus

Daniel Vetter (1):
      drm/i915: don't clobber the pipe param in sanitize_modesetting

Darren Hart (1):
      USB: serial: ti_usb_3410_5052: Add support for the FRI2 serial console

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

Greg Kroah-Hartman (1):
      Linux 3.4.1

Guennadi Liakhovetski (1):
      mmc: cd-gpio: protect against NULL context in mmc_cd_gpio_free()

H. Peter Anvin (2):
      x86-32, relocs: Whitelist more symbols for ld bug workaround
      x86, relocs: Add jiffies and jiffies_64 to the relative whitelist

Hans de Goede (1):
      usb-xhci: Handle COMP_TX_ERR for isoc tds

Hauke Mehrtens (1):
      USB: ehci-platform: remove update_device

Heiko Carstens (1):
      s390/pfault: fix task state race

Herton Ronaldo Krzesinski (1):
      spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control

Huajun Li (1):
      USB: Remove races in devio.c

Jarkko Sakkinen (1):
      x86, relocs: Build clean fix

Jonathan Nieder (1):
      HID: logitech: read all 32 bits of report type bitfield

Julia Lawall (1):
      drivers/staging/comedi/comedi_fops.c: add missing vfree

Kees Cook (1):
      docs: update HOWTO for 2.6.x -> 3.x versioning

Larry Finger (1):
      b43legacy: Fix error due to MMIO access with SSB unpowered

Laurent Pinchart (2):
      fbdev: sh_mobile_lcdc: Don't confuse line size with pitch
      media: uvcvideo: Fix ENUMINPUT handling

Laxman Dewangan (1):
      i2c: tegra: notify transfer-complete after clearing status.

Linus Torvalds (2):
      vfs: make AIO use the proper rw_verify_area() area helpers
      Fix blocking allocations called very early during bootup

Lothar Wa=DFmann (1):
      Add missing call to uart_update_timeout()

Luis R. Rodriguez (1):
      cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB

Marcus Folkesson (1):
      i2c: davinci: Free requested IRQ in remove

Mark Brown (1):
      regulator: core: Release regulator-regulator supplies on error

Matthias Fend (1):
      USB: ffs-test: fix length argument of out function call

Mel Gorman (1):
      mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy link=
ages

Michael Krufky (1):
      smsusb: add autodetection support for USB ID 2040:c0a0

Ming Lei (1):
      mmc: omap_hsmmc: pass IRQF_ONESHOT to request_threaded_irq

Nicolas Ferre (1):
      USB: ohci-at91: add a reset function to fix race condition

Nicolas Pitre (1):
      mmc: sdio: avoid spurious calls to interrupt handlers

Oliver Neukum (4):
      usbhid: prevent deadlock during timeout
      USB: cdc-wdm: sanitize error returns
      USB: cdc-wdm: fix memory leak
      USB: fix resource leak in xhci power loss path

Paul Zimmerman (1):
      usb: usbtest: two super speed fixes for usbtest

Peter Chen (1):
      usb: gadget: fsl_udc_core: dTD's next dtd pointer need to be updated =
once written

Richard Weinberger (2):
      um: Fix __swp_type()
      um: Implement a custom pte_same() function

Robert Richter (1):
      perf/x86: Update event scheduling constraints for AMD family 15h mode=
ls

Russ Dill (1):
      USB: EHCI: OMAP: Finish ehci omap phy reset cycle before adding hcd.

Sarah Sharp (4):
      xhci: Add Lynx Point to list of Intel switchable hosts.
      xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=3Dn
      xhci: Reset reserved command ring TRBs on cleanup.
      xhci: Add new short TX quirk for Fresco Logic host.

Shaohua Li (1):
      md: using GFP_NOIO to allocate bio for flush request

Shinya Kuribayashi (1):
      USB: gpio_vbus: provide an appropriate debounce interval

Stefano Stabellini (1):
      xen: do not map the same GSI twice in PVHVM guests.

Steffen M=FCller (1):
      usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es

Stephen Warren (1):
      ARM: dt: tegra cardhu: fix typo in SDHCI node name

Steve Wise (3):
      RDMA/cxgb4: Always wake up waiters in c4iw_peer_abort_intr()
      RDMA/cxgb4: Use dst parameter in import_ep()
      RDMA/cxgb4: Drop peer_abort when no endpoint found

Tejun Heo (1):
      workqueue: skip nr_running sanity check in worker_enter_idle() if tru=
stee is active

Thomas Gleixner (2):
      powerpc: Fix broken cpu_idle_wait() implementation
      gpio: mpc8xxx: Prevent NULL pointer deref in demux handler

Tilman Schmidt (3):
      isdn/gigaset: ratelimit CAPI message dumps
      isdn/gigaset: fix CAPI disconnect B3 handling
      isdn/gigaset: improve error handling querying firmware version

Tony Luck (1):
      x86/mce: Fix check for processor context when machine check was taken.

Yishai Hadas (1):
      IB/core: Fix mismatch between locked and pinned pages

nagalakshmi.nandigama@lsi.com (1):
      SCSI: mpt2sas: Fix for panic happening because of improper memory all=
ocation

=C9ric Piel (1):
      USB: ftdi-sio: add support for Physik Instrumente E-861


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPzQPPAAoJEDjbvchgkmk+8uUQALhnlNa452OC9LoMlvzR86qT
6hVNO4nywlW30N0kM1eewUe5r5tiLNJMrg94PfS+QENfA0esXOXuVwiX08/RjxBN
QaW4dZwXQtqR6qBXVcG1Nsyx1sUSB+ZbyQaZZqnVqDy0DYinZGtn63b3AOvGJ+ai
neMGOq2RvErtnXtJEwCL4MwH1KehMr67WGS9NnG2dZVmbHqNrdDlPaCtkixyjBnx
yJbvklT86HLok/4tHZYZFDd9bTfebu76TQgY9f7TotS8tB7WI/fQ1ASBatK2ajAW
hftN7/znQs0lyHAth8BaAj1gvJ7dZQJB4UnPR7t9pbj6sAVBokddaVdROuDsSfP8
NNqSFevtJNiSi6JMde8wf0Nnl/pPOKGGb1I5d9Xdvuv+LRYKuobHmcdv3V2CBbH2
HupxKhTtBTAU5Q6Dy6VSrmjGKnc5HfQLbYNT6c8e9p1oLLXHbX1ZKA67VhpQKiSA
5ZQMlmeMDLa42QBs32okFZ0W3ecTvuvVoXP44hHl+E7MTghShkb8zm2CdlhEVmoK
Ex/n39T0S5/NZqvUf9a7Z8PTWTohoaWoXmebO0TuHwH8WBilxwlXezMmpaoZGYyU
mIJJDT7sNxOiI4nYc7xNpagAtMq+uomlHj5cW1L4foxWxH39wRjfYAIV/PV1Xsfv
/kseFKsQgythfQxL0IRO
=7nWD
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
