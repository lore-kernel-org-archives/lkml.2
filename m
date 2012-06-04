Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2FDSvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:51:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54142 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2FDSvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:51:08 -0400
Date: Mon, 4 Jun 2012 11:51:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.3.8
Message-ID: <20120604185104.GA5409@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.3.8 kernel.

Note, this is the LAST 3.3.y kernel release, it is now end-of-life.
Please move to the 3.4.y kernel tree as soon as possible.

All users of the 3.3 kernel series must upgrade.

The updated 3.3.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.3.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/HOWTO                         |   32 -
 Makefile                                    |   11=20
 arch/arm/include/asm/cacheflush.h           |    2=20
 arch/arm/kernel/traps.c                     |    4=20
 arch/parisc/include/asm/prefetch.h          |    7=20
 arch/parisc/kernel/entry.S                  |    4=20
 arch/parisc/kernel/pacache.S                |   38 -
 arch/powerpc/kernel/idle.c                  |   14=20
 arch/s390/mm/fault.c                        |   14=20
 arch/sparc/Kconfig                          |    3=20
 arch/sparc/kernel/systbls_64.S              |    2=20
 arch/tile/Kconfig                           |    1=20
 arch/tile/include/asm/bitops.h              |   12=20
 arch/um/include/asm/pgtable.h               |   10=20
 arch/x86/Makefile                           |    4=20
 arch/x86/boot/compressed/Makefile           |    9=20
 arch/x86/boot/compressed/relocs.c           |  680 -----------------------
 arch/x86/kernel/cpu/mcheck/mce-severity.c   |   16=20
 arch/x86/kernel/cpu/mcheck/mce.c            |    8=20
 arch/x86/kernel/cpu/perf_event_amd.c        |   11=20
 arch/x86/pci/xen.c                          |    4=20
 arch/x86/tools/.gitignore                   |    1=20
 arch/x86/tools/Makefile                     |    4=20
 arch/x86/tools/relocs.c                     |  818 +++++++++++++++++++++++=
+++++
 block/genhd.c                               |   10=20
 drivers/ata/ahci.c                          |    2=20
 drivers/ata/libata-transport.c              |    1=20
 drivers/gpio/gpio-mpc8xxx.c                 |    3=20
 drivers/gpu/drm/gma500/psb_device.c         |    6=20
 drivers/gpu/drm/i915/i915_irq.c             |    9=20
 drivers/gpu/drm/i915/i915_reg.h             |   15=20
 drivers/gpu/drm/i915/intel_display.c        |   19=20
 drivers/gpu/drm/nouveau/nouveau_bo.c        |    2=20
 drivers/hid/hid-logitech-dj.c               |    5=20
 drivers/hid/hid-wiimote-core.c              |   16=20
 drivers/hid/usbhid/hid-core.c               |   61 +-
 drivers/i2c/busses/i2c-davinci.c            |    2=20
 drivers/i2c/busses/i2c-tegra.c              |   13=20
 drivers/infiniband/core/umem.c              |    2=20
 drivers/infiniband/hw/cxgb4/cm.c            |   13=20
 drivers/iommu/dmar.c                        |    4=20
 drivers/iommu/intel-iommu.c                 |   17=20
 drivers/isdn/gigaset/capi.c                 |   22=20
 drivers/md/md.c                             |    2=20
 drivers/md/raid0.c                          |   18=20
 drivers/media/dvb/siano/smsusb.c            |    2=20
 drivers/media/video/uvc/uvc_v4l2.c          |    2=20
 drivers/mmc/core/cd-gpio.c                  |    3=20
 drivers/mmc/core/sdio.c                     |    2=20
 drivers/mmc/core/sdio_irq.c                 |   11=20
 drivers/mmc/host/omap_hsmmc.c               |    2=20
 drivers/mtd/sm_ftl.c                        |    2=20
 drivers/net/wireless/b43legacy/main.c       |    2=20
 drivers/net/wireless/rtlwifi/pci.c          |   17=20
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c |    6=20
 drivers/net/wireless/rtlwifi/usb.c          |   12=20
 drivers/regulator/core.c                    |    2=20
 drivers/rtc/rtc-pl031.c                     |   18=20
 drivers/scsi/hpsa.c                         |   34 -
 drivers/scsi/isci/init.c                    |    2=20
 drivers/scsi/mpt2sas/mpt2sas_base.c         |    6=20
 drivers/spi/spi-fsl-spi.c                   |    6=20
 drivers/staging/comedi/comedi_fops.c        |    2=20
 drivers/tty/serial/8250/8250_pci.c          |   18=20
 drivers/tty/serial/mxs-auart.c              |    2=20
 drivers/tty/serial/serial_core.c            |    1=20
 drivers/usb/class/cdc-wdm.c                 |    4=20
 drivers/usb/core/devio.c                    |   33 -
 drivers/usb/core/hub.c                      |    4=20
 drivers/usb/core/quirks.c                   |    3=20
 drivers/usb/core/urb.c                      |   21=20
 drivers/usb/gadget/fsl_udc_core.c           |    2=20
 drivers/usb/host/ehci-pci.c                 |    4=20
 drivers/usb/host/ohci-at91.c                |   11=20
 drivers/usb/host/pci-quirks.c               |   32 +
 drivers/usb/host/xhci-mem.c                 |   27=20
 drivers/usb/host/xhci-pci.c                 |    1=20
 drivers/usb/host/xhci-ring.c                |   21=20
 drivers/usb/host/xhci.h                     |    1=20
 drivers/usb/misc/usbtest.c                  |   17=20
 drivers/usb/serial/ftdi_sio.c               |    1=20
 drivers/usb/serial/ftdi_sio_ids.h           |    8=20
 drivers/usb/serial/ti_usb_3410_5052.c       |    6=20
 drivers/usb/serial/ti_usb_3410_5052.h       |    1=20
 drivers/usb/storage/unusual_devs.h          |    7=20
 drivers/video/udlfb.c                       |  146 ++--
 drivers/xen/events.c                        |    5=20
 fs/aio.c                                    |   30 -
 fs/bio.c                                    |    7=20
 fs/block_dev.c                              |    6=20
 fs/buffer.c                                 |    4=20
 include/linux/fs.h                          |    1=20
 include/linux/genhd.h                       |    6=20
 include/linux/mmc/host.h                    |    2=20
 include/linux/usb.h                         |    3=20
 include/video/udlfb.h                       |    1=20
 include/xen/events.h                        |    3=20
 init/main.c                                 |    7=20
 kernel/workqueue.c                          |    9=20
 mm/mempolicy.c                              |   41 -
 mm/swapfile.c                               |    2=20
 net/wireless/reg.c                          |   10=20
 scripts/Makefile                            |    2=20
 security/selinux/selinuxfs.c                |    1=20
 tools/usb/ffs-test.c                        |    2=20
 105 files changed, 1565 insertions(+), 1030 deletions(-)

