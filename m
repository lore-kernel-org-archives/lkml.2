Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab2FDSt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:49:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51327 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab2FDStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:49:47 -0400
Date: Mon, 4 Jun 2012 11:49:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.33
Message-ID: <20120604184942.GA5356@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.33 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------


 Documentation/HOWTO                       |   32 +++++++++++------------
 Makefile                                  |    2 -
 arch/arm/include/asm/cacheflush.h         |    2 -
 arch/arm/kernel/traps.c                   |    4 ++
 arch/parisc/include/asm/prefetch.h        |    7 ++++-
 arch/parisc/kernel/entry.S                |    4 ++
 arch/parisc/kernel/pacache.S              |   38 ++++++++++++++-----------=
--
 arch/s390/mm/fault.c                      |   14 ++++++++--
 arch/sparc/Kconfig                        |    3 ++
 arch/sparc/kernel/systbls_64.S            |    2 -
 arch/tile/Kconfig                         |    1=20
 arch/tile/include/asm/bitops.h            |   12 ++++----
 arch/um/include/asm/pgtable.h             |   10 +++++--
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 +++++++----
 arch/x86/kernel/cpu/perf_event_amd.c      |   11 +++++++-
 block/genhd.c                             |   10 ++++---
 drivers/ata/ahci.c                        |    2 +
 drivers/gpu/drm/i915/i915_irq.c           |    9 ++----
 drivers/gpu/drm/i915/i915_reg.h           |   15 ++++++++++
 drivers/gpu/drm/i915/intel_display.c      |   19 ++++++++++++-
 drivers/gpu/drm/nouveau/nouveau_bo.c      |    2 -
 drivers/i2c/busses/i2c-davinci.c          |    2 -
 drivers/infiniband/hw/cxgb4/cm.c          |    6 ++++
 drivers/isdn/gigaset/capi.c               |   22 ++++++----------
 drivers/md/md.c                           |    2 -
 drivers/media/dvb/siano/smsusb.c          |    2 +
 drivers/media/video/uvc/uvc_v4l2.c        |    2 -
 drivers/mmc/core/sdio.c                   |    2 -
 drivers/mmc/core/sdio_irq.c               |   11 +++++---
 drivers/mtd/sm_ftl.c                      |    2 -
 drivers/rtc/rtc-pl031.c                   |   18 +++++++++++++
 drivers/scsi/hpsa.c                       |   34 ++++++++++--------------
 drivers/scsi/isci/init.c                  |    2 -
 drivers/scsi/mpt2sas/mpt2sas_base.c       |    6 ++--
 drivers/staging/comedi/comedi_fops.c      |    2 -
 drivers/tty/serial/mxs-auart.c            |    2 +
 drivers/tty/serial/serial_core.c          |    1=20
 drivers/usb/class/cdc-wdm.c               |    2 -
 drivers/usb/core/devio.c                  |   33 ++++++++++++++++++------
 drivers/usb/core/quirks.c                 |    3 ++
 drivers/usb/gadget/fsl_udc_core.c         |    2 +
 drivers/usb/host/ehci-pci.c               |    4 ++
 drivers/usb/host/pci-quirks.c             |   18 ++++++++++++-
 drivers/usb/host/xhci-mem.c               |    1=20
 drivers/usb/host/xhci-pci.c               |    1=20
 drivers/usb/host/xhci-ring.c              |   21 +++++++++++++--
 drivers/usb/host/xhci.h                   |    1=20
 drivers/usb/misc/usbtest.c                |   17 ++++++++----
 drivers/usb/serial/ftdi_sio.c             |    1=20
 drivers/usb/serial/ftdi_sio_ids.h         |    8 +++++
 drivers/usb/serial/ti_usb_3410_5052.c     |    6 ++--
 drivers/usb/serial/ti_usb_3410_5052.h     |    1=20
 drivers/usb/storage/unusual_devs.h        |    7 +++++
 fs/aio.c                                  |   30 ++++++++++-----------
 fs/block_dev.c                            |    6 ++--
 fs/buffer.c                               |    4 ++
 include/linux/fs.h                        |    1=20
 include/linux/genhd.h                     |    6 ----
 include/linux/mmc/host.h                  |    2 +
 init/main.c                               |    7 ++---
 kernel/workqueue.c                        |    9 +++++-
 mm/mempolicy.c                            |   41 ++++++++++++-------------=
-----
 net/wireless/reg.c                        |   10 +++++++
 security/selinux/selinuxfs.c              |    1=20
 tools/usb/ffs-test.c                      |    2 -
 65 files changed, 384 insertions(+), 192 deletions(-)


Alan Cox (1):
      tty: Allow uart_register/unregister/register

Alan Stern (1):
      usb-storage: unusual_devs entry for Yarvik PMP400 MP4 player

Ben Widawsky (1):
      drm/i915: [GEN7] Use HW scheduler for fixed function shaders

Bj=F8rn Mork (1):
      USB: cdc-wdm: poll must return POLLHUP if device is gone

Chris Metcalf (2):
      tilegx: enable SYSCALL_WRAPPERS support
      tile: fix bug where fls(0) was not returning 0