Alan Cox (2):
      tty: Allow uart_register/unregister/register
      gma500: Fix Poulsbo suspend/resume crash on devices with SDVO ports

Alan Stern (1):
      usb-storage: unusual_devs entry for Yarvik PMP400 MP4 player

Andi Kleen (1):
      MCE: Fix vm86 handling for 32bit mce handler

Andiry Xu (1):
      usbcore: enable USB2 LPM if port suspend fails

Arnaud Patard (1):
      8250_pci: fix pch uart matching

Ben Widawsky (1):
      drm/i915: [GEN7] Use HW scheduler for fixed function shaders

Bernd Schubert (1):
      bio allocation failure due to bio_get_nr_vecs()

Bernie Thompson (1):
      udlfb: fix hcd_buffer_free panic on unplug/replug

Bj=F8rn Mork (1):
      USB: cdc-wdm: poll must return POLLHUP if device is gone

Chris Metcalf (2):
      tilegx: enable SYSCALL_WRAPPERS support
      tile: fix bug where fls(0) was not returning 0

Chris Wilson (1):
      drm/i915: Avoid a double-read of PCH_IIR during interrupt handling

Dan Carpenter (1):
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
      Linux 3.3.8

Guennadi Liakhovetski (1):
      mmc: cd-gpio: protect against NULL context in mmc_cd_gpio_free()

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
      PARISC: fix PA1.1 oops on boot
      PARISC: fix panic on prefetch(NULL) on PA7300LC

Jarkko Sakkinen (1):
      x86, relocs: Build clean fix

Jeff Moyer (1):
      block: don't mark buffers beyond end of disk as mapped

Jes Sorensen (1):
      md: Avoid OOPS when reshaping raid1 to raid0

John David Anglin (1):
      PARISC: fix crash in flush_icache_page_asm on PA1.1

Jonathan Nieder (1):
      HID: logitech: read all 32 bits of report type bitfield

Julia Lawall (1):
      drivers/staging/comedi/comedi_fops.c: add missing vfree

Kees Cook (1):
      docs: update HOWTO for 2.6.x -> 3.x versioning

Kenth Eriksson (1):
      spi/mpc83xx: fix NULL pdata dereference bug

Larry Finger (3):
      b43legacy: Fix error due to MMIO access with SSB unpowered
      rtlwifi: fix for race condition when firmware is cached
      rtlwifi: rtl8192de: Fix firmware initialization

Laurent Pinchart (1):
      media: uvcvideo: Fix ENUMINPUT handling

Laxman Dewangan (1):
      i2c: tegra: notify transfer-complete after clearing status.

Lin Ming (1):
      libata: forbid port runtime pm by default, fixing regression

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

Matt Johnson (1):
      ahci: Detect Marvell 88SE9172 SATA controller

Matthias Fend (1):
      USB: ffs-test: fix length argument of out function call

Maxim Levitsky (1):
      mtd: sm_ftl: fix typo in major number.

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

Oliver Neukum (3):
      usbhid: prevent deadlock during timeout
      USB: cdc-wdm: sanitize error returns
      USB: fix resource leak in xhci power loss path

Paul Zimmerman (1):
      usb: usbtest: two super speed fixes for usbtest

Peter Chen (1):
      usb: gadget: fsl_udc_core: dTD's next dtd pointer need to be updated =
once written

Rajkumar Kasirajan (1):
      drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01

Richard Weinberger (2):
      um: Fix __swp_type()
      um: Implement a custom pte_same() function

Robert Richter (1):
      perf/x86: Update event scheduling constraints for AMD family 15h mode=
ls

Sarah Sharp (4):
      xhci: Add Lynx Point to list of Intel switchable hosts.
      xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=3Dn
      xhci: Reset reserved command ring TRBs on cleanup.
      xhci: Add new short TX quirk for Fresco Logic host.

Shaohua Li (2):
      swap: don't do discard if no discard option added
      md: using GFP_NOIO to allocate bio for flush request

Stefano Stabellini (1):
      xen: do not map the same GSI twice in PVHVM guests.

Steffen M=FCller (1):
      usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es

Stephen M. Cameron (1):
      SCSI: hpsa: Fix problem with MSA2xxx devices

Steve Wise (3):
      RDMA/cxgb4: Always wake up waiters in c4iw_peer_abort_intr()
      RDMA/cxgb4: Use dst parameter in import_ep()
      RDMA/cxgb4: Drop peer_abort when no endpoint found

Tejun Heo (2):
      block: fix buffer overflow when printing partition UUIDs
      workqueue: skip nr_running sanity check in worker_enter_idle() if tru=
stee is active

Thomas Gleixner (2):
      powerpc: Fix broken cpu_idle_wait() implementation
      gpio: mpc8xxx: Prevent NULL pointer deref in demux handler

Tilman Schmidt (1):
      isdn/gigaset: ratelimit CAPI message dumps

Tony Luck (1):
      x86/mce: Fix check for processor context when machine check was taken.

Yishai Hadas (1):
      IB/core: Fix mismatch between locked and pinned pages

nagalakshmi.nandigama@lsi.com (1):
      SCSI: mpt2sas: Fix for panic happening because of improper memory all=
ocation

=C9ric Piel (1):
      USB: ftdi-sio: add support for Physik Instrumente E-861


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPzQOYAAoJEDjbvchgkmk+a08QALUr26Ffol6XJmzBC0ITuUkM
ho5B8Jbo+ZWfG+QPRUzR59Zd5nGaUxCBzwLgaFbxc1WJxlRIvkKpkVEvYumkFEx+
QnpoAPJiYvNz3RdHo5mT6SWSvwmshZ5m+TClH4WxHMvGLhebmdjDeWMjUftMSAU3
oFP5lLmjpFMuPnfWKUfX/ZOGHsmV4cmKN/snggLPyxMHY4eRdMVnV6CK0J1spZou
iaQHHZEa6xh6NmIQCtTnJ62blSMWhY7WF17ykLh13RbHA9QYcVGiwYbYMCFDejOq
5R10XZVlmX89ieK1egfqL+gWr26HfWcq+a9Uwu2FbQrIbAx9hflL4ez9NZeIMfGp
nGJtRdRiDqqmOB/0Bxi7Y0l59Abp+I9ja2c3AZqR3rcypsed/m4wmf3OMOXiBR2u
w4AqycCKXVztLdb3TUHo823rjhy3V98+l2CvUXLd/WKUZkZXNplOCsGYX+fyxDWj
mhdY+bLkMJk9uMbm2GDsbGzHHK67LJGAg/6xOvB8KL5oYz2ba9sft6cXVmGeegTZ
rAAV1JFo52a8OwHkkeYqZmhdHsYTsEIvVxjj/EpCMDc9gzsMoq9eJtYm57aeCZgL
UldLzkW+XJv1i4Of+cLC1KQC+upx7lYXeAEnm3LzakJeT9DyLpG3nSrXl8+5x9q4
Bq0DXQtlqyzjRWQtMlu4
=h50x
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