Chris Wilson (1):
      drm/i915: Avoid a double-read of PCH_IIR during interrupt handling

Dan Williams (1):
      isci: fix oem parameter validation on single controller skus

Daniel Vetter (1):
      drm/i915: don't clobber the pipe param in sanitize_modesetting

Darren Hart (1):
      USB: serial: ti_usb_3410_5052: Add support for the FRI2 serial console

Dave Airlie (1):
      nouveau: nouveau_set_bo_placement takes TTM flags

David Howells (1):
      KEYS: Use the compat keyctl() syscall wrapper on Sparc64 for Sparc32 =
compat

Dima Zavin (2):
      ARM: 7365/1: drop unused parameter from flush_cache_user_range
      ARM: 7409/1: Do not call flush_cache_user_range with mmap_sem held

Eric Paris (1):
      SELinux: if sel_make_bools errors don't leave inconsistent state

Greg Kroah-Hartman (1):
      Linux 3.0.33

Hans de Goede (1):
      usb-xhci: Handle COMP_TX_ERR for isoc tds

Heiko Carstens (1):
      s390/pfault: fix task state race

Huajun Li (1):
      USB: Remove races in devio.c

James Bottomley (2):
      PARISC: fix PA1.1 oops on boot
      PARISC: fix panic on prefetch(NULL) on PA7300LC

Jeff Moyer (1):
      block: don't mark buffers beyond end of disk as mapped

John David Anglin (1):
      PARISC: fix crash in flush_icache_page_asm on PA1.1

Julia Lawall (1):
      drivers/staging/comedi/comedi_fops.c: add missing vfree

Kees Cook (1):
      docs: update HOWTO for 2.6.x -> 3.x versioning

Laurent Pinchart (1):
      media: uvcvideo: Fix ENUMINPUT handling

Linus Torvalds (2):
      vfs: make AIO use the proper rw_verify_area() area helpers
      Fix blocking allocations called very early during bootup

Lothar Wa=DFmann (1):
      Add missing call to uart_update_timeout()

Luis R. Rodriguez (1):
      cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB

Marcus Folkesson (1):
      i2c: davinci: Free requested IRQ in remove

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

Nicolas Pitre (1):
      mmc: sdio: avoid spurious calls to interrupt handlers

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

Sarah Sharp (3):
      xhci: Add Lynx Point to list of Intel switchable hosts.
      xhci: Reset reserved command ring TRBs on cleanup.
      xhci: Add new short TX quirk for Fresco Logic host.

Shaohua Li (1):
      md: using GFP_NOIO to allocate bio for flush request

Steffen M=FCller (1):
      usb: add USB_QUIRK_RESET_RESUME for M-Audio 88es

Stephen M. Cameron (1):
      SCSI: hpsa: Fix problem with MSA2xxx devices

Steve Wise (1):
      RDMA/cxgb4: Drop peer_abort when no endpoint found

Tejun Heo (2):
      block: fix buffer overflow when printing partition UUIDs
      workqueue: skip nr_running sanity check in worker_enter_idle() if tru=
stee is active

Tilman Schmidt (1):
      isdn/gigaset: ratelimit CAPI message dumps

Tony Luck (1):
      x86/mce: Fix check for processor context when machine check was taken.

nagalakshmi.nandigama@lsi.com (1):
      SCSI: mpt2sas: Fix for panic happening because of improper memory all=
ocation

=C9ric Piel (1):
      USB: ftdi-sio: add support for Physik Instrumente E-861


--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPzQNGAAoJEDjbvchgkmk+SI8P/0E/o9Ukrxk7X43ePkC5H66/
7ivUOuIT9pl5gd2kwvAnmrMfqGgNbNv+HA9VD2F5TpSH89iGnBw1pPDHoXcNKy0Z
2Fq89+al3u4uwYOAXT0YMU1QGTQN6Av60wx0JkWB1IHfNNoxMwiOCpQRtODsw+iL
WmT2KPsSdOOE289K00vgJaRUagiPfQJsL4BzaWsN64XAT3z57hPz8nxiYxqAFwTW
Komk+IsaXQBXoDU5hP4gEkM1dS+z5EpJuz/lVt3kQAFiQ0CgDMHUONuuI7gSennj
NkWi+JReJSVClDgPb3aaD9D/QgUqQIzA1bFqblAQx0Ei4oUgE4q68r7gO5b5N617
8vSHCLk9jjzDb6LJwTDkosw423Fso3Xnn4yNF5GGVNGQliZdUeNgBNqSvBRl8YTV
CjAt4ghbhsaLhQKdC9jH3L3w7bjD2FPjC4etGfz25QBi5pD5XcEfenfV7kSqhBPW
ttw9enmsnEcTUVQTq0djnepff5oihNZ+mO8FZRfC1/j7cWzw3ix66m0+9GEu6rQd
nITBpPS0gpivf+JwrhU7WCbey6roTnlAoxuI4LG+c3GsdyPMBAeZZJoE+GidxH26
xsmEpTbXDczcfUzcouq1b0GoUcDk9xRSbcbZ8fJK2EUYS/7IbNo/nZt3DL+y4HLA
KMYJMltbOsfqlB0mP7hv
=9LAR
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
